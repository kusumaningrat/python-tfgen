# Python-Tfgen Libvirt

Python tfgen is a tool that we can use to generate terraform configuration, especially for libvirt for right now. 

## Installation

You need to clone the repository into your computer. 

```bash
git clone https://<git_url/python-tfgen
```
You need to prepare a file named `data.yaml` that define your servers spec. The file is look like this for example (just make custom base on your need).
```
user_data:
  - user: ubuntu
    sshkey: <pubkey>
  - user: root
    sshkey: <pubkey>

spec:
  - vm_name: test-vm
    hostname: test-vm.local
    network:
      - ip_address: 172.16.0.20
        netmask: 255.255.255.0
        gateway: 172.16.0.1
        nameservers:
          - 8.8.8.8 
          - 8.8.4.4
  - vm_name: test-vm2
    hostname: test-vm2.local
    network:
      - ip_address: 172.16.0.21
        netmask: 255.255.255.0
        gateway: 172.16.0.1
        nameservers:
          - 8.8.8.8 
          - 8.8.4.4
  - vm_name: test-vm3
    hostname: test-vm3.local
    network:
      - ip_address: 172.16.0.22
        netmask: 255.255.255.0
        gateway: 172.16.0.1
        nameservers:
          - 8.8.8.8
          - 8.8.4.4

```

You need to create the `provider.tf` file manually by using below contents (just make custom base on your need).

```
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
```

Then, you can just run the `main.py` file to generate the config. 

```
 python3 main.py
```
The completed structure in your project will look like this

```
/
 - templates
 - cloudinit.cfg
 - network.cfg
 - provider.tf
 - terraform.tfvars
 - variables.tf
```

Apply the config

```
 terraform plan 
 terraform apply --auto-approve
```


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
Please make sure to update tests as appropriate.