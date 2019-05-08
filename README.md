# PowerShell.CreateUserFolders
A simple PowerShell script that reads users in Active Directory, creates a folder for each user and sets "Full Control" permissions on the folder. You can easily adjust the base directory ($FolderBase), the NetBIOS name of the domain ($DomainNetBIOS) and also the Serach Base ($SearchBase) for the Active Directory search (organization unit in Active Directory from which the users are obtained).
