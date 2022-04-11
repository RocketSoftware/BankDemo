param (
[parameter(Position=0, Mandatory=$false)]
[String]
$FilePath = "$PSScriptRoot"
)
$XmlFileName = "$PSScriptRoot\BANKDEMO.xml"
$XmlBakFileName = "$PSScriptRoot\BANKDEMO.xml.bak"
if (-not(Test-Path -Path $FilePath)) {
    (Write-Host "WARNING: Path does not exist.")
}
$WriteBak = "y"
if (Test-Path -Path $XmlBakFileName) {
    $WriteBak = Read-Host -Prompt "$XmlBakFileName already exists. Do you want to override? (y/n) "
}
if ($WriteBak -eq "y") {
    Copy-Item $XmlFileName -Destination $XmlBakFileName
}
(Get-Content $XmlFileName) -replace '__IMPORT_FILE_DIR__', $FilePath | Out-File -encoding ASCII $XmlFileName