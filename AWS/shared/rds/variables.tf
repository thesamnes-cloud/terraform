variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "subnet_ids" {
  type    = list(string)
}

variable "db_password" {
  type        = string
  description = "Default for security, must change after create"
  sensitive   = true # Do not display password in terminal output
  default = "Z9pK3WmR7TqL8D2x"
}