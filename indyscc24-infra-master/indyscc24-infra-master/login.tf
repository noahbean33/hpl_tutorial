# Create a port on the subnet made in subnet.tf for each team
resource "openstack_networking_port_v2" "login_ports" {
    for_each = openstack_networking_subnet_v2.indyscc_subnets

    name           = each.value.name
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"
    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.terraform_ssh_ping.id
    ]

    fixed_ip {
        subnet_id = each.value.id
    }
}

# Create the login nodes
resource "openstack_compute_instance_v2" "login_nodes" {
    for_each = var.teams

    name = "${each.key}-login"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.small"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    security_groups = ["terraform_ssh_ping", "default"]

    network {
        port = openstack_networking_port_v2.login_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.terraform_ssh_ping, openstack_networking_port_v2.login_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a floating (public) IP address for each login node
resource "openstack_networking_floatingip_v2" "terraform_login_floatingips" {
    for_each = var.teams

    pool = "public"
}

# Assign the floating IP to the login node
resource "openstack_compute_floatingip_associate_v2" "terraform_floatingips_assoc_login" {
    for_each = var.teams

    floating_ip = openstack_networking_floatingip_v2.terraform_login_floatingips[each.key].address
    instance_id = openstack_compute_instance_v2.login_nodes[each.key].id
}