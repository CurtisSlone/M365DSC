Configuration Office365
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $Thumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $paramCount = ($PSBoundParameters.GetEnumerator() | Where-Object -FilterScript { $_.Key -in 'ApplicationId', 'TenantId', 'Thumbprint' }).Count
    if ($paramCount -gt 0 -and $paramCount -lt 3)
    {
        throw "Please specify ApplicationId, TenantId and Thumbprint"
    }

    O365OrgCustomizationSetting 'EnableConfigurableMode'
    {
        IsSingleInstance      = "Yes"
        Ensure                = "Present"
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificateThumbprint = $Thumbprint
    }

    O365AdminAuditLogConfig 'ConfigureAdminAuditLog'
    {
        IsSingleInstance                = "Yes"
        UnifiedAuditLogIngestionEnabled = "Disabled"
        Ensure                          = "Present"
        ApplicationId                   = $ApplicationId
        TenantId                        = $TenantId
        CertificateThumbprint           = $Thumbprint
    }
}
