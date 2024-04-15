terraform {
  required_providers {
    azurerm = {
      version = ">= 3.43.0"
    }
  }
}

#######################################################
##########    Protected VM Backup Resource   ##########
#######################################################

#Protected VM Backup Resource
resource "azurerm_backup_protected_vm" "protected_vm_backup" {
  count               = local.is_compute_vm ? 1 : 0
  source_vm_id        = var.vm_id
  resource_group_name = "jwbakuppdrgp${local.subscription_number[0]}"
  recovery_vault_name = "jwbakuppdrsv${local.subscription_number[0]}"
  backup_policy_id    = "${local.current_subscription_id}/resourceGroups/jwbakuppdrgp${local.subscription_number[0]}/providers/Microsoft.RecoveryServices/vaults/jwbakuppdrsv${local.subscription_number[0]}/backupPolicies/${local.selected_backup_policy_tier}"

  lifecycle {
    ignore_changes = [
      source_vm_id,
    ]
  }
}

##############################################################
#########    Protected File Share Backup Resource   ##########
##############################################################

#Register Storage Account with Recovery Vault to allow backups
resource "azurerm_backup_container_storage_account" "protect_container_sa" {
  resource_group_name = "jwbakuppdrgp${local.subscription_number[0]}"
  recovery_vault_name = "jwbakuppdrsv${local.subscription_number[0]}"
  storage_account_id  = var.sa_id
}



##############################################################
#########    Protected File Share Backup Resource   ##########
##############################################################

#Protected File Share Backup Resource
resource "azurerm_backup_protected_file_share" "protected_file_share_backup" {
  depends_on                = [data.azurerm_subscription.current, azurerm_backup_container_storage_account.protect_container_sa]
  count                     = local.is_fileshare ? 1 : 0
  resource_group_name       = "jwbakuppdrgp${local.subscription_number[0]}"
  recovery_vault_name       = "jwbakuppdrsv${local.subscription_number[0]}"
  source_storage_account_id = var.sa_id
  source_file_share_name    = var.fs_name
  backup_policy_id          = "${local.current_subscription_id}/resourceGroups/jwbakuppdrgp${local.subscription_number[0]}/providers/Microsoft.RecoveryServices/vaults/jwbakuppdrsv${local.subscription_number[0]}/backupPolicies/${local.selected_backup_policy_tier}"
}

