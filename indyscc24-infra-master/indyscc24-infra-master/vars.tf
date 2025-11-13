variable "auto_allocated_network_id" {
    type = string
}

variable "subnet_pool_id" {
    type = string
}

variable "router_id" {
    type = string
}

variable "default_security_group_id" {
    type = string
}

variable "ceph_access_key" {
    type = string
}

variable "teams" {
    type = map(object({
        app_cred_secret = string
        ssh_pubkeys = set(string)
    }))
}

variable "admin_ssh_pubkey" {
    type = string
}