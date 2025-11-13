resource "openstack_compute_secgroup_v2" "terraform_ssh_ping" {
  name = "terraform_ssh_ping"
  description = "Security group with SSH and PING open to 0.0.0.0/0"

  #ssh rule
  rule {
    ip_protocol = "tcp"
    from_port   =  "22"
    to_port     =  "22"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

}

# Create a security group for each team that allows all incoming traffic from that team's subnet
resource "openstack_compute_secgroup_v2" "internal_incoming_groups" {
  for_each = var.teams

  name = "${each.key}-internal"
  description = "Allow all incoming TCP traffic from team ${each.key}'s subnet"

  rule {
    ip_protocol = "tcp"
    from_port   = "1"
    to_port     = "65535"
    cidr        = openstack_networking_subnet_v2.indyscc_subnets[each.key].cidr
  }

  depends_on = [ openstack_networking_subnet_v2.indyscc_subnets ]
}