# Failover Patterns

Patterns for designing and implementing failover mechanisms.

## Failover Strategy Comparison

| Strategy | RTO | RPO | Cost | Complexity | When to use |
|---------|-----|-----|------|-----------|------------|
| Active-Active | Seconds | ~0 | High | High | Core services, payment, auth |
| Active-Passive (warm) | 1-5 min | Seconds | Medium | Medium | Critical non-core services |
| Active-Passive (cold) | 15-60 min | Minutes | Low | Low | Internal tools, dev services |
| Backup restore | Hours | Hours | Lowest | Low | Archival, non-critical data |

**RTO** (Recovery Time Objective): Maximum acceptable time from failure to restoration.
**RPO** (Recovery Point Objective): Maximum acceptable data loss measured in time.

## Active-Active

Both instances serve traffic simultaneously. Failure of one instance does not cause downtime —
the load balancer routes around it.

```
                    ┌─────────────┐
                    │ Load Balancer│
                    └──────┬──────┘
                    ┌──────┴──────┐
             ┌──────┴─────┐ ┌────┴──────┐
             │  Instance A │ │ Instance B │
             └─────────────┘ └───────────┘
                    ┌──────┴──────┐
                    │  Shared DB  │
                    └─────────────┘
```

Requirements:
- Stateless application tier (session state in shared cache or token-based)
- Database replication lag must be acceptable for consistency requirements
- Health checks must correctly detect degraded (not just dead) instances
- Load balancer must route around failed instances automatically

## Active-Passive (Warm Standby)

Primary serves all traffic. Standby stays synchronized and can assume primary role quickly.

```
                    ┌─────────────┐
                    │ Load Balancer│  ──→ routes to primary (health check)
                    └──────┬──────┘
             ┌─────────────┴─────────────┐
         ┌───┴────┐               ┌──────┴───┐
         │Primary │               │ Standby  │  ← warm (running, synced)
         └───┬────┘               └──────────┘
             │ replication
         ┌───┴────────────────────────────┐
         │ Database (with replica)        │
         └────────────────────────────────┘
```

Failover steps:
1. Primary health check fails
2. Load balancer promotes standby to primary
3. Standby updates its own configuration (DB primary, etc.)
4. Alert fires, on-call investigates primary failure
5. Primary restored and demoted to standby

## Database Failover

### PostgreSQL Streaming Replication + Patroni

```yaml
# Patroni configuration example
scope: {cluster-name}
restapi:
  listen: 0.0.0.0:8008
  connect_address: {host}:8008
bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576  # 1 MB
postgresql:
  listen: 0.0.0.0:5432
  connect_address: {host}:5432
  data_dir: /data/patroni
```

Monitor replica lag:
```sql
SELECT
  client_addr,
  state,
  sent_lsn,
  write_lsn,
  flush_lsn,
  replay_lsn,
  (sent_lsn - replay_lsn) AS replication_lag_bytes
FROM pg_stat_replication;
```

### Redis Sentinel

```
sentinel monitor mymaster {primary-ip} 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 10000
sentinel parallel-syncs mymaster 1
```

## DNS Failover

For region-level failover, DNS TTL management is critical:

| TTL setting | Failover speed | Cache propagation risk |
|------------|---------------|----------------------|
| 60 seconds | Fast (~1 min) | High |
| 300 seconds | Medium (~5 min) | Medium |
| 3600 seconds | Slow (~1 hour) | Low |

**Best practice**: Set TTL to 60s during normal operations. This incurs slightly more DNS
queries but enables fast failover without pre-warming.

## Failover Testing

An untested failover is not a failover — it is a theory.

### Testing Checklist

- [ ] Failover tested in staging or production (not just designed)
- [ ] Test includes data path verification (not just "service started")
- [ ] Time to detect failure measured and within RTO
- [ ] Time to complete failover measured and within RTO
- [ ] Failback tested (returning to primary)
- [ ] Runbook followed exactly during test (not ad-hoc)
- [ ] Test result documented with actual RTO/RPO achieved

### Chaos Testing Schedule

| Component | Test frequency | Method |
|-----------|---------------|--------|
| Application failover | Monthly | Kill primary instance |
| Database failover | Quarterly | Patroni switchover |
| Region failover | Biannually | Traffic shift test |
| Full DR exercise | Annually | Full region evacuation simulation |

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Failover never tested | Works on paper, fails in crisis | Schedule regular chaos tests |
| High DNS TTL | Slow failover despite fast detection | Set TTL to 60s |
| Standby writes to same DB as primary | Brain-split, data corruption | Enforce primary lock in DB |
| Manual failover steps | Slow, error-prone under stress | Automate detection and routing |
| No replica lag monitoring | Standby is hours behind, RPO violated | Alert on replica lag >30s |
