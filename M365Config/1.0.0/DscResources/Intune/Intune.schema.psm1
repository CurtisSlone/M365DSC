Configuration Intune
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC
    
    IntuneDeviceCompliancePolicyiOs "IntuneDeviceCompliancePolicyiOs-MDM-iOS-CompliancePolicy"
        {
            AdvancedThreatProtectionRequiredSecurityLevel  = "unavailable";
            Assignments                                    = @();
            Credential                                     = $Credential;
            DeviceThreatProtectionEnabled                  = $False;
            DeviceThreatProtectionRequiredSecurityLevel    = "unavailable";
            DisplayName                                    = "MDM-iOS-CompliancePolicy";
            Ensure                                         = "Present";
            ManagedEmailProfileRequired                    = $False;
            PasscodeBlockSimple                            = $True;
            PasscodeMinimumLength                          = 6;
            PasscodeMinutesOfInactivityBeforeLock          = 0;
            PasscodeMinutesOfInactivityBeforeScreenTimeout = 2;
            PasscodeRequired                               = $True;
            PasscodeRequiredType                           = "deviceDefault";
            RestrictedApps                                 = @();
            SecurityBlockJailbrokenDevices                 = $True;
        }

}