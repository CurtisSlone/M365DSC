@{
    RootModule           = 'Office365.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '4fc5f373-7984-46e6-835c-97401ba17f9a'

    Author               = 'Yorick Kuijs'

    CompanyName          = 'Microsoft'

    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('Office365')
}