locals {
  label_order = ["namespace", "stage", "name", "attributes"]
  delimiter   = var.delimiter
  context = {
    name       = var.name
    namespace  = var.namespace
    stage      = var.stage
    attributes = join(local.delimiter, var.attributes)
  }
  labels = [for l in local.label_order : local.context[l] if length(local.context[l]) > 0]
  id     = var.name == "" ? lower(join(local.delimiter, local.labels)) : var.name

  defined_tags = {
    "Defined-Tags.Namespace" = var.namespace
    "Defined-Tags.Stage"     = var.stage
  }
  freeform_tags = var.freeform_tags
}
