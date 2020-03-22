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

variable cidr_block {
  type = string
}

variable dns_label {
  type    = string
  default = null
}

variable ipv6cidr_block {
  type    = string
  default = null
}

variable is_ipv6enabled {
  type    = bool
  default = null
}
