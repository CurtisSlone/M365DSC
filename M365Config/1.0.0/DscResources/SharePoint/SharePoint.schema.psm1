Configuration SharePoint
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC


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
        Credential                                    = $Credential
    }
}
