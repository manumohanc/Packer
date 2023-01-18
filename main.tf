provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

#==================
#Variables
#==================

variable "region" {

  default     = "ap-south-1"
  description = "Default region the project is created on"

}

variable "access_key" {

  default     = "AKIA56ODWEEZII5BZX73"
  description = "Access key of the terraform IAM user"

}

variable "secret_key" {

  default     = "jDB0dVB/Nm7CBfdYRcXB6DRfPu5aFPnX9TgNV+M5"
  description = "Secret key of the terraform IAM user"

}

variable "project" {

  default     = "Zomato"
  description = "Name of the project"

}

variable "environment" {

  default = "dev"

}

variable "instance_type" {

  default = "t2.micro"

}

#Create Key-Pair
#====================

resource "tls_private_key" "key-data" {

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {

  key_name   = "deployer-key"
  public_key = tls_private_key.key-data.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key-data.private_key_pem}' > ./mynewkey.pem ; chmod 400 ./mynewkey.pem"
  }

   provisioner "local-exec" {
    when = destroy
    command = "rm -rf ./mynewkey.pem"
  }
}


#Create Security Group
#=========================

resource "aws_security_group" "test" {

  name_prefix = "${var.project}-${var.environment}-db_server-"
  description = "Allow access to instance "

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {

    "Name" = "${var.project}-${var.environment}-test"
  }

}


#Get AMI details
#=============================

data "aws_ami" "check-ami" {

  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["${var.project}-${var.environment}-*"]
  }

  filter {
    name   = "tag:env"
    values = [var.environment]
  }

  filter {
    name   = "tag:project"
    values = [var.project]
  }
}


# Create AWS instance
#================================

resource "aws_instance" "webserver" {

  ami                    = data.aws_ami.check-ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.test.id]

  tags = {

    "Name" = "${var.project}-${var.environment}-webserver"
  }
}


# Outputs
#===========================

output Http-Link {

  value = "http://${aws_instance.webserver.public_ip}"

}

output ssh {

  value = "ssh -i ${path.cwd}/mynewkey.pem ec2-user@${aws_instance.webserver.public_ip}"
}
