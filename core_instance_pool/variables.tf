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

variable instance_configuration_id {
  type = string
}

variable placement_configurations {
  type = object({
    availability_domain = string
    primary_subnet_id   = string
  })
}

variable size {
  type = number
}

