# The module exposes no outputs, so the DB gateway's public address is looked up from its Octavia VIP port:
# the floating IP is attached to that port.
data "openstack_networking_port_v2" "db_gateway_vip" {
  project_id   = var.openstack_tenant_id
  network_id   = local.dugan_network_id # same network as database.tf
  device_owner = "Octavia"

  # The load balancer is created by module.database; without this the first plan fails looking up a port that does
  # not exist yet.
  depends_on = [module.database]
}

data "openstack_networking_floatingip_v2" "db_gateway" {
  port_id = data.openstack_networking_port_v2.db_gateway_vip.id
}

output "db_gateway_public_ip" {
  description = "Public IP of the Dugan DB gateway load balancer (dugan-test-sql.wenergysoftware.com should point here)."
  value       = data.openstack_networking_floatingip_v2.db_gateway.address
}
