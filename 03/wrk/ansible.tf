variable "web_provision" {
  type        = bool
  default     = false
  description = "ansible provision switch variable"
}

locals {
  db_instances = [for k, v in yandex_compute_instance.db : v]
  storage_instances = [yandex_compute_instance.storage]
  }

resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = local.db_instances
    storage    = local.storage_instances
  })
  filename = "${abspath(path.module)}/hosts.ini"
}

resource "terraform_data" "web_hosts_provision" {
  count = var.web_provision == true ? 1 : 0
  
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage,
    local_file.hosts_templatefile
  ]

  provisioner "local-exec" {
    command    = "eval $(ssh-agent) && cat ~/.ssh/id_rsa | ssh-add -"
    on_failure = continue
  }

  provisioner "local-exec" {
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.ini ${abspath(path.module)}/test.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }

  triggers_replace = {
    inventory_hash = local_file.hosts_templatefile.content_md5
  }
}
