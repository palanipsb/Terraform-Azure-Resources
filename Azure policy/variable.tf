variable "prefix" {
    type = string
    default = "training-poc"
}


variable "location" {
  type = list(string)
    default = ["southeastasia", "southindia"]
  
}

variable "vm_sizes" {
  type = list(string)
  default = [ "Standard_B2s", "StandardB2ms" ]
  
}

variable "allowed_tags" {
  type = list(string)
  default = [ "department", "project" ]
  
}