output "db_ip" {
  value = "${aws_instance.reecedbinst.private_ip}"
}
