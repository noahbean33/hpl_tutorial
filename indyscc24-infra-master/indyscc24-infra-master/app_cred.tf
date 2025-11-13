resource "openstack_identity_application_credential_v3" "team_scoped_credentials" {
    for_each = var.teams

    name = "indyscc-team-${each.key}"
    expires_at = "2024-11-04T00:00:00Z"
    unrestricted = false

    secret = each.value.app_cred_secret

    access_rules {
        path    = "/v2.1/servers"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/detail"
        service = "compute"
        method  = "GET"
    }

    ##### ACCESS RULES BASED ON INSTANCE ID

    # access rules for login node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.login_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu0 node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu0_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu0_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu0_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu0_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu0_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu1 node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu1_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu1_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu1_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu1_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu1_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu2 node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu2_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu2_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu2_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu2_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu2_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu3 node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu3_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu3_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu3_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu3_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.cpu3_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for gpu0 node
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu0_nodes[each.key].id}"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu0_nodes[each.key].id}/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu0_nodes[each.key].id}/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu0_nodes[each.key].id}/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${openstack_compute_instance_v2.gpu0_nodes[each.key].id}/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    #### ACCESS RULES BASED ON NAME

    # access rules for login node
    access_rules {
        path    = "/v2.1/servers/${each.key}-login"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-login/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-login/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-login/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-login/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu0 node
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu0"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu0/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu0/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu0/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu0/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu1 node
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu1"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu1/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu1/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu1/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu1/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu2 node
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu2"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu2/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu2/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu2/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu2/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for cpu3 node
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu3"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu3/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu3/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu3/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-cpu3/remote-consoles"
        service = "compute"
        method  = "POST"
    }

    # access rules for gpu0 node
    access_rules {
        path    = "/v2.1/servers/${each.key}-gpu0"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-gpu0/os-instance-actions"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-gpu0/os-instance-actions/*"
        service = "compute"
        method  = "GET"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-gpu0/action"
        service = "compute"
        method  = "POST"
    }
    access_rules {
        path    = "/v2.1/servers/${each.key}-gpu0/remote-consoles"
        service = "compute"
        method  = "POST"
    }
}