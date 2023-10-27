locals {
  enabled              = module.this.enabled
  logs_kms_key_enabled = length(var.logs_kms_key_arn) == 0
  logs_kms_key_arn     = local.logs_kms_key_enabled ? module.kms_key.key_arn : data.aws_kms_key.default.0.arn
  alb_use_existing     = length(var.alb_arn) > 0
  alb_enabled          = !local.alb_use_existing && var.alb_enabled && length(var.subnet_ids) > 0
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "ecs_insights" {
  count = local.enabled ? 1 : 0

  name              = "/aws/ecs/containerinsights/${module.this.id}/performance"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = local.logs_kms_key_arn
  tags              = module.this.tags
}

resource "aws_ecs_cluster" "default" {
  count = local.enabled ? 1 : 0

  name = module.this.id

  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_container_insights_enabled ? "enabled" : "disabled"
  }

  tags = module.this.tags
}

data "aws_kms_key" "default" {
  count = local.logs_kms_key_enabled && local.enabled ? 0 : 1

  key_id = var.logs_kms_key_arn
}

module "kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  enabled = local.logs_kms_key_enabled && local.enabled

  description             = "KMS ECS Cloudwatch Log Groups"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  alias                   = join("", ["alias/", module.this.id])
  policy                  = data.aws_iam_policy_document.kms_key.json

  context = module.this.context
}

data "aws_iam_policy_document" "kms_key" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow use with Cloudwatch log groups"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}

data "aws_subnet" "lb" {
  count = local.alb_enabled ? 1 : 0
  id    = var.subnet_ids[0]
}

module "lb" {
  source  = "nventive/lb/aws"
  version = "1.2.0"
  enabled = local.alb_enabled && local.enabled

  subnet_ids                = var.subnet_ids
  ip_address_type           = var.alb_ip_address_type
  internal                  = var.alb_internal
  load_balancer_type        = "application"
  enable_http2              = true
  security_group_enabled    = true
  access_logs_enabled       = var.alb_access_logs_enabled
  access_logs_force_destroy = var.alb_access_logs_force_destroy
  access_logs_prefix        = var.alb_access_logs_prefix
  vpc_id                    = join("", data.aws_subnet.lb.*.vpc_id)

  context = module.this.context
}

data "aws_lb" "default" {
  count = local.alb_use_existing && local.enabled ? 1 : 0
  arn   = var.alb_arn
}

module "alb_dns_alias" {
  source  = "cloudposse/route53-alias/aws"
  version = "0.13.0"

  enabled   = length(var.alb_dns_aliases) != 0 && local.enabled
  providers = { aws = aws.route53 }

  aliases          = var.alb_dns_aliases
  parent_zone_id   = var.parent_zone_id
  parent_zone_name = var.parent_zone_name
  target_dns_name  = local.alb_use_existing ? data.aws_lb.default.0.dns_name : module.lb.dns_name
  target_zone_id   = local.alb_use_existing ? data.aws_lb.default.0.zone_id : module.lb.zone_id

  context = module.this.context
}
