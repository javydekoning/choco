$ErrorActionPreference = 'Stop';

$procName = (Get-WmiObject Win32_Processor).Name

if (!$procName.Contains('Ryzen')) {
    Write-Warning 'Only compatible with AMD Ryzen processors!'
    Write-Error "Processor not supported: $procName"
}
else {
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $url = 'https://drivers.amd.com/drivers/amd_chipset_software_2.07.14.327.exe'
    $checksum = '053C486B63A0A1F02AD564167DBC32CAE88BBAA41F0BF1F104D505BC599CA546'
    $filePath = "$toolsDir\amd-chipset-drivers.exe"

    $downloadArgs = @{
        packageName  = $env:ChocolateyPackageName
        fileFullPath = $filePath
        url          = $url
        checksum     = $checksum
        checksumType = 'sha256'
        options      = @{
            Headers = @{             
                Accept  = '*/*'
                Referer = 'https://www.amd.com/en/support/chipsets/amd-socket-am4/a320'
            }
        }
    }

    Get-ChocolateyWebFile @downloadArgs

    Start-Process -FilePath "$env:comspec" -ArgumentList "/c START /WAIT `"`" `"$filePath`" /S" -NoNewWindow -Wait
    New-Item -Path "$filePath.ignore" -ItemType File
}
