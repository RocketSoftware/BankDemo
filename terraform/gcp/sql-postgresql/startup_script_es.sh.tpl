echo "Downloading setup scripts"
mkdir setup
gsutil cp "${BUCKET_URL}/scripts/*" ./setup
chmod u+x ./setup/*
./setup/setup.sh ${BUCKET_URL}

yum install -y postgresql12-odbc
#An entry is created in odbcinst.ini for /usr/lib64/psqlodbcw.so
#but the postgresql12-odbc package installs to /usr/pgsql-12/lib/psqlodbcw.so
cp /usr/pgsql-12/lib/psqlodbcw.so /usr/lib64/

cat << EOF > dsn.template
[BANK]
Driver=PostgreSQL
Description=Bankdemo
Servername=127.0.0.1
Port=5433
Database=bank
EOF
odbcinst -install -s -l -f dsn.template

echo "Setting up cloudsql proxy"
#Set up local proxy that forwards to cloudsql instance
#Listen on 5433 as local postgresql server might already be listening on 5432
./setup/setup-cloudsql-proxy.sh ${SQL_CONNECTION} 5433

. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv
cd /home/demouser/MFETDUSER/scripts
#python3 MF_Configure_Json.py ./config/demo.json database "VSAM"

python3 MF_Configure_Json.py ./options/sql_postgres.json database_connection server_port 5433
python3 MF_Configure_Json.py ./options/sql_postgres.json database_connection user ${PGUSER}
python3 MF_Configure_Json.py ./options/sql_postgres.json database_connection password ${PGPASSWORD}
python3 MF_Provision_Region.py sql_postgres

#setup VNC tunnel using:
#gcloud compute ssh --project amc-marketplacegcp-nonprod js1-es-2csp
#ssh -i c:\users\jamess\.ssh\google_compute_engine -v -C -L 5900:localhost:5900 JamesS@35.214.51.135

