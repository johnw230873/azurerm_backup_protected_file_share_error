
variable "vm_id" {
  description = "This is the ID of the target VM for Backups"
  type        = string
  default     = null
}

variable "sa_id" {
  description = "This is the ID of the target storage account for Backups"
  type        = string
  default     = null
}

variable "fs_name" {
  description = "This is the name if the target file share resource for Backups"
  type        = string
  default     = null
}

variable "backup_tier_letter" {
  description = "This is the backup is the backup tier letter required to add resoureces into the correct backup tier. Inputs are a, b, c, or d"
  type        = string

  validation {
    condition     = can(regex("^a|b|c|d$", var.backup_tier_letter))
    error_message = "Invalid backup tier letter name. Must be either 'a', 'b', 'c', or 'd'. Please refer to FMG Wiki for more information on which backup Tiers to use for your workload."
  }
}

variable "backup_resource_type" {
  description = "This value will define which backup code block to use based on the resource"
  type        = string

  validation {
    condition     = can(regex("^vm|fs$", var.backup_resource_type))
    error_message = "Invalid backup resource type. Must be either 'vm' or 'fs'. Please refer to Readme for more information."
  }
}
