Configuration SecurityCompliance
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

    #region Data Loss Prevention
    SCDLPCompliancePolicy 'DLPPolicy_USFinancialData'
    {
        Name                            = "U.S. Financial Data"
        Comment                         = ""
        ExchangeLocation                = "All"
        ExchangeSenderMemberOf          = @()
        ExchangeSenderMemberOfException = @()
        Mode                            = "Disable"
        OneDriveLocation                = "All"
        OneDriveLocationException       = @()
        Priority                        = 0
        SharePointLocation              = "All"
        SharePointLocationException     = @()
        TeamsLocation                   = "All"
        TeamsLocationException          = @()
        Ensure                          = "Present"
        Credential                      = $Credential
    }

    SCDLPComplianceRule 'DLPRule_USFinancialData_LowVolume'
    {
        Name                                = "Low volume of content detected U.S. Financial Data"
        Policy                              = "U.S. Financial Data"
        AccessScope                         = "NotInOrganization"
        BlockAccess                         = $False
        ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
        {
            SensitiveInformation = @(
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'Credit Card Number'
                    id             = '50842eb7-edc8-4019-85dd-5a5c1f2bb085'
                    maxconfidence  = '100'
                    minconfidence  = '85'
                    classifiertype = 'Content'
                    mincount       = '1'
                    maxcount       = '9'
                }
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'U.S. Bank Account Number'
                    id             = 'a2ce32a8-f935-4bb6-8e96-2a5157672e2c'
                    maxconfidence  = '100'
                    minconfidence  = '75'
                    classifiertype = 'Content'
                    mincount       = '1'
                    maxcount       = '9'
                }
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'ABA Routing Number'
                    id             = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'
                    maxconfidence  = '100'
                    minconfidence  = '75'
                    classifiertype = 'Content'
                    mincount       = '1'
                    maxcount       = '9'
                }
            )
        }
        Disabled                            = $False
        DocumentIsPasswordProtected         = $False
        DocumentIsUnsupported               = $False
        ExceptIfDocumentIsPasswordProtected = $False
        ExceptIfDocumentIsUnsupported       = $False
        ExceptIfHasSenderOverride           = $False
        ExceptIfProcessingLimitExceeded     = $False
        HasSenderOverride                   = $False
        ProcessingLimitExceeded             = $False
        RemoveRMSTemplate                   = $False
        ReportSeverityLevel                 = "Low"
        StopPolicyProcessing                = $False
        Ensure                              = "Present"
        Credential                          = $Credential
        DependsOn                           = '[SCDLPCompliancePolicy]DLPPolicy_USFinancialData'
    }

    SCDLPComplianceRule 'DLPRule_USFinancialData_HighVolume'
    {
        Name                                = "High volume of content detected U.S. Financial Data"
        Policy                              = "U.S. Financial Data"
        AccessScope                         = "NotInOrganization"
        BlockAccess                         = $False
        ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
        {
            SensitiveInformation = @(
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'Credit Card Number'
                    id             = '50842eb7-edc8-4019-85dd-5a5c1f2bb085'
                    maxconfidence  = '100'
                    minconfidence  = '85'
                    classifiertype = 'Content'
                    mincount       = '10'
                    maxcount       = '-1'
                }
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'U.S. Bank Account Number'
                    id             = 'a2ce32a8-f935-4bb6-8e96-2a5157672e2c'
                    maxconfidence  = '100'
                    minconfidence  = '75'
                    classifiertype = 'Content'
                    mincount       = '10'
                    maxcount       = '-1'
                }
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'ABA Routing Number'
                    id             = 'cb353f78-2b72-4c3c-8827-92ebe4f69fdf'
                    maxconfidence  = '100'
                    minconfidence  = '75'
                    classifiertype = 'Content'
                    mincount       = '10'
                    maxcount       = '-1'
                }
            )
        }
        Disabled                            = $False
        DocumentIsPasswordProtected         = $False
        DocumentIsUnsupported               = $False
        ExceptIfDocumentIsPasswordProtected = $False
        ExceptIfDocumentIsUnsupported       = $False
        ExceptIfHasSenderOverride           = $False
        ExceptIfProcessingLimitExceeded     = $False
        HasSenderOverride                   = $False
        ProcessingLimitExceeded             = $False
        RemoveRMSTemplate                   = $False
        ReportSeverityLevel                 = "High"
        StopPolicyProcessing                = $False
        Ensure                              = "Present"
        Credential                          = $Credential
        DependsOn                           = '[SCDLPCompliancePolicy]DLPPolicy_USFinancialData'
    }
    #endregion

    #region Sensitivity Labels
    SCSensitivityLabel 'SensitivityLabel_7039522b-ce94-44a0-92fb-0481c418a4e6'
    {
        Name                        = "7039522b-ce94-44a0-92fb-0481c418a4e6"
        AdvancedSettings            = @(
            MSFT_SCLabelSetting
            {
                Key   = 'aiplabelversion'
                Value = '6930dbde-8212-4d76-bd97-1d8f0411f27b'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'color'
                Value = '#317100'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'tooltip'
                Value = 'Approved information for public disclosure'
            }
        )
        Comment                     = ""
        Disabled                    = $False
        DisplayName                 = "DSCPublic"
        EncryptionEnabled           = $False
        EncryptionProtectionType    = "Template"
        Priority                    = 1
        Tooltip                     = "Approved information for public disclosure"
        Ensure                      = "Present"
        Credential                  = $Credential
    }

    SCSensitivityLabel 'SensitivityLabel_c525c408-17aa-4d15-8054-eee39715993e'
    {
        Name                               = "c525c408-17aa-4d15-8054-eee39715993e"
        AdvancedSettings                   = @(
            MSFT_SCLabelSetting
            {
                Key   = 'aiplabelversion'
                Value = '36d61235-7151-4448-b9ad-03ce5dc5493c'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'color'
                Value = '#0078D7'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'tooltip'
                Value = 'Company information intended for use by all colleagues on a need to know basis when conducting company business'
            }
        )
        ApplyContentMarkingFooterAlignment = "Left"
        ApplyContentMarkingFooterEnabled   = $False
        ApplyContentMarkingFooterFontColor = "#000000"
        ApplyContentMarkingFooterFontSize  = 8
        ApplyContentMarkingFooterMargin    = 15
        ApplyContentMarkingFooterText      = "Sensitivity: Internal"
        Comment                            = ""
        Disabled                           = $False
        DisplayName                        = "Internal"
        EncryptionEnabled                  = $False
        EncryptionProtectionType           = "Template"
        Priority                           = 2
        Tooltip                            = "Company information intended for use by all colleagues on a need to know basis when conducting company business"
        Ensure                             = "Present"
        Credential                         = $Credential
    }

    SCSensitivityLabel 'SensitivityLabel_42455fcb-65d9-4933-afb7-0da26de1c595'
    {
        Name                               = "42455fcb-65d9-4933-afb7-0da26de1c595"
        AdvancedSettings                   = @(
            MSFT_SCLabelSetting
            {
                Key   = 'aiplabelversion'
                Value = 'e03259b7-4b5b-430b-9815-de92822cb5c8'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'color'
                Value = '#FF8C00'
            }
            MSFT_SCLabelSetting
            {
                Key   = 'tooltip'
                Value = 'Information that is sensitive and intended for restricted specific business groups of colleagues on a need to know basis'
            }
        )
        ApplyContentMarkingFooterAlignment = "Left"
        ApplyContentMarkingFooterEnabled   = $False
        ApplyContentMarkingFooterFontColor = "#000000"
        ApplyContentMarkingFooterFontSize  = 8
        ApplyContentMarkingFooterMargin    = 15
        ApplyContentMarkingFooterText      = "Sensitivity: Confidential"
        Comment                            = ""
        Disabled                           = $False
        DisplayName                        = "DSCConfidential"
        EncryptionEnabled                  = $False
        EncryptionProtectionType           = "Template"
        Priority                           = 3
        Tooltip                            = "Information that is sensitive and intended for restricted specific business groups of colleagues on a need to know basis"
        Ensure                             = "Present"
        Credential                         = $Credential
    }
    #endregion
}
