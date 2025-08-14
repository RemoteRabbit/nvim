;; terraform
# {{_file_name_}} - Security groups and NACL

resource "aws_security_group" "{{_input_:sg_name_}}" {
  name_prefix = "${var.project_name}-{{_input_:sg_name_}}-"
  description = "Security group for {{_input_:sg_description_}}"
  vpc_id      = var.vpc_id

  # HTTP access
  dynamic "ingress" {
    for_each = var.allow_http ? [1] : []
    content {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.http_cidr_blocks
    }
  }

  # HTTPS access
  dynamic "ingress" {
    for_each = var.allow_https ? [1] : []
    content {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.https_cidr_blocks
    }
  }

  # SSH access
  dynamic "ingress" {
    for_each = var.allow_ssh ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_cidr_blocks
    }
  }

  # Custom port access
  dynamic "ingress" {
    for_each = var.custom_ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Default egress (all outbound traffic allowed)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-{{_input_:sg_name_}}-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer Security Group
resource "aws_security_group" "alb" {
  count = var.create_alb_sg ? 1 : 0

  name_prefix = "${var.project_name}-alb-"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

# Database Security Group
resource "aws_security_group" "database" {
  count = var.create_db_sg ? 1 : 0

  name_prefix = "${var.project_name}-database-"
  description = "Security group for database access"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Database access from application"
    from_port       = var.database_port
    to_port         = var.database_port
    protocol        = "tcp"
    security_groups = [aws_security_group.{{_input_:sg_name_}}.id]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-database-sg"
  })
}

{{_cursor_}}
