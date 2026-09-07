---
name: create-ec2-instance
description: Add or modify an EC2 instance in this Terraform practice repo, following the repo's conventions (data-source lookups, required tags, plan-before-apply workflow). Use when asked to add a new EC2 instance, change instance settings (type, tags, subnet), or provision AWS compute here.
---

# Create/modify an EC2 instance

Steps for adding a new `aws_instance` resource (or changing an existing one) in this
repo, consistent with `ec2.tf` and `CLAUDE.md`.

## 1. Reuse existing lookups, don't hardcode

This repo already looks up the default VPC/subnets and the latest Amazon Linux 2023 AMI
in `ec2.tf`:

- `data.aws_vpc.default`
- `data.aws_subnets.default`
- `data.aws_ami.amazon_linux`

New instances should reference these existing data sources (e.g.
`element(data.aws_subnets.default.ids, N)`, `data.aws_ami.amazon_linux.id`) instead of
hardcoding VPC/subnet/AMI IDs. Only add a new data source if the instance genuinely
needs a different AMI or network.

## 2. Expose configurable values as variables

Add new tunables (instance type, tags, etc.) to `variables.tf` rather than inlining
literals in the resource block, following the existing `owner` / `instance_type`
pattern. Give sensible defaults where the repo already has one to fall back on
(`instance_type` defaults to a small burstable type); leave required values like
`owner` without a default.

## 3. Required tags

Every `aws_instance` in this repo must be tagged with:

- `Name`
- `Environment`
- `Owner` (from `var.owner`)

## 4. Outputs

If the new instance should be inspectable after apply, add matching `output` blocks
(mirroring `instance_id` / `public_ip`) rather than expecting the caller to query state
directly.

## 5. Validate before proposing a plan

Before showing the user a plan:

```
terraform fmt
terraform validate
```

## 6. Plan, don't apply

Run `terraform plan` and show the **full** output to the user. Note that `var.owner`
has no default, so pass it explicitly (`-var="owner=..."`) or confirm how the user wants
it supplied.

Never run `terraform apply` or `terraform destroy` without asking first, even if the
plan looks safe — this matches the repo's standing convention in `CLAUDE.md`.
