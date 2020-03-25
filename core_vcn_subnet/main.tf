module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_subnet this {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  cidr_block     = var.cidr_block

  defined_tags               = module.label.defined_tags
  dhcp_options_id            = var.dhcp_options_id
  display_name               = module.label.id
  dns_label                  = join("-", var.attributes)
  freeform_tags              = module.label.freeform_tags
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic
  route_table_id             = var.route_table_id
  security_list_ids          = var.security_list_ids

  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}
