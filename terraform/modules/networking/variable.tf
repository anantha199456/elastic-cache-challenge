
variable "namespace" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "all_allow_block" {
  description = "The Availability Zone of the RDS instance"
  type = string
  default = "0.0.0.0/0"
}

variable "az_zone" {
  description = "The Availability Zone of the RDS instance"
  type = string
  default = "us-east-1a"
}

variable "public_cidr_block" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "private_cidr_block_2" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "private_cidr_block_1" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "default_cidr_vpc" {
  description = "The Availability Zone of the RDS instance"
  type = string
}
