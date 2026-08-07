variable "domain_name" { type = string }
variable "engine_version" { type = string default = "OpenSearch_2.11" }
variable "instance_type" { type = string default = "r6g.large.search" }
variable "instance_count" { type = number default = 3 }
variable "ebs_volume_size" { type = number default = 200 }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = min(3, length(var.subnet_ids))
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
  }

  encrypt_at_rest { enabled = true }
  node_to_node_encryption { enabled = true }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = var.tags
}

output "endpoint" { value = aws_opensearch_domain.this.endpoint }
