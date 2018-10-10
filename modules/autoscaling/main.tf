# -- Create Launch configuration --
resource "aws_launch_configuration" "reeceapplc" {
  name = "${var.name}-TF-App-LC"
  image_id = "${var.app_ami_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${var.app_sec_group}"]
  user_data = "${var.user_data}"
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
}

# -- Create Autoscale group --
resource "aws_autoscaling_group" "reeceappasg" {
  max_size = 2
  min_size = 2
  launch_configuration = "${aws_launch_configuration.reeceapplc.id}"
  vpc_zone_identifier = ["${var.app_sn_id}"]
  target_group_arns = ["${var.target_group}"]

  # Destroy before dependencies
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.name}-TF-App"
    propagate_at_launch = true
  }
}
