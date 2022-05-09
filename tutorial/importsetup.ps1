param (
[parameter(Position=0, Mandatory=$false)]
[String]
$FilePath = "$PSScriptRoot"
)
$TemplateFileName = "$PSScriptRoot\BANKDEMO.template"
$XmlFileName = "$PSScriptRoot\BANKDEMO.xml"
$XmlBakFileName = "$PSScriptRoot\BANKDEMO.xml.bak"
if (-not(Test-Path -Path $FilePath)) {
    (Write-Host "WARNING: Path does not exist.")
}
$WriteXml = "y"
if (Test-Path -Path $XmlFileName) {
    if (Test-Path -Path $XmlBakFileName) {
        $WriteXml = Read-Host -Prompt "$XmlBakFileName already exists. Do you want to override? (y/n) "
        if ($WriteXml -eq "y") {
            Copy-Item $XmlFileName -Destination $XmlBakFileName
        }
    }

}
if ($WriteXml -eq "y") {
    (Get-Content $TemplateFileName) -replace '__IMPORT_FILE_DIR__', $FilePath | Out-File -encoding ASCII $XmlFileName
} else {
        Read-Host -Prompt "Error: Enterprise Server definition was not created. Press return to continue"
}