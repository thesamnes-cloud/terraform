variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for redundancy"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "acm_certificate_arn" {
  type        = string
  description = "Created outside of terraform"
  default     = "arn:aws:acm:us-east-1:634183828914:certificate/e1107b89-99d7-45fc-afac-a39f3bc1e730"
}