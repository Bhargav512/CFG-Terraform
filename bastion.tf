variable "key_name" {
 default = "citizens"
}

variable "private_key_path" {
 default = "/home/ec2-user/terraform-poc/citizens.pem"
}

provider "aws" {
  access_key = "AKIAWXYX44ELTGIGBWRZ"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "bastion" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  count             = "3"
  key_name   = "${var.key_name}"

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_path}")}"

        }
}

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

}

resource "aws_security_group" "bastion-sg" {
  name   = "bastion-security-group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
cidr_blocks = ["0.0.0.0/0"]
  }
}
    
