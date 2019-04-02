module "eks-cluster" {
  source = "../../"

  cluster_name    = "cmdlab"
  cluster_version = "1.12"

  vpc_id          = "vpc-4df92b2a"
  private_subnets = ["subnet-457ee522", "subnet-c0b82c89", "subnet-2cc22074"]
  public_subnets  = ["subnet-d47de6b3", "subnet-f5bc28bc", "subnet-68c32130"]

  enable_kiam = true

  worker_group_count = 2

  workers = [
    {
      autoscaling_enabled  = true
      asg_desired_capacity = 1
      asg_min_size         = 0
      asg_max_size         = 5

      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_max_price                           = ""

      instance_type_1 = "m5.large"
      instance_type_2 = "m4.large"

      root_volume_size = 100

      kubelet_extra_args = "--node-labels=spot=true"
    },
    {
      autoscaling_enabled  = false
      asg_desired_capacity = 2
      asg_min_size         = 2
      asg_max_size         = 2

      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_max_price                           = ""

      instance_type_1 = "t3.small"
      instance_type_2 = "t2.small"

      root_volume_size = 100

      iam_role_name = "eks-cmdlab-workers-kiam"

      kubelet_extra_args = "--node-labels=spot=true,node-role.kubernetes.io/kiam=true --register-with-taints=node-role.kubernetes.io/kiam=true:NoSchedule"
    },
  ]
}
