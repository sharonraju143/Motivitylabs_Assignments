provider "aws" {
  region = var.AWS_REGION
}

variable "AMIS" {
  type = string
  default = "ami-07f3ef11ec14a1ea3"
}

variable "PRIV_KEY_PATH" {
  default = "project"
}

variable "PUB_KEY_PATH" {
  default = "project.pub"
}

variable "USERNAME" {
  default = "ec2-user"
}

variable "MYIP" {
  default = ""
}

variable "rmquser" {
  default = "admin"
}

variable "rmqpass" {
  default = "123456789project"
}

variable "dbuser" {
  default = "admin"
}

variable "dbpass" {
  default = "123456789"
}

variable "dbname" {
  default = "project"
}

variable "instance_count" {
  default = "1"
}

variable "VPC_NAME" {
  default = "project-vpc"
}

variable "zone1" {
  default = "us-west-2a"
}

variable "zone2" {
  default = "us-west-2b"
}

variable "zone3" {
  default = "us-west-2c"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pubsub1" {
  default = "10.0.1.0/24"
}

variable "pubsub2" {
  default = "10.0.2.0/24"
}

variable "pubsub3" {
  default = "10.0.3.0/24"
}

variable "pvtsub1" {
  default = "10.0.4.0/24"
}

variable "pvtsub2" {
  default = "10.0.5.0/24"
}

variable "pvtsub3" {
  default = "10.0.6.0/24"
}


