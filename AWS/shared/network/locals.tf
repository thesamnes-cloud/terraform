locals {
  vpc_cidrs = {
    default = "10.0.0.0/16"
    prod = "10.100.0.0/16"
    stag = "10.101.0.0/16"
    test = "10.102.0.0/16"
  }
}
