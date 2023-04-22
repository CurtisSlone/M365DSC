@{
    RootModule           = 'Teams.schema.psm1'

    ModuleVersion        = '0.0.1'

    GUID                 = '098b05cc-c50a-46b6-813c-b1bb8a59968f'

    Author               = 'Yorick Kuijs'

    CompanyName          = 'Microsoft'

    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'

    #RequiredModules      = @(
    #    @{ ModuleName = 'xPSDesiredStateConfiguration'; ModuleVersion = '8.4.0.0' }
    #)

    DscResourcesToExport = @('Teams')
}