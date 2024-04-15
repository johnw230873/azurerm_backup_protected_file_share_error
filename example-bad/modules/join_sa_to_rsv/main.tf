terraform {
  required_providers {
    azurerm = {
      version = ">= 3.43.0"
    }
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
