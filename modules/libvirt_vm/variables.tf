variable "libvirt_pool" {
  type        = string
  description = "Libvirt pool for virtual machine"
  default     = null
}

variable "machine_name" {
  type        = string
  description = "Name of the virtual machine"
  default     = null
}

variable "machine_mem" {
  type        = number
  description = "Virtual machine memory in GiB"
  default     = 4
}

variable "machine_cores" {
  type        = number
  description = "Number of virtual machine cores"
  default     = 2
}

variable "base_image_path" {
  type        = string
  description = "path of virtual machine base image"
  default     = null
}

variable "user_data" {
  type        = string
  description = "cloud-init user-data content"
  default     = ""
}

variable "networks" {
  type = list(object({
    name        = string
    address     = optional(string)
    mac_address = string
    gateway = optional(string)
  }))

  description = "networks to add an interface to the machine"
  default     = null
}