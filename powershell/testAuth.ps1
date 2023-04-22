Configuration ApplicationSecretExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationSecret
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'SiteWithApplicationSecret'
        {
            Url               = "https://contoso.sharepoint.com/sites/applicationsecretsite"
            Owner             = "admin@contoso.onmicrosoft.com"
            Title             = "TestSite"
            Template          = "STS#3"
            TimeZoneId        = 13
            Ensure            = "Present"
            ApplicationId     = $ApplicationId
            TenantId          = $TenantId
            ApplicationSecret = $ApplicationSecret
        }
    }
}