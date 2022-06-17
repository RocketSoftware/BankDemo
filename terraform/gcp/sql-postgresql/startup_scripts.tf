data "template_file" "es_startup_script_redhat" {
  template = file(format("${path.module}/startup_script_es.sh.tpl"))
  vars = {
    BUCKET_URL        = module.base.bucketurl
    PGUSER            = var.db_username
    PGPASSWORD        = var.db_password
    SQL_CONNECTION    = module.sql-db.instance_connection_name
    SQL_HOST          = module.sql-db.private_ip_address
    USE_PAC           = var.use_pac
  }
    
  depends_on = [
  ]
}

data "template_file" "es_startup_script_windows" {
  template = file(format("${path.module}/startup_script_es.ps1.tpl"))
  vars = {
    BUCKET_URL        = module.base.bucketurl
    PGUSER            = var.db_username
    PGPASSWORD        = var.db_password
    SQL_CONNECTION    = module.sql-db.instance_connection_name
    SQL_HOST          = module.sql-db.private_ip_address
    USE_PAC           = var.use_pac
  }
    
  depends_on = [
  ]
}