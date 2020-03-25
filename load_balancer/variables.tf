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

variable shape {
  type    = string
  default = "10Mbps-Micro"
}

variable subnet_ids {
  type = list(string)
}

variable ip_mode {
  type    = string
  default = "IPV4"
}

variable is_private {
  type    = bool
  default = true
}

variable network_security_group_ids {
  type    = list(string)
  default = []
}

variable backend_set {
  type = object({
    health_checker = object({
      protocol            = string
      interval_ms         = number
      port                = number
      response_body_regex = string
      retries             = number
      return_code         = number
      timeout_in_millis   = number
      url_path            = string
    })
    policy = string
  })
  default = {
    health_checker = {
      protocol            = "HTTP"
      interval_ms         = 10000
      port                = 80
      response_body_regex = null
      retries             = 3
      return_code         = 200
      timeout_in_millis   = 3000
      url_path            = null
    }
    policy = "ROUND_ROBIN"
  }
}

variable backend {
  type = object({
    ip_address = string
    port       = number
  })
}

variable listener {
  type = object({
    port     = number
    protocol = string
  })
}
