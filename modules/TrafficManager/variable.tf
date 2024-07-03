variable "resource_group_name" {
  default = "for_app_service_testing"
}

variable "location" {
  default = "East US"
}

variable "app_name" {
  type = set(string)
  default = [ "random-primary1" , "random-primary2" ]
}