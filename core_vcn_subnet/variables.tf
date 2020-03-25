variable namespace {
  type = string
}

variable stage {
  type = string
}

variable name {
  default = ""
}

variable attributes {
  default = []
}

variable compartment_id {
  type = string
}

variable vcn_id {
  type = string
}

variable cidr_block {
  type = string
}

variable dhcp_options_id {
  type = string
}

variable prohibit_public_ip_on_vnic {
  type    = bool
  default = true
}

variable route_table_id {
  type = string
}

variable security_list_ids {
  type    = list(string)
  default = []
}

