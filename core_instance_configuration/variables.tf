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

variable instance_details {
  type = object({
    launch_details = object({
      create_vnic_details = object({
        assign_public_ip = bool
        subnet_id        = string
      })
      metadata = map(string)
      shape    = string
      source_details = object({
        image_id = string
      })
    })
  })
}
