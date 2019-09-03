# terraform-aws-eks
## Summary
This module implementes an EKS cluster and associated worker groups. It utilised the new mixed instance type autoscaling groups allowing you to switch between spot and on demand as required.

To improve the security of your clusters this module defaults to expecting KIAM to be deployed to manage IAM Role credentials for Pods. If you are deploying a demo cluster where security is not as important you can disable this with the `enable_kiam=false`. Then the the IAM Permissions managed by this module will be assigned directly to the worker nodes.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autotag\_subnets | Automatically add Kubernetes tags to subnets. Requires aws-cli to be available. | string | `"false"` | no |
| autotag\_profile | Defines an optional AWS profile to use with aws-cli when auto-tagging subnets | string | `"false"` | no |
| cluster\_access\_additional\_sg | Security groups allowed access to the API server | list | `[]` | no |
| cluster\_access\_additional\_ip | CIDRs allowed access to the API server | list | `[]` | no |
| cluster\_endpoint\_private\_access | Enable Amazon EKS private API server endpoint. | string | `"false"` | no |
| cluster\_endpoint\_public\_access | Enable Amazon EKS public API server endpoint. | string | `"true"` | no |
| cluster\_name | Name of the EKS Cluster | string | n/a | yes |
| cluster\_version | EKS Cluster Version | string | n/a | yes |
| enable\_alb\_ingress | Enable required components for ALB Ingress | string | `"true"` | no |
| enable\_cert\_manager | Enable required components for Cert-Manager | string | `"true"` | no |
| enable\_container\_insights | Enable required components for Cloudwatch Container Insights | string | `"true"` | no |
| enable\_cluster\_autoscaler | Enable required components for Cluster Autoscaler | string | `"true"` | no |
| enabled\_cluster\_log\_types | A list of the desired control plane logging to enable | list | `["api", "audit", "authenticator", "controllerManager", "scheduler"] ` | no |
| enable\_ecr | Enable required components for Amazon ECR Read Only | string | `"true"` | no |
| enable\_external\_dns | Enable required components for External-DNS | string | `"true"` | no |
| enable\_kiam | Create IAM roles to be used by KIAM. Enabling this requires KIAM to be active and deployed to your cluster for IAM roles to work. | string | `"true"` | no |
| enable\_ssm | Enable required components for SSM | string | `"true"` | no |
| enable\_velero | Enable required components for Velero | string | `"true"` | no |
| private\_subnets | Private tier subnet list | list | n/a | yes |
| public\_subnets | Public tier subnet list | list | n/a | yes |
| vpc\_id | VPC ID for EKS Cluster | string | n/a | yes |
| worker\_group\_count | Count of worker groups. Set to 0 to disable worker creation | string | `"1"` | no |
| workers | List of worker groups | list | n/a | yes |

## Worker Group Options
It is possible to customise individual parameters on the the workers list.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| additional\_userdata | Userdata to append to the standard userdata | string | `""` | no |
| ami\_id | AMI ID | string | Most Recent EKS Optimized AMI | no |
| autoscaling\_enabled | Allows cluster-autoscaler to manage this ASG | string | `"true"` | no |
| desired\_capacity | ASG desired capacity. Ignored after creation | string | `"1"` | no |
| detailed\_monitoring | Enable EC2 detailed monitoring | string | `"false"` | no |
| enabled\_metrics | A list of ASG metrics to enable | list(string) | `null` | no |
| iam\_role\_name | Override the role that this module generates | string | `""` | no |
| instance\_types | Instance types used in the ASG | list(string) | `["m5.large", "m4.large"]` | no |
| kubelet\_extra\_args | Additional arguments to pass to the kubelet | string| `""` | no |
| max\_size | ASG maximum size | string | `"10"` | no |
| min\_size | ASG minimum size | string | `"1"` | no |
| on\_demand\_allocation\_strategy | Strategy to use when launching on-demand instances | string | `"prioritized"` | no |
| on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | string | `"0"` | no |
| on\_demand\_percentage\_above\_base_capacity | Percentage split between on-demand and spot instances above the base on-demand capacity | string | `"0"` | no |
| pre\_userdata | Userdata to prepend to the standard userdata | string | `""` | no |
| root\_volume\_size | Root EBS volume size | string | `"100"` | no |
| spot\_allocation\_strategy | How to allocate capacity across the Spot pools | string | `"lowest-price"` | no |
| spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity | string | `"10"` | no |
| spot\_max\_price | Maximum price youre willing to pay for spot instances. Defaults to the on demand price if blank | string | `""` | no |
| suspended\_processes | A list of processes to suspend for the worker group | list(string) | `null` | no |
| vpc\_subnets | A list of subnets for the ASG to place instances in | list(string) | `var.private_subnets` | no

## Outputs
| Name | Description |
|------|-------------|
| cluster\_certificate\_authority | Cluster Certificate Authority Certificate |
| cluster\_endpoint | Cluster Kubernetes API endpoint |
