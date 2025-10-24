variable "private_subnet_ids" {
    type = list(string)
}

variable "vpc_id" {
    type = string
}

variable "username" {
    type = string
    default = "omar"
}

variable "password" {
    type = string
    default = "12345678"
}