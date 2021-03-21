provider "aws" {
  region = "eu-central-1"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

module "ec2_demo" {
  source = "./terraform-aws-ec2-instance-master/"

  instance_count = 1

  name                   = "ec2_demo"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
}