vm_name = ["test-vm", "test-vm2", "test-vm3"]
hostname = ["test-vm.local", "test-vm2.local", "test-vm3.local"]
network = [{
    ip_addresses = ["172.16.0.20/24", "172.16.0.21/24", "172.16.0.22/24"],
    gateways = ["172.16.0.1", "172.16.0.1", "172.16.0.1"],
    nameservers = [[["8.8.8.8", "8.8.4.4"]], [["8.8.8.8", "8.8.4.4"]], [["8.8.8.8", "8.8.4.4"]]]
}]