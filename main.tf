terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
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

resource "aws_instance" "example_server" {
  ami           = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"
  user_data = "${data.template_file.user_data_test.rendered}"

  tags = {
    Name = "JacksBlogExample"
  }
}
