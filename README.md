# terraform-aws-eks
## Summary
This module implementes an EKS cluster and associated worker groups. It utilised the new mixed instance type autoscaling groups allowing you to switch between spot and on demand as required. 

To improve the security of your clusters this module defaults to expecting KIAM to be deployed to manage IAM Role credentials for Pods. If you are deploying a demo cluster where security is not as important you can disable this with the `enable_kiam=false`. Then the the IAM Permissions managed by this module will be assigned directly to the worker nodes.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autotag\_subnets | Automatically add Kubernetes tags to subnets. Requires aws-cli to be available. | string | `"false"` | no |
| cluster\_endpoint\_private\_access | Enable Amazon EKS private API server endpoint. | string | `"false"` | no |
| cluster\_endpoint\_public\_access | Enable Amazon EKS public API server endpoint. | string | `"true"` | no |
| cluster\_name | Name of the EKS Cluster | string | n/a | yes |
| cluster\_version | EKS Cluster Version | string | n/a | yes |
| enable\_alb\_ingress | Enable required components for ALB Ingress | string | `"true"` | no |
| enable\_cert\_manager | Enable required components for Cert-Manager | string | `"true"` | no |
| enable\_cluster\_autoscaler | Enable required components for Cluster Autoscaler | string | `"true"` | no |
| enabled\_cluster\_log\_types | A list of the desired control plane logging to enable | list | `["api", "audit", "authenticator", "controllerManager", "scheduler"] ` | no | 
| enable\_ecr | Enable required components for Amazon ECR Read Only | string | `"true"` | no |
| enable\_external\_dns | Enable required components for External-DNS | string | `"true"` | no |
| enable\_kiam | Create IAM roles and Nodes to be used by KIAM. Enabling this requires KIAM to be active and deployed to your cluster for IAM roles to work. | string | `"true"` | no |
| enable\_ssm | Enable required components for SSM | string | `"true"` | no |
| enable\_velero | Enable required components for Velero | string | `"true"` | no |
| kiam\_additonal\_userdata | Userdata to append to the standard userdata | string | `""` | no |
| kiam\_ami\_id | KIAM instances AMI ID | string | `""` | no |
| kiam\_asg\_desired | ASG Desired Size | string | `"2"` | no |
| kiam\_asg\_enabled\_metrics | A comma seperated string of ASG enabled metrics | string | `""` | no |
| kiam\_asg\_max | ASG Maximum Size | string | `"5"` | no |
| kiam\_asg\_min | ASG Minimum Size | string | `"2"` | no |
| kiam\_asg\_suspended\_processes | A comma seperated string of ASG suspended processes | string | `""` | no |
| kiam\_autoscaling\_enabled | Allows cluster-autoscaler to manage this ASG | string | `"true"` | no |
| kiam\_detailed\_monitoring | Enabled detailed monitoring of KIAM instances | string | `"false"` | no |
| kiam\_instance\_type\_1 | First choice of instace type that will be used by the KIAM ASG | string | `"t3.small"` | no |
| kiam\_instance\_type\_2 | Second choice of instance type that will be used by the KIAM ASG | string | `"t2.small"` | no |
| kiam\_kubelet\_extra\_args | Additional arguments to pass to the kubelet | string | [KIAM](#kiam) | no |
| kiam\_on\_demand\_allocation\_strategy | Strategy to use when launching on-demand instances | string | `"prioritized"` | no |
| kiam\_on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | string | `"0"` | no |
| kiam\_on\_demand\_percentage\_above\_base\_capacity | Percentage split between on-demand and spot instances above the base on-demand capacity | string | `"0"` | no |
| kiam\_pre\_userdata | Userdata to prepend to the standard userdata | string | `""` | no |
| kiam\_root\_volume\_size | KIAM instances root volume size | string | `"100"` | no |
| kiam\_spot\_allocation\_strategy | How to allocate capacity across the Spot pools | string | `"lowest-price"` | no |
| kiam\_spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity | string | `"10"` | no |
| kiam\_spot\_max\_price | Maximum price youre willing to pay for spot instances. Defaults to the on demand price if blank | string | `""` | no |
| kiam\_vpc\_subnets | A comma seperated string of subnets for the ASG to place kiam instances in | string | `""` | no |
| private\_subnets | Private tier subnet list | list | n/a | yes |
| public\_subnets | Public tier subnet list | list | n/a | yes |
| vpc\_id | VPC ID for EKS Cluster | string | n/a | yes |
| worker\_group\_count | Count of worker groups. Set to 0 to disable worker creation | string | `"1"` | no |
| workers | List of worker groups | list | n/a | yes |


## Worker Group Options
It is possible to customise individual parameters on the the workers list. 

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ami\_id | AMI ID | string | Most Recent EKS Optimized AMI | no |
| root\_volume\_size | Root EBS volume size | string | `"100"` | no |
| autoscaling\_enabled | Allows cluster-autoscaler to manage this ASG | string | `"true"` | no |
| desired\_capacity | ASG desired capacity. Ignored after creation | string | `"1"` | no |
| min\_size | ASG minimum size | string | `"1"` | no |
| max\_size | ASG maximum size | string | `"10"` | no |
| suspended\_processes | A comma seperated string of processes to suspend for the worker group | string | `""` | no |
| enabled\_metrics | A comma seperated string of ASG metrics to enable | string | `""` | no |
| on\_demand\_allocation\_strategy | Strategy to use when launching on-demand instances | string | `"prioritized"` | no |
| on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | string | `"0"` | no |
| on\_demand\_percentage\_above\_base_capacity | Percentage split between on-demand and spot instances above the base on-demand capacity | string | `"0"` | no |
| spot\_allocation\_strategy | How to allocate capacity across the Spot pools | string | `"lowest-price"` | no |
| spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity | string | `"10"` | no |
| spot\_max\_price | Maximum price youre willing to pay for spot instances. Defaults to the on demand price if blank | string | `""` | no |
| instance\_type\_1 | First instance type used by the ASG | string | `"m5.large"` | no |
| instance\_type\_2 | Second instance type used by the ASG | string | `"m4.large"` | no |
| detailed\_monitoring | Enable EC2 detailed monitoring | string | `"false"` | no |
| iam\_role\_name | Override the role that this module generates | string | `""` | no |
| kubelet\_extra\_args | Additional arguments to pass to the kubelet | string| `""` | no |
| pre\_userdata | Userdata to prepend to the standard userdata | string | `""` | no |
| additional\_userdata | Userdata to append to the standard userdata | string | `""` | no |
| vpc\_subnets | A comma seperated string of subnets for the ASG to place instances in | string | `var.private_subnets` | no

## Outputs
| Name | Description |
|------|-------------|
| cluster\_certificate\_authority | Cluster Certificate Authority Certificate |
| cluster\_endpoint | Cluster Kubernetes API endpoint |

## KIAM
KIAM is deployed on a dedicated set of nodes to ensure that other pods cannot elevate their permissions in the event they find a way to bypass KIAM-Agent.

The kubelet arguments default to following to prevent other workloads from scheduling onto the KIAM nodes.

`"--node-labels=spot=true,node-role.kubernetes.io/kiam=true --register-with-taints=node-role.kubernetes.io/kiam=true:NoSchedule"`