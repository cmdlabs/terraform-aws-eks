locals {
  optional_profile = var.autotag_profile ? "--profile ${var.autotag_profile}" : ""
}

resource "null_resource" "tag-public-subnet" {
  count = var.autotag_subnets ? 1 : 0

  triggers = {
    public_subnets = join(" ", var.public_subnets)
  }

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${join(" ", var.public_subnets)} --tags Key=kubernetes.io/cluster/${var.cluster_name},Value=shared Key=kubernetes.io/role/elb,Value=1 ${local.optional_profile}"
  }
}

resource "null_resource" "tag-private-subnet" {
  count = var.autotag_subnets ? 1 : 0

  triggers = {
    private_subnets = join(" ", var.private_subnets)
  }

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${join(" ", var.private_subnets)} --tags Key=kubernetes.io/cluster/${var.cluster_name},Value=shared Key=kubernetes.io/role/internal-elb,Value=1 ${local.optional_profile}"
  }
}

