variable "project" { type = string }
variable "environment" { type = string }
variable "owner" { type = string }
variable "extra" {
  type    = map(string)
  default = {}
}

locals {
  tags = merge({
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }, var.extra)
}

output "tags" { value = local.tags }
