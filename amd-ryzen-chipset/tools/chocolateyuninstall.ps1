$ErrorActionPreference = 'Stop';

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    softwareName   = 'amd-ryzen-chipset*'
    fileType       = 'EXE'
    silentArgs     = '-UNINSTALL'
    validExitCodes = @(0)
}

$uninstall = $false
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AMD Catalyst Install Manager'

if (Test-Path $registryPath) {
    $installLocation = 'InstallLocation'
    $keys = Get-ItemProperty -Path $registryPath
    $installLocation = $keys | Select-Object -ExpandProperty $installLocation -ErrorAction SilentlyContinue
    if ($installLocation) {
        $file = Join-Path -Path $installLocation -ChildPath 'Setup.exe'   
        if (Test-Path $file) {
            $packageArgs['file'] = $file
            Uninstall-ChocolateyPackage @packageArgs
            $uninstall = $true
        }
    }
}

if (!$uninstall) {
    Write-Warning "$($packageArgs.packageName) has already been uninstalled by other means."
}
