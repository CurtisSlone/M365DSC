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

        Exchange 'Exchange_Configuration'
        {
            Credential    = $Credentials.Exchange
        }

        Office365 'Office365_Configuration'
        {
            Credential    = $Credentials.Office365
        }

        PowerPlatform 'PowerPlatform_Configuration'
        {
            Credential    = $Credentials.PowerPlatform
        }

        SecurityCompliance 'SecurityCompliance_Configuration'
        {
            Credential    = $Credentials.SecurityCompliance
        }

        SharePoint 'SharePoint_Configuration'
        {
            Credential    = $Credentials.SharePoint
        }

        Teams 'Teams_Configuration'
        {
            Credential    = $Credentials.Teams
        }
    }
}
