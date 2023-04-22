Configuration Office365
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    O365OrgCustomizationSetting 'EnableConfigurableMode'
    {
        IsSingleInstance      = "Yes"
        Ensure                = "Present"
        Credential            = $Credential
    }

    O365AdminAuditLogConfig 'ConfigureAdminAuditLog'
    {
        IsSingleInstance                = "Yes"
        UnifiedAuditLogIngestionEnabled = "Disabled"
        Ensure                          = "Present"
        Credential            = $Credential
    }
}
