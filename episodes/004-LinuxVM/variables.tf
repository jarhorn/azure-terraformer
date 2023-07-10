variable "location" {
  type = string
}

variable "monitoring_state_path" {
  type    = string
  default = "../001-DiagnosticSettings/terraform.tfstate"
}

variable "ssh_state_path" {
  type    = string
  default = "../003-KeyVault/terraform.tfstate"
}

variable "network_state_path" {
  type    = string
  default = "../002-VirtualNetwork/terraform.tfstate"
}
