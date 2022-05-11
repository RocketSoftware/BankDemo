#Powershell script runs on ES instance on startup
$bitism = ${BITISM}
$pgPassword = ${PGPASSWORD}
$usePac = ${USE_PAC}
$is64bit = "False"
if ( $bitism -eq "64" )
{
  $is64bit = "True"
}

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
cd "C:\Program Files `(x86`)\Micro Focus\Licensing"
Invoke-Expression -Command "cmd.exe /C cesadmintool.exe -term install -f '$licensePath'"
Write-Host "Installing required python libraries"
python -m pip install requests
python -m pip install psycopg2
Write-Host "Starting ESCWA & MFDS services"
Start-Service -Name "mf_CCITCP2"
Start-Service -Name "escwa"

Write-Host "Downloading BANKDEMO sources"
#eventually this step can obtain bankdemo from the public github repo. 
#For now the repo has to be zipped and put in the scripts folder 
cd c:\temp\init\scripts
Expand-Archive .\BankDemo.zip c:\bankdemo
cd c:\bankdemo\BANKDEMO\scripts

Write-Host "Updating demo.json settings"

python MF_Configure_Json.py .\config\demo.json is64bit $is64bit
python MF_Configure_Json.py .\config\demo.json database "VSAM"
python MF_Configure_Json.py .\config\demo.json database_connection password $pgPassword
python MF_Configure_Json.py .\config\demo.json PAC enabled $usePac

$config = Get-Content .\config\database\Postgres\ODBCPostgres.reg -Raw
$config = $config.replace('USRPASS=postgres.postgres','USRPASS=postgres.$pgPassword')
Set-Content -Path .\config\xa_postgres.json -Value $config

$config = Get-Content .\config\xa_postgres.json -Raw
$config = $config.replace('USRPASS=postgres.postgres','USRPASS=postgres.$pgPassword')
Set-Content -Path .\config\xa_postgres.json -Value $config

python MF_Provision_Region.py
