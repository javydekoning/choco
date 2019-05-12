$ErrorActionPreference = 'Stop';

$procName = (Get-WmiObject Win32_Processor).Name
if (!$procName.Contains('Ryzen')) {
    Write-Error 'Only compatible with AMD Ryzen processors'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Need to uninstall any existing version
Write-Information 'Attempting removal of existing AMD Ryzen Chipset drivers...'
$uninstallFile = Join-Path -Path $toolsDir -ChildPath 'chocolateyuninstall.ps1'
Start-ChocolateyProcessAsAdmin "& `'$uninstallFile`'"

$url = 'https://drivers.amd.com/drivers/amd_chipset_drivers_19.10.0429.exe'
$checksum = 'FC811EE24F4150DA9BC4168EFCC299F2392C99763DE6CE2691686CE662A3AB8D'
$fullFilePath = "$toolsDir\amd-chipset-drivers.exe"

$downloadArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath   = $fullFilePath
    url            = $url
    url64          = $url
    checksum       = $checksum
    checksumType   = 'sha256'
    checksum64     = $checksum
    checksumType64 = 'sha256'
    options        = @{
        Headers = @{             
            Accept  = '*/*'
            Referer = 'https://www.amd.com/en/support/chipsets/amd-socket-am4/a320'
        }
    }
}

Get-ChocolateyWebFile @downloadArgs

$extractionPath = "$toolsDir\AMD-Chipset-Drivers"
Get-ChocolateyUnzip -FileFullPath $fullFilePath -Destination $extractionPath

$installerType = 'EXE'
$filePath = "$extractionPath\Setup.exe"
$checksum = 'FA360E1966FBF9D66C340C156D81A8BF2069EBFE609EB5741BE56C85F1E017B7'
$slientArgs = '-INSTALL'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = $installerType
    file           = $filePath
    file64         = $filePath
    softwareName   = 'amd-ryzen-chipset*'
    checksum       = $checksum
    checksumType   = 'sha256'
    checksum64     = $checksum
    checksumType64 = 'sha256'
    silentArgs     = $slientArgs
    silentArgs64   = $slientArgs
    validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fullFilePath -Force -ErrorAction SilentlyContinue
Remove-Item $extractionPath -Recurse -Force -ErrorAction SilentlyContinue
