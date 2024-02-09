terraform {
  cloud {
    organization = "Pocdemo"

    workspaces {
      name = "terra"
    }
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  }
}

provider "aws" {
  region  = "us-east-1"
}

data "template_file" "user_data_test" {
      template = "${file("userdata_arg_test.tfl")}"
      vars {
        myuser = "${var.myuser}"
        mypassword = "${var.mypassword}"
      }
}

data "aws_ami" "amazon_linux_2" {
 most_recent = true

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

 filter {
   name = "architecture"
   values = ["x86_64"]
 }

 owners = ["137112412989"] #amazon
}

resource "aws_instance" "example_server" {
  ami           = "${data.aws_ami.amazon_linux_2.id}"
  instance_type = "t2.micro"
  user_data = "${data.template_file.user_data_test.rendered}"

  tags = {
    Name = "JacksBlogExample"
  }
}
