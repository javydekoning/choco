$ErrorActionPreference = 'Stop';

$procName = (Get-WmiObject Win32_Processor).Name
if (!$procName.Contains('Ryzen')) {
    Write-Error 'Only compatible with AMD Ryzen processors'
}

$url = 'https://download.amd.com/Desktop/AMD-Ryzen-Master.exe'
$checksum = '87B8487789D5CE2EFB53FB11C1D1583F835DBAA2D587FBB93A9945AC82B65BC1'
$slientArgs = '/S /v/qn'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = $url
    url64          = $url
    softwareName   = 'amd-ryzen-master*'
    checksum       = $checksum
    checksumType   = 'sha256'
    checksum64     = $checksum
    checksumType64 = 'sha256'
    silentArgs     = $slientArgs
    silentArgs64   = $slientArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
