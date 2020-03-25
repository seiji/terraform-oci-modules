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

variable ingress_security_rules {
  type = list(object({
    protocol    = string
    source      = string
    source_type = string
    stateless   = bool

    icmp_options = object({
      code = number
      type = number
    })
    tcp_options = object({
      max = number
      min = number
    })
  }))
}

variable egress_security_rules {
  type = object({
    destination = string
    protocol    = string
    tcp_options = object({
      min = number
      max = number
    })
  })
  default = {
    destination = "0.0.0.0/0"
    protocol    = "all"
    tcp_options = null
  }
}
