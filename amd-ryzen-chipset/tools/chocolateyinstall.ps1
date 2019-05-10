$ErrorActionPreference = 'Stop';

$procName = (Get-WmiObject Win32_Processor).Name
if (!$procName.Contains('Ryzen')) {
    Write-Error 'Only compatiable with AMD Ryzen processors'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://drivers.amd.com/drivers/amd-chipset-drivers_18.50.0422.exe'
$checksum = '26093A75ED4859E26FFEC58A1F528EAC803946C8E49C87AE2A42992E59AF2D6C'
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
$checksum = '1D6778C54D8808F4C4144DEB1D4DCC98C23085D90C8F745351BB8238BF234268'
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
