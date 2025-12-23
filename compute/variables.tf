variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "k3s_token" {
  description = "K3S cluster token"
  type        = string
  sensitive   = true
}

variable "private_subnet_id" {
  type = string 
}

variable "public_subnet_id" {
  type = string
}

variable "private_key_path" {
  type = string 
}

variable "public_key_path" {
  type = string
}

variable "cidr_blocks" {
  description = "CIDRs of the network, use index 0 for everything"
  type        = list(any)
}

variable "ssh_private_key" {
  type = string 
  sensitive = true
}
