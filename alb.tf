resource "aws_security_group" "alb" {
  count       = var.enable_alb_ingress ? 1 : 0
  name        = "eks-${var.cluster_name}-alb-ingress"
  description = "Allow all traffic on HTTP and HTTPS into ALB Ingress Controller ALB"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "alb_http" {
  count             = var.enable_alb_ingress ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https" {
  count             = var.enable_alb_ingress ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress" {
  count             = var.enable_alb_ingress ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb_workers" {
  count       = var.enable_alb_ingress ? 1 : 0
  name        = "eks-${var.cluster_name}-workers-alb-ingress"
  description = "Allow all traffic from Ingress Controller ALB to workers"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "alb_workers" {
  count                    = var.enable_alb_ingress ? 1 : 0
  security_group_id        = aws_security_group.alb[0].id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb[0].id
}

