data "template_file" "es_startup_script_redhat" {
  template = file(format("${path.module}/startup_script_es.sh.tpl"))
  vars = {
    BUCKET_URL        = module.storage.bucket.url
    BITISM            = var.bitism
    PGPASSWORD        = var.pg_db_password
    USE_PAC           = var.use_pac
  }
    
  depends_on = [
  ]
}

data "template_file" "es_startup_script_windows" {
  template = file(format("${path.module}/startup_script_es.ps1.tpl"))
  vars = {
    BUCKET_URL        = module.storage.bucket.url
    BITISM            = var.bitism
    PGPASSWORD        = var.pg_db_password
    USE_PAC           = var.use_pac
  }
    
  depends_on = [
  ]
}