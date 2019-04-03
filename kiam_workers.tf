resource "aws_autoscaling_group" "kiam_workers" {
  count            = "${var.enable_kiam ? 1 : 0}"
  name_prefix      = "eks-${var.cluster_name}-kiam-workers"
  desired_capacity = "${var.kiam_asg_desired}"
  min_size         = "${var.kiam_asg_min}"
  max_size         = "${var.kiam_asg_max}"

  #Make this configurable
  vpc_zone_identifier = ["${var.private_subnets}"]

  #suspended_processes = ["${compact(split(",", lookup(var.workers[count.index], "suspended_processes", "")))}"]
  #enabled_metrics     = ["${compact(split(",", lookup(var.workers[count.index], "enabled_metrics", "")))}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = "${var.kiam_on_demand_allocation_strategy}"
      on_demand_base_capacity                  = "${var.kiam_on_demand_base_capacity}"
      on_demand_percentage_above_base_capacity = "${var.kiam_on_demand_percentage_above_base_capacity}"
      spot_allocation_strategy                 = "${var.kiam_spot_allocation_strategy}"
      spot_instance_pools                      = "${var.kiam_spot_instance_pools}"
      spot_max_price                           = "${var.kiam_spot_max_price}"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.kiam_workers.id}"
        version            = "$Latest"
      }

      override {
        instance_type = "${var.kiam_instance_type_1}"
      }

      override {
        instance_type = "${var.kiam_instance_type_2}"
      }
    }
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }
  tags = ["${concat(
    list(
      map("key", "Name", "value", "eks-${var.cluster_name}-workergroup-kiam", "propagate_at_launch", "true"),
      map("key", "kubernetes.io/cluster/${var.cluster_name}", "value", "owned", "propagate_at_launch", "true"),
      map("key", "k8s.io/cluster-autoscaler/${var.kiam_autoscaling_enabled == 1 ? "enabled" : "disabled"  }", "value", "true", "propagate_at_launch", "false")
    )
  )}"]
}

resource "aws_launch_template" "kiam_workers" {
  count       = "${var.enable_kiam ? 1 : 0}"
  name_prefix = "eks-${var.cluster_name}-kiam-workers"

  image_id               = "${coalesce(var.kiam_ami_id, data.aws_ami.eks_worker.id)}"
  instance_type          = "${var.kiam_instance_type_1}"
  user_data              = "${base64encode(data.template_file.kiam_launch_template_userdata.rendered)}"
  vpc_security_group_ids = ["${aws_security_group.workers.id}"]

  iam_instance_profile = {
    name = "${aws_iam_instance_profile.kiam_workers_launch_template.name}"
  }

  block_device_mappings {
    device_name = "${data.aws_ami.eks_worker.root_device_name}"

    ebs {
      volume_size           = "${var.kiam_root_volume_size}"
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = "${var.kiam_detailed_monitoring}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "kiam_workers_launch_template" {
  role  = "${aws_iam_role.workers_kiam.name}"
  count = "${var.enable_kiam ? 1 : 0}"
}
