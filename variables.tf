variable "instance_type_ec2" {
  type    = string
  default = "t2.micro"
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_version" {
  type    = string
  default = "14.9"
}

variable "db_description" {
  type    = string
  default = "quick-serve-db"
}

variable "db_database_name" {
  type    = string
  default = "quickserve"
}

variable "db_storage" {
  type    = number
  default = 20
}

variable "db_user" {
  type    = string
  default = "root"
}

variable "db_password" {
  type    = string
  default = "RootFiap123"
}
