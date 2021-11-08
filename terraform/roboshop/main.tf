provider "aws" {
  region = "us-east-1"
}

variable "components" {
  default = ["frontend", "mongodb", "catalogue", "cart", "user", "redis", "mysql", "shipping", "rabbitmq", "payment"]
}

data "aws_ami" "ami" {
  owners       = [973714476881]
  name_regex   = "^Centos*"
  most_recent  = true
}

resource "aws_spot_instance_request" "cheap_worker" {
  count                  = length(var.components)
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-08797573be56216ce"]
  wait_for_fulfillment   = true
  tags = {
    Name = local.COMP_NAME
  }
}

resource "aws_ec2_tag" "tags" {
  count       = length(var.components)
  resource_id = element(aws_spot_instance_request.cheap_worker.*.spot_instance_id, count.index)
  key         = "Name"
  value       = local.COMP_NAME
}

locals {
  COMP_NAME = element(var.components, count.index)
}