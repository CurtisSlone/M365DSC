Configuration PowerPlatform
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

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
