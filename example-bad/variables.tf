variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}


variable "primary_location" {
  description = "the Primary Azure region to deploy resources to"
  type        = string
  default     = "australiaeast"
}

variable "common_tags" {
  description = "Common tags applied to all the resources created in this module"
  type        = map(string)
  default = {
  }
}

variable "coreservices_subscription_id" {
  description = "Core Services subscription"
  type        = string
  default     = "c2ed245c-85dc-4179-aeb4-a637a3cf96db" # FMG Core Services
}


variable "environment" {
  description = "2 letter naming code for the envirment"
  type        = string
  default     = "pd"
}


