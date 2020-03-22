locals {
  namespace = "vcn"
  stage     = "developement"
}

module vcn {
  source    = "../../vcn"
  namespace = local.namespace
  stage     = local.stage
  cidr_block = "10.0.0.0/16"
}
