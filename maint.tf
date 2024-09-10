terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

#resource "aws_instance" "app_server" {
#  ami           = "ami-0e86e20dae9224db8"
#  instance_type = var.instance_type
#
#  tags = {
#    Name = "Fiap Primeira Instância"
#  }
#
#  key_name = "iac-fiap"
#}

#resource "aws_vpc" "vpc_prd" {
#  cidr_block           = "10.0.0.0/16"
#  enable_dns_hostnames = true
#}
#
#resource "aws_subnet" "public_subnet_a" {
#  vpc_id            = aws_vpc.vpc_prd.id
#  cidr_block        = "10.0.1.0/24"
#  availability_zone = "us-east-1a"
#}
#
#resource "aws_subnet" "public_subnet_b" {
#  vpc_id            = aws_vpc.vpc_prd.id
#  cidr_block        = "10.0.2.0/24"
#  availability_zone = "us-east-1b"
#}
#
#resource "aws_subnet" "private_subnet_a" {
#  vpc_id            = aws_vpc.vpc_prd.id
#  cidr_block        = "10.0.3.0/24"
#  availability_zone = "us-east-1a"
#}
#
#resource "aws_subnet" "private_subnet_b" {
#  vpc_id            = aws_vpc.vpc_prd.id
#  cidr_block        = "10.0.4.0/24"
#  availability_zone = "us-east-1b"
#}
#
#resource "aws_db_subnet_group" "db_subnet" {
#  name       = "db_subnet"
#  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
#}

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
