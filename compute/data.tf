data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_arm" {
  compartment_id = var.compartment_id
  operating_system = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape = "VM.Standard.A1.Flex"

  sort_by = "TIMECREATED"
  sort_order = "DESC"

  filter {
    name = "display_name"
    values = [".*aarch64.*"]
    regex = true 
  }
}

data "oci_core_images" "ubuntu_amd" {
  compartment_id = var.compartment_id
  operating_system = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape = "VM.Standard.E2.1.Micro"

  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

data "oci_core_images" "ol9_arm" {
  compartment_id = var.compartment_id
  operating_system = "Oracle Linux"
  operating_system_version = "9"
  shape = "VM.Standard.A1.Flex"

  sort_by = "TIMECREATED"
  sort_order = "DESC"

  filter {
    name = "display_name"
    values = [".*aarch64.*"]
    regex = true 
  }
}

data "oci_core_images" "ol9_x86" {
  compartment_id = var.compartment_id
  operating_system = "Oracle Linux"
  operating_system_version = "9"
  shape = "VM.Standard.E2.1.Micro"

  sort_by = "TIMECREATED"
  sort_order = "DESC"
}


