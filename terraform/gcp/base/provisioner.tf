resource "null_resource" "upload_scripts" {
  provisioner "local-exec" {
    command = "gsutil cp -r ${path.cwd}/eslicense/* ${module.storage.bucket.url}/eslicense/"
    on_failure = fail
  }
  
  provisioner "local-exec" {
    command = "gsutil cp -r ../scripts/* ${module.storage.bucket.url}/scripts/"
    on_failure = fail
  }
  
  provisioner "local-exec" {
    command = "python ../base/deploy.py ${module.storage.bucket.url}"
    on_failure = fail
  }
}