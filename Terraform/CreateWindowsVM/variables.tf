variable "admin_username" {
  default = "azureuser"
  type    = string
}

variable "admin_password" {
  sensitive = true
  type      = string
}

variable "vmname" {
  default = "tfvm"
  type    = string
}
