data "aws_ami" "project" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_kms_alias" "default_ebs" {
  name = "alias/aws/ebs"
}

resource "aws_security_group" "ec2" {
  name   = "ec2-secgroup-${var.env}"
  vpc_id = module.vpc.vpc_id

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_template" "project" {
  name_prefix                          = "${var.env}-ec2-project"
  instance_type                        = "t2.micro"
  image_id                             = data.aws_ami.project.id #"ami-0648880541a3156f7"
  key_name                             = var.ssh_key_name
  vpc_security_group_ids               = [aws_security_group.ec2.id]
  depends_on                           = [aws_efs_access_point.project]
  user_data                            = base64encode(data.template_file.userdata.rendered)
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    arn = aws_iam_instance_profile.project.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      encrypted             = true
      kms_key_id            = data.aws_kms_alias.default_ebs.target_key_arn
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }
}

data "template_file" "userdata" {
  template = file("./files/user_data_apache.sh")

  vars = {
    efs_fqdn = "${aws_efs_file_system.project.dns_name}"
  }
}

resource "aws_autoscaling_group" "project" {
  launch_template {
    id      = aws_launch_template.project.id
    version = "$Latest"
  }
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns   = [aws_lb_target_group.project.arn]
  health_check_type   = "ELB"
  timeouts {
    delete = "5m"
  }


  min_size         = 1
  desired_capacity = 1
  max_size         = 1

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_iam_instance_profile" "project" {
  name = "instance_project"
  role = aws_iam_role.project.name
}

resource "aws_iam_role" "project" {
  name = "ssm-project"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "project" {
  name       = "ssmmanager"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.project.name]
}

resource "aws_iam_policy_attachment" "project1" {
  name       = "ssmpatch"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  roles      = [aws_iam_role.project.name]
}

