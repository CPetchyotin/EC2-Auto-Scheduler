
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] #
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "auto_ec2" {
  ami           = data.aws_ami.amazon_linux_2023.id # 
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name          = "AutoScheduledEC2"
    AutoScheduler = "true"
  }
}