Configuration ConfigureLCM
{
 Import-DscResource -ModuleName PsDesiredStateConfiguration -SkipEditionCheck
 node localhost
 {
    LocalConfigurationManager
 {
    ConfigurationMode = "ApplyOnly"
 }
 }
}
ConfigureLcm