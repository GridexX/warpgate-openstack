module "openstack" {

  source = "git::https://github.com/GridexX/openstack-vm-module.git?ref=1.1.1"


  instance_name = var.instance_name
  image_name = var.image_name
  flavor_name = var.flavor_name
  public_network_name = var.public_network_name
  public_key_pair_path = var.public_key_pair_path
  security_groups = [openstack_networking_secgroup_v2.warpgate.id]
  ssh_user = var.ssh_user
  user_data = file("./cloud-init.sh")
}

# Create a security group for Warpgate
resource "openstack_networking_secgroup_v2" "warpgate" {
  name        = "warpgate"
  description = "Security group for Warpgate"
}

resource "openstack_networking_secgroup_rule_v2" "warpgate-ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 2222
  port_range_max   = 2222
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.warpgate.id
}

resource "openstack_networking_secgroup_rule_v2" "warpgate-http" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 8888
  port_range_max   = 8888
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.warpgate.id
}

resource "openstack_networking_secgroup_rule_v2" "warpgate-mysql" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 33306
  port_range_max   = 33306
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.warpgate.id
}
