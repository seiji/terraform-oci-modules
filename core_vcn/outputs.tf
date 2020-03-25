output id {
  value = oci_core_vcn.this.id
}

output default_dhcp_options_id {
  value = oci_core_vcn.this.default_dhcp_options_id
}

output default_route_table_id {
  value = oci_core_vcn.this.default_route_table_id
}

output default_security_list_id {
  value = oci_core_vcn.this.default_security_list_id
}

output subnet_public_id {
  value = oci_core_subnet.public.id
}

output subnet_public_cidr_block {
  value = oci_core_subnet.public.cidr_block
}

output subnet_private_id {
  value = oci_core_subnet.private.id
}

output subnet_private_cidr_block {
  value = oci_core_subnet.private.cidr_block
}

