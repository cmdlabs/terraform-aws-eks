resource "aws_autoscaling_group" "workers" {
  count = "${var.worker_group_count}"
  name_prefix       = "${var.cluster_name}-workers-${count.index}"
  desired_capacity  = "${lookup(var.workers[count.index], "asg_desired_capacity", 1)}"
  min_size          = "${lookup(var.workers[count.index], "asg_min_size", 1)}"
  max_size          = "${lookup(var.workers[count.index], "asg_max_size", 10)}"
  vpc_zone_identifier = "${var.private_subnets}" 
  
  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy = "${lookup(var.workers[count.index], "on_demand_allocation_strategy" , "prioritized")}"
      on_demand_base_capacity = "${lookup(var.workers[count.index], "on_demand_base_capacity", 0)}"
      on_demand_percentage_above_base_capacity = "${lookup(var.workers[count.index], "on_demand_percentage_above_base_capacity", 0)}"
      spot_allocation_strategy = "${lookup(var.workers[count.index], "spot_allocation_strategy", "lowest-price")}"
      spot_instance_pools = "${lookup(var.workers[count.index], "spot_instance_pools", 10)}"
      spot_max_price = "${lookup(var.workers[count.index], "spot_max_price", "")}"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.workers.id}"
        version = "$Latest"
      }

      override {
        instance_type = "${lookup(var.workers[count.index], "instance_type_1", "m5.large")}"
      }

      override {
        instance_type = "${lookup(var.workers[count.index], "instance_type_2", "c5.large")}"
      }
      
      override {
        instance_type = "${lookup(var.workers[count.index], "instance_type_3", "r5.large")}"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["desired_capacity"]
  }

  tags = ["${concat(
    list(
      map("key", "name", "value", "eks-${var.cluster_name}-workergroup-${count.index}", "propagate_at_launch", "true"),
      map("key", "kubernetes.io/cluster/${var.cluster_name}", "value", "owned", "propagate_at_launch", "true"),
      map("key", "k8s.io/cluster-autoscaler/${lookup(var.workers[count.index], "autoscaling_enabled", false) == 1 ? "enabled" : "disabled"  }", "value", "true", "propagate_at_launch", "false")
    )
  )}"]
}

resource "aws_launch_template" "workers" {
  count = "${var.worker_group_count}"
  name_prefix = "${var.cluster_name}-workers-${count.index}"

  iam_instance_profile = {
    ame = "${element(aws_iam_instance_profile.workers_launch_template.*.name, count.index)}"
  }

  image_id = "${lookup(var.workers[count.index], "ami_id", data.aws_ami.eks_worker.id)}"
  instance_type = "${lookup(var.workers[count.index], "instance_type_1", "m5.large")}"
  user_data = "${base64encode(element(data.template_file.launch_template_userdata.*.rendered, count.index))}"

  block_device_mappings {
    device_name = "${data.aws_ami.eks_worker.root_device_name}"

    ebs {
      volume_size = "${lookup(var.workers[count.index], "root_volume_size", 100)}"
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = "${lookup(var.workers[count.index], "detailed_monitoring", false)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "workers_launch_template" {
  role        = "${lookup(var.worker_groups_launch_template[count.index], "iam_role_name", "${aws_iam_role.workers.name}" )}"
  count       = "${var.worker_group_count}"
}

resource "aws_security_group" "workers" {
  name = "eks-${var.cluster_name}-workers"
  description = "Security group for worker nodes of cluster ${var.cluster_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "Allow Worker to Worker"
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ingress {
    # Full port range to allow kubectl proxy
    description = "Allow Control Plane to Worker"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = "${aws_security_group.cluster.name}"
  }

  egress {
    description = "Allow Worker to Internet"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = "0.0.0.0/0"
  }

}
