resource oci_core_vcn this {
  cidr_block = var.cidr_block
  compartment_id = var.compartment_id

#   #Optional
#   defined_tags = {"Operations.CostCenter"= "42"}
#   display_name = "${var.vcn_display_name}"
#   dns_label = "${var.vcn_dns_label}"
#   freeform_tags = {"Department"= "Finance"}
#   ipv6cidr_block = "${var.vcn_ipv6cidr_block}"
#   is_ipv6enabled = "${var.vcn_is_ipv6enabled}"
}
