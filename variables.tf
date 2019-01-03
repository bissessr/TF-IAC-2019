# VARIABLES
# =======================================
# From TerraForm.tfvars file
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

# Other Variables
# =======================================
variable "vpc_cidr" {
  description = "VPC CIDR"
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
  default = "ami-009d6802948d06e52"

}

variable "key_name" {
  description = "AWS SSH Key Name"
  default = "devops1"
}

variable "key_path" {
  description = "SSH Public Key path"  
  default = "C://Users//Raj//Documents//_LAB/_keys//devops1.pub"    
}