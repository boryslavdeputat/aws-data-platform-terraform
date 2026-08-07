# Design notes

## Multi-AZ

- Aurora: instances across AZs via subnet group
- MSK: number_of_broker_nodes multiple of AZ count
- Redis: automatic_failover + multi_az
- OpenSearch: zone_awareness_enabled

## Security baseline

- Encryption at rest on
- TLS in transit where supported
- No public endpoints in modules (VPC only for OS)
- Secrets: pass master passwords from Secrets Manager / CI - never commit tfvars with real secrets

## Cost levers

- Right-size instance classes per env
- OpenSearch volume type gp3
- MSK storage vs retention tradeoff
