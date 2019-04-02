resource "aws_iam_role" "workers_kiam" {
  count = "${var.enable_kiam ? 1 : 0}"

  name = "eks-${var.cluster_name}-workers-kiam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEKSWorkerNodePolicy" {
  count      = "${var.enable_kiam ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.workers_kiam.name}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEKS_CNI_Policy" {
  count      = "${var.enable_kiam ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.workers_kiam.name}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEC2ContainerRegistryReadOnly" {
  count      = "${var.enable_ecr && var.enable_kiam ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.workers_kiam.name}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_AmazonEC2RoleforSSM" {
  count      = "${var.enable_ssm && var.enable_kiam ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = "${aws_iam_role.workers_kiam.name}"
}

data "aws_iam_policy_document" "kiam_server_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${var.cluster_name}-workers-kiam"]
    }
  }
}

data "aws_iam_policy_document" "kiam_role_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-${var.cluster_name}-kiam-server"]
    }
  }
}

resource "aws_iam_role" "kiam_server" {
  count = "${var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-server"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_server_trust_policy.json}"
}

resource "aws_iam_role" "kiam_external_dns" {
  count = "${var.enable_external_dns && var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-external-dns"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_workers_external_dns" {
  count      = "${var.enable_external_dns && !var.enable_kiam ? 1 : 0}"
  policy_arn = "${aws_iam_policy.worker_external_dns.arn}"
  role       = "${aws_iam_role.kiam_external_dns.name}"
}

resource "aws_iam_role" "kiam_cluster_autoscaler" {
  count = "${var.enable_cluster_autoscaler && var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-cluster-autoscaler"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_cluster_autoscaler" {
  count      = "${var.enable_cluster_autoscaler && var.enable_kiam ? 1 : 0}"
  policy_arn = "${aws_iam_policy.worker_autoscaling.arn}"
  role       = "${aws_iam_role.kiam_cluster_autoscaler.name}"
}

resource "aws_iam_role" "kiam_ingress_alb" {
  count = "${var.enable_alb_ingress && var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-ingress-alb"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_ingress_alb" {
  count      = "${var.enable_alb_ingress && var.enable_kiam ? 1 : 0}"
  policy_arn = "${aws_iam_policy.worker_alb_ingress.arn}"
  role       = "${aws_iam_role.kiam_ingress_alb.name}"
}

resource "aws_iam_role" "kiam_cert_manager" {
  count = "${var.enable_cert_manager && var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-cert-manager"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_cert_manager" {
  count      = "${var.enable_alb_ingress && var.enable_kiam ? 1 : 0}"
  policy_arn = "${aws_iam_policy.worker_cert_manager.arn}"
  role       = "${aws_iam_role.kiam_cert_manager.name}"
}

resource "aws_iam_role" "kiam_velero" {
  count = "${var.enable_velero && var.enable_kiam ? 1 : 0}"
  name = "eks-${var.cluster_name}-kiam-velero"
  assume_role_policy = "${data.aws_iam_policy_document.kiam_role_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "kiam_velero" {
  count      = "${var.enable_velero && var.enable_kiam ? 1 : 0}"
  policy_arn = "${aws_iam_policy.worker_velero.arn}"
  role       = "${aws_iam_role.kiam_velero.name}"
}