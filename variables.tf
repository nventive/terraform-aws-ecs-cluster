variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 60
  description = "Number of days to retain Cloudwatch logs."
}

variable "ecs_cluster_container_insights_enabled" {
  type        = bool
  default     = true
  description = "Whether or not Container Insights should be enabled."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs for the Load Balancer. The Load Balancer will be created in the VPC associated with the subnet IDs."
}

variable "alb_enabled" {
  type        = bool
  default     = true
  description = <<-EOT
    Set to false to prevent the module from creating an Application Load Balancer.
    This setting defaults to false if `alb_arn` is specified.
  EOT
}

variable "alb_arn" {
  type        = string
  default     = ""
  description = "Set if you want to use an existing Application Load Balancer."
}

variable "alb_ip_address_type" {
  type        = string
  default     = null
  description = "Address type for ALB possible. Specify one of `ipv4`, `dualstack`. Only when `alb_enabled = true`."
}

variable "alb_access_logs_prefix" {
  type        = string
  default     = ""
  description = "Prefix for ALB access logs."
}

variable "alb_access_logs_enabled" {
  type        = bool
  default     = true
  description = "Whether or not ALB access logs should be enabled."
}

variable "alb_access_logs_force_destroy" {
  type        = bool
  default     = true
  description = "Whether or not force destroy option should be enabled for the ALB access logs Bucket."
}

variable "alb_dns_aliases" {
  type        = list(string)
  default     = []
  description = "List of custom domain name aliases for ALB."
}

variable "parent_zone_id" {
  type        = string
  default     = ""
  description = "ID of the hosted zone to contain this record (or specify `parent_zone_name`). Requires `dns_alias_enabled` set to true."
}

variable "parent_zone_name" {
  type        = string
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`). Requires `dns_alias_enabled` set to true."
}

variable "logs_kms_key_arn" {
  type        = string
  default     = ""
  description = "ARN of the KMS key for CloudWatch encryption, if blank, one will be created."
}
