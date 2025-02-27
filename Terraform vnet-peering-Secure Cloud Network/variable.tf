variable "resource_name" {
  type        = string
  default     = "rg-training-poc"
  description = "Resource Name"

}

variable "location" {
  type        = string
  default     = "southindia"
  description = "Location name"

}

variable "vnet1-name" {
  type        = string
  default     = "vnet1-training-poc"
  description = "virtual network name 1"

}

variable "vnet2-name" {
  type        = string
  default     = "vnet2-training-poc"
  description = "virtual network name 2"

}

variable "vnet-peering-1" {
  type        = string
  default     = "vnet-peering-1"
  description = "virtual network peering 1"

}

variable "vnet-peering-2" {
  type        = string
  default     = "vnet-peering-1"
  description = "virtual network peering 1"

}

variable "vnet1_subnet1_name" {
  type        = string
  default     = "vnet1-subnet-1"
  description = "Subnet name"

}

variable "vnet2_subnet1_name" {
  type        = string
  default     = "vnet2-subnet-1"
  description = "Subnet name"

}

variable "virtual_machine_name" {
  type        = string
  default     = "vm-training-poc"
  description = "virtual machine name"

}

variable "prefix" {
  type        = string
  default     = "training-poc"
  description = "Resource name prefix"

}
