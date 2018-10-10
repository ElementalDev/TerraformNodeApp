# -- Give provider --
provider "aws" {
  region = "eu-west-3"
}

# -- Create a VPC --
resource "aws_vpc" "reecevpc" {
  cidr_block = "10.9.0.0/16"
  tags {
    Name = "${var.name}-TF-vpc"
  }
}

# -- Create an internet gateway --
resource "aws_internet_gateway" "reeceig" {
  vpc_id = "${aws_vpc.reecevpc.id}"
  tags {
    Name = "${var.name}-TF-igw"
  }
}

# -- Create an app machine and all its requirements --
module "app_setup" {
  source = "./modules/app"

  name = "${var.name}"
  avail_zone = "eu-west-3a"
  vpc_id = "${aws_vpc.reecevpc.id}"
  igw_id = "${aws_internet_gateway.reeceig.id}"
  db_private_ip = "${module.db_setup.db_ip}"
}

# -- Create an db machine and all its requirements --
module "db_setup" {
  source = "./modules/db"

  name = "${var.name}"
  db_ami_id = "${var.db_ami_id}"
  instance_type = "t2.micro"
  avail_zone = "eu-west-3a"
  vpc_id = "${aws_vpc.reecevpc.id}"
  app_sec_group = "${module.app_setup.app_sec_group_id}"
  app_sn_cidr = "${module.app_setup.app_sn_cidr}"
}

# -- Create an target group --
module "target_group_setup" {
  source = "./modules/target_group"

  name = "${var.name}"
  vpc_id = "${aws_vpc.reecevpc.id}"
}

# -- Create an autoscaling group --
module "autoscaling_setup" {
  source = "./modules/autoscaling"

  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  instance_type = "t2.micro"
  app_sec_group = "${module.app_setup.app_sec_group_id}"
  user_data = "${data.template_file.app_init.rendered}"
  app_sn_id = "${module.app_setup.app_sn_id}"
  target_group = "${module.target_group_setup.target_group}"
}

# -- Create a load balancer group --
module "lb_setup" {
  source = "./modules/load_balancer"

  name = "${var.name}"
  app_sn_id = "${module.app_setup.app_sn_id}"
  target_group = "${module.target_group_setup.target_group}"
}

# -- Create a route53 record --
module "r53_setup" {
  source = "./modules/route53"

  lb_dns_name = "${module.lb_setup.lb_dns}"
  route_zone_id = "${var.route_zone_id}"
  route_name = "${var.route_name}"
}

# -- Initialise template --
data "template_file" "app_init" {
  template = "${file("./modules/app/scripts/app/setup.sh.tpl")}"

  vars {
   database_ip = "${module.db_setup.db_ip}"
  }
}
