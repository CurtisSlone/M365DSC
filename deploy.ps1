[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [System.String]
    $Environment
)

######## FUNCTIONS ########
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

######## START SCRIPT ########

Write-Log -Message '*********************************************************'
Write-Log -Message '*      Starting M365 DSC Configuration Deployment       *'
Write-Log -Message '*********************************************************'
Write-Log -Message "Environment to be deployed: $Environment"
Write-Log -Message '*********************************************************'
Write-Log -Message ' '

$workingDirectory = $PSScriptRoot
Set-Location -Path $workingDirectory

Write-Log -Message "Switching to path: $workingDirectory"
Write-Log -Message ' '

Write-Log -Message 'Checking for presence of specified environment'
Write-Log -Message ' '
$environmentPath = Join-Path -Path $workingDirectory -ChildPath '\Output\Production'
if ((Test-Path -Path $environmentPath) -eq $false)
{
    Write-Error "Specified environment not found"
    Write-Host "##vso[task.complete result=Failed;]Failed"
    Exit 20
}

Write-Log -Message 'Checking for presence of Microsoft365Dsc module and all required modules'
Write-Log -Message ' '

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
            Install-Module PowerShellGet -Scope AllUsers -SkipPublisherCheck -Force
            Write-Log -Message 'NOTE: If you receive Package Management errors later in this script, please restart the pipeline.' -Level 6
            Write-Log -Message '      This update is not yet being picked up.' -Level 6
        }
        else
        {
            if ($psGetModule.Version -lt [System.Version]"2.2.4.0")
            {
                Write-Log -Message '* Installing PowerShellGet' -Level 5
                Install-Module PowerShellGet -Scope AllUsers -SkipPublisherCheck -Force
                Write-Log -Message 'NOTE: If you receive Package Management errors later in this script, please restart the pipeline.' -Level 6
                Write-Log -Message '      This update is not yet being picked up.' -Level 6
            }
        }

        Write-Log -Message 'Installing Microsoft365Dsc' -Level 4
        $null = Install-Module -Name 'Microsoft365Dsc' -RequiredVersion $psGalleryVersion -Scope AllUsers
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
    Write-Error "[ERROR] Unable to find Microsoft365Dsc in DscResources.psd1. Cancelling!"
    Write-Host "##vso[task.complete result=Failed;]Failed"
    exit 10
}

$envPath = Join-Path -Path $workingDirectory -ChildPath '\Output\Production'
$dataFilePath = Join-Path -Path $envPath -ChildPath "$Environment.psd1"
$data = Import-PowerShellDataFile -Path $dataFilePath
$envShortName = $data.NonNodeData.Environment.ShortName


try
{
    $deploymentSucceeded = $true
    Write-Log -Message "Running deployment of MOF file for environment '$Environment'"
    Start-DscConfiguration -Path $envPath -Verbose -Wait -Force
}
catch
{
    Write-Log -Message 'MOF Deployment Failed!'
    Write-Log -Message "  Error occurred during deployment: $($_.Exception.Message)"
    $deploymentSucceeded = $false
}
finally
{
    Write-Log -Message ' '
    Write-Log -Message ' '
    Write-Log -Message '************************************************'
    Write-Log -Message '*              Deployment results              *'
    Write-Log -Message '************************************************'
    if ($deploymentSucceeded -eq $true)
    {
        Write-Log -Message 'MOF Deployment Succeeded!'
        Exit 0
    }
    else
    {
        Write-Log -Message 'MOF Deployment Failed!'
        Write-Log -Message "  Issues found during config deployment!"
        Write-Log -Message '  Make sure you correct all mistakes and try again.'
        Write-Host "##vso[task.complete result=Failed;]Failed"
        Exit 100
    }
}
Write-Log -Message ' '
Write-Log -Message '*********************************************************'
Write-Log -Message '*      Finished M365 DSC Configuration Deployment       *'
Write-Log -Message '*********************************************************'
Write-Log -Message ' '
