output "vcn_private_subnet_id" {
  value = oci_core_subnet.vcn_private_subnet.id 
}

output "vcn_public_subnet_id" {
  value = oci_core_subnet.vcn_public_subnet.id
}

output "ad" {
  value = local.ad_name 
  description = "Selected AD"
}
