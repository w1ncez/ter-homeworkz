locals {
  vm_web_name = "${var.vpc_name}-${var.default_zone}-platform-web"
  vm_db_name  = "${var.vpc_name}-${var.vm_db_zone}-platform-db"
}
