variable "region"{
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cluster_id"{
    type = string
}

variable "app_name" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ECS Service"
}

variable "execution_role_arn" {
  type        = string
}

variable "task_role_arn" {
  type        = string
}