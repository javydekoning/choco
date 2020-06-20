$ErrorActionPreference = 'Stop';

$procName = (Get-WmiObject Win32_Processor).Name
if (!$procName.Contains('Ryzen')) {
    Write-Warning 'Only compatible with AMD Ryzen processors!'
    Write-Warning 'Skipping uninstall...'
}
else {
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $checksum = 'E10649A1844D1B1BAF2B0C58BEDBC033AD817EC9F68FD5322AB793D6E855718D'
    $filePath = "$toolsDir\amd-chipset-drivers.exe"

    Get-ChecksumValid -File $filePath -Checksum $checksum -ChecksumType 'sha256'

    Start-Process -FilePath "$env:comspec" -ArgumentList "/c START /WAIT `"`" `"$filePath`" /S /EXPRESSUNINSTALL=1" -NoNewWindow -Wait

    Remove-Item $filePath -Force -ErrorAction SilentlyContinue
    Remove-Item "$filePath.ignore" -Recurse -Force -ErrorAction SilentlyContinue
}
