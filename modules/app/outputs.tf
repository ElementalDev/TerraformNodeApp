output "app_sec_group_id" {
  value = "${aws_security_group.reeceapp.id}"
}

output "app_sn_cidr" {
  value = "${aws_subnet.reeceapp.cidr_block}"
}

output "app_sn_id" {
  value = "${aws_subnet.reeceapp.id}"
}
