terraform {
  #required_version = ">= 1.0.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      #version = ">= 3.70.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

module "network" {
  source = "./network"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  cidr_blocks            = local.cidr_blocks
}

module "compute" {
  source     = "./compute"
  depends_on = [module.network]

  ssh_private_key  = var.ssh_private_key
  compartment_id      = var.compartment_id
  tenancy_ocid        = var.tenancy_ocid
  private_subnet_id = module.network.vcn_private_subnet_id
  public_subnet_id = module.network.vcn_public_subnet_id 
  k3s_token = var.k3s_token

  private_key_path = var.private_key_path
  public_key_path = var.public_key_path

  cidr_blocks = local.cidr_blocks
}
