Configuration AzureAD
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    
    foreach ($RoleSetting in $ConfigurationData.NonNodeData.AzureAD.RoleSettings)
    {
        AADRoleSetting $RoleSetting.Displayname
        {
            Id                                                        = $RoleSetting.Id
            ActivateApprover                                          = $RoleSetting.ActivateApprover
            ActivationMaxDuration                                     = $RoleSetting.ActivationMaxDuration
            ActivationReqJustification                                = $RoleSetting.ActivationReqJustification
            ActivationReqMFA                                          = $RoleSetting.ActivationReqMFA 
            ActivationReqTicket                                       = $RoleSetting.ActivationReqTicket
            ActiveAlertNotificationAdditionalRecipient                = $ConfigurationData.NonNodeData.Environment.AlertName
            ActiveAlertNotificationDefaultRecipient                   = $RoleSetting.ActiveAlertNotificationDefaultRecipient
            ActiveAlertNotificationOnlyCritical                       = $RoleSetting.ActiveAlertNotificationOnlyCritical
            ActiveApproveNotificationAdditionalRecipient              = $RoleSetting.ActiveApproveNotificationAdditionalRecipient
            ActiveApproveNotificationDefaultRecipient                 = $RoleSetting.ActiveApproveNotificationDefaultRecipient 
            ActiveApproveNotificationOnlyCritical                     = $RoleSetting.ActiveApproveNotificationOnlyCritical
            ActiveAssigneeNotificationAdditionalRecipient             = $RoleSetting.ActiveAssigneeNotificationAdditionalRecipient
            ActiveAssigneeNotificationDefaultRecipient                = $RoleSetting.ActiveAssigneeNotificationDefaultRecipient
            ActiveAssigneeNotificationOnlyCritical                    = $RoleSetting.ActiveAssigneeNotificationOnlyCritical 
            ApprovaltoActivate                                        = $RoleSetting.ApprovaltoActivate
            AssignmentReqJustification                                = $RoleSetting.AssignmentReqJustification
            AssignmentReqMFA                                          = $RoleSetting.AssignmentReqMFA
            Displayname                                               = $RoleSetting.Displayname
            ElegibilityAssignmentReqJustification                     = $RoleSetting.ElegibilityAssignmentReqJustification
            ElegibilityAssignmentReqMFA                               = $RoleSetting.ElegibilityAssignmentReqMFA
            EligibleAlertNotificationAdditionalRecipient              = $ConfigurationData.NonNodeData.Environment.AlertName
            EligibleAlertNotificationDefaultRecipient                 = $RoleSetting.EligibleAlertNotificationDefaultRecipient
            EligibleAlertNotificationOnlyCritical                     = $RoleSetting.EligibleAlertNotificationOnlyCritical
            EligibleApproveNotificationAdditionalRecipient            = $RoleSetting.EligibleApproveNotificationAdditionalRecipient
            EligibleApproveNotificationDefaultRecipient               = $RoleSetting.EligibleApproveNotificationDefaultRecipient
            EligibleApproveNotificationOnlyCritical                   = $RoleSetting.EligibleApproveNotificationOnlyCritical 
            EligibleAssigneeNotificationAdditionalRecipient           = $RoleSetting.EligibleAssigneeNotificationAdditionalRecipient
            EligibleAssigneeNotificationDefaultRecipient              = $RoleSetting.EligibleAssigneeNotificationDefaultRecipient
            EligibleAssigneeNotificationOnlyCritical                  = $RoleSetting.EligibleAssigneeNotificationOnlyCritical
            EligibleAssignmentAlertNotificationAdditionalRecipient    = $ConfigurationData.NonNodeData.Environment.AlertName
            EligibleAssignmentAlertNotificationDefaultRecipient       = $RoleSetting.EligibleAssignmentAlertNotificationDefaultRecipient
            EligibleAssignmentAlertNotificationOnlyCritical           = $RoleSetting.EligibleAssignmentAlertNotificationOnlyCritical
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = $RoleSetting.EligibleAssignmentAssigneeNotificationAdditionalRecipient
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $RoleSetting.EligibleAssignmentAssigneeNotificationDefaultRecipient
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $RoleSetting.EligibleAssignmentAssigneeNotificationOnlyCritical
            ExpireActiveAssignment                                    = $RoleSetting.ExpireActiveAssignment
            ExpireEligibleAssignment                                  = $RoleSetting.ExpireEligibleAssignment
            PermanentActiveAssignmentisExpirationRequired             = $RoleSetting.PermanentActiveAssignmentisExpirationRequired
            PermanentEligibleAssignmentisExpirationRequired           = $RoleSetting.PermanentEligibleAssignmentisExpirationRequired
            Credential                                                = $Credential
            Ensure                                                    = "Present"
        }
    }
    # endregion
}