variable "azurerm_resource_group" {
  type        = string
  default     = "rg_poc_training"
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "location of the resource group"

}

variable "environment" {
  default = {
    environment = "val"
  }

}
