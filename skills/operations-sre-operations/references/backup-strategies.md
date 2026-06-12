# Backup Strategies

Backup design, implementation, and testing for data resilience.

## Backup Principles

1. **3-2-1 Rule**: 3 copies of data, on 2 different media types, with 1 copy offsite
2. **Test restores**: An untested backup is a hypothesis, not a backup
3. **Automate and verify**: Automated backups must be verified complete (not just running)
4. **Encrypt at rest**: All backups contain sensitive data; encrypt before storage
5. **Version and retain**: Keep multiple restore points to recover from logical corruption

## Backup Types

| Type | Description | Use case |
|------|-------------|---------|
| Full backup | Complete copy of all data | Weekly baseline |
| Incremental | Changes since last backup | Daily (lower storage) |
| Differential | Changes since last full backup | Balance of size and restore speed |
| Point-in-time recovery (PITR) | Continuous WAL/binlog archiving | Database, precision recovery |
| Snapshot | Volume-level copy | VMs, containers, fast restore |

## Retention Policy Template

```yaml
retention:
  hourly:   24 snapshots    # last 24 hours
  daily:    14 backups      # last 2 weeks
  weekly:   8 backups       # last 2 months
  monthly:  12 backups      # last 1 year
  annual:   7 backups       # last 7 years (compliance)
```

Adjust retention based on:
- Regulatory requirements (GDPR, HIPAA, PCI-DSS often specify minimums)
- Recovery point objectives (how far back you might need to go)
- Storage costs (longer retention = more cost)

## PostgreSQL Backup

### pg_dump (logical backup)

```bash
# Full database backup
pg_dump -h {host} -U {user} -Fc -f /backups/{db}_{timestamp}.dump {dbname}

# Restore
pg_restore -h {host} -U {user} -d {dbname} /backups/{db}_{timestamp}.dump

# Verify backup integrity
pg_restore --list /backups/{db}_{timestamp}.dump | head -20
```

### Continuous Archiving (PITR) with WAL-E / pgBackRest

```bash
# pgBackRest configuration
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
repo1-cipher-type=aes-256-cbc

# Full backup
pgbackrest --stanza={stanza} backup --type=full

# Incremental backup
pgbackrest --stanza={stanza} backup --type=incr

# Point-in-time restore
pgbackrest --stanza={stanza} --delta restore --target="2024-01-15 10:30:00"
```

### Replication ≠ Backup

Database replication (primary → replica) is NOT a backup. Replication propagates all writes
including accidental deletes. A backup is a point-in-time snapshot that can be restored
independently of the live database.

## Object Storage / File Backup

### AWS S3 / Compatible

```bash
# Backup to S3 with versioning + encryption
aws s3 sync /data s3://{bucket}/{prefix} \
  --sse aws:kms \
  --storage-class STANDARD_IA

# Verify backup
aws s3 ls s3://{bucket}/{prefix} --recursive --human-readable | tail -20

# Restore specific file
aws s3 cp s3://{bucket}/{prefix}/{file} /restore/{file}
```

Enable S3 bucket versioning + MFA delete for accidental deletion protection.

## Backup Testing Schedule

| Backup type | Test frequency | Test method | Pass criteria |
|------------|---------------|------------|--------------|
| Database full | Monthly | Full restore to isolated test instance | Application passes smoke test |
| Database PITR | Weekly | Restore to specific timestamp | Data matches expected state at that time |
| File/object backup | Quarterly | Restore sample of 10 random files | SHA256 checksum matches original |
| Infrastructure config | On any change | Redeploy to staging from backup | Staging matches production |
| Annual DR exercise | Annually | Full restore in isolated environment | RTO/RPO objectives met |

## Backup Monitoring

Alert when:
- Backup job fails to complete (deadman alert)
- Backup size deviates >20% from previous run (data loss or explosion)
- Restore test fails
- Backup age exceeds RPO target

```yaml
# Alert: backup not completed within expected window
- alert: DatabaseBackupMissing
  expr: time() - backup_last_success_timestamp{type="full"} > 90000  # 25 hours
  labels:
    severity: critical
  annotations:
    summary: "Daily database backup has not completed in 25 hours"
```

## Recovery Runbook Template

```markdown
## Restore Procedure: {Database / Service}

**RTO target**: {N hours}
**RPO target**: {N hours}

### Identify restore point
1. Check backup catalog: `{command}`
2. Identify latest clean backup before the recovery event
3. Confirm backup integrity: `{command}`

### Restore procedure
1. Stop application: `{command}`
2. Begin restore: `{command}`
3. Estimated restore time: {N minutes for full backup}
4. Apply incremental/WAL: `{command}` (if needed)
5. Verify data integrity: `{command}`

### Verify and restart
1. Run smoke tests: `{command}`
2. Confirm data completeness: `{command}`
3. Restart application: `{command}`
4. Monitor for {N minutes}

### Document
- Record actual RTO achieved
- Record actual RPO (data loss, if any)
- File post-mortem if RTO/RPO exceeded
```

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| Backups never tested | Will fail when needed most | Monthly restore test, automate |
| No offsite copy | Single disaster destroys all copies | Use cross-region object storage |
| Unencrypted backup | Data breach via backup storage | Always encrypt, test decryption |
| Backup to same disk as data | Disk failure loses both | Separate backup destination |
| Replication instead of backup | Deletes propagate to replica | Maintain independent backup |
| Backup without retention policy | Storage fills up, oldest backups deleted unexpectedly | Define and enforce retention |
