@{
    RootModule           = 'SharePoint.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '0ddcf465-e00d-43f7-943d-b2e3d207e0c7'

    Author               = 'Yorick Kuijs'

    CompanyName          = 'Microsoft'

    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('SharePoint')
}