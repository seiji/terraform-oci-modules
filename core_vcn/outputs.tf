output id {
  value = oci_core_vcn.this.id
}

output subnet_public_id {
  value = oci_core_subnet.public.id
}

output subnet_private_id {
  value = oci_core_subnet.private.id
}
