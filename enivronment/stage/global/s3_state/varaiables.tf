variable "region" {
  description = "Region in which this is created"
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "S3 bucket for terraform states"
  default     = "demo-set-tfstate-environment"
}

variable "env_name" {
  description = "Environment name"
  default     = "stage-environment"
}

variable "s3_locking" {
  type        = string
  description = "Lock name per environment"
  default     = "stage_project_terraform_locks"
}