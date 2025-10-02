Write-Host "Installing Azure PowerShell module..."
install-module az.accounts -force -allowclobber -confirm:$false
Write-Host "Finishing Azure PowerShell module installation"