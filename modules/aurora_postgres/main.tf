variable "name" { type = string }
variable "engine_version" { type = string default = "15.4" }
variable "instance_class" { type = string default = "db.r6g.large" }
variable "instances" { type = number default = 2 }
variable "subnet_ids" { type = list(string) }
variable "vpc_security_group_ids" { type = list(string) }
variable "master_username" { type = string }
variable "master_password" {
  type      = string
  sensitive = true
}
variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-aurora"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_rds_cluster" "this" {
  cluster_identifier           = var.name
  engine                       = "aurora-postgresql"
  engine_version               = var.engine_version
  master_username              = var.master_username
  master_password              = var.master_password
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = var.vpc_security_group_ids
  storage_encrypted            = true
  backup_retention_period      = 7
  preferred_backup_window      = "07:00-09:00"
  deletion_protection          = true
  copy_tags_to_snapshot        = true
  tags                         = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instances
  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  tags               = var.tags
}

output "cluster_endpoint" { value = aws_rds_cluster.this.endpoint }
output "reader_endpoint" { value = aws_rds_cluster.this.reader_endpoint }
