terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  cloud { 
    
    organization = "FIAP-7SOAT-51" 

    workspaces { 
      name = "quick-serve-infra-db" 
    } 
  } 
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "postgres_sg" {
  name = "postgres_sg"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]  # Adjust for security
  }
}

resource "aws_db_instance" "postgres_instance" {
  allocated_storage   = var.db_storage
  engine              = var.db_engine
  engine_version      = var.db_version  # Specify the desired version
  instance_class      = var.db_instance_type  # Free tier eligible
  identifier          = var.db_description
  username            = var.db_user
  password            = var.db_password
  db_name             = var.db_database_name
  skip_final_snapshot = true
  publicly_accessible  = true
  #db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
}
