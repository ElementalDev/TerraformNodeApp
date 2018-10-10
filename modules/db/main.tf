resource "aws_subnet" "reecedb" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.9.2.0/24"
  availability_zone = "${var.avail_zone}"
  tags {
    Name = "${var.name}-db-subnet"
  }
}

resource "aws_route_table" "reecedbrt" {
  vpc_id = "${var.vpc_id}"

  # Create your routes for the route table
  tags{
    Name = "${var.name}-db-rt"
  }
}

resource "aws_route_table_association" "reeceassocdb" {
  subnet_id = "${aws_subnet.reecedb.id}"
  route_table_id = "${aws_route_table.reecedbrt.id}"
}

resource "aws_network_acl" "reecedb" {
  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.reecedb.id}"]

  ingress{
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.app_sn_cidr}"
    from_port = 27017
    to_port = 27017
  }

  egress{
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "${var.app_sn_cidr}"
    from_port = 1024
    to_port = 65535
  }

  tags {
    Name = "${var.name}-nacldb"
  }
}

resource "aws_security_group" "reecedb" {
  name = "${var.name}-db"
  description = "${var.name} db Security Group"
  vpc_id = "${var.vpc_id}"

  # Inbound
  ingress{
    from_port = "27017"
    to_port = "27017"
    protocol = "tcp"
    security_groups = ["${var.app_sec_group}"]
  }

  # Outbound
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-db"
  }
}

resource "aws_instance" "reecedbinst" {
  ami = "${var.db_ami_id}"
  subnet_id = "${aws_subnet.reecedb.id}"
  vpc_security_group_ids = ["${aws_security_group.reecedb.id}"]
  instance_type = "${var.instance_type}"
  # Adds bash script and runs it on AWS instance
  tags {
    Name = "${var.name}-TF-db"
  }
}
