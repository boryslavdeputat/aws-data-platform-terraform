variable "name" { type = string }
variable "description" { type = string default = "redis" }
variable "engine_version" { type = string default = "7.1" }
variable "node_type" { type = string default = "cache.r6g.large" }
variable "num_cache_clusters" { type = number default = 2 }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-redis"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = var.name
  description                = var.description
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = true
  multi_az_enabled           = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = var.security_group_ids
  tags                       = var.tags
}

output "primary_endpoint" { value = aws_elasticache_replication_group.this.primary_endpoint_address }
