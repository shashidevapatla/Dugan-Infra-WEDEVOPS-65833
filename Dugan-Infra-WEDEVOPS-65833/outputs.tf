# The module exposes no outputs, so the DB gateway's public address is looked up from its Octavia VIP port:
# the floating IP is attached to that port (WEDEVOPS-61443).
data "openstack_networking_port_v2" "db_gateway_vip" {
  project_id   = var.openstack_tenant_id
  network_id   = "8c3a0ad6-fdd4-4246-a22c-bc87ab313cc9" # w-app-eagleclaw-network, as in database.tf
  device_owner = "Octavia"
}

data "openstack_networking_floatingip_v2" "db_gateway" {
  port_id = data.openstack_networking_port_v2.db_gateway_vip.id
}

output "db_gateway_public_ip" {
  description = "Public IP of the kinetik-sql-external load balancer; dugan-test-sql.wenergysoftware.com points here."
  value       = data.openstack_networking_floatingip_v2.db_gateway.address
}
