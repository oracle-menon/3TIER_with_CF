data "aws_kms_alias" "default_rds" {
  name = "alias/aws/rds"
}

data "aws_kms_alias" "default_secret" {
  name = "alias/aws/secretsmanager"
}

resource "random_string" "project" {
  length  = 9
  special = false
}


resource "aws_db_subnet_group" "project" {
  name       = "db_subnet_group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "project" {
  identifier_prefix    = "db-project-${var.env}-1"
  storage_encrypted    = true
  kms_key_id           = data.aws_kms_alias.default_rds.target_key_arn
  engine               = "mysql"
  allocated_storage    = 10
  instance_class       = "db.t2.small"
  skip_final_snapshot  = true
  db_name              = "project${var.env}"
  db_subnet_group_name = aws_db_subnet_group.project.name
  # master_user_secret_kms_key_id = data.aws_kms_alias.default_secret.target_key_id
  username                    = random_string.project.result
  manage_master_user_password = true
  multi_az                    = true
  vpc_security_group_ids      = [aws_security_group.db.id]
}

resource "aws_security_group" "db" {
  name   = "secgroup-db-${var.env}"
  vpc_id = module.vpc.vpc_id


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




