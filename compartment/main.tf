module label {
  source     = "../label"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
}

resource oci_identity_compartment this {
  description = var.description
  name        = module.label.id

  defined_tags  = module.label.defined_tags
  enable_delete = true

  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}
