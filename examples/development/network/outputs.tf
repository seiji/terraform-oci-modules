output compartment_id {
  value = module.compartment_development.compartment_id
}

output vcn_id {
  value = module.vcn.id
}

output default_dhcp_options_id {
  value = module.vcn.default_dhcp_options_id
}

output default_route_table_id {
  value = module.vcn.default_route_table_id
}

output default_security_list_id {
  value = module.vcn.default_security_list_id
}

output subnet_public_id {
  value = module.vcn.subnet_public_id
}

output subnet_public_cidr_block {
  value = module.vcn.subnet_public_cidr_block
}

output subnet_private_id {
  value = module.vcn.subnet_private_id
}

output subnet_private_cidr_block {
  value = module.vcn.subnet_private_cidr_block
}

