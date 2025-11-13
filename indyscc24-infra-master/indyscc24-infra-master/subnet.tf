# Create a subnet for each team
resource "openstack_networking_subnet_v2" "indyscc_subnets" {
  for_each = var.teams

  network_id = var.auto_allocated_network_id
  subnetpool_id = var.subnet_pool_id
  name       = each.key
}

# Create an interface on the router for each subnet
resource "openstack_networking_router_interface_v2" "indyscc_subnet_interfaces" {
  for_each = openstack_networking_subnet_v2.indyscc_subnets

  router_id = var.router_id
  subnet_id = each.value.id
}