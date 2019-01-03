variable "aws_region" {
  description = "VPC Region"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet - CIDR"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet - CIDR"
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "EC2 AMI"
  default = "ami-4fffc834"
}

variable "key_name" {
    description = "AWS SSH Key Name"
    default = "devops1"
}

variable "key_path" {
  description = "SSH Public Key path"
  #default = "/home/core/.ssh/id_rsa.pub"
    default = "C://Users//Raj//Documents//_LAB/_keys//devops1.pem"