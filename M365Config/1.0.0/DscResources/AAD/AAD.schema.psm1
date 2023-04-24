Configuration AAD
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC
    
    foreach ($ConditionalAccessPolicy in $ConfigurationData.NonNodeData.AAD.ConditionalAccessPolicies)
    {
        AADConditionalAccessPolicy "AADConditionalAccessPolicy - $($ConditionalAccessPolicy.DisplayName) "
        {
            ApplicationEnforcedRestrictionsIsEnabled = $ConditionalAccessPolicy.ApplicationEnforcedRestrictionsIsEnabled
            BuiltInControls                          = $ConditionalAccessPolicy.BuiltInControls
            ClientAppTypes                           = $ConditionalAccessPolicy.ClientAppTypes
            CloudAppSecurityIsEnabled                = $ConditionalAccessPolicy.CloudAppSecurityIsEnabled
            CloudAppSecurityType                     = $ConditionalAccessPolicy.CloudAppSecurityType
            Credential                               = $Credential;
            CustomAuthenticationFactors              = $ConditionalAccessPolicy.CustomAuthenticationFactors
            DeviceFilterRule                         = $ConditionalAccessPolicy.DeviceFilterRule
            DisplayName                              = $ConditionalAccessPolicy.DisplayName
            Ensure                                   = $ConditionalAccessPolicy.Ensure
            ExcludeApplications                      = $ConditionalAccessPolicy.ExcludeApplications
            ExcludeExternalTenantsMembers            = $ConditionalAccessPolicy.ExcludeExternalTenantsMembers
            ExcludeExternalTenantsMembershipKind     = $ConditionalAccessPolicy.ExchangeLocation
            ExcludeGroups                            = $ConditionalAccessPolicy.ExcludeGroups
            ExcludeLocations                         = $ConditionalAccessPolicy.ExcludeLocations
            ExcludePlatforms                         = $ConditionalAccessPolicy.ExcludePlatforms
            ExcludeRoles                             = $ConditionalAccessPolicy.ExcludeRoles
            ExcludeUsers                             = $ConditionalAccessPolicy.ExcludeUsers
            GrantControlOperator                     = $ConditionalAccessPolicy.GrantControlOperator
            Id                                       = $ConditionalAccessPolicy.Id
            IncludeApplications                      = $ConditionalAccessPolicy.IncludeApplications
            IncludeExternalTenantsMembers            = $ConditionalAccessPolicy.IncludeExternalTenantsMembers
            IncludeExternalTenantsMembershipKind     = $ConditionalAccessPolicy.IncludeExternalTenantsMembershipKind
            IncludeGroups                            = $ConditionalAccessPolicy.IncludeGroups
            IncludeLocations                         = $ConditionalAccessPolicy.IncludeApplications
            IncludePlatforms                         = $ConditionalAccessPolicy.IncludePlatforms
            IncludeRoles                             = $ConditionalAccessPolicy.IncludeRoles 
            IncludeUserActions                       = $ConditionalAccessPolicy.IncludeUserActions 
            IncludeUsers                             = $ConditionalAccessPolicy.IncludeUsers 
            PersistentBrowserIsEnabled               = $ConditionalAccessPolicy.PersistentBrowserIsEnabled
            PersistentBrowserMode                    = $ConditionalAccessPolicy.PersistentBrowserMode
            SignInFrequencyIsEnabled                 = $ConditionalAccessPolicy.SignInFrequencyIsEnabled
            SignInFrequencyType                      = $ConditionalAccessPolicy.SignInFrequencyType
            SignInRiskLevels                         = $ConditionalAccessPolicy.SignInRiskLevels
            State                                    = $ConditionalAccessPolicy.State 
            UserRiskLevels                           = $ConditionalAccessPolicy.UserRiskLevels 
        }
    }

}