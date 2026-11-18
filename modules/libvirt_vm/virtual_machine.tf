
resource "libvirt_domain" "machine" {

  lifecycle {
    replace_triggered_by = [
      libvirt_cloudinit_disk.init_disk.meta_data,
      libvirt_cloudinit_disk.init_disk.network_config,
      libvirt_cloudinit_disk.init_disk.user_data,
    ]
  }

  name        = var.machine_name
  memory      = var.machine_mem
  memory_unit = "GiB"
  vcpu        = var.machine_cores
  autostart   = true
  type        = "kvm"

  cpu = {
    mode = "host-passthrough"
  }

  features = {
    acpi = true
    smm = {
      state = "on"
    }
  }

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    firmware     = "efi"
  }

  devices = {
    disks = [
      {
        source = {
          file = {
            file = libvirt_volume.vm_disk.path
          }
        }
        target = {
          bus = "virtio"
          dev = "vda"
        }
        driver = {
          type = "qcow2"
        }
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.init_volume.pool
            volume = libvirt_volume.init_volume.name
          }
        }
        target = {
          bus = "sata"
          dev = "sda"
        }
      }
    ],
    consoles = [{
      protocol = {
        type = "pty"
      }
      target = {
        port = 0
        type = "serial"
      }
    }]

    interfaces = [for net in var.networks :
      {
        model = {
          type = "virtio"
        }
        mac = {
          address = net.mac_address
        }
        source = {
          network = {
            network = net.name
          }
        }
      }
    ]

  }
}