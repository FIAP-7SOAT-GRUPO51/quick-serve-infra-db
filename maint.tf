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

#resource "aws_security_group" "postgres_sg" {
#  name = "postgres_sg"
#  ingress {
#    from_port   = 5432
#    to_port     = 5432
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"] # Adjust for security
#  }
#}

#resource "aws_db_instance" "postgres_instance" {
#  allocated_storage   = var.db_storage
#  engine              = var.db_engine
#  engine_version      = var.db_version       # Specify the desired version
#  instance_class      = var.db_instance_type # Free tier eligible
#  identifier          = var.db_description
#  username            = var.db_user
#  password            = var.db_password
#  db_name             = var.db_database_name
#  skip_final_snapshot = true
#  publicly_accessible = true
#  #vpc_security_group_ids = [aws_security_group.postgres_sg.id]
#}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow access to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage   = var.db_storage
  engine              = var.db_engine
  engine_version      = var.db_version       # Specify the desired version
  instance_class      = var.db_instance_type # Free tier eligible
  identifier          = var.db_description
  username            = var.db_user
  password            = var.db_password
  db_name             = var.db_database_name
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
}
