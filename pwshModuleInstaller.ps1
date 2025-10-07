Write-Host 'Installing NuGet Package Provider...'
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Write-Host 'Installing Azure PowerShell module...'
install-module az -Confirm:$false -AllowClobber -Force -verbose
Write-Host 'Installing Microsoft Graph module...'
install-module Microsoft.Graph -Confirm:$false -AllowClobber -Force -verbose
Write-Host 'Finishing Azure PowerShell module installation'



