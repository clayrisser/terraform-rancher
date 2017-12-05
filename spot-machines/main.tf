provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
}

data "template_file" "userdata" {
  template = "${file("userdata.template")}"
  vars {
    rancher_registration_command = "${var.rancher_registration_command}"
    docker_version               = "1.12.6"
    ssh_pub_key                  = "${var.ssh_public_key}"
  }
}

resource "aws_launch_configuration" "rancher-spot-machine" {
  image_id        = "ami-9515feed"
  instance_type   = "t2.medium"
  key_name        = "rancher-machine"
  security_groups = ["rancher-machine"]
  user_data       = "${data.template_file.userdata.rendered}"
}

resource "aws_autoscaling_group" "rancher-spot-machines" {
  lifecycle { create_before_destroy = true }
  depends_on                = ["aws_launch_configuration.rancher-spot-machine"]
  availability_zones        = ["us-west-2a", "us-west-2b", "us-west-2c"]
  name                      = "spot-${aws_launch_configuration.rancher-spot-machine.name}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.rancher-spot-machine.name}"
  tag {
    key                 = "Name"
    value               = "spot-${aws_launch_configuration.rancher-spot-machine.name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "spot"
    value               = "true"
    propagate_at_launch = true
  }
}
