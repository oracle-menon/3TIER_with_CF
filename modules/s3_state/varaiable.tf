variable "bucket_name" {
  type        = string
  description = "The bucket to use for storing terrform state files"
  }

variable "s3_locking" {
  type        = string
  description = "Lock name per environment" 
}

variable "env_name" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type = string
  description = "Region in which this is created"
}