echo "Downloading setup scripts"
mkdir setup
gsutil cp "${BUCKET_URL}/scripts/*" ./setup
chmod u+x ./setup/*
./setup/setup.sh ${BUCKET_URL}

. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv

jdkpath=$(ls /usr/lib/jvm/ | grep java-11-openjdk-11)
export JAVA_HOME=/usr/lib/jvm/$jdkpath
echo "JAVA_HOME=$JAVA_HOME"

cd /bankdemo/scripts
#python3 MF_Configure_Json.py ./config/demo.json database "VSAM"
python3 MF_Provision_Region.py vsam

#setup VNC tunnel using:
#gcloud compute ssh --project amc-marketplacegcp-nonprod js1-es-2csp
#ssh -i c:\users\jamess\.ssh\google_compute_engine -v -C -L 5900:localhost:5900 JamesS@35.214.51.135
