provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}

data "template_file" "cloudconfig" {
  template = "${file("cloudconfig.template")}"
  vars {
    aws_access_key       = "${var.aws_access_key}"
    aws_secret_key       = "${var.aws_secret_key}"
    cloudflare_api_key   = "${var.cloudflare_api_key}"
    cloudflare_email     = "${var.cloudflare_email}"
    cloudflare_webstie   = "${var.cloudflare_website}"
    docker_version       = "${var.docker_version}"
    rancher_register_url = "${var.rancher_register_url}"
    rancher_version      = "${var.rancher_version}"
  }
}

resource "aws_security_group" "servers" {
  name        = "servers"
  description = "servers security group"
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "servers"
  }
}

resource "aws_launch_configuration" "server" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "servers"
  security_groups = ["${aws_security_group.servers.name}"]
  user_data       = "${data.template_file.cloudconfig.rendered}"
  root_block_device {
    volume_size = "${var.volume_size}"
  }
}

resource "aws_autoscaling_group" "servers" {
  lifecycle { create_before_destroy = true }
  depends_on                = ["aws_launch_configuration.server"]
  availability_zones        = ["${var.region}a", "${var.region}b", "${var.region}c"]
  name                      = "servers"
  max_size                  = ${var.desired_capacity + 2}
  min_size                  = ${max(var.desirec_capacity - 2, 1)}
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = ${var.desired_capacity}
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.rancher_spot_machine.name}"
  tag {
    key                 = "Name"
    value               = "spot_${aws_launch_configuration.rancher_spot_machine.name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "spot-enabled"
    value               = "true"
    propagate_at_launch = true
  }
}
