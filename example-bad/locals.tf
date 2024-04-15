#Tagging Locals
locals {
  default_common_tags = {
    costCentre = "Shared Services"
    deployType = "Terraform"
    source     = "https://github.com/fmgplatform/az-coreservices-tf-L3"
  }
  common_tags = merge(local.default_common_tags, var.common_tags)
}

#Resources Groups Locals
locals {
  rg_name = "jwdeply${var.environment}rgp002"
}

#Diagnostic Retention
locals {
  log_retention = "365"
}
