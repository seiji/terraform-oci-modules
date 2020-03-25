module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_load_balancer_load_balancer this {
  compartment_id = var.compartment_id
  display_name   = module.label.id
  shape          = var.shape
  subnet_ids     = var.subnet_ids

  defined_tags               = module.label.defined_tags
  freeform_tags              = module.label.freeform_tags
  ip_mode                    = var.ip_mode
  is_private                 = var.is_private
  network_security_group_ids = var.network_security_group_ids

  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
      system_tags,
    ]
  }
}

resource oci_load_balancer_backend_set this {
  health_checker {
    protocol = var.backend_set.health_checker.protocol

    interval_ms         = var.backend_set.health_checker.interval_ms
    port                = var.backend_set.health_checker.port
    response_body_regex = var.backend_set.health_checker.response_body_regex
    retries             = var.backend_set.health_checker.retries
    return_code         = var.backend_set.health_checker.return_code
    timeout_in_millis   = var.backend_set.health_checker.timeout_in_millis
    url_path            = var.backend_set.health_checker.url_path
  }
  load_balancer_id = oci_load_balancer_load_balancer.this.id
  name             = join("-", ["bs", module.label.id])
  policy           = var.backend_set.policy

  depends_on = [
    oci_load_balancer_load_balancer.this,
  ]
}

resource oci_load_balancer_backend this {
  backendset_name  = oci_load_balancer_backend_set.this.name
  ip_address       = var.backend.ip_address
  load_balancer_id = oci_load_balancer_load_balancer.this.id
  port             = var.backend.port

  depends_on = [
    oci_load_balancer_load_balancer.this,
    oci_load_balancer_backend_set.this,
  ]
}

resource oci_load_balancer_listener this {
  default_backend_set_name = oci_load_balancer_backend_set.this.name
  load_balancer_id         = oci_load_balancer_load_balancer.this.id
  name                     = join("-", ["listener", module.label.id])
  port                     = var.listener.port
  protocol                 = var.listener.protocol

  connection_configuration {
    idle_timeout_in_seconds = 60
  }
  # hostname_names = ["${oci_load_balancer_hostname.test_hostname.name}"]
  # path_route_set_name = "${oci_load_balancer_path_route_set.test_path_route_set.name}"
  # rule_set_names = ["${oci_load_balancer_rule_set.test_rule_set.name}"]
  # ssl_configuration {
  #   #Required
  #   certificate_name = "${oci_load_balancer_certificate.test_certificate.name}"
  #
  #   #Optional
  #   verify_depth = "${var.listener_ssl_configuration_verify_depth}"
  #   verify_peer_certificate = "${var.listener_ssl_configuration_verify_peer_certificate}"
  # }
}
