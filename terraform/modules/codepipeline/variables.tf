variable "artifacts_bucket_name" {
    type = string
}

variable "autoscaling_group_name" {
    type = string
}

variable "github_connection_arn" {
  type = string
  default = "arn:aws:codeconnections:us-east-1:586794472419:connection/ba14e399-90f3-43dc-9709-f719acc2d4f0"
}