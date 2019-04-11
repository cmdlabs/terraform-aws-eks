resource "" "name" {
  
}


resource "aws_autoscaling_group" "workers" {
  count               = "${var.worker_group_count}"
  name_prefix         = "eks-${var.cluster_name}-workers-${count.index}"
  desired_capacity    = "${lookup(var.workers[count.index], "asg_desired_capacity", 1)}"
  min_size            = "${lookup(var.workers[count.index], "asg_min_size", 1)}"
  max_size            = "${lookup(var.workers[count.index], "asg_max_size", 10)}"
  vpc_zone_identifier = ["${split(",", coalesce(lookup(var.workers[count.index], "vpc_subnets", ""), join(",", var.private_subnets)))}"]

  suspended_processes = ["${compact(split(",", lookup(var.workers[count.index], "suspended_processes", "")))}"]
  enabled_metrics     = ["${compact(split(",", lookup(var.workers[count.index], "enabled_metrics", "")))}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = "${lookup(var.workers[count.index], "on_demand_allocation_strategy" , "prioritized")}"
      on_demand_base_capacity                  = "${lookup(var.workers[count.index], "on_demand_base_capacity", 0)}"
      on_demand_percentage_above_base_capacity = "${lookup(var.workers[count.index], "on_demand_percentage_above_base_capacity", 0)}"
      spot_allocation_strategy                 = "${lookup(var.workers[count.index], "spot_allocation_strategy", "lowest-price")}"
      spot_instance_pools                      = "${lookup(var.workers[count.index], "spot_instance_pools", 10)}"
      spot_max_price                           = "${lookup(var.workers[count.index], "spot_max_price", "")}"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = "${element(aws_launch_template.workers.*.id, count.index)}"
        version            = "$Latest"
      }

      override {
        instance_type = "${lookup(var.workers[count.index], "instance_type_1", "m5.large")}"
      }

      override {
        instance_type = "${lookup(var.workers[count.index], "instance_type_2", "m4.large")}"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }

  tags = ["${concat(
    list(
      map("key", "Name", "value", "eks-${var.cluster_name}-workergroup-${count.index}", "propagate_at_launch", "true"),
      map("key", "kubernetes.io/cluster/${var.cluster_name}", "value", "owned", "propagate_at_launch", "true"),
      map("key", "k8s.io/cluster-autoscaler/${lookup(var.workers[count.index], "autoscaling_enabled", true) == 1 ? "enabled" : "disabled"  }", "value", "true", "propagate_at_launch", "false")
    )
  )}"]
}

resource "aws_launch_template" "workers" {
  count       = "${var.worker_group_count}"
  name_prefix = "eks-${var.cluster_name}-workers-${count.index}"

  image_id               = "${lookup(var.workers[count.index], "ami_id", data.aws_ami.eks_worker.id)}"
  instance_type          = "${lookup(var.workers[count.index], "instance_type_1", "m5.large")}"
  user_data              = "${base64encode(element(data.template_file.launch_template_userdata.*.rendered, count.index))}"
  vpc_security_group_ids = ["${aws_security_group.workers.id}", "${var.enable_alb_ingress ? "${join("", aws_security_group.alb_workers.*.id)}" : ""}"]

  iam_instance_profile = {
    name = "${element(aws_iam_instance_profile.workers_launch_template.*.name, count.index)}"
  }

  block_device_mappings {
    device_name = "${data.aws_ami.eks_worker.root_device_name}"

    ebs {
      volume_size           = "${lookup(var.workers[count.index], "root_volume_size", 100)}"
      volume_type           = "gp2"
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
  role  = "${lookup(var.workers[count.index], "iam_role_name", "${aws_iam_role.workers.name}" )}"
  count = "${var.worker_group_count}"
}

resource "aws_security_group" "workers" {
  name        = "eks-${var.cluster_name}-workers"
  description = "Security group for worker nodes of cluster ${var.cluster_name}"
  vpc_id      = "${var.vpc_id}"

  tags = "${map("kubernetes.io/cluster/${var.cluster_name}", "owned")}"
}

resource "aws_security_group_rule" "worker_to_worker" {
  security_group_id = "${aws_security_group.workers.id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "controlplane_to_worker" {
  # Full port range to allow kubectl proxy
  security_group_id        = "${aws_security_group.workers.id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "worker_to_internet" {
  security_group_id = "${aws_security_group.workers.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
