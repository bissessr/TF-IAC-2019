provider "aws" {
   region = "us-east-1"
}
 

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

# Define the public subnet

resource "aws_subnet" "public-subnet" {
  vpc_id = "DevOps1"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Web Public Subnet"
  }
}


# Define webserver inside the public subnet
resource "aws_instance" "wb" {
   ami  = "ami-009d6802948d06e52"
   instance_type = "t2.micro"
   key_name = "devops1"
   subnet_id = "${aws_subnet.public-subnet.id}"    

  tags {
    Name = "webserver"
  }

}

