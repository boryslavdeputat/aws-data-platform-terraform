variable "cluster_name" { type = string }
variable "kafka_version" { type = string default = "3.5.1" }
variable "number_of_broker_nodes" { type = number default = 3 }
variable "broker_instance_type" { type = string default = "kafka.m5.large" }
variable "client_subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "volume_size" { type = number default = 1000 }
variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = var.client_subnets
    security_groups = var.security_groups
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  tags = var.tags
}

output "bootstrap_brokers_tls" { value = aws_msk_cluster.this.bootstrap_brokers_tls }
output "zookeeper_connect" { value = aws_msk_cluster.this.zookeeper_connect_string }
