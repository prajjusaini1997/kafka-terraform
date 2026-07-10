variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair"
  type        = string
}


variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}




variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}



