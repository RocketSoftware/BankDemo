locals {
  read_replica_ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
    authorized_networks = []
  }
}

module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "6.0.0"
  name = "${var.name}-db"
  random_instance_name = true
  project_id = var.project_id
  database_version = "POSTGRES_12"
  availability_type = "REGIONAL"
  region = var.region
  zone = var.availability_zones[0]
  create_timeout = "50m"
  delete_timeout = "50m"
  update_timeout = "50m"
  deletion_protection = false
  tier = "db-f1-micro"
  disk_autoresize  = false
  disk_size        = 100
  disk_type        = "PD_HDD"
  db_name      = "postgresql"
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"
  user_name = var.db_username
  user_password = var.db_password
  database_flags = [{ name  = "max_connections", value = "10000" }]

  backup_configuration = {
    enabled                        = false
    start_time                     = "00:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }
}
