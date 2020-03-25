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

variable availability_domain {
  type = string
}

variable compartment_id {
  type = string
}

variable shape {
  type = string
}

variable create_vnic_details {
  type = object({
    subnet_id        = string
    assign_public_ip = bool
  })
}

variable metadata {
  type = object({
    ssh_authorized_keys = string
    user_data           = string
  })
}

variable source_details {
  type = object({
    source_id = string
  })
}

