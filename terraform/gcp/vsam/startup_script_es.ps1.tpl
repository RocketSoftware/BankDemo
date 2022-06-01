#Powershell script runs on ES instance on startup
Write-Host "Downloading setup scripts"
mkdir c:\temp\init
cd c:\temp\init
mkdir eslicense
mkdir scripts
gsutil cp "${BUCKET_URL}/eslicense/*" .\eslicense
gsutil cp "${BUCKET_URL}/scripts/*" .\scripts
$currentDirectory = Get-Location
Write-Host "Installing product license"
$licenseFile = (Get-ChildItem -Path eslicense).Name
$licensePath = "$currentDirectory\eslicense\$licenseFile"
if ("$licenseFile" -eq "")
{
  write-host "Error: license file not found in eslicense folder"
  exit 1
}
cd "C:\Program Files `(x86`)\Micro Focus\Licensing"
Invoke-Expression -Command "cmd.exe /C cesadmintool.exe -term install -f '$licensePath'"
Write-Host "Installing required python libraries"
python -m pip install requests
python -m pip install psycopg2
Write-Host "Starting ESCWA & MFDS services"
Start-Service -Name "mf_CCITCP2"
Start-Service -Name "escwa"

Write-Host "Downloading BANKDEMO sources"
gsutil cp "${BUCKET_URL}/bankdemo.zip" c:\temp
Expand-Archive c:\temp\BankDemo.zip c:\bankdemo
cd c:\bankdemo\bankdemo\scripts
python MF_Provision_Region.py vsam
