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

variable "enable_kiam" {
  description = "Create IAM roles and Nodes to be used by KIAM. Enabling this requires KIAM to be active and deployed to your cluster for IAM roles to work."
  default     = true
}

variable "kiam_ami_id" {
  description = "KIAM instances AMI ID"
  default     = ""
}

variable "kiam_root_volume_size" {
  description = "KIAM instances root volume size"
  default     = 100
}

variable "kiam_autoscaling_enabled" {
  description = "Allows cluster-autoscaler to manage this ASG"
  default     = "true"
}

variable "kiam_asg_desired" {
  description = "ASG Desired Size"
  default     = "2"
}

variable "kiam_asg_min" {
  description = "ASG Minimum Size"
  default     = "2"
}

variable "kiam_asg_max" {
  description = "ASG Maximum Size"
  default     = "5"
}

variable "kiam_on_demand_allocation_strategy" {
  description = "Strategy to use when launching on-demand instances"
  default     = "prioritized"
}

variable "kiam_on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  default     = "0"
}

variable "kiam_on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and spot instances above the base on-demand capacity"
  default     = "0"
}

variable "kiam_spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools"
  default     = "lowest-price"
}

variable "kiam_spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity"
  default     = 10
}

variable "kiam_spot_max_price" {
  description = "Maximum price youre willing to pay for spot instances. Defaults to the on demand price if blank"
  default     = ""
}

variable "kiam_instance_type_1" {
  description = "First choice of instace type that will be used by the KIAM ASG"
  default     = "t3.small"
}

variable "kiam_instance_type_2" {
  description = "Second choice of instance type that will be used by the KIAM ASG"
  default     = "t2.small"
}

variable "kiam_detailed_monitoring" {
  description = "Enabled detailed monitoring of KIAM instances"
  default     = false
}

variable "kiam_kubelet_extra_args" {
  description = "Additional arguments to pass to the kubelet"
  default     = "--node-labels=spot=true,node-role.kubernetes.io/kiam=true --register-with-taints=node-role.kubernetes.io/kiam=true:NoSchedule"
}

variable "kiam_pre_userdata" {
  description = "Userdata to prepend to the standard userdata"
  default     = ""
}

variable "kiam_additonal_userdata" {
  description = "Userdata to append to the standard userdata"
  default     = ""
}

variable "kiam_vpc_subnets" {
  description = "A comma seperated string of subnets for the ASG to place kiam instances in"
  default     = ""
}

variable "kiam_asg_suspended_processes" {
  description = "A comma seperated string of ASG suspended processes"
  default     = ""
}

variable "kiam_asg_enabled_metrics" {
  description = "A comma seperated string of ASG enabled metrics"
  default     = ""
}
