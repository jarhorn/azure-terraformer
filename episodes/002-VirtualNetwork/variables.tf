variable "location" {
  type = string
}

variable "monitoring_state_path" {
  type    = string
  default = "../001-DiagnosticSettings/terraform.tfstate"
}
