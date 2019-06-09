module "eks-cluster" {
  source = "github.com/cmdlabs/terraform-aws-eks?ref=0.6.0"

  cluster_name    = "cmdlab"
  cluster_version = "1.12"

  vpc_id          = "vpc-4df92b2a"
  private_subnets = ["subnet-457ee522", "subnet-c0b82c89", "subnet-2cc22074"]
  public_subnets  = ["subnet-d47de6b3", "subnet-f5bc28bc", "subnet-68c32130"]

  enable_kiam = true

  worker_group_count = 1

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

      instance_types = ["m5.large", "m4.large"]

      root_volume_size = 100

      kubelet_extra_args = "--node-labels=spot=true"
    },
  ]
}
