bucketUrl=$1
echo "Downloading BANKDEMO sources"
gsutil cp $bucketUrl/bankdemo.zip /tmp/bankdemo.zip
#tutorial expects bankdemo to be under /home/demouser/MFETDUSER
unzip /tmp/bankdemo.zip -d /home/demouser/MFETDUSER
chmod -R a+wrx /home/demouser/MFETDUSER

scriptdir=$( dirname -- "$0"; )
$scriptdir/install-license.sh "$bucketUrl/eslicense"
if [ $? -ne 0 ]; then
    echo "Failed to install license"
    exit 1
fi

jdkpath=$(ls /usr/lib/jvm/ | grep java-11-openjdk-11)
export JAVA_HOME=/usr/lib/jvm/$jdkpath
echo "JAVA_HOME=$JAVA_HOME"

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