locals {
  is_serverless  = var.engine_mode == "serverless"
  create_cluster = var.create_cluster
}

################################################################################
# DB subnet group
################################################################################

resource "aws_db_subnet_group" "subnet_group" {
  count = var.create_db_subnet_group ? 1 : 0

  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

################################################################################
# Cluster
################################################################################

resource "aws_rds_cluster" "cluster" {
  # create_cluster                      = local.create_cluster
  count                               = var.create_cluster ? 1 : 0
  cluster_identifier                  = var.cluster_identifier
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  master_username                     = var.master_username
  master_password                     = var.master_password
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  availability_zones                  = var.availability_zones
  backtrack_window                    = var.backtrack_window
  backup_retention_period             = var.backup_retention_period
  cluster_identifier_prefix           = var.cluster_identifier_prefix
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name    = var.db_instance_parameter_group_name
  db_subnet_group_name                = aws_db_subnet_group.subnet_group[0].name
  deletion_protection                 = var.deletion_protection
  enable_http_endpoint                = var.enable_http_endpoint
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  db_cluster_instance_class           = var.db_cluster_instance_class
  global_cluster_identifier           = var.global_cluster_identifier
  enable_global_write_forwarding      = var.enable_global_write_forwarding
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  port                                = var.port
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  replication_source_identifier       = var.replication_source_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  snapshot_identifier                 = var.snapshot_identifier
  source_region                       = var.source_region
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  iops                                = var.iops
  storage_encrypted                   = var.storage_encrypted
  tags                                = var.tags
  vpc_security_group_ids              = var.vpc_security_group_ids

  dynamic "restore_to_point_in_time" {
    for_each = length(var.restore_to_point_in_time) > 0 ? [var.restore_to_point_in_time] : []

    content {
      restore_to_time            = try(restore_to_point_in_time.value.restore_to_time, null)
      restore_type               = try(restore_to_point_in_time.value.restore_type, null)
      source_cluster_identifier  = restore_to_point_in_time.value.source_cluster_identifier
      use_latest_restorable_time = try(restore_to_point_in_time.value.use_latest_restorable_time, null)
    }
  }

  dynamic "scaling_configuration" {
    for_each = length(var.scaling_configuration) > 0 && local.is_serverless ? [var.scaling_configuration] : []

    content {
      auto_pause               = try(scaling_configuration.value.auto_pause, null)
      max_capacity             = try(scaling_configuration.value.max_capacity, null)
      min_capacity             = try(scaling_configuration.value.min_capacity, null)
      seconds_until_auto_pause = try(scaling_configuration.value.seconds_until_auto_pause, null)
      timeout_action           = try(scaling_configuration.value.timeout_action, null)
    }
  }

  dynamic "serverlessv2_scaling_configuration" {
    for_each = length(var.serverlessv2_scaling_configuration) > 0 && var.engine_mode == "provisioned" ? [var.serverlessv2_scaling_configuration] : []

    content {
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
    }


    # lifecycle {
    #   ignore_changes = [
    #     # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#replication_source_identifier
    #     # Since this is used either in read-replica clusters or global clusters, this should be acceptable to specify
    #     replication_source_identifier,
    #     # See docs here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster#new-global-cluster-from-existing-db-cluster
    #     global_cluster_identifier,
    #   ]
    # }
  }
}

################################################################################
# Cluster instance
################################################################################

resource "aws_rds_cluster_instance" "cluster_instance" {
  for_each = { for k, v in var.instances : k => v if local.create_cluster && !local.is_serverless }

  apply_immediately          = try(each.value.apply_immediately, var.apply_immediately)
  auto_minor_version_upgrade = try(each.value.auto_minor_version_upgrade, var.auto_minor_version_upgrade)
  availability_zone          = try(each.value.availability_zone, null)
  ca_cert_identifier         = var.ca_cert_identifier
  cluster_identifier         = aws_rds_cluster.cluster[0].id
  copy_tags_to_snapshot      = try(each.value.copy_tags_to_snapshot, var.copy_tags_to_snapshot)
  db_parameter_group_name    = var.db_parameter_group_name
  db_subnet_group_name       = aws_db_subnet_group.subnet_group[0].name
  engine                     = var.engine
  engine_version             = var.engine_version
  identifier                 = var.instance_identifier
  # identifier_prefix                     = var.instances_use_identifier_prefix ? try(each.value.identifier_prefix, "${var.name}-${each.key}-") : null
  instance_class                        = try(each.value.instance_class, var.instance_class)
  monitoring_interval                   = try(each.value.monitoring_interval, var.monitoring_interval)
  monitoring_role_arn                   = var.create_monitoring_role ? try(aws_iam_role.rds_enhanced_monitoring[0].arn, null) : var.monitoring_role_arn
  performance_insights_enabled          = try(each.value.performance_insights_enabled, var.performance_insights_enabled)
  performance_insights_kms_key_id       = try(each.value.performance_insights_kms_key_id, var.performance_insights_kms_key_id)
  performance_insights_retention_period = try(each.value.performance_insights_retention_period, var.performance_insights_retention_period)
  # preferred_backup_window - is set at the cluster level and will error if provided here
  preferred_maintenance_window = try(each.value.preferred_maintenance_window, var.preferred_maintenance_window)
  promotion_tier               = try(each.value.promotion_tier, null)
  publicly_accessible          = try(each.value.publicly_accessible, var.publicly_accessible)
  tags                         = merge(var.tags, try(each.value.tags, {}))

  timeouts {
    create = try(var.instance_timeouts.create, null)
    update = try(var.instance_timeouts.update, null)
    delete = try(var.instance_timeouts.delete, null)
  }
}

resource "aws_rds_cluster_endpoint" "eligible" {
  for_each = { for k, v in var.endpoints : k => v if local.create_cluster && !local.is_serverless }

  cluster_endpoint_identifier = each.value.identifier
  cluster_identifier          = aws_rds_cluster.cluster[0].id
  custom_endpoint_type        = each.value.type
  excluded_members            = try(each.value.excluded_members, null)
  static_members              = try(each.value.static_members, null)
  tags                        = merge(var.tags, try(each.value.tags, {}))

  depends_on = [
    aws_rds_cluster_instance.gworks_cluster_instance
  ]
}

resource "aws_rds_cluster_role_association" "cluster_association" {
  for_each              = { for k, v in var.iam_roles : k => v if local.create_cluster }
  db_cluster_identifier = aws_rds_cluster.cluster[0].id
  feature_name          = "S3_INTEGRATION"
  role_arn              = aws_iam_role.rds_enhanced_monitoring[0].arn
}

################################################################################
# Enhanced Monitoring
################################################################################

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = local.create_cluster && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : var.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${var.iam_role_name}-" : null
  description = var.iam_role_description
  path        = var.iam_role_path

  assume_role_policy    = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  managed_policy_arns   = var.iam_role_managed_policy_arns
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration

  tags = var.tags
}

data "aws_partition" "current" {}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = local.create_cluster && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

################################################################################
# Autoscaling
################################################################################

resource "aws_appautoscaling_target" "autoscaling_gw" {
  count              = local.create_cluster && var.autoscaling_enabled && !local.is_serverless ? 1 : 0
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "cluster:${aws_rds_cluster.gworks_cluster[0].cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_ploicy_gw" {
  count              = local.create_cluster && var.autoscaling_enabled && !local.is_serverless ? 1 : 0
  name               = var.autoscaling_policy_name
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.gworks_cluster[0].cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.autoscaling_target_cpu : var.autoscaling_target_connections
  }

  depends_on = [
    aws_appautoscaling_target.autoscaling_gw
  ]
}
