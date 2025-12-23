output "ol9_arm_image_info" {
  value = {
    id = data.oci_core_images.ol9_arm.images[0].id 
    display_name = data.oci_core_images.ol9_arm.images[0].display_name 
    time_created = data.oci_core_images.ol9_arm.images[0].time_created 
  }
}

output "ol9_x86_image_info" {
  value = {
    id           = data.oci_core_images.ol9_x86.images[0].id
    display_name = data.oci_core_images.ol9_x86.images[0].display_name
    time_created = data.oci_core_images.ol9_x86.images[0].time_created
  }
}
