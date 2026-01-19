variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable app_target_group_arn{
  type = string
}

# variable "lb_listener_https_arn" {
#   type = string
# }

variable "iam_instance_profile_name" {
  type = string
}

