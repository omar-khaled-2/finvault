variable "vpc_id" {
  type = string
}


variable "ec2_subnet_ids" {
  type = list(string)
}

variable "lb_subnet_id" {
  type = list(string)
}


variable "mongo_endpoint" {
  type = string
}

variable "mongo_username" {
  type = string
}

variable "mongo_password" {
  type = string
}

variable "jwt_secret" {
  type = string
  default = "omar"
}