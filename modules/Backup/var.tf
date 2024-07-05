variable "rg" {
  
}

variable "location" {
  
}

variable "recovery_service_name" {
  type = string
  default = "testing-vm-backup"
}

variable "sku" {
  type = string
  default = "Standard"
}

variable "backup_policy" {
  type = string
  default = "daily-backup-policy"
}

variable "vm_id" {

}

variable "disk_id" {
  type = string
}