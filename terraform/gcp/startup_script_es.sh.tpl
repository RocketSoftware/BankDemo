bitism=${BITISM}
is64bit="False"
pgPassword=${PGPASSWORD}
usePac=${USE_PAC}

echo "Downloading setup scripts"

mkdir /tmp/init
cd /tmp/init
mkdir eslicense
mkdir scripts
gsutil cp "${BUCKET_URL}/eslicense/*" ./eslicense
gsutil cp "${BUCKET_URL}/scripts/*" ./scripts

licenseFile=$(ls eslicense)
licensePath=$PWD/eslicense/$licenseFile

echo "Installing license file"
# Currently interactive, so need this workaround
/var/microfocuslicensing/bin/cesadmintool.sh -install $licensePath << block
block

find /opt/microfocus/EnterpriseDeveloper/etc -type d -exec chmod 777 {} \; # So escwa can write to the logfile
runuser -l demouser -c '. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv; escwa &'

service firewalld stop
sh -c '. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv; export CCITCP2_PORT=86; mfds64 --listen-all; mfds64 &'

if [ $? -ne 0 ]; then
    echo "Failed to start MFDS."
    exit 1
fi

echo "Downloading BANKDEMO sources"
#eventually this step can obtain bankdemo from the public github repo. 
#For now the repo is obtained from a zip held in cloud storage
gsutil cp gs://js-bucket2/bankdemo.zip .
unzip bankdemo.zip
cp -R ./bankdemo /bankdemo
chmod -R a+wrx /bankdemo
cd /bankdemo/scripts
. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv

python3 MF_Configure_Json.py ./config/demo.json is64bit $is64bit
python3 MF_Configure_Json.py ./config/demo.json database "VSAM"
python3 MF_Configure_Json.py ./config/demo.json database_connection password $pgPassword
python3 MF_Configure_Json.py ./config/demo.json PAC enabled $usePac
python3 MF_Provision_Region.py

#setup VNC tunnel using:
#gcloud compute ssh --project amc-marketplacegcp-nonprod js1-es-2csp
#ssh -i c:\users\jamess\.ssh\google_compute_engine -v -C -L 5900:localhost:5900 JamesS@35.214.51.135
