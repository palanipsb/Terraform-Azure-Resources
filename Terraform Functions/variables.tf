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
