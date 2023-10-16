env = "stage"

availability_zones = [
  "eu-west-1a",
  "eu-west-1b",
  "eu-west-1c",
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
]

private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24",
]

region = "eu-west-1"

budget_cost = 30

tags = {
  Terraform   = "true"
  Application = "Static Content"
}

ssh_key_name = "Stage-Training"

domain_name = "envcloud.link"

bucket-name = "s3-bucket-for-static-content-stage"

