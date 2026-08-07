terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "tags" {
  source      = "../../modules/tags"
  project     = var.project
  environment = var.environment
  owner       = var.owner
}

module "aurora" {
  source                 = "../../modules/aurora_postgres"
  name                   = "${var.project}-${var.environment}-aurora"
  subnet_ids             = var.private_subnet_ids
  vpc_security_group_ids = var.db_security_group_ids
  master_username        = var.db_username
  master_password        = var.db_password
  tags                   = module.tags.tags
}

module "msk" {
  source           = "../../modules/msk"
  cluster_name     = "${var.project}-${var.environment}-msk"
  client_subnets   = var.private_subnet_ids
  security_groups  = var.msk_security_group_ids
  tags             = module.tags.tags
}

module "redis" {
  source             = "../../modules/elasticache_redis"
  name               = "${var.project}-${var.environment}-redis"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.redis_security_group_ids
  tags               = module.tags.tags
}

module "opensearch" {
  source             = "../../modules/opensearch"
  domain_name        = "${var.project}-${var.environment}-os"
  subnet_ids         = slice(var.private_subnet_ids, 0, min(3, length(var.private_subnet_ids)))
  security_group_ids = var.os_security_group_ids
  tags               = module.tags.tags
}

output "aurora_endpoint" { value = module.aurora.cluster_endpoint }
output "msk_bootstrap" { value = module.msk.bootstrap_brokers_tls }
output "redis_endpoint" { value = module.redis.primary_endpoint }
output "opensearch_endpoint" { value = module.opensearch.endpoint }
