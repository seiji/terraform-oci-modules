module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_security_list this {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  defined_tags  = module.label.defined_tags
  display_name  = "Security List for ${module.label.id}"
  freeform_tags = module.label.freeform_tags

  dynamic ingress_security_rules {
    for_each = [for s in var.ingress_security_rules : s]
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      stateless   = ingress_security_rules.value.stateless
      dynamic icmp_options {
        for_each = [for o in ingress_security_rules.value.icmp_options != null ? [ingress_security_rules.value.icmp_options] : [] : o]
        content {
          code = icmp_options.value.code
          type = icmp_options.value.type
        }
      }
      dynamic tcp_options {
        for_each = [for o in ingress_security_rules.value.tcp_options != null ? [ingress_security_rules.value.tcp_options] : [] : o]
        content {
          max = tcp_options.value.max
          min = tcp_options.value.min
        }
      }
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}
