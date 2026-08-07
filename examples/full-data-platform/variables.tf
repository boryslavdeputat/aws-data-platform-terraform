variable "aws_region" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "owner" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "db_security_group_ids" { type = list(string) }
variable "msk_security_group_ids" { type = list(string) }
variable "redis_security_group_ids" { type = list(string) }
variable "os_security_group_ids" { type = list(string) }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
