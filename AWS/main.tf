# --- SHARED INFRASTRUCTURE ---

# Network: VPC, Subnets, Gateways
module "network" {
  source       = "./shared/network"
  environment  = terraform.workspace
  project_name = var.project_name
}

# Database: RDS PostgreSQL instance
module "database" {
  source       = "./shared/rds"
  environment  = terraform.workspace
  project_name = var.project_name
  vpc_cidr     = module.network.vpc_cidr
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.private_subnet_ids
}

# IAM: Permissions
module "iam" {
 source       = "./shared/iam"
 environment  = terraform.workspace
 project_name = var.project_name
}

# ECS Cluster
module "ecs_cluster" {
 source       = "./shared/ecs_cluster"
 environment  = terraform.workspace
 project_name = var.project_name
}

# S3 Storage
module "s3" {
  source       = "./shared/s3"
  environment  = terraform.workspace
  project_name = var.project_name
}

# Cognito
module "Cognito" {
  source       = "./shared/Cognito"
  environment  = terraform.workspace
  project_name = var.project_name
  app_name     = var.app_name
}


module "EC2"{
  source                    = "./shared/ec2"
  environment               = terraform.workspace
  project_name              = var.project_name
  vpc_id                    = module.network.vpc_id
  subnet_id                 = module.network.public_subnet_ids[0]
  app_target_group_arn      = module.network.app_target_group_arn
  # lb_listener_https_arn     = module.network.aws_lb_listener_https_arn
  iam_instance_profile_name = module.iam.data_collector_instance_profile_name
}

# --- APPLICATIONS ---

# DataCollector
module "app_datacollector" {
 source       = "./apps/datacollector"
 app_name     = var.app_name
 environment  = terraform.workspace
 project_name = var.project_name
 region       = var.region
 # Network mapping
 vpc_id             = module.network.vpc_id
 private_subnet_ids = module.network.private_subnet_ids

 # Compute mapping (Shared Cluster)
 cluster_id         = module.ecs_cluster.cluster_id

 execution_role_arn = module.iam.ecs_exec_role_arn
 task_role_arn      = module.iam.ecs_task_role_arn

 
}

