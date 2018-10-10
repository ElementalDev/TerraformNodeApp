output "lb_dns" {
  value = "${aws_lb.reeceapplb.dns_name}"
}
