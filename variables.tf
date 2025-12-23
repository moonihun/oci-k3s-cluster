variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the key to use for signing"
  type        = string
}

variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "ssh_private_key" {
  type      = string
  sensitive = true
  description = "SSH private key for OCI instances"
}

variable "k3s_token" {
  type = string 
  sensitive = true 
}

variable "region" {
  description = "The region to connect to. Default: eu-frankfurt-1"
  type        = string
  default     = "ap-chuncheon-1"
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "The user OCID."
  type        = string
}

