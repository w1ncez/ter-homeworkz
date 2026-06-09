vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 20
    hdd_size      = 5
    hdd_type      = "network-hdd"
  }
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    hdd_size      = 5
    hdd_type      = "network-ssd"
  }
}

vm_metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMuFmpVixwtgIUouxGwEJhpLjJ********* root@vbox2"
}
