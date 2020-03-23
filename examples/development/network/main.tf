locals {
  namespace = "default"
  stage     = "development"
}

module compartment_development {
  source      = "../../../compartment"
  namespace   = local.namespace
  stage       = local.stage
  name        = local.stage
  description = "${local.stage} compartment"
}

module vcn {
  source         = "../../../core_vcn"
  namespace      = local.namespace
  stage          = local.stage
  compartment_id = module.compartment_development.compartment_id
  dns_label      = local.stage
  cidr_block     = "10.0.0.0/16"

  subnets = {
    public = {
      cidr_block = "10.0.0.0/24"
    }
    private = {
      cidr_block = "10.0.1.0/24"
    }
  }
}
