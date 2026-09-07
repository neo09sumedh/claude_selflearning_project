# Look up the default VPC and its subnets so we don't need to
# hardcode any network IDs to get started.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Always use the latest Amazon Linux 2023 AMI instead of a
# hardcoded, possibly-outdated AMI ID.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "practice" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = element(data.aws_subnets.default.ids, 0)

  tags = {
    Name        = "terraform-ec2-practice"
    Environment = "dev"
    Owner       = var.owner
  }
}

output "instance_id" {
  value = aws_instance.practice.id
}

output "public_ip" {
  value = aws_instance.practice.public_ip
}