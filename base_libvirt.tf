resource "libvirt_pool" "default" {
  name = "terraform"
  type = "dir"

  target = {
    path = "/var/lib/libvirt/images"
  }
}


resource "libvirt_volume" "ubuntu_base" {
  name = "ubuntu-24.04.qcow2"
  pool = libvirt_pool.default.name
  target = {
    format = {
      type = "qcow2"
    }
  }
  create = {
    content = {
      url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    }
  }
}

resource "libvirt_network" "vm-net" {
  name      = "vm-network"
  autostart = true
}

resource "libvirt_network" "wan" {
  name      = "wan"
  autostart = true
  forward = {
    mode = "nat"
  }
  ips = [ {
    address = cidrhost("192.168.150.0/27", 1)
    prefix = 27
    dhcp = {
      hosts = [ {
        mac = macaddress.mac_addresses[3].address
        ip = "192.168.150.20"
      } ]
    }
  } ]

}