provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}

data "template_file" "cloudconfig" {
  template = "${file("cloudconfig.template")}"
  vars {
    cloudflare_api_key = "${var.cloudflare_api_key}"
    cloudflare_email   = "${var.cloudflare_email}"
    cloudflare_website = "${var.cloudflare_website}"
    docker_version     = "${var.docker_version}"
  }
}

resource "aws_security_group" "orch" {
  name        = "orch"
  description = "orch security group"
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "orch"
  }
}

resource "aws_launch_configuration" "orch" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "orch"
  security_groups = ["${aws_security_group.orch.name}"]
  user_data       = "${data.template_file.cloudconfig.rendered}"
  root_block_device {
    volume_size = "${var.volume_size}"
  }
}

resource "aws_autoscaling_group" "orch" {
  lifecycle { create_before_destroy = true }
  depends_on                = ["aws_launch_configuration.orch"]
  availability_zones        = ["${var.region}a", "${var.region}b", "${var.region}c"]
  name                      = "orch"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.orch.name}"
  tag {
    key                 = "Name"
    value               = "orch"
    propagate_at_launch = true
  }
}
