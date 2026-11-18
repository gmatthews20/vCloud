resource "macaddress" "mac_addresses" {
  count = 4
}

locals {
  address = "10.20.1.0"
  prefix  = 27
}


module "ctrl-01" {
  source          = "./modules/libvirt_vm"
  machine_name    = "ctrl-01"
  machine_cores   = 1
  machine_mem     = 4
  libvirt_pool    = libvirt_pool.default.name
  base_image_path = libvirt_volume.ubuntu_base.path
  networks = [
    {
      name        = libvirt_network.vm-net.name,
      address     = format("%s/%s", cidrhost(format("%s/%s", local.address, local.prefix), 2), local.prefix),
      mac_address = macaddress.mac_addresses[0].address
      gateway = cidrhost(format("%s/%s", local.address, local.prefix), 1)
    }
  ]
  user_data = file("user_data/ctrl.yaml")
}

module "ctrl-02" {
  source          = "./modules/libvirt_vm"
  machine_name    = "ctrl-02"
  machine_cores   = 1
  machine_mem     = 4
  libvirt_pool    = libvirt_pool.default.name
  base_image_path = libvirt_volume.ubuntu_base.path
  networks = [
    {
      name        = libvirt_network.vm-net.name,
      address     = format("%s/%s", cidrhost(format("%s/%s", local.address, local.prefix), 3), local.prefix),
      mac_address = macaddress.mac_addresses[1].address,
      gateway = cidrhost(format("%s/%s", local.address, local.prefix), 1)
    }
  ]
  user_data = file("user_data/ctrl.yaml")
}

module "rtr-01" {
  source          = "./modules/libvirt_vm"
  machine_name    = "rtr-01"
  machine_cores   = 1
  machine_mem     = 4
  libvirt_pool    = libvirt_pool.default.name
  base_image_path = libvirt_volume.ubuntu_base.path
  networks = [
    {
      name        = libvirt_network.vm-net.name,
      address     = format("%s/%s", cidrhost(format("%s/%s", local.address, local.prefix), 1), local.prefix),
      mac_address = macaddress.mac_addresses[2].address
    },
    {
      name        = libvirt_network.wan.name,
      mac_address = macaddress.mac_addresses[3].address,
      gateway = "192.168.150.1"
    }
  ]
  user_data = file("user_data/rtr.yaml")
}
