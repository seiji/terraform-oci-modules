data terraform_remote_state network {
  backend = "s3"

  config = {
    bucket   = "terraform-state"
    key      = "development/network.tfstate"
    region   = "ap-tokyo-1"
    endpoint = "https://nrapqa8w4izn.compat.objectstorage.ap-tokyo-1.oraclecloud.com"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

locals {
  namespace = "default"
  stage     = "development"
  # shape     = "VM.Standard.E2.1.Micro"
  shape = "VM.Standard.E2.1"

  compartment_id            = data.terraform_remote_state.network.outputs.compartment_id
  vcn_id                    = data.terraform_remote_state.network.outputs.vcn_id
  subnet_public_id          = data.terraform_remote_state.network.outputs.subnet_public_id
  subnet_public_cidr_block  = data.terraform_remote_state.network.outputs.subnet_public_cidr_block
  subnet_private_id         = data.terraform_remote_state.network.outputs.subnet_private_id
  subnet_private_cidr_block = data.terraform_remote_state.network.outputs.subnet_private_cidr_block
  default_dhcp_options_id   = data.terraform_remote_state.network.outputs.default_dhcp_options_id
  default_route_table_id    = data.terraform_remote_state.network.outputs.default_route_table_id
  default_security_list_id  = data.terraform_remote_state.network.outputs.default_security_list_id
}

data oci_identity_availability_domains this {
  compartment_id = local.compartment_id
}

data oci_core_images this {
  compartment_id           = local.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.7"
  shape                    = local.shape
  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

module instances_bastion {
  source              = "../../../core_instances"
  namespace           = local.namespace
  stage               = local.stage
  attributes          = ["bastion"]
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[0].name
  compartment_id      = local.compartment_id
  shape               = local.shape
  create_vnic_details = {
    subnet_id        = local.subnet_public_id
    assign_public_ip = true
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = null
  }
  source_details = {
    source_id = data.oci_core_images.this.images[0].id
  }
}

data template_file cloud_init {
  template = file("./templates/cloud-init.yml")
  vars = {
  }
}

module instances_app {
  source              = "../../../core_instances"
  namespace           = local.namespace
  stage               = local.stage
  attributes          = ["app"]
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[0].name
  compartment_id      = local.compartment_id
  shape               = local.shape
  create_vnic_details = {
    subnet_id        = local.subnet_private_id
    assign_public_ip = false
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.cloud_init.rendered)
  }
  source_details = {
    source_id = data.oci_core_images.this.images[0].id
  }
}

module sl_lb {
  source         = "../../../core_security_list"
  namespace      = local.namespace
  stage          = local.stage
  attributes     = ["lb"]
  compartment_id = local.compartment_id
  vcn_id         = local.vcn_id
  ingress_security_rules = [
    {
      source       = "0.0.0.0/0"
      protocol     = "6"
      source_type  = "CIDR_BLOCK"
      stateless    = false
      icmp_options = null
      tcp_options = {
        min = 80
        max = 80
      }
    },
    {
      source       = "0.0.0.0/0"
      protocol     = "6"
      source_type  = "CIDR_BLOCK"
      stateless    = false
      icmp_options = null
      tcp_options = {
        min = 443
        max = 443
      }
    }
  ]
  egress_security_rules = {
    destination = local.subnet_private_cidr_block
    protocol    = "6"
    tcp_options = {
      min = 80
      max = 80
    }
  }
}

module subnet_lb {
  source                     = "../../../core_vcn_subnet"
  namespace                  = local.namespace
  stage                      = local.stage
  attributes                 = ["lb"]
  compartment_id             = local.compartment_id
  vcn_id                     = local.vcn_id
  cidr_block                 = "10.0.2.0/24"
  dhcp_options_id            = local.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false
  route_table_id             = local.default_route_table_id
  security_list_ids          = [module.sl_lb.id]
}

