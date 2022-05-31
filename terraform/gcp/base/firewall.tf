#Access to ESCWA from restricted IP
resource "google_compute_firewall" "escwa" {
  project = var.project_id
  name    = "${var.name}-firewall-rule-escwa"
  network = var.create_network ? module.vpc[0].network_name : var.vpc_network    
  target_tags = ["escwa"]
  allow {
    protocol = "tcp"
    ports    = ["10086"]
  }
  source_ranges=[var.access_ip]
}

#SSH & RDP access
resource "google_compute_firewall" "ssh" {
  project = var.project_id
  name    = "${var.name}-firewall-rule-ssh"
  network = var.create_network ? module.vpc[0].network_name : var.vpc_network    

  allow {
    protocol = "tcp"
    ports    = ["22","3389"]
  }
  source_ranges=[var.access_ip]
}
