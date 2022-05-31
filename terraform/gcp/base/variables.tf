locals {
  vpc_name = "${var.name}-vpc"
  subnet_name = "${var.name}-subnet"
}

variable "project_id" {
  description = "The project to deploy the environment into"
  type        = string
}

variable "name" {
  description = "The prefix to use for created resources"
  type        = string
  default     = null
}

variable "bitism" {
  type        = string
  description = "Bitism of created region. Must be either 32 or 64"
  default     = "32"
  validation {
    condition = contains(["32", "64"], var.bitism)
    error_message = "Bitism must be 32 or 64."
  }
}

variable "use_pac" {
  description = "Whether to install the region into a PAC"
  type        = bool
  default     = false
}

variable "create_network" {
  description = "Create Network (true or false)"
  type = bool
  default = true
}

variable "vpc_network" {
  description = "Network to attach nodes to"
  default = "vpc-network"
}

variable "vpc_subnet" {
  description = "Subnet to attach nodes to"
  default = "vpc-subnet"
}

variable "vpc_subnet_cidr" {
  description = "Subnet CIDR to attach nodes to"
  default = "10.2.0.0/16"
}

variable "bucketname" {
  description = "Name of the bucket to create to upload scripts and the license file to"
  type        = string
  default     = null
}

variable "region" {
  description = "Region to deploy to"
  type    = string
  default = "europe-west2"
}

variable "availability_zones" {
  description = "Availabity zones to use"
  type    = list(string)
  default = ["europe-west2-a", "europe-west2-b"]
}

variable "vm_service_account" {
  default = {
    email  = ""
    scopes = ["storage-ro", "compute-ro", "sql-admin", "cloud-platform"]
  }
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

variable "vm_machine_type" {
  description = "Machine type to use for Enteprise Server machines and ESCWA machine"
  type    = string
  default = "e2-micro"
}

variable "escount" {
  description = "Number of Enterprise Server instances to deploy"
  type    = number
  default = 2
}

variable "es_image_project" {
  description = "Name of project containing Enterprise Server and Active Directory machine images"
  type    = string
  default = ""
}

variable "es_image_name" {
  description = "Name of Enterprise Server machine image"
  type    = string
  default = ""
}

variable "access_ip" {
  description = "Remote access to ES VM is locked to this public IP address"
  type    = string
  default = ""
}

variable "es_startup_script" {
  type    = string
}

variable "es_startup_script_win" {
  type    = string
}