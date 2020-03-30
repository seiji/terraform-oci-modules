module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_core_instance_pool this {
  compartment_id            = var.compartment_id
  instance_configuration_id = var.instance_configuration_id
  placement_configurations {
    availability_domain = var.placement_configurations.availability_domain
    primary_subnet_id   = var.placement_configurations.primary_subnet_id
  }
  size = var.size

  defined_tags  = module.label.defined_tags
  display_name  = module.label.id
  freeform_tags = module.label.freeform_tags
  # load_balancers {
  #   #Required
  #   backend_set_name = "${oci_load_balancer_backend_set.test_backend_set.name}"
  #   load_balancer_id = "${oci_load_balancer_load_balancer.test_load_balancer.id}"
  #   port = "${var.instance_pool_load_balancers_port}"
  #   vnic_selection = "${var.instance_pool_load_balancers_vnic_selection}"
  # }
}
