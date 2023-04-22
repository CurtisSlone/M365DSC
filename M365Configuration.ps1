Configuration M365Configuration
{

    Import-DscResource -ModuleName M365Config

    node localhost
    {

        Exchange 'Exchange_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }

        Office365 'Office365_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }

        PowerPlatform 'PowerPlatform_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }

        SecurityCompliance 'SecurityCompliance_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }

        SharePoint 'SharePoint_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }

        Teams 'Teams_Configuration'
        {
            Credential    = $ConfigurationData.NonNodeData.Environment.Credentials
        }
    }
}
