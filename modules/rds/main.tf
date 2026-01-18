# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.identifier}-subnet-group"
    }
  )
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.identifier}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block != null ? [var.vpc_cidr_block] : []
    # If app_security_group_id is provided, allow access from there (preferred for ECS)
    security_groups = var.app_security_group_id != null ? [var.app_security_group_id] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.identifier}-sg"
    }
  )
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier        = var.identifier
  engine            = "postgres"
  engine_version    = "16.6" # Validated available version
  instance_class    = "db.t3.micro" 
  allocated_storage = 20
  
  db_name  = var.db_name
  username = var.username
  password = var.password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  skip_final_snapshot = true # For learning/dev only!

  tags = var.common_tags
}
