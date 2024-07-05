module "vm" {
  source = "../modules/Virtualmachines"
  private_or_public = true
}

module "load_balancer" {
  source = "../modules/LoadBalancer"
  rg = module.vm.rg
  location = module.vm.location
  vn_id = module.vm.vn_id
  private_lb_or_public_lb = true
  subnet_id = module.vm.subnet_id[0]
}


module "traffic_manager" {
  source = "../modules/TrafficManager"
}

module "disks" {
  source = "../modules/Disks"
  resource_group = module.vm.rg
  location = module.vm.location
  az_vmid = module.vm.vm_id[1]
}

module "backup" {
  source = "../modules/Backup"
  rg = module.vm.rg
  location = module.vm.location
  vm_id = module.vm.vm_id[1]
  disk_id = module.disks.disk_id
}

module "blob_storage" {
  source = "../modules/Blobstorage"
}

module "image_capture" {
  source = "../modules/ImageCapture"
  resource_group_name = module.vm.rg
  location = module.vm.location
  vm_id = module.vm.vm_id[0]
}