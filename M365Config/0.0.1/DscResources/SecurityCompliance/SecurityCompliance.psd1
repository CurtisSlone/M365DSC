@{
    RootModule           = 'SecurityCompliance.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '59330cae-baea-49af-97f1-fdb1faf6307b'

    Author               = 'Yorick Kuijs'

    CompanyName          = 'Microsoft'

    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('SecurityCompliance')
}