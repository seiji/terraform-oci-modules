locals {
  namespace = "default"
  stage     = "development"
}

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
