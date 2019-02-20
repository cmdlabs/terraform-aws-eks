variable "cluster_name" {
  description = "Name of the EKS Cluster"
}

variable "cluster_version" {
  description = "EKS Cluster Version"
}

variable "private_subnets" {
  description = "Private tier subnet list"
  type = "list"
}

variable "public_subnets" {
  description = "Public tier subnet list"
  type = "list"
}

variable "autotag_subnets" {
  description = "Automatically add Kubernetes tags to subnets. Requires aws-cli to be available."
  default = false
}

