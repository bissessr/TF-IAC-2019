/* AWS Provider Configuration
/*

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "ExampleServer1" {
    ami = ""
    instance_type = "t2_micro"
    
    tags {
        Name = "Server1",        
        Project = "Example IaC"
    }
    
    /* provisioner "local-exec" {
    /*    command = "echo ${aws_instance.ExampleServer1.private_ip} >> private_ip.txt"
    /*}

    provisioner "remote-exec" {
        inline = [
            "puppet apply"
            "touch test.txt"
        ]
    }
}

resource "aws_instance" "ExampleServer2" {
    ame = ""
    instance_type = "t2_micro"

    tags {
        Name = "Server2",
        Project = "Example IaC"
    }
}
