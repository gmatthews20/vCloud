resource "libvirt_cloudinit_disk" "init_disk" {
  name = format("%s_init", var.machine_name)

  user_data = var.user_data
  meta_data = templatefile("${path.module}/cloud_config/meta_data", { vm_hostname = var.machine_name })
  network_config = templatefile("${path.module}/cloud_config/network_config.tftpl", { networks = var.networks })
}

resource "libvirt_volume" "init_volume" {
  name = format("%s_init.iso", var.machine_name)
  pool = var.libvirt_pool
  # Format will be auto-detected as "iso"

  create = {
    content = {
      url = libvirt_cloudinit_disk.init_disk.path
    }
  }
}
