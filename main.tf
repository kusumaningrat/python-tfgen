resource "libvirt_cloudinit_disk" "vms" {
    for_each      = toset(var.vm_name)
    name          = "${each.value}.iso"
    pool          = "vms"
    user_data     = data.template_file.user_data[vm.name].rendered
    network_config = data.template_file.network_config[vm.name].rendered
}