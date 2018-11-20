resource "aws_subnet" "plane_subnets" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${cidrsubnet(local.control_plane_cidr, 2, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags = "${merge(var.tags, map("Name", "${var.env_name}-infrastructure-subnet${count.index}"))}"
}

data "template_file" "plane_subnet_gateways" {
  # Render the template once for each availability zone
  count    = "${length(var.availability_zones)}"
  template = "$${gateway}"

  vars {
    gateway = "${cidrhost(element(aws_subnet.plane_subnets.*.cidr_block, count.index), 1)}"
  }
}

resource "aws_route_table_association" "route_plane_subnets" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.plane_subnets.*.id, count.index)}"
  route_table_id = "${element(var.private_route_table_ids, count.index)}"
}
