module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_instance this {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false
  }
  create_vnic_details {
    subnet_id              = var.create_vnic_details.subnet_id
    assign_public_ip       = var.create_vnic_details.assign_public_ip
    defined_tags           = module.label.defined_tags
    display_name           = module.label.id
    freeform_tags          = module.label.freeform_tags
    hostname_label         = module.label.id
    skip_source_dest_check = false
  }
  defined_tags                        = module.label.defined_tags
  display_name                        = module.label.id
  freeform_tags                       = module.label.freeform_tags
  is_pv_encryption_in_transit_enabled = false

  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
    ssh_authorized_keys = var.metadata.ssh_authorized_keys
    user_data           = var.metadata.user_data
  }
  source_details {
    source_id   = var.source_details.source_id
    source_type = "image"
    # boot_volume_size_in_gbs = null
  }
  preserve_boot_volume = false

  lifecycle {
    ignore_changes = [
      create_vnic_details[0].defined_tags,
      create_vnic_details[0].freeform_tags,
      defined_tags,
      freeform_tags,
    ]
  }
}
