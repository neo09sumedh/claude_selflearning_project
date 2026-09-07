# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A small Terraform practice project that provisions a single EC2 instance into the
default VPC/subnet of an AWS account, using the latest Amazon Linux 2023 AMI (looked
up dynamically, not hardcoded).


## Stack
- Terraform >= 1.5, AWS provider ~> 5.0
- Default AWS region: us-east-1
- Credentials come from an AWS_PROFILE or environment variables — never
  hardcode credentials in any .tf file.

## Conventions
- Every EC2 instance must be tagged with Name, Environment, and Owner.
- Always run `terraform plan` and show me the full output before running
  `terraform apply`.
- Never run `terraform apply` or `terraform destroy` without asking me
  first, even if the plan looks safe.
- Run `terraform fmt` and `terraform validate` before proposing any plan.

## Not committed

`.gitignore` excludes `.terraform/`, `*.tfstate*`, `*.tfplan`, and `crash.log` — state is
local-only in this repo, so don't assume a remote backend exists.
