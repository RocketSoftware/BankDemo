module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = ">= 7.3.0"
  project_id      = var.project_id
  name_prefix     = "esvm"
  service_account = var.vm_service_account
  subnetwork = var.create_network ? module.vpc[0].subnets_names[0] : var.vpc_subnet
  subnetwork_project = var.project_id
  machine_type    = var.vm_machine_type
  region          = var.region
  source_image_project = var.es_image_project
  source_image_family = ""
  source_image = var.es_image_name
  auto_delete = true
  
  metadata = {
    startup-script = var.es_startup_script
    windows-startup-script-ps1 = var.es_startup_script_win
    
  }
  
  #Empty access_config causes an external IP to be auto-assigned
  access_config = [{
    nat_ip=""
    network_tier="STANDARD"
  }]
  depends_on = [null_resource.upload_license]
  tags=["es"]
}

module "mig" {
  source                    = "terraform-google-modules/vm/google//modules/mig"
  version = ">= 7.3.0"
  instance_template         = module.instance_template.self_link
  region                    = var.region
  project_id                = var.project_id
  hostname                  = "${var.name}-es"
  distribution_policy_zones = [var.availability_zones[0], var.availability_zones[1]]
  target_size               = var.escount
  //target_pools              = [module.load_balancer.target_pool]
  wait_for_instances        = true
}
