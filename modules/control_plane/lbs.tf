resource "aws_security_group" "plane_lb" {
  name        = "plane_lb_security_group"
  description = "Control Plane Load Balancer Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 2222
    to_port     = 2222
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = "${merge(var.tags, map("Name", "${var.env_name}-plane-security-group"))}"
}

resource "aws_lb" "control-plane" {
  name                             = "${var.env_name}-web-lb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  internal                         = false
  subnets                          = ["${var.public_subnet_ids}"]
}

resource "aws_lb_listener" "worker-gateway" {
  load_balancer_arn = "${aws_lb.control-plane.arn}"
  port              = 2222
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.worker-gateway.arn}"
  }
}

resource "aws_lb_listener" "atc" {
  load_balancer_arn = "${aws_lb.control-plane.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.atc.arn}"
  }
}

resource "aws_lb_listener" "uaa" {
  load_balancer_arn = "${aws_lb.control-plane.arn}"
  port              = 8443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.uaa.arn}"
  }
}

resource "aws_lb_target_group" "worker-gateway" {
  name     = "${var.env_name}-worker-gateway-tg"
  port     = 2222
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "atc" {
  name     = "${var.env_name}-atc"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "uaa" {
  name     = "${var.env_name}-uaa"
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    protocol = "TCP"
  }
}
