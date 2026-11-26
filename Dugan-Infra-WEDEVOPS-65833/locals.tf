locals {
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

  # WEDEVOPS-61443 description
 # kinetik_client_cidrs = [
#  ]

  # Stage 2 (WEDEVOPS-61443, after the cutover checks): P81 plus Kinetik's 14 egress IPs. Sorted because Octavia
  # returns allowed_cidrs in string order, and an unsorted list shows a reorder diff on every plan.
  lb_allowed_cidrs = sort(concat(local.p81_egress, local.kinetik_client_cidrs))
}
