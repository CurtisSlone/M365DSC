Configuration OneDrive
{
    param
    (
        [Parameter()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC
    
    

}