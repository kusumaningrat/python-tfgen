resource "libvirt_cloudinit_disk" "vms" {
    for_each      = toset(var.vm_name)
    name          = "${each.value}.iso"
    pool          = "vms"
    user_data     = data.template_file.user_data[each.key].rendered
    network_config = data.template_file.network_config[each.key].rendered
}
data "template_file" "network_config" {
    for_each = { for item in var.network : item.vm_name => item}
    template = file("${path.module}/network.cfg")

    vars = {
        ip_address = each.value.network[0].ip_address
        gateway    = each.value.network[0].gateway
        nameserver = each.value.network[0].nameserver
    }
}

data "template_file" "user_data" {
    for_each = { for item in var.network : item.vm_name => item}
    template = file("${path.module}/cloudinit.cfg")

    vars = {
	    hostname = each.value.hostname
    }

}

resource "libvirt_volume" "k8s-vm-vda" {
    for_each = local.vms

    name             = "${each.value.hostname}.qcow2"
    pool             = "vms"
    base_volume_name = "template-ubuntu2004.img"
    base_volume_pool = "isos"
    size             = "53687091200"
    format           = "qcow2"
}

resource "libvirt_domain" "vms" {
    for_each = local.vms

    name   = each.value.hostname
    memory = contains(["k8s-master01", "k8s-master02"], each.value.hostname) ? 6192 : 4096
    vcpu   = contains(["k8s-master01", "k8s-master02"], each.value.hostname) ? 3 : 2

    cpu {
           mode = "host-passthrough"
    }

    cloudinit = libvirt_cloudinit_disk.vms[each.key].id

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_port = "1"
        target_type = "virtio"
    }

    network_interface {
        network_name = "kubernetes"
        addresses     = [each.value.ip_address]
    }

    disk {
        volume_id = libvirt_volume.k8s-vm-vda[each.key].id
    }

    video {
        type = "vga"
    }

    graphics {
        type        = "vnc"
        listen_type = "address"
        autoport    = true
    }
}