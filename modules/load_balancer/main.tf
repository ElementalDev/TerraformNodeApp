# -- Create a LB Listener --
resource "aws_lb_listener" "reeceapplblist" {
  load_balancer_arn = "${aws_lb.reeceapplb.arn}"
  port = "80"
  protocol = "TCP"

  default_action {
    target_group_arn = "${var.target_group}"
    type = "forward"
  }
}

# -- Create Load Balancer --
resource "aws_lb" "reeceapplb" {
  name = "${var.name}-TF-LB"
  internal = false
  load_balancer_type = "network"
  tags {
    Name = "${var.name}-TF-LB"
  }
  subnet_mapping {
    subnet_id = "${var.app_sn_id}"
  }
}
