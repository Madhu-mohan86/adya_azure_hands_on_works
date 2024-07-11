variable "resource_group" {
    default = "sirius"
}

variable "location" {
  default = "East US"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "vm_name" {
  type = set(string)
  default = ["vmbytf01"]
}

variable "private_or_public" {
  type = bool
}

variable "vm_name_and_address"{
  type = map(list(string))
  default = {
    "vm_name" = [ "vmbytf01" ]
    "vm_address_prefixes" = ["10.0.0.0/26"]
  }
}