variable "environment" {
  type        = string
  description = "The env type"
  default     = "staging"
}

variable "disksize" {
  type        = number
  description = "Size of the disk"
  default     = 15
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete OS disk on delete vm"
  default     = true
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Delete data on delete vm"
  default     = true
}

variable "allowed_location" {
  type        = list(string)
  description = "The list of allowed ocations"
  default     = ["West Europe", "North Europe", "East US"]
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to apply for VM"
  default = {
    "managed_by"  = "Terraform"
    "deparment"   = "DevOps"
    "environment" = "demo"
  }

}

variable "network_config" {
  type        = tuple([string, string, number])
  description = "Network Configuration (Vnet address, subnet address and subnet mask)"
  default     = ["10.0.0.0/16", "10.0.2.0", 24]

}

variable "allowed_vm_sizes" {
  type        = list(string)
  description = "Allowed VM sizes"
  default     = ["Satndard_DS1_v2", "Satndard_DS2_v2", "Satndard_DS3_v2"]

}
