variable "resource_group" {
    default = "intro_group"
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


variable "vm_name_and_address"{
  type = map(list(string))
  default = {
    "vm_name" = [ "vmbytf01" ]
    "vm_address_prefixes" = ["10.0.1.0/25"]
  }
}