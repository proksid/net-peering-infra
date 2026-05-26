locals {
  prefix = "${var.name}-${var.environment}-${var.role}"
}

resource "aws_iam_role" "this" {
  name = "${local.prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${local.prefix}-ec2-role"
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.prefix}-instance-profile"
  role = aws_iam_role.this.name

  tags = merge(var.tags, {
    Name = "${local.prefix}-instance-profile"
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data = var.user_data

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(var.tags, {
    Name = "${local.prefix}-instance"
  })
}