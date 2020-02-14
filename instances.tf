locals {
  subnets = ["${aws_subnet.terraform-blue-green.*.id}"]

  user_data = <<EOF
    #cloud-config
    runcmd:
    - sudo docker run -d -p 80:80 nginx:latest
  EOF
}

resource "aws_instance" "terraform-blue-green" {
  count                  = 2
  ami                    = "ami-01d3a624c504dceda"
  instance_type          = "t2.micro"
  subnet_id              = "${element(local.subnets, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.terraform-blue-green.id}"]
  key_name               = "terraform-blue-green-v1"

  user_data = "${local.user_data}"

  tags {
    Name                  = "Terraform Blue/Green ${count.index + 1} (v${var.infrastructure_version})"
    InfrastructureVersion = "${var.infrastructure_version}"
  }
}

output "instance_public_ips" {
  value = "${aws_instance.terraform-blue-green.*.public_ip}"
}
