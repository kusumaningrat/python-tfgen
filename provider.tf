provider "libvirt" {
    uri = "qemu:///system"
}

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.4"
    }
  }
}