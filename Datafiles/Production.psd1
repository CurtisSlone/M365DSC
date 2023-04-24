@{
    AllNodes    = @(
        @{
            NodeName                    = 'localhost'
            PsDscAllowPlainTextPassword = $true
            PsDscAllowDomainUser        = $true
        }
    )

    NonNodeData = @{

        Environment    = @{
            Name             = 'Production'
            ShortName        = 'PRD'
            OrganizationName = "checkyourpockets.club"
        }
        
        Accounts       = @(
            @{
                Workload = 'Exchange'
            }
            @{
                Workload = 'Office365'
            }
            @{
                Workload = 'PowerPlatform'
            }
            @{
                Workload = 'SecurityCompliance'
            }
            @{
                Workload = 'SharePoint'
            }
            @{
                Workload = 'Teams'
            }
            @{
                Workload = "AAD"
            }
            @{
                Workload = "Intune"
            }
        )

        Exchange       = @{
            OrganizationalRelationships = @(
                @{
                    Name                  = "checkyourpockets.club"
                    ArchiveAccessEnabled  = $false
                    DeliveryReportEnabled = $false
                    DomainNames           = @("checkyourpockets.club")
                    Enabled               = $true
                    FreeBusyAccessEnabled = $true
                    FreeBusyAccessLevel   = "LimitedDetails"
                    MailboxMoveEnabled    = $false
                    MailTipsAccessEnabled = $false
                    MailTipsAccessLevel   = "None"
                    OrganizationContact   = ""
                    PhotosEnabled         = $false
                    TargetApplicationUri  = "outlook.com"
                    TargetAutodiscoverEpr = "https://autodiscover-s.outlook.com/autodiscover/autodiscover.svc/WSSecurity"
                    TargetOwaURL          = ""
                    TargetSharingEpr      = ""
                }
            )

            AcceptedDomains             = @(
                @{
                    Identity        = "checkyourpockets.club"
                    DomainType      = 'Authoritative'
                    MatchSubDomains = $false
                    OutboundOnly    = $false
                    Ensure          = 'Present'
                }
            )

            DKIM                        = @(
                @{
                    Identity               = "checkyourpockets.club"
                    Enabled                = $true
                    AdminDisplayName       = ''
                    BodyCanonicalization   = 'Relaxed'
                    HeaderCanonicalization = 'Relaxed'
                    KeySize                = 1024
                }
            )

            InboundConnectors           = @()
            OutboundConnectors          = @()
        }

        Teams          = @{

            MeetingBroadcastConfiguration = @{
                Identity                            = "Global"
                AllowSdnProviderForBroadcastMeeting = $false
                SdnApiTemplateUrl                   = ""
                SdnApiToken                         = ""
                SdnLicenseId                        = ""
                SdnProviderName                     = ""
                SupportURL                          = "https://support.office.com/home/contact"
            }

            MeetingBroadcastPolicies      = @(
                @{
                    Identity                        = "Global"
                    AllowBroadcastScheduling        = $false
                    AllowBroadcastTranscription     = $true
                    BroadcastAttendeeVisibilityMode = "EveryoneInCompany"
                    BroadcastRecordingMode          = "UserOverride"
                }
            )

            MeetingConfiguration          = @{
                Identity                    = "Global"
                ClientAppSharingPort        = 50040
                ClientAppSharingPortRange   = 20
                ClientAudioPort             = 50000
                ClientAudioPortRange        = 20
                ClientMediaPortRangeEnabled = $true
                ClientVideoPort             = 50020
                ClientVideoPortRange        = 20
                DisableAnonymousJoin        = $false
                EnableQoS                   = $false
            }

            MeetingPolicies               = @(
                @{
                    Identity                                   = "Global"
                    AllowAnonymousUsersToDialOut               = $false
                    AllowAnonymousUsersToStartMeeting          = $false
                    AllowBreakoutRooms                         = $true
                    AllowChannelMeetingScheduling              = $true
                    AllowCloudRecording                        = $false
                    AllowEngagementReport                      = "Disabled"
                    AllowExternalParticipantGiveRequestControl = $true
                    AllowIPAudio                               = $true
                    AllowIPVideo                               = $true
                    AllowMeetingReactions                      = $true
                    AllowMeetNow                               = $true
                    AllowNDIStreaming                          = $false
                    AllowOrganizersToOverrideLobbySettings     = $false
                    AllowOutlookAddIn                          = $true
                    AllowParticipantGiveRequestControl         = $true
                    AllowPowerPointSharing                     = $true
                    AllowPrivateMeetingScheduling              = $true
                    AllowPrivateMeetNow                        = $true
                    AllowPSTNUsersToBypassLobby                = $true
                    AllowRecordingStorageOutsideRegion         = $false
                    AllowSharedNotes                           = $true
                    AllowTranscription                         = $false
                    AllowUserToJoinExternalMeeting             = "Disabled"
                    AllowWhiteboard                            = $true
                    AutoAdmittedUsers                          = "EveryoneInCompanyExcludingGuests"
                    DesignatedPresenterRoleMode                = "EveryoneInCompanyUserOverride"
                    EnrollUserOverride                         = "Disabled"
                    IPAudioMode                                = "EnabledOutgoingIncoming"
                    IPVideoMode                                = "EnabledOutgoingIncoming"
                    LiveCaptionsEnabledType                    = "DisabledUserOverride"
                    MediaBitRateKb                             = 50000
                    MeetingChatEnabledType                     = "Enabled"
                    PreferredMeetingProviderForIslandsMode     = "TeamsAndSfb"
                    RecordingStorageMode                       = "OneDriveForBusiness"
                    ScreenSharingMode                          = "EntireScreen"
                    StreamingAttendeeMode                      = "Disabled"
                    TeamsCameraFarEndPTZMode                   = "Disabled"
                    VideoFiltersMode                           = "AllFilters"
                    WhoCanRegister                             = "EveryoneInCompany"
                }
            )
        }

        AAD = @{
            Globals = @{
                ExcludeUsers                             = @("curtis@checkyourpockets.club");
            }
            ConditionalAccessPolicies = @(
                @{
                    ApplicationEnforcedRestrictionsIsEnabled = $False;
                    BuiltInControls                          = @("mfa");
                    ClientAppTypes                           = @("all");
                    CloudAppSecurityIsEnabled                = $False;
                    CloudAppSecurityType                     = "";
                    Credential                               = $Credscredential;
                    CustomAuthenticationFactors              = @();
                    DeviceFilterRule                         = "";
                    DisplayName                              = "Require MFA - High-Privileged Roles";
                    Ensure                                   = "Present";
                    ExcludeApplications                      = @("0000000a-0000-0000-c000-000000000000");
                    ExcludeExternalTenantsMembers            = @();
                    ExcludeExternalTenantsMembershipKind     = "";
                    ExcludeGroups                            = @();
                    ExcludeLocations                         = @();
                    ExcludePlatforms                         = @();
                    ExcludeRoles                             = @();
                    ExcludeUsers                             = @("curtis@checkyourpockets.club");
                    GrantControlOperator                     = "OR";
                    Id                                       = "6dd444bc-650c-4985-8ad5-b2256145f457";
                    IncludeApplications                      = @("All");
                    IncludeExternalTenantsMembers            = @();
                    IncludeExternalTenantsMembershipKind     = "";
                    IncludeGroups                            = @();
                    IncludeLocations                         = @();
                    IncludePlatforms                         = @();
                    IncludeRoles                             = @("Global Administrator","Privileged Role Administrator","User Administrator","SharePoint Administrator","Exchange Administrator","Hybrid Identity Administrator","Application Administrator","Cloud Application Administrator");
                    IncludeUserActions                       = @();
                    IncludeUsers                             = @();
                    PersistentBrowserIsEnabled               = $False;
                    PersistentBrowserMode                    = "";
                    SignInFrequencyIsEnabled                 = $False;
                    SignInFrequencyType                      = "";
                    SignInRiskLevels                         = @();
                    State                                    = "enabled";
                    UserRiskLevels                           = @();
                }
            )
        }
    }
}