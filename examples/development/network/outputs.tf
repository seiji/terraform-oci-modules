output compartment_id {
  value = module.compartment_development.compartment_id
}

output vcn_id {
  value = module.vcn.id
}

output subnet_public_id {
  value = module.vcn.subnet_public_id
}

output subnet_private_id {
  value = module.vcn.subnet_private_id
}
