module "vm" {
  source = "../modules/Virtualmachines"
  private_or_public = true
}

module "load_balancer" {
  source = "../modules/LoadBalancer/"
  rg = module.vm.rg
  location = module.vm.location
  vn_id = module.vm.vn_id
}