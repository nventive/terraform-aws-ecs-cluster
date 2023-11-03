![nventive](https://nventive-public-assets.s3.amazonaws.com/nventive_logo_github.svg?v=2)

# terraform-aws-ecs-cluster

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE) [![Latest Release](https://img.shields.io/github/release/nventive/terraform-aws-ecs-cluster.svg?style=flat-square)](https://github.com/nventive/terraform-aws-ecs-cluster/releases/latest)

Terraform module to create an ECS Cluster.

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
