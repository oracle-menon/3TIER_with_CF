resource "aws_elasticache_cluster" "project-memcached" {
  cluster_id           = "project-memcached"
  engine               = "memcached"
  node_type            = "cache.t2.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.project-memcached.name
  security_group_ids   = [aws_security_group.project_memcached.id]
}

resource "aws_elasticache_subnet_group" "project-memcached" {
  name       = "memcashed-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "project_memcached" {
  name        = "project-memcached"
  description = "Allow inbound traffic from VPC and ec2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

