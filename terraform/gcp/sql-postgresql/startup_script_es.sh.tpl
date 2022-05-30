echo "Downloading setup scripts"
mkdir setup
gsutil cp "${BUCKET_URL}/scripts/*" ./setup
chmod u+x ./setup/*
./setup/setup.sh ${BUCKET_URL}

echo "Setting up cloudsql proxy"
#Set up local proxy that forwards to cloudsql instance
#Listen on 5433 as local postgresql server might already be listening on 5432
./setup-cloudsql-proxy.sh ${SQL_CONNECTION} 5433

. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv
cd /bankdemo/scripts
#python3 MF_Configure_Json.py ./config/demo.json database "VSAM"

python3 MF_Configure_Json.py ./config/demo.json database_connection server_port 5433
python3 MF_Configure_Json.py ./config/demo.json database_connection user ${PGUSER}
python3 MF_Configure_Json.py ./config/demo.json database_connection password ${PGPASSWORD}
python3 MF_Provision_Region.py vsam_postgres.json

#setup VNC tunnel using:
#gcloud compute ssh --project amc-marketplacegcp-nonprod js1-es-2csp
#ssh -i c:\users\jamess\.ssh\google_compute_engine -v -C -L 5900:localhost:5900 JamesS@35.214.51.135
