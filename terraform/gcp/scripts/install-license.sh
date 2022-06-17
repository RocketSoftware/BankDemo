#obtains license file from given storage folder and installs
licenseBucketFolder=$1  #gs://bucketName/eslicense
if [ -z $licenseBucketFolder ]; then
    echo "No license bucket folder specified"
    exit 1
fi
mkdir -p eslicense
licenseFolder="$PWD/eslicense"
gsutil cp "$licenseBucketFolder/*" "$licenseFolder"
if [ ! $? -eq 0 ]; then
    echo "Failed to download license file from $licenseBucketFolder"
    exit 1
fi
licenseFolder="$PWD/eslicense"
#obtain the license file name, ignoring the "place license here" file
licenseFile=$(ls $licenseFolder -I place*)
licensePath=$licenseFolder/$licenseFile
echo "Installing license $licensePath"
# Currently interactive, so need this workaround
/var/microfocuslicensing/bin/cesadmintool.sh -install $licensePath << block
block

