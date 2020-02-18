locals {
  subnets = ["${aws_subnet.terraform-blue-green.*.id}"]

  user_data = <<EOF
    #cloud-config
    runcmd:
    - sudo $(aws ecr get-login --no-include-email --region us-west-2);
    - sudo docker run -d -p 3000:3000 780533555440.dkr.ecr.us-west-2.amazonaws.com/grafana-stage
  EOF
}

resource "aws_instance" "terraform-blue-green" {
  count                  = 2
  ami                    = "ami-089642cd2741957fc"
  instance_type          = "t2.micro"
  iam_instance_profile   = "ecr_read_only"
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
