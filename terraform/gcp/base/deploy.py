#zips the bankdemo directory and uploads it to the given cloud storage location
import zipfile
import tempfile
import os
import shutil
import sys

if len(sys.argv) < 2:
  print("deploy.py <bucketURL>")
  print("eg deploy.py gs://bucket1")
  sys.exit(1)
bucketUrl=sys.argv[1]
scriptDir=os.path.dirname(os.path.realpath(__file__))
gcpDir=os.path.dirname(scriptDir)
terraformDir=os.path.dirname(gcpDir)
bankdemoDir=os.path.dirname(terraformDir)
print("creating bankdemo.zip from " + bankdemoDir)
tmpDir=tempfile.TemporaryDirectory()
bankdemoCopyDir=os.path.join(tmpDir.name,"bankdemo")
shutil.copytree(bankdemoDir, bankdemoCopyDir, ignore=shutil.ignore_patterns('.git', 'terraform'))
bankdemoZip=os.path.join(tmpDir.name,"bankdemo")
shutil.make_archive(bankdemoZip,"zip",bankdemoCopyDir)
bankdemoZipFullpath=os.path.join(tmpDir.name,"bankdemo.zip")
dest=bucketUrl + "/bankdemo.zip"
print("Uploading bankdemo.zip to " + dest)
os.system("gsutil cp " + bankdemoZipFullpath + " " + dest)
