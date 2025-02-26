variable "resource_group_name" {
  type        = string
  default     = "rg_training_poc"
  description = "Resource group name"
}

variable "allowed_location" {
  type    = list(string)
  default = ["canadacentral", "eastus"]
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "location of the resource"
  validation {
    condition     = contains(var.allowed_location, var.location)
    error_message = "Enter the valid location"
  }

}

variable "vnet-name" {
  type        = string
  default     = "vnet-training-poc"
  description = "Virtual network name"

}

variable "nsg-name" {
  type        = string
  default     = "nsg-training-poc"
  description = "Network security group name"

}
