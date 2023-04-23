Configuration ConfigureLCM
{
 Import-DscResource -ModuleName PsDesiredStateConfiguration 
 node localhost
 {
    LocalConfigurationManager
 {
    ConfigurationMode = "ApplyOnly"
 }
 }
}
ConfigureLcm