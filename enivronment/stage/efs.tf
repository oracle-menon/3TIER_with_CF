resource "aws_efs_file_system" "project" {
  creation_token   = "Project-EFS"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "Project-EFS"
  }
}

resource "aws_efs_mount_target" "project" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.project.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Allow NFS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "efs-security-group"
  }
}

resource "aws_efs_access_point" "project" {
  file_system_id = aws_efs_file_system.project.id
  root_directory {
    path = "/"
    creation_info {
      owner_gid   = "1000"
      owner_uid   = "1000"
      permissions = "755"
    }
  }
  tags = {
    Name = "project-efs-access-point"
  }
}