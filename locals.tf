locals {
  # w-app-dugan-network. Used by database.tf and outputs.tf so both always point at the same network.
  # TODO(WEDEVOPS-65833): confirm this ID in Horizon (Network > Networks > w-app-dugan-network). Network IDs are
  # normally dashed UUIDs (like the subnet ID in database.tf); this undashed value looks like a project ID.
  dugan_network_id = "b6ebd9d467b949c484512faadb0d7486"

  vpn_and_mgmt = {
    "P81 - Dallas"         = "131.226.46.230/32"
    "P81 - Bangalore"      = "159.65.153.110/32"
    "P81 - Internal"       = "10.255.0.0/16"
    "net-internal-network" = "10.251.0.0/24"
  }

  p81_egress = [
    "131.226.46.230/32", # P81 - Dallas
    "159.65.153.110/32", # P81 - Bangalore
  ]

  # Dugan's client egress IPs allowed through the DB gateway on TCP/1433.
  # TODO(WEDEVOPS-65833): add Dugan's egress IPs here once known. Empty means P81 only.
  dugan_client_cidrs = []

  # Sorted because Octavia returns allowed_cidrs in string order, and an unsorted list shows a reorder diff on every plan.
  lb_allowed_cidrs = sort(concat(local.p81_egress, local.dugan_client_cidrs))
}
