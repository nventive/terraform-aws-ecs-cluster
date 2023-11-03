<!-- BEGIN_TF_DOCS -->
![nventive](https://nventive-public-assets.s3.amazonaws.com/nventive_logo_github.svg?v=2)

# terraform-aws-ecs-cluster

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE) [![Latest Release](https://img.shields.io/github/release/nventive/terraform-aws-ecs-cluster.svg?style=flat-square)](https://github.com/nventive/terraform-aws-ecs-cluster/releases/latest)

Terraform module to provision an ECS Cluster.

---

## Providers

This modules uses two instances of the AWS provider. One for Route 53 resources and one for the rest. The reason why is
that Route 53 is often in a different account (ie. in the prod account when creating resources for dev).

You must provide both providers, whether you use Route 53 or not. In any case, you can specify the same provider for
both if need be.

## Examples

**IMPORTANT:** We do not pin modules to versions in our examples because of the difficulty of keeping the versions in
the documentation in sync with the latest released versions. We highly recommend that in your code you pin the version
to the exact version you are using so that your infrastructure remains stable, and update versions in a systematic way
so that they do not catch you by surprise.

```hcl
module "ecs_cluster" {
  source = "nventive/ecs-cluster/aws"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  namespace = "eg"
  stage     = "test"
  name      = "app"

  providers = {
    aws         = aws
    aws.route53 = aws.route53
  }
  subnet_ids       = ["subnet-xxxxxxxxxxxxxxxx1", "subnet-xxxxxxxxxxxxxxxx2"]
  parent_zone_name = "example.com"
  alb_enabled      = true
  alb_dns_aliases  = ["test.example.com", "demo.example.com"]
}
```

Should you want to use the same AWS provider for both Route 53 and the default one.

```hcl
module "ecs_cluster" {
  source = "nventive/ecs-cluster/aws"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  providers = {
    aws         = aws
    aws.route53 = aws
  }

  # ...
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_dns_alias"></a> [alb\_dns\_alias](#module\_alb\_dns\_alias) | cloudposse/route53-alias/aws | 0.13.0 |
| <a name="module_kms_key"></a> [kms\_key](#module\_kms\_key) | cloudposse/kms-key/aws | 0.12.1 |
| <a name="module_lb"></a> [lb](#module\_lb) | nventive/lb/aws | 1.0.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_lb.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alb_access_logs_enabled"></a> [alb\_access\_logs\_enabled](#input\_alb\_access\_logs\_enabled) | Whether or not ALB access logs should be enabled. | `bool` | `true` | no |
| <a name="input_alb_access_logs_force_destroy"></a> [alb\_access\_logs\_force\_destroy](#input\_alb\_access\_logs\_force\_destroy) | Whether or not force destroy option should be enabled for the ALB access logs Bucket. | `bool` | `true` | no |
| <a name="input_alb_access_logs_prefix"></a> [alb\_access\_logs\_prefix](#input\_alb\_access\_logs\_prefix) | Prefix for ALB access logs. | `string` | `""` | no |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | Set if you want to use an existing Application Load Balancer. | `string` | `""` | no |
| <a name="input_alb_dns_aliases"></a> [alb\_dns\_aliases](#input\_alb\_dns\_aliases) | List of custom domain name aliases for ALB. | `list(string)` | `[]` | no |
| <a name="input_alb_enabled"></a> [alb\_enabled](#input\_alb\_enabled) | Set to false to prevent the module from creating an Application Load Balancer.<br>This setting defaults to false if `alb_arn` is specified. | `bool` | `true` | no |
| <a name="input_alb_ip_address_type"></a> [alb\_ip\_address\_type](#input\_alb\_ip\_address\_type) | Address type for ALB possible. Specify one of `ipv4`, `dualstack`. Only when `alb_enabled = true`. | `string` | `null` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain Cloudwatch logs. | `number` | `60` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_ecs_cluster_container_insights_enabled"></a> [ecs\_cluster\_container\_insights\_enabled](#input\_ecs\_cluster\_container\_insights\_enabled) | Whether or not Container Insights should be enabled. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_logs_kms_key_arn"></a> [logs\_kms\_key\_arn](#input\_logs\_kms\_key\_arn) | ARN of the KMS key for CloudWatch encryption, if blank, one will be created. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_parent_zone_id"></a> [parent\_zone\_id](#input\_parent\_zone\_id) | ID of the hosted zone to contain this record (or specify `parent_zone_name`). Requires `dns_alias_enabled` set to true. | `string` | `""` | no |
| <a name="input_parent_zone_name"></a> [parent\_zone\_name](#input\_parent\_zone\_name) | Name of the hosted zone to contain this record (or specify `parent_zone_id`). Requires `dns_alias_enabled` set to true. | `string` | `""` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the Load Balancer. The Load Balancer will be created in the VPC associated with the subnet IDs. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC. Required if `alb_enabled` is `true`. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the Application Load Balancer |
| <a name="output_alb_arn_suffix"></a> [alb\_arn\_suffix](#output\_alb\_arn\_suffix) | ARN suffix of the ALB |
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | ID of the ALB security group |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the ECS cluster |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN for log encryption |
## Breaking Changes

Please consult [BREAKING\_CHANGES.md](BREAKING\_CHANGES.md) for more information about version
history and compatibility.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the process for
contributing to this project.

Be mindful of our [Code of Conduct](CODE\_OF\_CONDUCT.md).

## We're hiring

Look for current openings on BambooHR https://nventive.bamboohr.com/careers/

## Stay in touch

[nventive.com](https://nventive.com/) | [Linkedin](https://www.linkedin.com/company/nventive/) | [Instagram](https://www.instagram.com/hellonventive/) | [YouTube](https://www.youtube.com/channel/UCFQyvGEKMO10hEyvCqprp5w) | [Spotify](https://open.spotify.com/show/0lsxfIb6Ttm76jB4wgutob)
<!-- END_TF_DOCS -->