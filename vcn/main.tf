module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_vcn this {
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_id

  display_name   = module.label.id
  dns_label      = var.dns_label
  ipv6cidr_block = var.ipv6cidr_block
  is_ipv6enabled = var.is_ipv6enabled

  defined_tags  = module.label.defined_tags
  freeform_tags = module.label.freeform_tags

  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}
