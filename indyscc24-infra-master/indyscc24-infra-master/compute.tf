# Create a port on the subnet made in subnet.tf for each team's cpu0 node
resource "openstack_networking_port_v2" "cpu0_ports" {
    for_each = var.teams

    name           = "${each.key}-cpu0"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_groups[each.key].id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnets[each.key].id
    }
}

resource "openstack_compute_instance_v2" "cpu0_nodes" {
    for_each = var.teams

    name = "${each.key}-cpu0"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.xl"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    network {
        port = openstack_networking_port_v2.cpu0_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_groups, openstack_networking_port_v2.cpu0_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a port on the subnet made in subnet.tf for each team's cpu1 node
resource "openstack_networking_port_v2" "cpu1_ports" {
    for_each = var.teams

    name           = "${each.key}-cpu1"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_groups[each.key].id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnets[each.key].id
    }
}

resource "openstack_compute_instance_v2" "cpu1_nodes" {
    for_each = var.teams

    name = "${each.key}-cpu1"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.xl"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    network {
        port = openstack_networking_port_v2.cpu1_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_groups, openstack_networking_port_v2.cpu1_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a port on the subnet made in subnet.tf for each team's cpu2 node
resource "openstack_networking_port_v2" "cpu2_ports" {
    for_each = var.teams

    name           = "${each.key}-cpu2"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_groups[each.key].id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnets[each.key].id
    }
}

resource "openstack_compute_instance_v2" "cpu2_nodes" {
    for_each = var.teams

    name = "${each.key}-cpu2"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.xl"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    network {
        port = openstack_networking_port_v2.cpu2_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_groups, openstack_networking_port_v2.cpu2_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a port on the subnet made in subnet.tf for each team's cpu3 node
resource "openstack_networking_port_v2" "cpu3_ports" {
    for_each = var.teams

    name           = "${each.key}-cpu3"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_groups[each.key].id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnets[each.key].id
    }
}

resource "openstack_compute_instance_v2" "cpu3_nodes" {
    for_each = var.teams

    name = "${each.key}-cpu3"
    image_name = "Featured-RockyLinux9"
    flavor_name = "m3.xl"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    network {
        port = openstack_networking_port_v2.cpu3_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_groups, openstack_networking_port_v2.cpu3_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}

# Create a port on the subnet made in subnet.tf for each team's GPU node
resource "openstack_networking_port_v2" "gpu0_ports" {
    for_each = var.teams

    name           = "${each.key}-gpu0"
    network_id     = var.auto_allocated_network_id
    admin_state_up = "true"

    security_group_ids = [
        var.default_security_group_id,
        openstack_compute_secgroup_v2.internal_incoming_groups[each.key].id
    ]

    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.indyscc_subnets[each.key].id
    }
}

resource "openstack_compute_instance_v2" "gpu0_nodes" {
    for_each = var.teams

    name = "${each.key}-gpu0"
    image_name = "Featured-RockyLinux9"
    flavor_name = "g3.large"
    key_pair = "indyscc-${each.key}"

    user_data = templatefile("cloud-init.yml.tftpl", {ceph_access_key = var.ceph_access_key})

    network {
        port = openstack_networking_port_v2.gpu0_ports[each.key].id
    }

    depends_on = [ openstack_compute_secgroup_v2.internal_incoming_groups, openstack_networking_port_v2.gpu0_ports, openstack_compute_keypair_v2.indyscc_keypairs ]

    metadata = {
        terraform_controlled = "yes"
    }
}