provider "aws" {
  region = "us-east-1"
  access_key = "var.access_key"
  secret_key = "var.secret_key"
}


resource "aws_instance" "docker" {
    ami                         = var.ami
    instance_type               = var.instancetype
    vpc_security_group_ids      = ["sg-0171b9eb291b9d915"]
    subnet_id                   = var.subnet
    associate_public_ip_address = true
    user_data                   = file("user-data.sh")
    key_name                    = var.keypair
}

resource "aws_ebs_volume" "data_volume" {
    availability_zone = aws_instance.docker.availability_zone
    size              = var.addlDiskSizeinGB
    tags              = var.default_tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.docker.id
}

output "ip" {
  value = aws_instance.docker.private_ip
}
