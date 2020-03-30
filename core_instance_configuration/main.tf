module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_instance_configuration this {
  compartment_id = var.compartment_id

  defined_tags  = module.label.defined_tags
  display_name  = module.label.id
  freeform_tags = module.label.freeform_tags

  instance_details {
    instance_type = "compute"

    block_volumes {
      attach_details {
        type = "paravirtualized"

        display_name = module.label.id
        is_read_only = false
      }
      create_details {
        compartment_id = var.compartment_id
        defined_tags   = module.label.defined_tags
        display_name   = module.label.id
        freeform_tags  = module.label.freeform_tags
        # size_in_gbs = ""
      }
    }
    launch_details {
      compartment_id = var.compartment_id
      create_vnic_details {
        assign_public_ip = var.instance_details.launch_details.create_vnic_details.assign_public_ip
        display_name     = module.label.id
        subnet_id        = var.instance_details.launch_details.create_vnic_details.subnet_id
      }
      defined_tags  = module.label.defined_tags
      display_name  = module.label.id
      freeform_tags = module.label.freeform_tags
      metadata      = var.instance_details.launch_details.metadata
      shape         = var.instance_details.launch_details.shape
      source_details {
        source_type = "image"
        image_id    = var.instance_details.launch_details.source_details.image_id
      }
    }
  }
}
