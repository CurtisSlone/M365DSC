Configuration M365Configuration
{

    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credentials
    )
    
    Import-DscResource -ModuleName M365Config

    node localhost
    {

        Exchange 'Exchange_Configuration'
        {
            Credential    = $Credentials
        }

        Office365 'Office365_Configuration'
        {
            Credential    = $Credentials
        }

        PowerPlatform 'PowerPlatform_Configuration'
        {
            Credential    = $Credentials
        }

        SecurityCompliance 'SecurityCompliance_Configuration'
        {
            Credential    = $Credentials
        }

        SharePoint 'SharePoint_Configuration'
        {
            Credential    = $Credentials
        }

        Teams 'Teams_Configuration'
        {
            Credential    = $Credentials
        }
    }
}
