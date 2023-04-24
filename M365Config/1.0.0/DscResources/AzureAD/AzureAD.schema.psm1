Configuration AzureAD
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $OrganizationName = $ConfigurationData.NonNodeData.Environment.OrganizationName
    
    foreach ($ConditionalAccessPolicy in $ConfigurationData.NonNodeData.AzureAD.ConditionalAccessPolicies)
    {
       
    }

}