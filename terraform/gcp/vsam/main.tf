module "base" {
  source = "../base"
  es_startup_script=data.template_file.es_startup_script_redhat.rendered
  es_startup_script_win=data.template_file.es_startup_script_windows.rendered
  project_id = var.project_id
  name = var.name
  region = var.region
  create_network = var.create_network
  vpc_network = var.vpc_network
  vpc_subnet = var.vpc_subnet
  bucketname = var.bucketname
  availability_zones = var.availability_zones
  es_image_project = var.es_image_project
  es_image_name = var.es_image_name
  escount = 1
  vm_machine_type = "e2-standard-4"
  access_ip = var.access_ip
}