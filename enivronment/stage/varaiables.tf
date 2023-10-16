variable "env" {
  description = "Environmens e.g. Test, Stage or Production"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = set(string)
}

variable "public_subnets" {
  description = "The Public subnets for the project"
  type        = set(string)
}

variable "private_subnets" {
  description = "The Private subnets for the project"
  type        = set(string)
}

variable "region" {
  description = "The Region for the alarm ( Ireland eu-west-1(default))"
  type        = string
}

variable "budget_cost" {
  description = "Allowed Amount in AWS Budget"
  type        = number
}

variable "tags" {
  description = "resource tags"
  type        = map(any)
}

variable "ssh_key_name" {
  description = "SSH key name that is allready created"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "bucket-name" {
  description = "S3 bucket for static content in terraform-project"
  type        = string
}

