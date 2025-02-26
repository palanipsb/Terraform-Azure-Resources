variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "Project ALPHA Resource"

}

variable "default_tags" {
  type        = map(string)
  description = "Default tags"
  default = {
    company    = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  type        = map(string)
  description = "Environment tags"
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

variable "storageaccountname" {
  type        = string
  description = "The name of the storage account"
  default     = "projectalphastorageaccount to be formated"
}

variable "allowed_ports" {
  type    = string
  default = "80, 443, 223"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Enter the valid environment"
  }
}

variable "vm_sizes" {
  type = map(string)
  default = {
    "dev"     = "standard_D2s_v3",
    "staging" = "standard_D4s_v3",
    "prod"    = "standard_D8s_v3"
  }
}

variable "vm_size" {
  type    = string
  default = "standard_D2s_v3"
  validation {
    condition     = length(var.vm_size) >= 2 && length(var.vm_size) <= 20
    error_message = "The vm size should bewtween 2 and 20"
  }
  validation {
    condition     = strcontains(lower(var.vm_size), "standard")
    error_message = "The vm size should contain standard"
  }

}

variable "backup_name" {
  type    = string
  default = "test_backup"
  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup should ends with _backup"
  }
}

variable "credential" {
  type      = string
  default   = "xyz123"
  sensitive = true
}


