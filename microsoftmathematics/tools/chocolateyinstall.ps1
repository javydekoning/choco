$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$fullFilePath = "$toolsDir\MSetup.exe"

$downloadArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileFullPath   = $fullFilePath
    url            = 'https://download.microsoft.com/download/F/7/6/F76E0187-07B5-4958-B3FF-2E5ACD53B637/MSetup_x86.exe'
    url64          = 'https://download.microsoft.com/download/F/7/6/F76E0187-07B5-4958-B3FF-2E5ACD53B637/MSetup_x64.exe'
    checksum       = '318873EA190CE55572672F67E2320AE393374C1775A13DE963E4D673532DF295'
    checksumType   = 'sha256'
    checksum64     = '1BBF871F90BD2314D10809B9C1A7A150E4FE5FE61571AF8EBB893C91E41C337A'
    checksumType64 = 'sha256'
}

Get-ChocolateyWebFile @downloadArgs

$extractionPath = "$toolsDir\MSetupFiles"
Invoke-Expression "& '$fullFilePath' /T:'$extractionPath' /C | Out-Null" 

$installerType = 'MSI'
$filePath32 = "$extractionPath\MSMath_x86.msi"
$filePath64 = "$extractionPath\MSMath_x64.msi"
$slientArgs = "/passive FROMSETUP=1 ALREADYRUNNING=0 DOTNET35=1 SXSOFF=0"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = $installerType
    file           = $filePath32
    file64         = $filePath64
    softwareName   = 'microsoftmathematics*'
    checksum       = '8BF70EC328A62A0A720FA6F52DE9F22DD1EA23F64F67F27BD64209248AF078B7'
    checksumType   = 'sha256'
    checksum64     = 'E56C32CF9D3D621C4281842117C478D56702BCA0268D1A76447C1720A2678BD0'
    checksumType64 = 'sha256'
    silentArgs     = $slientArgs
    silentArgs64   = $slientArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
