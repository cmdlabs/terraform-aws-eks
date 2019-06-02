data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

data "template_file" "launch_template_userdata" {
  template = file("${path.module}/templates/userdata.sh.tpl")
  count    = var.worker_group_count

  vars = {
    cluster_name        = var.cluster_name
    endpoint            = aws_eks_cluster.this.endpoint
    cluster_auth_base64 = aws_eks_cluster.this.certificate_authority[0].data
    pre_userdata        = lookup(var.workers[count.index], "pre_userdata", "")
    additional_userdata = lookup(var.workers[count.index], "additional_userdata", "")
    kubelet_extra_args  = lookup(var.workers[count.index], "kubelet_extra_args", "")
  }
}

data "template_file" "kiam_launch_template_userdata" {
  template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    cluster_name        = var.cluster_name
    endpoint            = aws_eks_cluster.this.endpoint
    cluster_auth_base64 = aws_eks_cluster.this.certificate_authority[0].data
    pre_userdata        = var.kiam_pre_userdata
    additional_userdata = var.kiam_additonal_userdata
    kubelet_extra_args  = var.kiam_kubelet_extra_args
  }
}

