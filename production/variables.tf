# Cofiguration specific variables
variable "region" {}
variable "backend-s3-bucket" {}
variable "backend-dynamodb-table" {}

variable "project-name" {}
variable "az-1" {}
variable "az-2" {}
variable "vpc-cidr" {}
variable "pub-subnet1-cidr" {}
variable "pub-subnet2-cidr" {}
variable "prv-subnet1-cidr" {}
variable "prv-subnet2-cidr" {}

variable "ec2-ami" {}
variable "ec2-instance-type" {}
variable "ec2-keypair" {}

variable "ssl-cert-arn" {}
variable "zone-name" {}
variable "record-name" {}