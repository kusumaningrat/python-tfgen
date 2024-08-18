variable "vm_name" {
  description = "Description for vm_name"
  type        = list(string)
}
variable "hostname" {
  description = "Description for hostname"
  type        = list(string)
}
variable "network" {
  description = "Description for network"
  type = list(object({
      ip_address  = string
      netmask     = string
      gateway     = string
      nameservers = list(string)
  }))
}
