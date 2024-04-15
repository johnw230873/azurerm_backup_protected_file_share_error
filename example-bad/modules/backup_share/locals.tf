# Defines a map with information about different Azure subscriptions. It then takes the resource_naming_number and uses it to add onto the string values for the resource groups and recovery vaults.
# Note new subscriptions will need to be added here in the same format

locals {
  current_subscription_id = data.azurerm_subscription.current.id
}

locals {
  subscription_number_map = {
    vocus_services_pd = {
      subscription_id        = "/subscriptions/###############-#########-#########"
      resource_naming_number = "001"
    }
    core_services_pd = {
      subscription_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
      resource_naming_number = "002"
    }
    application_integration_pd = {
      subscription_id        = "/subscriptions/###############-#########-#########"
      resource_naming_number = "003"
    }

  }

  # Use a for loop to generate a list of resource naming numbers for the current subscription
  subscription_number = [
    for k, v in local.subscription_number_map :                                          # Iterate over the subscription_number_map
    v["resource_naming_number"] if v["subscription_id"] == local.current_subscription_id # Add the resource_naming_number to the list if the subscription ID matches the current subscription
  ]
}

#Runs a Contains function to determine whether the resource is a VM or not
locals {
  is_compute_vm = contains([var.backup_resource_type], "vm")
}

#Runs a Contains function to determine whether the resource is a FileShare Resource or not
locals {
  is_fileshare = contains([var.backup_resource_type], "fs")
}

# Select the appropriate map consisting of backup policy tier based on the resource type
locals {
  selected_backup_policy_tier = local.is_compute_vm ? local.vm_backup_tier[var.backup_tier_letter] : local.fs_backup_tier[var.backup_tier_letter]
}

#Virtual Machine Backup Policy Tier Map
locals {
  vm_backup_tier = {
    a = "vm-tier-a-recovery-vault-policy"
    b = "vm-tier-b-recovery-vault-policy"
    c = "vm-tier-c-recovery-vault-policy"
    d = "vm-tier-d-recovery-vault-policy"
  }
}

#File Share Backup Policy Tier Map
locals {
  fs_backup_tier = {
    a = "fs-tier-a-recovery-vault-policy"
    b = "fs-tier-b-recovery-vault-policy"
    c = "fs-tier-c-recovery-vault-policy"
    d = "fs-tier-d-recovery-vault-policy"
  }
}
