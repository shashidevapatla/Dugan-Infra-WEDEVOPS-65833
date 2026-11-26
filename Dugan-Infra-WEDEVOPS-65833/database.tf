module "database" {
  source = "git::https://github.com/waterfield/openstack-mssql-server-instance-module.git?ref=v2.2.3"

  environment           = var.environment
  project               = var.project
  client_name           = var.client_name
  openstack_cloud       = "openmetal-nonprod"
  openstack_tenant_name = var.openstack_tenant_name
  openstack_tenant_id   = var.openstack_tenant_id
  client_env_name       = "dugan-test"
  subnet_cidr           = "172.21.13.192/27"
  instance_network_id   = "b6ebd9d467b949c484512faadb0d7486" # w-app-dugan-network (shared, om-Infra-network)
  instance_subnet_id    = "db6aa191-97c0-4096-bfa2-efbaf3a13d18" # w-app-dugan-subnet
  mssql_instance_name   = "ndugsql"
  instance_flavor       = var.mssql_instance_flavor
  client_database_name  = "dugan_tempdoppa" # created empty, then replaced by the restore from domsq02
  mssql_version         = "2019"

  databases_count                             = 1
  auto_generate_vm_number                     = true
  instance_administrator_username             = "Administrator"
  instance_administrator_password             = random_password.local_admin.result
  instance_domain_address                     = "om.w-energy.net"
  instance_domain_netbios_name                = "OM"
  instance_default_domain_controller_hostname = "domdc02"
  instance_domain_administrator_username      = var.domain_join_username
  # instance_domain_administrator_password: deliberately unset, so the module default (the OM domain-join
  # credential the other nonprod repos use) applies and no copy of it lands in this repo. Operator decision, WEDEVOPS-61443.

  # Sized at build (WEDEVOPS-61443): data = (149.4 + 31.1 GB) x 1.3; logs = kinetik_test2 log 40.8 GB x 1.5; backups = 3 x data.
  # Grown online since: kinetik_uat moved here took data to 400 and logs to 100 (WEDEVOPS-66875), then data 400 -> 500
  # (WEDEVOPS-67001, 2026-11-22). Keep these equal to the live cinder volumes: a smaller value forces a volume replacement.
  instance_root_disk_size     = 64
  instance_data_disk_size     = 500
  instance_logs_disk_size     = 100
  instance_tempdb_disk_size   = 24
  instance_backups_disk_size  = 705
  instance_create_floating_ip = false

  is_db_gateway                                    = true
  loadbalancer_allowed_cidrs                       = local.lb_allowed_cidrs
  loadbalancer_tcp_listener_timeout_client_data    = 60000
  loadbalancer_tcp_listener_timeout_member_connect = 60000
  loadbalancer_tcp_listener_timeout_member_data    = 60000

  rdp_enabled_cidrs     = local.vpn_and_mgmt
  ansible_enabled_cidrs = local.vpn_and_mgmt
  sql_enabled_cidrs     = local.vpn_and_mgmt

  # kinetik_ro was created by hand on 2026-10-09 with a new password that the operator vaulted, so the kinetik_ro
  # secret this module put in Barbican (nkinsql01_mssql_users_credentials) does NOT match the live login. The module's
  # create_users step silently created no users up to v2.2.11 (fixed in v2.2.12). This repo stays on v2.2.3 because
  # newer tags reject this local admin password and would run the patch, SSIS and max-memory steps on the live server
  # (WEDEVOPS-61443).
  mssql_user_mappings = [
    { username = "dugan_ro", type = "readonly", databases = ["dugan_tempdoppa_analytics"] },
  ]
}
