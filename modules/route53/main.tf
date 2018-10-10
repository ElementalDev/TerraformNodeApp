resource "aws_route53_record" "reecer53" {
  zone_id = "${var.route_zone_id}"
  name    = "${var.route_name}.spartaglobal.education"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.lb_dns_name}"]
}
