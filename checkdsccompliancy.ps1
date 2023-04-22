#Requires -Version 5.1
[CmdletBinding()]
param ()

#region Supporting functions
function Write-Log
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message,

        [Parameter()]
        [System.Int32]
        $Level = 0
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $indentation = '  ' * $Level
    $output = "[{0}] - {1}{2}" -f $timestamp, $indentation, $Message
    Write-Host $output
}

##### GENERIC VARIABLES #####
$workingDirectory = $PSScriptRoot
$encounteredError = $false

$useMail = $false
$mailAppId = '<APPID>'
$mailAppSecret = '<SECRET>'
$mailTenantId = '<TENANTID>'
$mailFrom = '<FROM>'
$mailTo = '<TO>'

$useTeams = $false
$teamsWebhook = '<WEBHOOK>'

##### START SCRIPT #####

if ($PSVersionTable.PSVersion.Major -ne 5)
{
    Write-Log -Message 'You are not using PowerShell v5. Please make sure you are using that version!'
    return
}

try
{
    Write-Log -Message '******************************************************************************'
    Write-Log -Message '*        Checking for Microsoft365Dsc module and all required modules        *'
    Write-Log -Message '******************************************************************************'
    Write-Log -Message ' '

    if ($useMail -eq $false -and $useTeams -eq $false)
    {
        Write-Log -Message "[ERROR] Both useTeams and useMail are set to False."
        Write-Log -Message "        Please configure a notification method before continuing!"
        Write-Host "##vso[task.complete result=Failed;]Failed"
        exit 20
    }

    $modules = Import-PowerShellDataFile -Path (Join-Path -Path $workingDirectory -ChildPath 'DscResources.psd1')

    if ($modules.ContainsKey("Microsoft365Dsc"))
    {
        Write-Log -Message 'Checking Microsoft365Dsc version' -Level 1
        $psGalleryVersion = $modules.Microsoft365Dsc
        $localModule = Get-Module 'Microsoft365Dsc' -ListAvailable

        Write-Log -Message "Required version: $psGalleryVersion" -Level 2
        Write-Log -Message "Installed version: $($localModule.Version)" -Level 2

        if ($localModule.Version -ne $psGalleryVersion)
        {
            if ($null -ne $localModule)
            {
                Write-Log -Message 'Incorrect version installed. Removing current module.' -Level 3
                Write-Log -Message 'Removing Microsoft365DSC' -Level 4
                $m365ModulePath = Join-Path -Path 'C:\Program Files\WindowsPowerShell\Modules' -ChildPath 'Microsoft365DSC'
                Remove-Item -Path $m365ModulePath -Force -Recurse -ErrorAction 'SilentlyContinue'
            }

            Write-Log -Message 'Configuring PowerShell Gallery' -Level 4
            Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $psGetModule = Get-Module -Name PowerShellGet -ListAvailable | Select-Object -First 1
            if ($null -eq $psGetModule)
            {
                Write-Log -Message '* Installing PowerShellGet' -Level 5
                Install-Module PowerShellGet -SkipPublisherCheck -Force
                Write-Log -Message 'NOTE: If you receive Package Management errors later in this script, please restart the pipeline.' -Level 6
                Write-Log -Message '      This update is not yet being picked up.' -Level 6
            }
            else
            {
                if ($psGetModule.Version -lt [System.Version]"2.2.4.0")
                {
                    Write-Log -Message '* Installing PowerShellGet' -Level 5
                    Install-Module PowerShellGet -SkipPublisherCheck -Force
                    Write-Log -Message 'NOTE: If you receive Package Management errors later in this script, please restart the pipeline.' -Level 6
                    Write-Log -Message '      This update is not yet being picked up.' -Level 6
                }
            }

            Write-Log -Message 'Installing Microsoft365Dsc' -Level 4
            $null = Install-Module -Name 'Microsoft365Dsc' -RequiredVersion $psGalleryVersion
        }
        else
        {
            Write-Log -Message 'Correct version installed, continuing.' -Level 3
        }

        Write-Log -Message 'Checking Module Dependencies' -Level 1
        Update-M365DSCDependencies

        Write-Log -Message 'Removing Outdated Module Dependencies' -Level 1
        Uninstall-M365DSCOutdatedDependencies

        Write-Log -Message 'Modules installed successfully!'
        Write-Log -Message ' '
    }
    else
    {
        Write-Log -Message "[ERROR] Unable to find Microsoft365Dsc in DscResources.psd1. Cancelling!"
        Write-Host "##vso[task.complete result=Failed;]Failed"
        exit 10
    }
    Write-Log -Message ' '
    Write-Log -Message 'Check complete!'
    Write-Log -Message ' '
    Write-Log -Message '-----------------------------------------------'
    Write-Log -Message ' '

    Write-Log -Message '************************************************************'
    Write-Log -Message '*          Testing compliancy on all environments          *'
    Write-Log -Message '************************************************************'

    Write-Log -Message "Processing all MOF files in '$workingDirectory'"

    $mofFiles = Get-ChildItem -Path $workingDirectory -Filter *.mof -Recurse
    Write-Log -Message "- Found $($mofFiles.Count) files" -Level 1

    $checkResults = @{}
    foreach ($file in $mofFiles)
    {
        $envName = Split-Path -Path $file.DirectoryName -Leaf

        Write-Log -Message "* Processing $envName" -Level 2
        $checkResults.$envName = @{}

        try
        {
            $result = Test-DscConfiguration -ReferenceConfiguration $file.FullName -Verbose -ErrorAction Stop

            if ($result.InDesiredState -eq $false)
            {
                $checkResults.$envName.ErrorCount = $result.ResourcesNotInDesiredState.Count
                $checkResults.$envName.ErroredResources = $result.ResourcesNotInDesiredState.ResourceId -join ", "
            }
            else
            {
                $checkResults.$envName.ErrorCount = 0
                $checkResults.$envName.ErroredResources = ""
            }
        }
        catch
        {
            $checkResults.$envName.ErrorCount = 999
            $checkResults.$envName.ErroredResources = $_.Exception.Message
        }
    }

    Write-Log -Message ' '
    Write-Log -Message 'Testing complete!'
    Write-Log -Message ' '
    Write-Log -Message '-----------------------------------------------'
    Write-Log -Message ' '

    Write-Log -Message '************************************************'
    Write-Log -Message '*    Creating and sending report via e-mail    *'
    Write-Log -Message '************************************************'
    Write-Log -Message ' '
    Write-Log -Message 'Creating report'
    $htmlReport = '<!DOCTYPE html>'
    $htmlReport += '<html>'
    $htmlReport += '<head>'
    $htmlReport += '<title>DSC Compliancy Report</title>'
    $htmlReport += '<style>table { border: 1px solid black; border-collapse: collapse; } th, td { padding: 10px; text-align:center } th { background-color: #00A4EF; color: white } .failed {background-color: red;} .nocenter {text-align:left;}</style>'
    $htmlReport += '</head><body>'

    $date = Get-Date -Format 'yyyy-MM-dd'
    $title = 'DSC Compliancy Report ({0})' -f $date
    $htmlReport += "<H1>$title</H1>"

    [System.Threading.Thread]::CurrentThread.CurrentUICulture = "en-US" ;
    [System.Threading.Thread]::CurrentThread.CurrentCulture = "en-US";
    $datetime = Get-Date -Format 'ddd dd-MM-yyyy HH:mm'
    $generatedAt = 'Generated at: {0}<br>' -f $datetime
    $htmlReport += $generatedAt
    $htmlReport += '<br>'

    $errorCount = 0
    $erroredEnvironment = @()
    foreach ($result in $checkResults.GetEnumerator())
    {
        if ($result.Value.ErrorCount -gt 0)
        {
            $errorCount++
            $erroredEnvironment += $result.Key
        }
    }

    $incompliantEnvs = 'Number of incompliant environments: {0}<br>' -f $errorCount
    $htmlReport += $incompliantEnvs
    $htmlReport += '<br>'

    $htmlReport += '<H3>Environments</H3>'

    $report = '<table>'
    $report += '<tr><th>Environment</th><th>In Desired State</th><th>Error Count</th><th>Details</th></tr>'

    foreach ($environment in $checkResults.GetEnumerator())
    {
        if ($environment.Value.ErrorCount -gt 0)
        {
            $report += '<tr><td>{0}</td><td class=failed>False</td><td>{1}</td><td class=nocenter>{2}</td></tr>' -f $environment.Key, $environment.Value.ErrorCount, $environment.Value.ErroredResources
        }
        else
        {
            $report += '<tr><td>{0}</td><td>True</td><td>0</td><td class=nocenter>-</td></tr>' -f $environment.Key
        }
    }
    $report += '</table>'
    $htmlReport += $report
    $htmlReport += '<br>'

    $htmlReport += '</body></html>'
    Write-Log -Message 'Report created!'
    Write-Log -Message ' '

    if ($useMail)
    {
        Write-Log -Message 'Full HTML Report:'
        Write-Log -Message $htmlReport
        Write-Log -Message ' '

        Write-Log -Message 'Sending report via mail'

        # Construct URI and body needed for authentication
        Write-Log -Message 'Retrieving Authentication Token' -Level 1
        $uri = "https://login.microsoftonline.com/$mailTenantId/oauth2/v2.0/token"
        $body = @{
            client_id     = $mailAppId
            scope         = "https://graph.microsoft.com/.default"
            client_secret = $mailAppSecret
            grant_type    = "client_credentials"
        }

        $tokenRequest = Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/x-www-form-urlencoded" -Body $body -UseBasicParsing

        # Unpack Access Token
        $token = ($tokenRequest.Content | ConvertFrom-Json).access_token
        $Headers = @{
            'Content-Type'  = "application/json"
            'Authorization' = "Bearer $token"
        }

        # Create message body and properties and send
        Write-Log -Message 'Creating mail object' -Level 1
        $MessageParams = @{
            "URI"         = "https://graph.microsoft.com/v1.0/users/$mailFrom/sendMail"
            "Headers"     = $Headers
            "Method"      = "POST"
            "ContentType" = 'application/json'
            "Body"        = (@{
                    "message" = @{
                        "subject"      = "DSC Compliancy Report ($date)"
                        "body"         = @{
                            "contentType" = 'HTML' 
                            "content"     = $htmlReport
                        }
                        "toRecipients" = @(
                            @{
                                "emailAddress" = @{"address" = $mailTo }
                            }
                        )
                    }
                } | ConvertTo-JSON -Depth 6 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
        }
        
        try
        {
            Write-Log -Message 'Trying to send mail' -Level 1
            Invoke-RestMethod @Messageparams
            Write-Log -Message 'Report send!'
        }
        catch
        {
            Write-Log -Message ' '
            Write-Log -Message "[ERROR] Error while sending E-mail message: $($_.Exception.Message)"
            Write-Log -Message '        Make sure you have configured the App Credentials and From / To mail addresses correctly!'
            $encounteredError = $true
        }
    }

    if ($useTeams)
    {
        # Documentation for Teams Message Card: https://docs.microsoft.com/en-us/microsoftteams/platform/task-modules-and-cards/cards/cards-reference#example-of-an-office-365-connector-card

        Write-Log -Message 'Teams HTML message:'
        Write-Log -Message $report
        Write-Log -Message ' '

        Write-Log -Message 'Sending report via Teams'
        if ($errorCount -gt 0)
        {
            # An error occurred during a check
            $themeColor = 'FF0000'
            $activityTitle = "Check(s) failed!"
            $imageUrl = 'https://cdn.pixabay.com/photo/2012/04/12/13/15/red-29985_1280.png'
        }
        else
        {
            # All checks succeeded
            $themeColor = '0078D7'
            $activityTitle = "All checks passed!"
            $imageUrl = 'https://cdn.pixabay.com/photo/2016/03/31/14/37/check-mark-1292787_1280.png'
        }

        $JSONBody = [PSCustomObject][Ordered]@{
            "@type"      = "MessageCard"
            "@context"   = "http://schema.org/extensions"
            "summary"    = $title
            "themeColor" = $themeColor
            "title"      = $title
            "sections"   = @(
                [PSCustomObject][Ordered]@{
                    "activityTitle"    = $activityTitle
                    "activitySubtitle" = $generatedAt
                    "activityText"     = $incompliantEnvs
                    "activityImage"    = $imageUrl
                },
                [PSCustomObject][Ordered]@{
                    "title" = "Details"
                    "text"  = $report
                }
            )
        }

        $TeamMessageBody = ConvertTo-Json $JSONBody

        $parameters = @{
            "URI"         = $teamsWebhook
            "Method"      = 'POST'
            "Body"        = $TeamMessageBody
            "ContentType" = 'application/json'
        }

        $restResult = Invoke-RestMethod @parameters
        if ($restResult -isnot [PSCustomObject] -or $restResult.isSuccessStatusCode -eq $false)
        {
            Write-Log -Message ' '
            Write-Log -Message '[ERROR] Error while sending Teams message!'
            Write-Log -Message $restResult
            $encounteredError = $true
        }
    }

    Write-Log -Message ' '
    Write-Log -Message '------------------------------------------------'
}
catch [System.Net.Mail.SmtpException]
{
    Write-Log -Message ' '
    Write-Log -Message "[ERROR] Error while sending report e-mail: $($_.Exception.Message)"
    $encounteredError = $true
}
catch
{
    Write-Log -Message ' '
    Write-Log -Message '[ERROR] Error occurred during DSC Compliance check!'
    Write-Log -Message "  Error message: $($_.Exception.Message)"
    $encounteredError = $true
}
finally
{
    Write-Log -Message ' '
    Write-Log -Message '************************************************'
    Write-Log -Message '*        DSC Compliance Check results          *'
    Write-Log -Message '************************************************'
    Write-Log -Message ' '
    if ($encounteredError -eq $false -and $errorCount -eq 0)
    {
        Write-Log -Message 'DSC Compliance Check Succeeded!'
        Exit 0
    }
    else
    {
        Write-Log -Message '[ERROR] DSC Compliance Check Failed!'
        Write-Log -Message '  Issues found during DSC Compliance Check!'
        Write-Log -Message '  Make sure you correct all mistakes and try again.'
        if ($errorCount -gt 0)
        {
            Write-Log -Message ' '
            Write-Log -Message "  Environments with errors: $($errorCount) ($($erroredEnvironment -join ", "))"
        }
        Write-Host "##vso[task.complete result=Failed;]Failed"
        Exit 100
    }
}
