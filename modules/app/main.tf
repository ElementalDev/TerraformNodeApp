# -- Create a subnet --
resource "aws_subnet" "reeceapp" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.9.1.0/24"
  availability_zone = "${var.avail_zone}"
  tags {
    Name = "${var.name}-app-subnet"
  }
}

# -- Create a route table --
resource "aws_route_table" "reeceapprt" {
  vpc_id = "${var.vpc_id}"

  # Create your routes for the route table
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw_id}"
  }

  tags{
    Name = "${var.name}-app-rt"
  }
}

# -- Associate route tables --
resource "aws_route_table_association" "reeceassocapp" {
  subnet_id = "${aws_subnet.reeceapp.id}"
  route_table_id = "${aws_route_table.reeceapprt.id}"
}

# -- Create NACLs --
resource "aws_network_acl" "reeceapp" {
  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.reeceapp.id}"]

  egress{
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }
  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }

  egress{
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }

  ingress {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }

  tags {
    Name = "${var.name}-naclapp"
  }
}

# -- Create a security group --
resource "aws_security_group" "reeceapp" {
  name = "${var.name}-app"
  description = "${var.name} App Security Group"
  vpc_id = "${var.vpc_id}"

  # Inbound
  ingress{
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-app"
  }
}
