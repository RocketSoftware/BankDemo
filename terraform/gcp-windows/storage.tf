module "storage" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = ">= 3.1.0"
  name       = var.bucketname
  project_id = var.project_id
  location   = var.region
  force_destroy = true
  iam_members = []
}

resource "null_resource" "upload_folder_content" {
  provisioner "local-exec" {
    command = "gsutil cp -r scripts/* ${module.storage.bucket.url}/scripts/"
  }
}

resource "null_resource" "upload_license" {
  provisioner "local-exec" {
    command = "gsutil cp -r eslicense/* ${module.storage.bucket.url}/eslicense/"
  }
}