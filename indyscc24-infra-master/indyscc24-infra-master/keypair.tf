# Create a multi-pubkey keypair for each team
resource "openstack_compute_keypair_v2" "indyscc_keypairs" {
    for_each = var.teams

    name       = "indyscc-${each.key}"
    public_key = "${var.admin_ssh_pubkey}\n${join("\n", each.value.ssh_pubkeys)}"
}