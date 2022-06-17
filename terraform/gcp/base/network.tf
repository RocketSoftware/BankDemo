module "vpc" {
    source        = "terraform-google-modules/network/google"
    project_id    = var.project_id
    count         = var.create_network ? 1 : 0
    network_name  = "${var.name}-vpc"
    subnets = [
    {
      subnet_name   = "${var.name}-subnetwork"
      subnet_ip     = "${var.vpc_subnet_cidr}"
      subnet_region = var.region
      subnet_private_access = "true"
    }]
}
