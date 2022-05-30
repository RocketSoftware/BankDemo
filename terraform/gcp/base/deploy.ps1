#Zips the local bankdemo folder and uploads to the given storage bucket

param(
    [Parameter()]
    [String]$bucketUrl   #eg "gs://jsbucket113"
)

#if (-not (Test-Path -Path "eslicense")) {
#    "eslicense folder not found"
#}

$parentDir = [System.IO.Directory]::GetParent($PSScriptRoot)
$parentDir = [System.IO.Directory]::GetParent($parentDir)
$bankdemoDir = [System.IO.Directory]::GetParent($parentDir)
$demosDir = Join-Path $bankdemoDir "demos"
if (-not (Test-Path -Path $demosDir)) {
    "Parent folder $bankdemoDir does not contain demos directory"
    exit 1
}

function CreateTemporaryDirectory {
  [string] $tempname = [System.Guid]::NewGuid()
  $tempdir = [System.IO.Path]::GetTempPath()
  $temppath = Join-Path $tempdir $tempname
  $temppath = Join-Path $temppath "bankdemo"
  New-Item -ItemType Directory -Path $temppath
  #output of New-Item is returned
}

function CopyBankDemoToTemporaryDirectory {
  $tempDirectory = CreateTemporaryDirectory
  $subfolders = [System.IO.Directory]::GetDirectories($bankdemoDir)
  foreach ($subFolderPath in $subfolders) {
    $subFolderName = [System.IO.Path]::GetFileName($subFolderPath)
    if ($subFolderName -eq "terraform" -or $subFolderName -eq ".git") {
      continue
    }
    #write-host $subFolderPath
    $destinationPath = Join-Path $tempDirectory $subFolderName
    Copy-Item -Path $subFolderPath -Destination $destinationPath -Recurse
  }
  $tempDirectory
}

function CreateBankDemoZip() {
  #copy bankdemo to temporary folder and zip it
  $srcDir = CopyBankDemoToTemporaryDirectory
  $dstDir = [System.IO.Path]::GetTempPath()
  $dstName = [System.Guid]::NewGuid()
  $dstPath = Join-Path $dstDir $dstName
  $dstPath = $dstPath + ".zip"
  write-host $srcDir
  write-host $dstPath
  Compress-Archive -Path "$srcDir" -DestinationPath $dstPath -CompressionLevel "Fastest"
  Remove-Item $srcDir -Recurse
  $dstPath
}

write-host "Creating bankdemo zip"
$zipPath = CreateBankDemoZip
write-host "Uploading bankdemo zip to $bucketUrl"
gsutil cp $zipPath $bucketUrl/bankdemo.zip
Remove-Item $zipPath

#Copy-Item -Path "C:\test_folder1" -Destination "C:\New" -PassThru

#gsutil cp -r eslicense/* ${module.storage.bucket.url}/eslicense/
#terraform apply -var-file="bankdemo.tfvars"

