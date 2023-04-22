Configuration SharePoint
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

    SPOTenantSettings 'TenantSettings'
    {
        IsSingleInstance                              = "Yes"
        ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
        ConditionalAccessPolicy                       = "AllowFullAccess"
        FilePickerExternalImageSearchEnabled          = $true
        HideDefaultThemes                             = $false
        LegacyAuthProtocolsEnabled                    = $false
        MarkNewFilesSensitiveByDefault                = "AllowExternalSharing"
        MaxCompatibilityLevel                         = 15
        MinCompatibilityLevel                         = 15
        NotificationsInSharePointEnabled              = $true
        OfficeClientADALDisabled                      = $false
        OwnerAnonymousNotification                    = $true
        PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
        PublicCdnEnabled                              = $false
        SearchResolveExactEmailOrUPN                  = $false
        SignInAccelerationDomain                      = ""
        UseFindPeopleInPeoplePicker                   = $false
        UsePersistentCookiesForExplorerView           = $false
        UserVoiceForFeedbackEnabled                   = $true
        ApplicationId                                 = $ApplicationId
        TenantId                                      = $TenantId
        CertificateThumbprint                         = $Thumbprint
    }
}
