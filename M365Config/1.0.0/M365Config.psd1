@{
    ModuleVersion        = '1.0.0'

    Author               = 'Curtis Slone'

    RequiredModules      = @()

    DscResourcesToExport = @('*')

    Description          = 'DSC composite resource for configuring Microsoft 365'

    PrivateData          = @{

        PSData = @{

            Tags                       = @('DSC', 'Configuration', 'Composite', 'Resource', 'Microsoft365DSC')

            ExternalModuleDependencies = @('Microsoft365DSC')

        }
    }
}