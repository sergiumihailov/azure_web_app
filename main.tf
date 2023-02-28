locals {
    rg_name = "project5_rg"
    rg_location = "canadacentral"
}

resource "azurerm_resource_group" "progect5_rg" {
  name     = local.rg_name
  location = local.rg_location
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "Project5-AppServicePlan"
  resource_group_name = azurerm_resource_group.progect5_rg.name
  location            = azurerm_resource_group.progect5_rg.location
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "Project5-WebAppService"
  resource_group_name = azurerm_resource_group.progect5_rg.name
  location            = azurerm_resource_group.progect5_rg.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id


  site_config {
    always_on         = false
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}

/*
Shared compute: Free and Shared, the two base tiers, runs an app on the same Azure VM as other App Service apps, including apps of other customers. These tiers allocate CPU quotas to each app that runs on the shared resources, and the resources cannot scale out.
Dedicated compute: The Basic, Standard, Premium, PremiumV2, and PremiumV3 tiers run apps on dedicated Azure VMs. Only apps in the same App Service plan share the same compute resources. The higher the tier, the more VM instances are available to you for scale-out.
Isolated: This Isolated and IsolatedV2 tiers run dedicated Azure VMs on dedicated Azure Virtual Networks. It provides network isolation on top of compute isolation to your apps. It provides the maximum scale-out capabilities.
*/