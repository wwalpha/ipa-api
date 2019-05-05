# --------------------------------------------------------------------------------
# Terraform Configs
# --------------------------------------------------------------------------------
variable "shared_credentials_file" {}

variable "aws_profile" {}

variable "configs_path" {}

# --------------------------------------------------------------------------------
# AWS Commons
# --------------------------------------------------------------------------------
variable "region" {}

# data "aws_caller_identity" "current" {}

variable "bucketArn" {}

variable "bucketName" {}
