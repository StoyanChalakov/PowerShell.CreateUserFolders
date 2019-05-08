#Impoerting Module
Import-Module ActiveDirectory
 
#region variables
#Define the base directory for all user folders
$FolderBase = "C:\UserFolders"
#Get the Domain NetBIOS name
$DomainNetBIOS = Get-ADDomain | Select-Object -ExpandProperty NetBIOSName
#AD Search Base
$SearchBase = 'OU=Organization,DC=domain,DC=com'
#endregion
 
#Get the users
try {
    $userbase = Get-ADUser -searchbase $SearchBAse -Filter * -Properties samaccountname
} catch {
    $ErrorMessage = "Unable to get the users from Actibve Directory"
    Write-Host $ErrorMessage
    Throw $ErrorMessage
}


#iterate through the users, create a folder for each user and set "Full Control" permission on the folder
ForEach ($user in $userbase)
{
    #Get the SamAccountName and format it for later use
    $samaccountname = $user.samaccountname
    $DomSamAccountName = $DomainNetBIOS + "\" + $samaccountname
 
    #Generate user folder path
    $newPath = $FolderBase + "\" + $samaccountname
    #Test if the folder already exists
    $test = Test-path -Path $newPath
 
    #Create the folder if it does not exist
    if(!($test)){
        New-Item $newPath -Itemtype directory
    }else{
        Write-Verbose "Folder '$newPath' already exists." -Verbose
    }
    
    #Set user permissions on the folder
    $FolderACL = Get-Acl $newPath
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$DomSamAccountName","FullControl","Allow")
    $FolderACL.SetAccessRule($AccessRule)
    $FolderACL | Set-Acl $newPath
    
}   
