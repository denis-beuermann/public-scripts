function downloadPackage {
    write-host ('Downloading Package "' + $package.PackageName + '"')
    Write-Host ("Create temmporary package folder " + $package.PackageName)
    New-Item -Path C:\\tmp -Name $package.packageName -ItemType Directory -ErrorAction SilentlyContinue
    $packagePath = ($tmpDirectory + '\' + $package.PackageName )
    Write-Host ("Download package " + $package.PackageName + " from " + $package.PackageUrl)
    Invoke-WebRequest -Uri $package.PackageUrl -OutFile ($packagePath + '\' + $package.PackageInstaller)
}

function expandPackage {
    Write-Host ("Extract package " + $package.PackageName)
    $packagePath = ($tmpDirectory + '\' + $package.PackageName )
    Expand-Archive ($packagePath + '\' + $package.PackageInstaller) -DestinationPath $packagePath -Force
}
function installPackage {
    
    Write-Host ('Setup type "' + $setupType + '" detected')
    Write-Host ("Install package " + $package.PackageName)
    $packagePath = ($tmpDirectory + '\' + $package.PackageName )
    
    switch ($setupType) {
        "msi" {
            Start-Process `
                -FilePath "msiexec.exe" `
                -ArgumentList "/i $packagePath\$($package.PackageSetup) /qn /norestart" `
                -Wait `
                -Passthru
        }
        "exe" {
            #Set-Location "$packagePath\FSLogix\x64\Release\"
            Start-Process `
                -FilePath "$packagePath\x64\Release\FSLogixAppsSetup.exe" `
                -ArgumentList $package.PackageArguments `
                -Wait `
                -Passthru
            #Set-Location $packagePath
            #Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
            #.\$($package.PackageSetup) -AllUsers -Quiet
        } 
    }
}

function tmpCleanup {
    Write-Host ("Cleanup temporary files for package " + $package.PackageName)
    $packagePath = ($tmpDirectory + '\' + $package.PackageName )
    Remove-Item $packagePath -Force -Confirm:$false -Recurse  
}

$tmpDirectory = 'C:\\tmp'
$packages = @(
        [PSCustomObject]@{
            PackageName = 'fslogix'
            PackageUrl = 'https://aka.ms/fslogix_download'
            PackageInstaller = "fslogix_download.zip"
            PackageType = "zip"
            PackageSetup = "FSLogixAppsSetup.exe"
            PackageArguments = "/install /quiet"
        },
        [PSCustomObject]@{
            PackageName = 'pwsh'
            PackageUrl = 'https://github.com/PowerShell/PowerShell/releases/download/v7.5.3/PowerShell-7.5.3-win-x64.msi'
            PackageInstaller = "PowerShell-7.5.3-win-x64.msi"
            PackageType = "msi"
            PackageSetup = "PowerShell-7.5.3-win-x64.msi"
        }
        [PSCustomObject]@{
            PackageName = 'vscode';
            PackageUrl = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64';
            PackageInstaller = "VSCodeSetup-x64-1.104.3.exe"
            PackageType = "exe"
            PackageSetup = "VSCodeSetup-x64-1.104.3.exe"
            PackageArguments = "/very /suppressmsgboxes"
        }
    )

New-Item -Path C:\\ -Name tmp -ItemType Directory -ErrorAction SilentlyContinue
foreach ($package in $packages) {  
    downloadPackage
    if ($package.PackageType -eq 'zip') {
        expandPackage
    }
    Write-Host ("Detect setup type for package " + $package.PackageName)
    $setupType = $package.PackageSetup.Substring($package.PackageSetup.Length -3)
    installPackage
    tmpCleanup
}

#$WVDfslogixURL = 'https://raw.githubusercontent.com/DeanCefola/Azure-WVD/master/PowerShell/FSLogixSetup.ps1'
#$WVDFslogixInstaller = 'FSLogixSetup.ps1'
#$outputPath = $fslogixPath + '\' + $WVDFslogixInstaller
#Invoke-WebRequest -Uri $WVDfslogixURL -OutFile $outputPath
#set-Location $fslogixPath

#Invoke-WebRequest $fsLogixURL -OutFile $LocalPath\$installerFile
#Expand-Archive $LocalPath\$installerFile -DestinationPath $LocalPath
#write-host 'AIB Customization: Download Fslogix installer finished'

#write-host 'AIB Customization: Start Fslogix installer'
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
#.\\FSLogixSetup.ps1 -ProfilePath \\wvdSMB\wvd -Verbose 
#write-host 'AIB Customization: Finished Fslogix installer' 

#rd .\tmp\ -Force -Confirm:$false -Recurse  
