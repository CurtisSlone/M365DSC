Configuration Exchange
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC
    
    $OrganizationName = $ConfigurationData.NonNodeData.Environment.OrganizationName

    EXOOrganizationConfig 'EXOOrganizationConfig'
    {
        IsSingleInstance                                          = "Yes"
        ActivityBasedAuthenticationTimeoutEnabled                 = $True
        ActivityBasedAuthenticationTimeoutInterval                = "06:00:00"
        ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $True
        AppsForOfficeEnabled                                      = $True
        AsyncSendEnabled                                          = $True
        AuditDisabled                                             = $False
        AutoExpandingArchive                                      = $False
        BookingsEnabled                                           = $True
        BookingsPaymentsEnabled                                   = $False
        BookingsSocialSharingRestricted                           = $False
        ByteEncoderTypeFor7BitCharsets                            = 0
        ConnectorsActionableMessagesEnabled                       = $True
        ConnectorsEnabled                                         = $True
        ConnectorsEnabledForOutlook                               = $True
        ConnectorsEnabledForSharepoint                            = $True
        ConnectorsEnabledForTeams                                 = $True
        ConnectorsEnabledForYammer                                = $True
        DefaultGroupAccessType                                    = "Private"
        DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00"
        DefaultPublicFolderIssueWarningQuota                      = "Unlimited"
        DefaultPublicFolderMaxItemSize                            = "Unlimited"
        DefaultPublicFolderMovedItemRetention                     = "7.00:00:00"
        DefaultPublicFolderProhibitPostQuota                      = "Unlimited"
        DirectReportsGroupAutoCreationEnabled                     = $False
        DistributionGroupNameBlockedWordsList                     = @()
        DistributionGroupNamingPolicy                             = ""
        ElcProcessingDisabled                                     = $False
        EndUserDLUpgradeFlowsDisabled                             = $False
        EwsApplicationAccessPolicy                                = "EnforceBlockList"
        EwsEnabled                                                = $True
        ExchangeNotificationEnabled                               = $True
        ExchangeNotificationRecipients                            = @()
        IPListBlocked                                             = @()
        LeanPopoutEnabled                                         = $False
        LinkPreviewEnabled                                        = $True
        MailTipsAllTipsEnabled                                    = $True
        MailTipsExternalRecipientsTipsEnabled                     = $True
        MailTipsGroupMetricsEnabled                               = $True
        MailTipsLargeAudienceThreshold                            = 25
        MailTipsMailboxSourcedTipsEnabled                         = $True
        OAuth2ClientProfileEnabled                                = $True
        OutlookMobileGCCRestrictionsEnabled                       = $False
        OutlookPayEnabled                                         = $True
        PublicComputersDetectionEnabled                           = $False
        PublicFoldersEnabled                                      = "Local"
        PublicFolderShowClientControl                             = $False
        ReadTrackingEnabled                                       = $False
        RemotePublicFolderMailboxes                               = @()
        SendFromAliasEnabled                                      = $False
        SmtpActionableMessagesEnabled                             = $True
        VisibleMeetingUpdateProperties                            = "Location,AllProperties:15"
        WebPushNotificationsDisabled                              = $False
        WebSuggestedRepliesDisabled                               = $False
        Credential                                                = $Credential
    }

    #region EXOOrganizationRelationships
    foreach ($OrganizationalRelationship in $ConfigurationData.NonNodeData.Exchange.OrganizationalRelationships)
    {
        EXOOrganizationRelationship $OrganizationalRelationship.Name
        {
            Name                  = $OrganizationalRelationship.Name
            ArchiveAccessEnabled  = $OrganizationalRelationship.ArchiveAccessEnabled
            DeliveryReportEnabled = $OrganizationalRelationship.DeliveryReportEnabled
            DomainNames           = $OrganizationalRelationship.DomainNames
            Enabled               = $OrganizationalRelationship.Enabled
            FreeBusyAccessEnabled = $OrganizationalRelationship.FreeBusyAccessEnabled
            FreeBusyAccessLevel   = $OrganizationalRelationship.FreeBusyAccessLevel
            MailboxMoveEnabled    = $OrganizationalRelationship.MailboxMoveEnabled
            MailTipsAccessEnabled = $OrganizationalRelationship.MailTipsAccessEnabled
            MailTipsAccessLevel   = $OrganizationalRelationship.MailTipsAccessLevel
            OrganizationContact   = $OrganizationalRelationship.OrganizationContact
            PhotosEnabled         = $OrganizationalRelationship.PhotosEnabled
            TargetApplicationUri  = $OrganizationalRelationship.TargetApplicationUri
            TargetAutodiscoverEpr = $OrganizationalRelationship.TargetAutodiscoverEpr
            TargetOwaURL          = $OrganizationalRelationship.TargetOwaURL
            TargetSharingEpr      = $OrganizationalRelationship.TargetSharingEpr
            Ensure                = "Present"
            Credential            = $Credential
        }
    }
    #endregion

    #region EXOAcceptedDomain
    foreach ($AcceptedDomain in $ConfigurationData.NonNodeData.Exchange.AcceptedDomains)
    {
        EXOAcceptedDomain $AcceptedDomain.Identity
        {
            Identity              = $AcceptedDomain.Identity
            DomainType            = $AcceptedDomain.DomainType
            MatchSubDomains       = $AcceptedDomain.MatchSubDomains
            OutboundOnly          = $AcceptedDomain.OutboundOnly
            Ensure                = $AcceptedDomain.Ensure
            Credential            = $Credential
        }
    }
    #endregion

    #region EXODkimSigningConfig
    foreach ($DKIM in $ConfigurationData.NonNodeData.Exchange.DKIM)
    {
        EXODkimSigningConfig $DKIM.Identity
        {
            Identity               = $DKIM.Identity
            AdminDisplayName       = $DKIM.AdminDisplayName
            Enabled                = $DKIM.Enabled
            BodyCanonicalization   = $DKIM.BodyCanonicalization
            HeaderCanonicalization = $DKIM.HeaderCanonicalization
            KeySize                = $DKIM.KeySize
            Ensure                 = "Present"
            Credential             = $Credential
        }
    }
    #endregion

    EXOAtpPolicyForO365 'ATPPolicy'
    {
        IsSingleInstance              = "Yes"
        Identity                      = "Default"
        AllowSafeDocsOpen             = $False
        EnableATPForSPOTeamsODB       = $True
        EnableSafeDocs                = $True
        Ensure                        = "Present"
        Credential                    = $Credential
    }

    EXOMailTips 'OrgWideMailTips'
    {
        Organization                          = "$OrganizationName"
        MailTipsAllTipsEnabled                = $True
        MailTipsExternalRecipientsTipsEnabled = $True
        MailTipsGroupMetricsEnabled           = $True
        MailTipsLargeAudienceThreshold        = 25
        MailTipsMailboxSourcedTipsEnabled     = $True
        Ensure                                = "Present"
        Credential                            = $Credential
    }

    #region EXOInboundConnectors
    foreach ($InboundConnector in $ConfigurationData.NonNodeData.Exchange.InboundConnectors)
    {
        EXOInboundConnector $InboundConnector.Identity
        {
            Identity                     = $InboundConnector.Identity
            AssociatedAcceptedDomains    = $InboundConnector.AssociatedAcceptedDomains
            CloudServicesMailEnabled     = $InboundConnector.CloudServicesMailEnabled
            Comment                      = $InboundConnector.Comment
            ConnectorSource              = $InboundConnector.ConnectorSource
            ConnectorType                = $InboundConnector.ConnectorType
            Enabled                      = $InboundConnector.Enabled
            RequireTls                   = $InboundConnector.RequireTls
            RestrictDomainsToCertificate = $InboundConnector.RestrictDomainsToCertificate
            RestrictDomainsToIPAddresses = $InboundConnector.RestrictDomainsToIPAddresses
            SenderDomains                = $InboundConnector.SenderDomains
            SenderIPAddresses            = $InboundConnector.SenderIPAddresses
            TlsSenderCertificateName     = $InboundConnector.TlsSenderCertificateName
            TreatMessagesAsInternal      = $InboundConnector.TreatMessagesAsInternal
            Ensure                       = "Present"
            Credential                   = $Credential
        }
    }
    #endregion

    #region EXOOutboundConnectors
    foreach ($OutboundConnector in $ConfigurationData.NonNodeData.Exchange.OutboundConnectors)
    {
        EXOOutboundConnector $OutboundConnector.Identity
        {
            Identity                      = $OutboundConnector.Identity
            AllAcceptedDomains            = $OutboundConnector.AllAcceptedDomains
            CloudServicesMailEnabled      = $OutboundConnector.CloudServicesMailEnabled
            Comment                       = $OutboundConnector.Comment
            ConnectorSource               = $OutboundConnector.ConnectorSource
            ConnectorType                 = $OutboundConnector.ConnectorType
            Enabled                       = $OutboundConnector.Enabled
            IsTransportRuleScoped         = $OutboundConnector.IsTransportRuleScoped
            RecipientDomains              = $OutboundConnector.RecipientDomains
            RouteAllMessagesViaOnPremises = $OutboundConnector.RouteAllMessagesViaOnPremises
            SmartHosts                    = $OutboundConnector.SmartHosts
            TestMode                      = $OutboundConnector.TestMode
            TlsSettings                   = $OutboundConnector.TlsSettings
            UseMxRecord                   = $OutboundConnector.UseMxRecord
            ValidationRecipients          = $OutboundConnector.ValidationRecipients
            Ensure                        = "Present"
            Credential                    = $Credential
        }
    }
    #endregion
}
