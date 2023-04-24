Configuration PowerPlatform
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    PPTenantSettings "Org-PPTenantSettings"
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
