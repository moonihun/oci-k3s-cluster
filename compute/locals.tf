locals {
  ol9_arm_image_id = data.oci_core_images.ol9_arm.images[0].id
  ol9_x86_image_id = data.oci_core_images.ol9_x86.images[0].id
  ubuntu_arm_image_id = data.oci_core_images.ubuntu_arm.images[0].id 
  ubuntu_amd_image_id = data.oci_core_images.ubuntu_amd.images[0].id
  ad_name = data.oci_identity_availability_domains.ads.availability_domains[0].name
}
