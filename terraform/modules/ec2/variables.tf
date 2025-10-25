variable "vpc_id" {
  type = string
}


variable "ec2_subnet_ids" {
  type = list(string)
}

variable "lb_subnet_id" {
  type = list(string)
}


variable "jwt_secret" {
  type = string
  default = "omar"
}