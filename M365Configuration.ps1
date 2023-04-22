Configuration M365Configuration
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Credentials
    )

    Import-DscResource -ModuleName M365Config

    node localhost
    {
        $exchangeAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'Exchange' }
        $officeAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'Office365' }
        $powerplatformAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'PowerPlatform' }
        $securitycomplianceAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'SecurityCompliance' }
        $sharepointAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'SharePoint' }
        $teamsAppCreds = $ConfigurationData.NonNodeData.AppCredentials | Where-Object -FilterScript { $_.Workload -eq 'Teams' }

        Exchange 'Exchange_Configuration'
        {
            Credential    = $Credentials.Exchange
            ApplicationId = $exchangeAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $exchangeAppCreds.CertThumbprint
        }

        Office365 'Office365_Configuration'
        {
            Credential    = $Credentials.Office365
            ApplicationId = $officeAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $officeAppCreds.CertThumbprint
        }

        PowerPlatform 'PowerPlatform_Configuration'
        {
            Credential    = $Credentials.PowerPlatform
            ApplicationId = $powerplatformAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $powerplatformAppCreds.CertThumbprint
        }

        SecurityCompliance 'SecurityCompliance_Configuration'
        {
            Credential    = $Credentials.SecurityCompliance
            ApplicationId = $securitycomplianceAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $securitycomplianceAppCreds.CertThumbprint
        }

        SharePoint 'SharePoint_Configuration'
        {
            Credential    = $Credentials.SharePoint
            ApplicationId = $sharepointAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $sharepointAppCreds.CertThumbprint
        }

        Teams 'Teams_Configuration'
        {
            Credential    = $Credentials.Teams
            ApplicationId = $teamsAppCreds.ApplicationId
            TenantId      = $ConfigurationData.NonNodeData.Environment.TenantId
            Thumbprint    = $teamsAppCreds.CertThumbprint
        }
    }
}
