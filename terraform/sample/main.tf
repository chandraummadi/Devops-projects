provider "aws" {
  region = "us-east-1"
}

resource "aws_spot_instance_request" "aws-spot-request" {
  ami           = "ami-0dc863062bc04e1de"
  instance_type = "t2.micro"
  spot_type = "persistent"
  vpc_security_group_ids = ["sg-08797573be56216ce"]

  tags = {
    Name = "first-instance"
  }
}

resource "aws_ec2_tag" "aws-instance" {
  key         = "Name"
  resource_id = aws_spot_instance_request.aws-spot-request.spot_instance_id
  value       = "first-instance"
}