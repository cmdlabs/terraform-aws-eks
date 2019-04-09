variable "cluster_name" {
  description = "Name of the EKS Cluster"
}

variable "cluster_version" {
  description = "EKS Cluster Version"
}

variable "private_subnets" {
  description = "Private tier subnet list"
  type        = "list"
}

variable "public_subnets" {
  description = "Public tier subnet list"
  type        = "list"
}

variable "autotag_subnets" {
  description = "Automatically add Kubernetes tags to subnets. Requires aws-cli to be available."
  default     = false
}

variable "enable_cert_manager" {
  description = "Enable required components for Cert-Manager"
  default     = true
}

variable "enable_ecr" {
  description = "Enable required components for Amazon ECR Read Only"
  default     = true
}

variable "enable_external_dns" {
  description = "Enable required components for External-DNS"
  default     = true
}

variable "enable_ssm" {
  description = "Enable required components for SSM"
  default     = true
}

variable "enable_alb_ingress" {
  description = "Enable required components for ALB Ingress"
  default     = true
}

variable "enable_cluster_autoscaler" {
  description = "Enable required components for Cluster Autoscaler"
  default     = true
}

variable "enable_velero" {
  description = "Enable required components for Velero"
  default     = true
}

variable "workers" {
  description = "List of worker groups"
  type        = "list"
}

variable "worker_group_count" {
  description = "Count of worker groups. Set to 0 to disable worker creation"
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID for EKS Cluster"
}

variable "cluster_endpoint_private_access" {
  description = "Enable Amazon EKS private API server endpoint."
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Enable Amazon EKS public API server endpoint."
  default     = true
}