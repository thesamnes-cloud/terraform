provider "aws" {
  region  = var.region
  # profile = "profile1"
  default_tags {
    tags = {
      Company = "Grupomas"
      Project = "Proyecto"
    }
  }
}