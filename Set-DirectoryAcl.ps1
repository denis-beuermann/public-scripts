<#
.SYNOPSIS
    This script sets the ACL for a directory, allowing you to specify the path and the security principal to which you want to grant permissions.
.DESCRIPTION
    The script helps you to set permissions for a specified directory by adding an access control entry (ACE) for a given security principal. You can specify the path to the directory and the security principal (e.g., user or group) to which you want to grant permissions.
.PARAMETER path
    The path to the directory for which you want to set the ACL. You should replace the default value with the actual path to your directory.
.PARAMETER securityPrincipal
    The security principal (e.g., user or group) to which you want to grant permissions. You should replace the default value with the actual security principal you want to add.    
.NOTES
    This function is not supported in Linux or macOS environments. It relies on Windows-specific ACL management. The servicePrincipal parameter is language agnostic. This is important in case you want to add local groups (f.e. Builtin\Users on english and Vordefiniert\Benutzer in german installation).
.LINK
    There is no link for this script, but you can find more information about ACL management in PowerShell in the official Microsoft documentation: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-acl
.EXAMPLE
    set-directoryacl.ps1 -path "C:\acl" -securityPrincipal "Builtin\Users"
#>

param (
    [string]$path = "c:\tmp\acl",
    [string]$securityPrincipal = "VORDEFINIERT\Benutzer"
)

$acl = Get-Acl -Path $path
# Debug Get-Acl -Path $path | Format-List
# specify the new group to add 
$addtlGroupIdentity = $securityPrincipal
# define the access rights 
$addtlGroupAccessRights = 'Modify' 
# define the access type "allow/deny" 
$addtlGroupAccessType = 'Allow'
$addtlInheritanceFlags = 'ContainerInherit,ObjectInherit'
$newACE = ([System.Security.AccessControl.FileSystemAccessRule]::New($addtlGroupIdentity, $addtlGroupAccessRights, $addtlInheritanceFlags, "none",$addtlGroupAccessType))
# Set the new ACE 
$acl.AddAccessRule($newACE) 
# Display the updated ACE 
# Debug $acl.Access | Format-Table
# Update the directory ACL 
Set-Acl -Path $path -AclObject $acl 
# Get the new directory ACL 
# Debug Get-Acl -Path $path | Format-List