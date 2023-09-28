output "kms_key_arn" {
  value       = local.logs_kms_key_arn
  description = "KMS Key ARN for log encryption"
}

output "alb_arn" {
  value       = local.alb_use_existing ? join("", data.aws_lb.default.*.arn) : module.lb.arn
  description = "ARN of the Application Load Balancer"
}

output "alb_security_group_id" {
  value       = module.lb.security_group_id
  description = "ID of the ALB security group"
}

output "cluster_name" {
  value       = join("", aws_ecs_cluster.default.*.name)
  description = "The name of the ECS cluster"
}

output "cluster_arn" {
  value       = join("", aws_ecs_cluster.default.*.arn)
  description = "ARN of the ECS cluster"
}

output "alb_arn_suffix" {
  value       = local.alb_use_existing ? join("", data.aws_lb.default.*.arn_suffix) : module.lb.arn_suffix
  description = "ARN suffix of the ALB"
}
