bucketUrl=$1
echo "Downloading BANKDEMO sources"
gsutil cp $bucketUrl/bankdemo.zip /tmp/bankdemo.zip
unzip /tmp/bankdemo.zip -d /
chmod -R a+wrx /bankdemo

echo "Installing license file"
mkdir eslicense
gsutil cp "$bucketUrl/eslicense/*" ./eslicense
licenseFile=$(ls eslicense)
licensePath=$PWD/eslicense/$licenseFile
echo "Installing license file"
# Currently interactive, so need this workaround
/var/microfocuslicensing/bin/cesadmintool.sh -install $licensePath << block
block

echo "Starting ESCWA"
find /opt/microfocus/EnterpriseDeveloper/etc -type d -exec chmod 777 {} \; # So escwa can write to the logfile
runuser -l demouser -c '. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv; escwa &'

service firewalld stop
echo "Starting MFDS"
sh -c '. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv; export CCITCP2_PORT=86; mfds64 --listen-all; mfds64 &'
if [ $? -ne 0 ]; then
    echo "Failed to start MFDS."
    exit 1
fi

. /opt/microfocus/EnterpriseDeveloper/bin/cobsetenv