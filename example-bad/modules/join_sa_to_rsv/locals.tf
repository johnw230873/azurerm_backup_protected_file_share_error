# Defines a map with information about different Azure subscriptions. It then takes the resource_naming_number and uses it to add onto the string values for the resource groups and recovery vaults.
# Note new subscriptions will need to be added here in the same format
locals {
  subscription_number_map = {
    vocus_services_pd = {
      subscription_id        = "/subscriptions/###############-#########-#########"
      resource_naming_number = "001"
    }
    core_services_pd = {
      subscription_id        = "/subscriptions/${data.azurerm_subscription.currentrsv.subscription_id}"
      resource_naming_number = "002"
    }
    application_integration_pd = {
      subscription_id        = "/subscriptions/###############-#########-#########"
      resource_naming_number = "003"
    }
  }

  # Use a for loop to generate a list of resource naming numbers for the current subscription
  subscription_number = [
    for k, v in local.subscription_number_map :                                                    # Iterate over the subscription_number_map
    v["resource_naming_number"] if v["subscription_id"] == data.azurerm_subscription.currentrsv.id # Add the resource_naming_number to the list if the subscription ID matches the current subscription
  ]
}
