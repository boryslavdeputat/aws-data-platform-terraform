# AWS Data Platform Terraform

**Languages:** [English](README.md) · [Українська](README.uk.md)

> Practical reference by [Boryslav Deputat](https://github.com/boryslavdeputat) - Cloud / SRE / Platform.
> Sites: [Portfolio](https://boryslavdeputat.com/) · [ClawDBot / KLAV (UA AI)](https://clawdbot.llc/) · [Walk ATX Pet](https://walkatxpet.com/) · [DepuTater](https://deputater.com/)

Production-oriented **Terraform** modules for a multi-AZ AWS data platform: **Aurora PostgreSQL**, **MSK**, **ElastiCache Redis**, **OpenSearch**, networking hooks, and tagging standards.

## Modules

| Module | Resource |
|--------|----------|
| `modules/network` | VPC refs / subnet validation |
| `modules/aurora_postgres` | Aurora PostgreSQL cluster |
| `modules/msk` | Amazon MSK (Kafka) |
| `modules/elasticache_redis` | Redis replication group |
| `modules/opensearch` | OpenSearch domain |
| `modules/tags` | Standard tag map |

## Quick start

```bash
cd examples/full-data-platform
cp terraform.tfvars.example terraform.tfvars
# edit account, vpc, subnet ids
terraform init
terraform plan
# terraform apply   # only in your account after review
```

## Design principles

1. Multi-AZ by default
2. Encryption at rest + in transit where supported
3. Explicit subnet / SG inputs (no hidden defaults for prod)
4. Consistent tags: `Project`, `Environment`, `Owner`, `ManagedBy=terraform`
5. Outputs for endpoint discovery by apps / Crossplane / SSM

## Example architecture

```
                    +------------------+
   Apps / K8s  ---> | Aurora PostgreSQL|
                    +------------------+
   Producers   ---> | MSK (Kafka)      | ---> Consumers
                    +------------------+
   Cache layer ---> | ElastiCache Redis|
                    +------------------+
   Search      ---> | OpenSearch       |
                    +------------------+
```

## Disclaimer

Educational and practical reference. Validate against your compliance, cost, and SLO requirements before production use.

## Contact

- Portfolio: https://boryslavdeputat.com/
- ClawDBot / KLAV (UA AI): https://clawdbot.llc/
- Email: info@boryslavdeputat.com

## License

MIT - see [LICENSE](LICENSE).
