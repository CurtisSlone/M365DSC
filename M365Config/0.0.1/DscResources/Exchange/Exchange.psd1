@{
    RootModule           = 'Exchange.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '93eb8565-a941-42ae-9de3-3d8084e3cfc2'

    Author               = 'Yorick Kuijs'

    CompanyName          = 'Microsoft'

    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('Exchange')
}