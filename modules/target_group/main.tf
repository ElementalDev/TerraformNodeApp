# -- Create Target group --
resource "aws_lb_target_group" "reeceapptg" {
  name     = "${var.name}-TF-TG"
  vpc_id   = "${var.vpc_id}"
  port     = 80
  protocol = "TCP"
}
