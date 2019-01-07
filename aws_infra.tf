# terraform plan -var-file terraform.tfvars
# terraform apply -var-file terraform.tfvars

# Define AWS provider
# ==============================================================

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

# Resources - VPC
# ==============================================================

# Create VPC
resource "aws_vpc" "DevOpsOne" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "DevOpsOne-vpc"
  }
}

# Setup the public subnet - on US-East-1A AZ
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.DevOpsOne.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Web Public Subnet"
  }
}

# Setup private subnet - on US-East-1B AZ
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.DevOpsOne.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1b"

  tags {
    Name = "Database Private Subnet"
  }
}

# Setup internet gateway
# =========================================================
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.DevOpsOne.id}"

  tags {
    Name = "DevOpsOne-VPC IGW"
  }
}


# NAT Gateway for Internet access for Private Subnet
# =========================================================
resource "aws_eip" "gateway_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.gateway_eip.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  depends_on    = ["aws_internet_gateway.gw"]
  tags {
    Name = "gw nat"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.DevOpsOne.id}"
}  

resource "aws_route" "nat_route" {
  route_table_id         = "${aws_route_table.nat_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gateway.id}"  
}

resource "aws_route_table_association" "private_route" {  
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}


# Setup Route Table
# =========================================================
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.DevOpsOne.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags {
    Name = "Public Subnet Route Table"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Setup Security Groups
# ============================================================

# Setup Security Group for public subnet
resource "aws_security_group" "sg-public" {
  name = "vpc_test_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

  vpc_id="${aws_vpc.DevOpsOne.id}"

  tags {
    Name = "Public-SG"
  }
}

# Setup security group for private subnet
resource "aws_security_group" "sg-private"{
  name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

# Allow traffic within Private Subnet
ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.DevOpsOne.id}"

  tags {
    Name = "Private-SG"
  }
}

# Resources - EC2 Instances
# ==============================================================

# Setup webserver on public subnet
resource "aws_instance" "wb" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-public.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("install_web.sh")}"

  tags {
    Name = "webserver"
  }
}

# Setup database on private subnet
resource "aws_instance" "db" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   # key_name = "${aws_key_pair.default.id}"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-private.id}"]
   source_dest_check = false
   user_data = "${file("install_db.sh")}"

  tags {
    Name = "database"
  }
}

# setup Jenkins Server on private subnet
resource "aws_instance" "jenkins" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   #key_name = "${aws_key_pair.default.id}"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-private.id}"]
   source_dest_check = false
   user_data = "${file("install_jenkins.sh")}"

  tags {
    Name = "jenkins"
  }
}

# Setup Docker Host on private subnet
resource "aws_instance" "docker-host" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   #key_name = "${aws_key_pair.default.id}"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-private.id}"]
   source_dest_check = false
   user_data = "${file("install_docker.sh")}"

  tags {
    Name = "docker-host"
  }
}
