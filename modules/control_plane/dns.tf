locals {
  use_route53 = "${var.region == "us-gov-west-1" ? 0 : 1}"
}

resource "aws_route53_record" "control-plane" {
  count   = "${local.use_route53 ? 1 : 0}"
  zone_id = "${var.zone_id}"
  name = "plane.${var.dns_zone_dns_name}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_lb.control-plane.dns_name}"]
}
