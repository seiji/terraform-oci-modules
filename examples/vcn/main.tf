locals {
  namespace = "vcn"
  stage     = "developement"
}

module vcn {
  source    = "../../vcn"
  namespace = local.namespace
  stage     = local.stage
}
