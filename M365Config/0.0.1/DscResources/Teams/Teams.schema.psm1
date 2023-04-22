Configuration Teams
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

    TeamsClientConfiguration 'ClientConfiguration_Global'
    {
        Identity                         = "Global"
        AllowBox                         = $False
        AllowDropBox                     = $False
        AllowEgnyte                      = $False
        AllowEmailIntoChannel            = $True
        AllowGoogleDrive                 = $False
        AllowGuestUser                   = $True
        AllowOrganizationTab             = $True
        AllowResourceAccountSendMessage  = $True
        AllowScopedPeopleSearchandAccess = $False
        AllowShareFile                   = $False
        AllowSkypeBusinessInterop        = $True
        ContentPin                       = "RequiredOutsideScheduleMeeting"
        ResourceAccountContentAccess     = "NoAccess"
        Credential                       = $Credential
    }

    #region Emergency Policies
    TeamsEmergencyCallingPolicy 'EmergencyCallingPolicy_Global'
    {
        Identity   = "Global"
        Ensure     = "Present"
        Credential = $Credential
    }

    TeamsEmergencyCallRoutingPolicy 'EmergencyCallRoutingPolicy_Global'
    {
        Identity                       = "Global"
        AllowEnhancedEmergencyServices = $False
        Ensure                         = "Present"
        Credential                     = $Credential
    }
    #endregion

    #region Guest Configuration
    TeamsGuestCallingConfiguration 'GuestCallingConfiguration_Global'
    {
        Identity            = "Global"
        AllowPrivateCalling = $True
        Credential          = $Credential
    }

    TeamsGuestMeetingConfiguration 'GuestMeetingConfiguration_Global'
    {
        Identity          = "Global"
        AllowIPVideo      = $True
        AllowMeetNow      = $True
        ScreenSharingMode = "EntireScreen"
        Credential        = $Credential
    }

    TeamsGuestMessagingConfiguration 'GuestMessagingConfiguration_Global'
    {
        Identity               = "Global"
        AllowGiphy             = $True
        AllowImmersiveReader   = $True
        AllowMemes             = $True
        AllowStickers          = $True
        AllowUserChat          = $True
        AllowUserDeleteMessage = $True
        AllowUserEditMessage   = $True
        GiphyRatingType        = "Moderate"
        Credential             = $Credential
    }
    #endregion

    #region Meeting Broadcast Configuration
    TeamsMeetingBroadcastConfiguration 'MeetingBroadcastConfiguration_Global'
    {
        Identity                            = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.Identity
        AllowSdnProviderForBroadcastMeeting = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.AllowSdnProviderForBroadcastMeeting
        SdnApiTemplateUrl                   = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.SdnApiTemplateUrl
        SdnApiToken                         = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.SdnApiToken
        SdnLicenseId                        = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.SdnLicenseId
        SdnProviderName                     = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.SdnProviderName
        SupportURL                          = $ConfigurationData.NonNodeData.Teams.MeetingBroadcastConfiguration.SupportURL
        Credential                          = $Credential
    }
    #endregion

    #region Meeting Broadcast Policies
    foreach ($MeetingBroadcastPolicy in $ConfigurationData.NonNodeData.Teams.MeetingBroadcastPolicies)
    {
        TeamsMeetingBroadcastPolicy "MeetingBroadcastPolicy_$($MeetingBroadcastPolicy.Identity)"
        {
            Identity                        = $MeetingBroadcastPolicy.Identity
            AllowBroadcastScheduling        = $MeetingBroadcastPolicy.AllowBroadcastScheduling
            AllowBroadcastTranscription     = $MeetingBroadcastPolicy.AllowBroadcastTranscription
            BroadcastAttendeeVisibilityMode = $MeetingBroadcastPolicy.BroadcastAttendeeVisibilityMode
            BroadcastRecordingMode          = $MeetingBroadcastPolicy.BroadcastRecordingMode
            Ensure                          = "Present"
            Credential                      = $Credential
        }
    }
    #endregion

    #region Meeting Configuration
    TeamsMeetingConfiguration 'MeetingConfiguration_Global'
    {
        Identity                    = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.Identity
        ClientAppSharingPort        = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientAppSharingPort
        ClientAppSharingPortRange   = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientAppSharingPortRange
        ClientAudioPort             = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientAudioPort
        ClientAudioPortRange        = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientAudioPortRange
        ClientMediaPortRangeEnabled = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientMediaPortRangeEnabled
        ClientVideoPort             = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientVideoPort
        ClientVideoPortRange        = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.ClientVideoPortRange
        DisableAnonymousJoin        = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.DisableAnonymousJoin
        EnableQoS                   = $ConfigurationData.NonNodeData.Teams.MeetingConfiguration.EnableQoS
        Credential                  = $Credential
    }
    #endregion

    #region Meeting Policies
    foreach ($MeetingPolicy in $ConfigurationData.NonNodeData.Teams.MeetingPolicies)
    {
        TeamsMeetingPolicy "MeetingPolicy_$($MeetingPolicy.Identity)"
        {
            Identity                                   = $MeetingPolicy.Identity
            AllowAnonymousUsersToDialOut               = $MeetingPolicy.AllowAnonymousUsersToDialOut
            AllowAnonymousUsersToStartMeeting          = $MeetingPolicy.AllowAnonymousUsersToStartMeeting
            AllowBreakoutRooms                         = $MeetingPolicy.AllowBreakoutRooms
            AllowChannelMeetingScheduling              = $MeetingPolicy.AllowChannelMeetingScheduling
            AllowCloudRecording                        = $MeetingPolicy.AllowCloudRecording
            AllowEngagementReport                      = $MeetingPolicy.AllowEngagementReport
            AllowExternalParticipantGiveRequestControl = $MeetingPolicy.AllowExternalParticipantGiveRequestControl
            AllowIPAudio                               = $MeetingPolicy.AllowIPAudio
            AllowIPVideo                               = $MeetingPolicy.AllowIPVideo
            AllowMeetingReactions                      = $MeetingPolicy.AllowMeetingReactions
            AllowMeetNow                               = $MeetingPolicy.AllowMeetNow
            AllowNDIStreaming                          = $MeetingPolicy.AllowNDIStreaming
            AllowOrganizersToOverrideLobbySettings     = $MeetingPolicy.AllowOrganizersToOverrideLobbySettings
            AllowOutlookAddIn                          = $MeetingPolicy.AllowOutlookAddIn
            AllowParticipantGiveRequestControl         = $MeetingPolicy.AllowParticipantGiveRequestControl
            AllowPowerPointSharing                     = $MeetingPolicy.AllowPowerPointSharing
            AllowPrivateMeetingScheduling              = $MeetingPolicy.AllowPrivateMeetingScheduling
            AllowPrivateMeetNow                        = $MeetingPolicy.AllowPrivateMeetNow
            AllowPSTNUsersToBypassLobby                = $MeetingPolicy.AllowPSTNUsersToBypassLobby
            AllowRecordingStorageOutsideRegion         = $MeetingPolicy.AllowRecordingStorageOutsideRegion
            AllowSharedNotes                           = $MeetingPolicy.AllowSharedNotes
            AllowTranscription                         = $MeetingPolicy.AllowTranscription
            AllowUserToJoinExternalMeeting             = $MeetingPolicy.AllowUserToJoinExternalMeeting
            AllowWhiteboard                            = $MeetingPolicy.AllowWhiteboard
            AutoAdmittedUsers                          = $MeetingPolicy.AutoAdmittedUsers
            DesignatedPresenterRoleMode                = $MeetingPolicy.DesignatedPresenterRoleMode
            EnrollUserOverride                         = $MeetingPolicy.EnrollUserOverride
            IPAudioMode                                = $MeetingPolicy.IPAudioMode
            IPVideoMode                                = $MeetingPolicy.IPVideoMode
            LiveCaptionsEnabledType                    = $MeetingPolicy.LiveCaptionsEnabledType
            MediaBitRateKb                             = $MeetingPolicy.MediaBitRateKb
            MeetingChatEnabledType                     = $MeetingPolicy.MeetingChatEnabledType
            PreferredMeetingProviderForIslandsMode     = $MeetingPolicy.PreferredMeetingProviderForIslandsMode
            RecordingStorageMode                       = $MeetingPolicy.RecordingStorageMode
            ScreenSharingMode                          = $MeetingPolicy.ScreenSharingMode
            StreamingAttendeeMode                      = $MeetingPolicy.StreamingAttendeeMode
            TeamsCameraFarEndPTZMode                   = $MeetingPolicy.TeamsCameraFarEndPTZMode
            VideoFiltersMode                           = $MeetingPolicy.VideoFiltersMode
            WhoCanRegister                             = $MeetingPolicy.WhoCanRegister
            Ensure                                     = "Present"
            Credential                                 = $Credential
        }
    }
    #endregion
}
