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

  defined_tags   = module.label.defined_tags
  display_name   = module.label.id
  dns_label      = var.dns_label
  freeform_tags  = module.label.freeform_tags
  ipv6cidr_block = var.ipv6cidr_block
  is_ipv6enabled = var.is_ipv6enabled


  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_subnet public {
  cidr_block     = var.subnets.public.cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  defined_tags               = module.label.defined_tags
  dhcp_options_id            = oci_core_vcn.this.default_dhcp_options_id
  display_name               = "Public Subnet-${module.label.id}"
  dns_label                  = "publicsubnet"
  freeform_tags              = module.label.freeform_tags
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_vcn.this.default_route_table_id
  security_list_ids          = [oci_core_vcn.this.default_security_list_id]

  depends_on = [
    oci_core_vcn.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_subnet private {
  cidr_block     = var.subnets.private.cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  defined_tags               = module.label.defined_tags
  dhcp_options_id            = oci_core_vcn.this.default_dhcp_options_id
  display_name               = "Private Subnet-${module.label.id}"
  dns_label                  = "privatesubnet"
  freeform_tags              = module.label.freeform_tags
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.private.id
  security_list_ids          = [oci_core_vcn.this.default_security_list_id]

  depends_on = [
    oci_core_vcn.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_internet_gateway this {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  defined_tags  = module.label.defined_tags
  display_name  = "Internet Gateway-${module.label.id}"
  enabled       = true
  freeform_tags = module.label.freeform_tags

  depends_on = [
    oci_core_vcn.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_nat_gateway this {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  block_traffic = false
  defined_tags  = module.label.defined_tags
  display_name  = "NAT Gateway-${module.label.id}"
  freeform_tags = module.label.freeform_tags

  depends_on = [
    oci_core_vcn.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

data oci_core_services this {}

resource oci_core_service_gateway this {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  services {
    service_id = data.oci_core_services.this.services.1.id
  }

  defined_tags  = module.label.defined_tags
  display_name  = "Service Gateway-${module.label.id}"
  freeform_tags = module.label.freeform_tags

  depends_on = [
    oci_core_vcn.this,
    data.oci_core_services.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_default_route_table default {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
  depends_on = [
    oci_core_vcn.this,
    oci_core_internet_gateway.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_route_table private {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  defined_tags  = module.label.defined_tags
  display_name  = "Route Table for Private Subnet-${module.label.id}"
  freeform_tags = module.label.freeform_tags
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.this.id
  }
  route_rules {
    destination       = "all-nrt-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.this.id
  }

  depends_on = [
    oci_core_vcn.this,
    oci_core_nat_gateway.this,
    oci_core_service_gateway.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource oci_core_security_list private {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  defined_tags  = module.label.defined_tags
  display_name  = "Security List for Private Subnet-${module.label.id}"
  freeform_tags = module.label.freeform_tags

  ingress_security_rules {
    protocol    = "6"
    source      = var.cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    icmp_options {
      code = 4
      type = 3
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = var.cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    icmp_options {
      code = -1
      type = 3
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  depends_on = [
    oci_core_vcn.this,
  ]
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}
