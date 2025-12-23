resource "oci_core_public_ip" "k3s_master_ip" {
  compartment_id = var.compartment_id
  lifetime       = "RESERVED"
  #private_ip_id  = data.oci_core_private_ips.master_private_ips.private_ips[0].id
  display_name   = "k3s-master-ip"

  #depends_on = [oci_core_instance.k3s-master]
}

# Master + NFS
resource "oci_core_instance" "k3s-master" {
  compartment_id = var.compartment_id
  availability_domain = local.ad_name
  fault_domain = "FAULT-DOMAIN-1"

  display_name = "k3s-master"
  shape = "VM.Standard.A1.Flex"

  shape_config {
    ocpus = 2  
    memory_in_gbs = 12
  }

  source_details {
    source_type = "image"
    source_id = local.ubuntu_arm_image_id
    boot_volume_size_in_gbs = 150
  }

  create_vnic_details {
    subnet_id = var.public_subnet_id 
    assign_public_ip = false 
  }

  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data = base64encode(templatefile("${path.module}/cloud-init-master.yaml", {
      k3s_token = var.k3s_token
      ssh_private_key  = indent(6, var.ssh_private_key) 
      master_public_ip = oci_core_public_ip.k3s_master_ip.ip_address
    }))
  }

  freeform_tags = { 
    "Name" = "k3s-master"
    "Role" = "master"
    "Provisioner" = "terraform"
  }
}

data "oci_core_vnic_attachments" "master_vnics" {
  compartment_id = var.compartment_id 
  instance_id = oci_core_instance.k3s-master.id
}

data "oci_core_vnic" "master_vnic" {
  vnic_id = data.oci_core_vnic_attachments.master_vnics.vnic_attachments[0].vnic_id
}

data "oci_core_private_ips" "master_private_ips" {
  vnic_id = data.oci_core_vnic.master_vnic.id
}

resource "null_resource" "attach_public_ip" {
  provisioner "local-exec" {
    command = <<-EOT
      oci network public-ip update \
        --public-ip-id ${oci_core_public_ip.k3s_master_ip.id} \
        --private-ip-id ${data.oci_core_private_ips.master_private_ips.private_ips[0].id} \
        --force
    EOT
  }

  depends_on = [oci_core_instance.k3s-master]
}

resource "oci_core_instance" "k3s_worker" {
  compartment_id      = var.compartment_id
  availability_domain = local.ad_name
  fault_domain = "FAULT-DOMAIN-2"
  
  display_name = "k3s-worker"  
  shape        = "VM.Standard.A1.Flex"
  
  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }
  
  source_details {
    source_type = "image"
    source_id   = local.ubuntu_arm_image_id
    boot_volume_size_in_gbs = 50
  }
  
  create_vnic_details {
    subnet_id                 = var.private_subnet_id
    assign_public_ip          = false
    assign_private_dns_record = true
  }

  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
    user_data = base64encode(templatefile("${path.module}/cloud-init-worker.yaml", {
      master_private_ip = data.oci_core_private_ips.master_private_ips.private_ips[0].ip_address
      k3s_token = var.k3s_token
    }))
  }
  
  
  freeform_tags = {
    "Name"        = "k3s-worker"
    "Role"        = "worker"
    "Provisioner" = "terraform"
  }
}

#resource "oci_core_instance"  "nfs-server" {
#  compartment_id = var.compartment_id
#  availability_domain = local.ad_name
#  fault_domain = "FAULT-DOMAIN-3"
#
#  display_name = "nfs-server"
#  shape = "VM.Standard.E2.1.Micro"
#
#  source_details {
#    source_type = "image"
#    source_id = local.ol9_x86_image_id 
#    boot_volume_size_in_gbs = 100
#  }
#  
#  create_vnic_details {
#    subnet_id                 = var.private_subnet_id
#    assign_public_ip          = false
#    assign_private_dns_record = true
#  }
#  
#  metadata = {
#    ssh_authorized_keys = file(var.public_key_path)
#    user_data = base64encode(templatefile("${path.module}/cloud-init-nfs-server.yaml", {
#    }))
#  }
#
#  freeform_tags = {
#    "Name"        = "nfs-server"
#    "Role"        = "storage"
#    "Provisioner" = "terraform"
#  }
#}
