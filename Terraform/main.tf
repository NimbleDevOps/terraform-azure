# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  backend "azurerm" {
    key = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.65.0"
    }
  }
  required_version = ">= 0.14.9"
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
    Team        = var.team
  }
}
resource "azurerm_application_insights" "app_ai" {
  name                = format("%s-%s", var.resource_group_name, "ai")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = merge({
    //format("%s%s%s%s%s%s%s", "hidden-link:/subscriptions/", data.azurerm_client_config.current.subscription_id, "/resourceGroups/", var.resource_group_name, "/providers/Microsoft.Web/sites/", var.resource_group_name, "-as") = "Resource"
    },
    azurerm_resource_group.rg.tags
  )
}
resource "azurerm_app_service_plan" "plan" {
  name                = "exampleAppServicePlan1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
  tags = merge({
    //format("%s%s%s%s%s%s%s", "hidden-link:/subscriptions/", data.azurerm_client_config.current.subscription_id, "/resourceGroups/", var.rg_name, "/providers/Microsoft.Web/sites/", var.rg_name, "-as") = "Resource"
    },
    azurerm_resource_group.rg.tags
  )
}

resource "azurerm_app_service" "app_as" {
  name                = "exampleAppService1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  https_only          = true
  tags = merge({
    //format("%s%s%s%s%s%s%s", "hidden-link:/subscriptions/", data.azurerm_client_config.current.subscription_id, "/resourceGroups/", var.rg_name, "/providers/Microsoft.Web/sites/", var.rg_name, "-as") = "Resource"
    },
    azurerm_resource_group.rg.tags
  )

  site_config {
    always_on                 = false
    dotnet_framework_version  = "v5.0"
    scm_type                  = "None"
    http2_enabled             = true
    use_32_bit_worker_process = true
    cors {
      allowed_origins = ["*"]
    }
  }
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = azurerm_application_insights.app_ai.instrumentation_key

  }
  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}