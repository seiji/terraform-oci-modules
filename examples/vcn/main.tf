locals {
  namespace = "default"
  stage     = "developement"
}

module compartment_development {
  source      = "../../compartment"
  namespace   = local.namespace
  stage       = local.stage
  name        = local.stage
  description = "${local.stage} compartment"
}

module vcn {
  source         = "../../vcn"
  namespace      = local.namespace
  stage          = local.stage
  compartment_id = module.compartment_development.compartment_id
  cidr_block     = "10.0.0.0/16"
  dns_label      = local.stage
}
