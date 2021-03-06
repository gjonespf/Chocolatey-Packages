try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $exe = "$drop\NugetPackageExplorer.exe"
    Install-ChocolateyZipPackage 'NugetPackageExplorer' 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=npe&DownloadId=781182' $drop
    Install-ChocolateyDesktopLink $exe
    $allTypes = (cmd /c assoc)
    $testType = $allTypes | ? { $_.StartsWith('.nupkg') }
    if($testType -ne $null) {
        $fileType=$testType.Split("=")[1]
    } 
    else {
        $fileType="Nuget.Package"
        Start-ChocolateyProcessAsAdmin "cmd /c assoc .nupkg=$fileType"
    }
    Start-ChocolateyProcessAsAdmin "cmd /c ftype $fileType=`"$exe`" %1"
    Write-ChocolateySuccess 'NuGet Package Explorer'
} catch {
    Write-ChocolateyFailure 'NuGet Package Explorer' $($_.Exception.Message)
    throw 
}