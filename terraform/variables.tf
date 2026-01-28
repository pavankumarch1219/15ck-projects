variable "regions" {
  default = {
    westus2       = "West US 2"
    koreacentral  = "Korea Central"
  }
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "admin_user" {
  default = "azureuser"
}

