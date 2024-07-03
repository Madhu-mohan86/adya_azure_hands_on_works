module "vm" {
  source = "../modules/Virtualmachines"
  private_or_public = true
}

module "load_balancer" {
  source = "../modules/LoadBalancer/"
  rg = module.vm.rg
  location = module.vm.location
  vn_id = module.vm.vn_id
  # nic_id = module.vm.nic_id[0]
}

module "traffic_manager" {
  source = "../modules/TrafficManager"
}