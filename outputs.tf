output "cluster_endpoint" {
  description = "Cluster Kubernetes API endpoint"
  value = "${aws_eks_cluster.this.endpoint}"
}

output "cluster_certificate_authority" {
  description = "Cluster Certificate Authority Certificate"
  value = "${aws_eks_cluster.this.certificate_authority.0.data}"
}
