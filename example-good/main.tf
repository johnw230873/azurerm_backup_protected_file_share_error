
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.primary_location
  tags = merge(
    local.common_tags,
    {
      description = "Resource Group for Software Deployment File Shares"
      # TestTag     = "Adding or removing this will cause a recreation of protected_file_share_backup"
    }
  )
}



resource "azurerm_storage_account" "softwaredeployment_sa" {
  name                             = "jwdeplypdsto003"
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  account_tier                     = "Standard"
  account_kind                     = "StorageV2"
  account_replication_type         = "LRS"
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false



  tags = merge(
    local.common_tags,
    {
      description = "Storage account for hosting install media for codified software deployments"
    }
  )
}
resource "azurerm_storage_share" "softwaredeployment" {
  name                 = "softwaredeployment"
  storage_account_name = azurerm_storage_account.softwaredeployment_sa.name
  quota                = "10"
  depends_on           = [azurerm_storage_account.softwaredeployment_sa]
}


resource "azurerm_resource_group" "rg2" {
  name     = "jwbakuppdrgp003"
  location = var.primary_location
  tags = merge(
    local.common_tags,
    {
      description = "Resource Group for Software Deployment File Shares"
    }
  )
}

resource "azurerm_recovery_services_vault" "recover_value" {
  location            = azurerm_resource_group.rg2.location
  name                = "jwbakuppdrsv003"
  resource_group_name = azurerm_resource_group.rg2.name
  sku                 = "Standard"
}



resource "azurerm_backup_policy_file_share" "policy1" {
  name                = "fs-tier-a-recovery-vault-policy"
  recovery_vault_name = azurerm_recovery_services_vault.recover_value.name
  resource_group_name = azurerm_resource_group.rg2.name
  timezone            = "UTC"
  backup {
    frequency = "Daily"
    time      = "16:00"
  }
  retention_daily {
    count = 30
  }
}


module "backup_share" {
  source               = "./modules/backup_share"
  backup_resource_type = "fs"
  backup_tier_letter   = "a"
  sa_id                = azurerm_storage_account.softwaredeployment_sa.id
  fs_name              = azurerm_storage_share.softwaredeployment.name
  depends_on           = [azurerm_backup_policy_file_share.policy1]

}
