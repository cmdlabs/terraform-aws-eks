# terraform-aws-eks
## Summary
This module implementes an EKS cluster and associated worker groups. It utilised the new mixed instance type autoscaling groups allowing you to switch between spot and on demand as required. 

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autotag\_subnets | Automatically add Kubernetes tags to subnets. Requires aws-cli to be available. | string | `"false"` | no |
| cluster\_name | Name of the EKS Cluster | string | n/a | yes |
| cluster\_version | EKS Cluster Version | string | n/a | yes |
| enable\_alb\_ingress | Enable required components for ALB Ingress | string | `"true"` | no |
| enable\_cert\_manager | Enable required components for Cert-Manager | string | `"true"` | no |
| enable\_cluster\_autoscaler | Enable required components for Cluster Autoscaler. | string | `"true"` | no |
| enable\_ecr | Enable required components for Amazon ECR Read Only | string | `"true"` | no |
| enable\_external\_dns | Enable required components for External-DNS | string | `"true"` | no |
| enable\_ssm | Enable required components for SSM | string | `"true"` | no |
| enable\_velero | Enable required components for Velero | string | `"true"` | no |
| private\_subnets | Private tier subnet list | list | n/a | yes |
| public\_subnets | Public tier subnet list | list | n/a | yes |
| vpc\_id | VPC ID for EKS Cluster | string | n/a | yes |
| worker\_group\_count | Count of worker groups. Set to 0 to disable worker creation | string | `"1"` | no |
| workers | List of worker groups options objects | list | n/a | yes |

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
| suspended\_processes | A list of processes to suspend for the AutoScaling Group | list | `[]` | no |
| on\_demand\_allocation\_strategy | Strategy to use when launching on-demand instances | string | `"prioritized"` | no |
| on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | string | `"0"` | no |
| on\_demand\_percentage\_above\_base_capacity | Percentage split between on-demand and spot instances above the base on-demand capacity | string | `"0"` | no |
| spot\_allocation\_strategy | How to allocate capacity across the Spot pools | string | `"lowest-price"` | no |
| spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity | string | `"10"` | no |
| spot\_max\_price | Maximum price youre willing to pay for spot instances. Defaults to the on demand price if blank | string | `""` | no |
| instance\_type\_1 | First instance type used by the ASG | string | `"m5.large"` | no |
| instance\_type\_2 | Second instance type used by the ASG | string | `"c5.large"` | no |
| instance\_type\_3 | Third instance type used by the ASG | string | `"r5.large"` | no |
| detailed\_monitoring | Enable EC2 detailed monitoring | string | `"false"` | no |
| iam\_role\_name | Override the role that this module generates | string | `""` | no |
| kubelet\_extra\_args | Additional arguments to pass to the kubelet | string| `""` | no |
| pre\_userdata | Userdata to prepend to the standard userdata | string | `""` | no |
| additional\_userdata | Userdata to append to the standard userdata | string | `""` | no |

## Outputs
| Name | Description |
|------|-------------|
| cluster\_certificate\_authority | Cluster Certificate Authority Certificate |
| cluster\_endpoint | Cluster Kubernetes API endpoint |