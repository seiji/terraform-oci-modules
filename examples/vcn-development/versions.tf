terraform {
  required_version = "~> 0.12.0"
  backend "s3" {
    bucket   = "terraform-state"
    key      = "vcn-development.tfstate"
    region   = "ap-tokyo-1"
    endpoint = "https://nrapqa8w4izn.compat.objectstorage.ap-tokyo-1.oraclecloud.com"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

provider oci {
  version = ">= 3.67.0"
  region  = "ap-tokyo-1"
}
