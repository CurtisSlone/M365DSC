@{
    RootModule    = 'PowerPlatform.schema.psm1'

    ModuleVersion = '0.0.1'

    GUID          = 'fafdbd8a-d8e0-4b38-a7b1-02f98622b579'

    Author        = 'Yorick Kuijs'

    CompanyName   = 'Microsoft'

    Copyright     = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('PowerPlatform')
}