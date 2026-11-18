resource "libvirt_volume" "vm_disk" {
  lifecycle {
    replace_triggered_by = [
      libvirt_volume.init_volume
    ]
  }
  name          = format("%s_disk", var.machine_name)
  pool          = var.libvirt_pool
  capacity      = 10
  capacity_unit = "GB"
  target        = { format = { type = "qcow2" } }

  backing_store = {
    path = var.base_image_path
    format = {
      type = "qcow2"
    }
  }
}