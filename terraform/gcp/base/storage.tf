module "storage" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = ">= 3.1.0"
  name       = var.bucketname
  project_id = var.project_id
  location   = var.region
  force_destroy = true
  iam_members = []
}

