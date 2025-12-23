data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "terraform_state" {
  compartment_id = var.compartment_id
  namespace = data.oci_objectstorage_namespace.ns.namespace 
  name = var.bucket_name 
  access_type = "NoPublicAccess"

  # 버전관리 (state rollback)
  versioning = "Enabled"

  # 자동삭제 방지
  storage_tier = "Standard"
  
  freeform_tags = {
    "Purpose" = "terraform-state"
    "Provisioner" = "terraform"
  }
}




