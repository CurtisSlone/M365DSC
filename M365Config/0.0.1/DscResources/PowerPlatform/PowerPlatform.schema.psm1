Configuration PowerPlatform
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

    PPTenantSettings 1ae1e6d9-83ae-4da4-8546-dca6a16028d4
    {
        IsSingleInstance                               = "Yes"
        DisableBingVideoSearch                         = $False
        DisableCapacityAllocationByEnvironmentAdmins   = $True
        DisableCommunitySearch                         = $False
        DisableDocsSearch                              = $False
        DisableEnvironmentCreationByNonAdminUsers      = $True
        DisableNewsletterSendout                       = $False
        DisableNPSCommentsReachout                     = $False
        DisablePortalsCreationByNonAdminUsers          = $False
        DisableShareWithEveryone                       = $False
        DisableSupportTicketsVisibleByAllUsers         = $False
        DisableSurveyFeedback                          = $False
        DisableTrialEnvironmentCreationByNonAdminUsers = $True
        EnableGuestsToMake                             = $False
        ShareWithColleaguesUserLimit                   = 10000
        WalkMeOptOut                                   = $False
        Credential                                     = $Credential
    }
}
