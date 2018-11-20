output "plane_subnet_ids" {
  value = ["${aws_subnet.plane_subnets.*.id}"]
}

output "plane_subnets" {
  value = ["${aws_subnet.plane_subnets.*.id}"]
}

output "plane_subnet_availability_zones" {
  value = ["${aws_subnet.plane_subnets.*.availability_zone}"]
}

output "plane_subnet_cidrs" {
  value = ["${aws_subnet.plane_subnets.*.cidr_block}"]
}

output "plane_subnet_gateways" {
  value = ["${data.template_file.plane_subnet_gateways.*.rendered}"]
}
