provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source               = "./modules/vpc"
  azs                  = data.aws_availability_zones.available.names
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

module "iam" {
  source = "./modules/iam"
}

module "rds" {
  source         = "./modules/rds"
  vpc_id         = module.vpc.vpc_id
  db_subnet_ids  = module.vpc.private_subnet_ids
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  app_image_url          = var.app_image_url
  db_host                = module.rds.db_endpoint
  db_user                = module.rds.db_username
  db_password            = module.rds.db_password
  db_name                = module.rds.db_name
  s3_bucket              = module.s3.bucket_name
  s3_region              = var.region
  lb_endpoint            = module.alb.alb_dns
  alb_target_group_arn   = module.alb.target_group_arn
  alb_listener_arn       = module.alb.listener_arn
  ecs_task_execution_role = module.iam.ecs_task_execution_role_arn
  alb_sg_id              = module.alb.alb_sg_id
}