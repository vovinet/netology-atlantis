provider "aws" {
  region = "eu-central-1"
}

locals {
  workspace_instance_type_map = {
    stage = "t2.micro"
    prod = "t2.micro"
  }
  workspace_instance_count = {
    stage = "1"
    prod = "2"
  }

  foreach_instance_desc = {
    stage = {
      stage-1 = {
        name = "stage-1"
        instance_type = "t2.micro"
      }
    }
    prod = {
      prod-1 = {
        name = "prod-1"
        instance_type = "t2.micro"
      }
      prod-2 = {
        name = "prod-2"
        instance_type = "t2.micro"
      }
    }
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "ec2_count" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.workspace_instance_type_map[terraform.workspace.name]
  count         = local.workspace_instance_count[terraform.workspace]
}

resource "aws_instance" "ec2_foreach" {
  for_each = local.foreach_instance_desc[terraform.workspace]
    tags = {
      name = each.value.name
    }
    ami           = data.aws_ami.ubuntu.id
    instance_type = each.value.instance_type
}