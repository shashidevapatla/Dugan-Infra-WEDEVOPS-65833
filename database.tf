module "database" {
  # TODO(WEDEVOPS-65833): move to v2.2.12 or later. Up to v2.2.11 the module's create_users step silently creates
  # no users, so dugan_ro would not be created on this pin. Check the module changelog first: newer tags changed the
  # accepted local admin password characters (see secrets.tf).
  source = "git::https://github.com/waterfield/openstack-mssql-server-instance-module.git?ref=v2.2.3"

  environment           = var.environment
  project               = var.project
  client_name           = var.client_name
  openstack_cloud       = "openmetal-nonprod"
  openstack_tenant_name = var.openstack_tenant_name
  openstack_tenant_id   = var.openstack_tenant_id
  client_env_name       = "dugan-test"
  subnet_cidr           = "172.21.13.192/27"
  instance_network_id   = local.dugan_network_id                # w-app-dugan-network, see locals.tf
  instance_subnet_id    = "db6aa191-97c0-4096-bfa2-efbaf3a13d18" # w-app-dugan-subnet
  mssql_instance_name   = "ndugsql"
  instance_flavor       = var.mssql_instance_flavor
  client_database_name  = "dugan_tempdoppa"
  mssql_version         = "2019"

  databases_count                             = 1
  auto_generate_vm_number                     = true
  instance_administrator_username             = "Administrator"
  instance_administrator_password             = "vMD~WG5ytTr"
  instance_domain_address                     = "om.w-energy.net"
  instance_domain_netbios_name                = "OM"
  instance_default_domain_controller_hostname = "domdc02"
  instance_domain_administrator_username      = var.domain_join_username
  # instance_domain_administrator_password: deliberately unset, so the module default (the OM domain-join
  # credential the other nonprod repos use) applies and no copy of it lands in this repo.

  # TODO(WEDEVOPS-65833): confirm disk sizes (GB) before the first apply; shrinking one later replaces the volume.
  # These are the values copied from the Kinetik server. Sized from this server's data (149 + 31 GB) the usual rule
  # gives data ~235 (x1.3), logs ~60, backups ~3x data.
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

  mssql_user_mappings = [
    { username = "dugan_ro", type = "readonly", databases = ["dugan_tempdoppa_analytics"] },
  ]
}
