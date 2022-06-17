dbConnectionName=$1
dbListenPort=$2
echo "Installing cloudsql proxy"
yum install -y wget
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy
./cloud_sql_proxy -instances=${dbConnectionName}=tcp:$dbListenPort &

#wait for cloud sql proxy to start before proceeding
#to prevent errors in subsequent commands that connect to the DB
#maximum wait time is around 50 seconds
i=1
while [ "$i" -le 60 ]
do
  netstat -ln | grep $dbListenPort
  if [[ "$?" -eq 0 ]]; then
    echo "cloud_sql_proxy running"
    break
  fi
  if [[ "$i" -eq 50 ]]; then
    echo "error: cloud_sql_proxy timeout"
    break
  fi
  ((i++))
  sleep 1000
done