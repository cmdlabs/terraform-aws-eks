resource "aws_iam_role" "workers" {
  name = "eks-${var.cluster_name}-workers"

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

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  count = var.enable_ecr ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2RoleforSSM" {
  count = var.enable_ssm ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  count = var.enable_cluster_autoscaler && ! var.enable_kiam ? 1 : 0
  policy_arn = aws_iam_policy.worker_autoscaling.arn
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_external_dns" {
  count = var.enable_external_dns && ! var.enable_kiam ? 1 : 0
  policy_arn = aws_iam_policy.worker_external_dns.arn
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_ingress_alb" {
  count = var.enable_alb_ingress && ! var.enable_kiam ? 1 : 0
  policy_arn = aws_iam_policy.worker_alb_ingress.arn
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_cert_manager" {
  count = var.enable_cert_manager && ! var.enable_kiam ? 1 : 0
  policy_arn = aws_iam_policy.worker_cert_manager.arn
  role = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_velero" {
  count = var.enable_velero && ! var.enable_kiam ? 1 : 0
  policy_arn = aws_iam_policy.worker_velero.arn
  role = aws_iam_role.workers.name
}
