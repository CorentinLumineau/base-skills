# Communication Templates

Standardized templates for incident communication. Use these verbatim — consistency reduces
cognitive load during high-stress incidents.

## Incident Channel Templates

### Initial Notification

Post immediately upon declaring an incident:

```
INCIDENT SEV-{1|2|3} declared — {short title}

Started:   {HH:MM UTC}
Detected:  {HH:MM UTC} (via {alert name / customer report / manual})
IC:        @{name}
Tech Lead: @{name}
Comms:     @{name} (SEV-1/2 only)

Impact:    {what is broken}
Scope:     {estimated % of users / specific regions / features affected}
Runbook:   {link — or "Locating runbook"}
Channel:   #incident-{YYYYMMDD}-{NNN}

Status: INVESTIGATING
```

### Status Update (post every 15 min for SEV-1, 30 min for SEV-2)

```
UPDATE {HH:MM UTC} — SEV-{N} {title}

Status:   {INVESTIGATING | IDENTIFIED | MITIGATING | MONITORING}
Progress: {1-3 sentences: what we found, what we tried, current hypothesis}
Action:   {what is being done right now}
Blocker:  {any blockers — or "None"}
ETA:      {estimate — or "Unknown, next update in {N} min"}
```

### Mitigation Confirmed

```
MITIGATION APPLIED {HH:MM UTC}

Action taken:  {what was done}
Expected fix:  {what this should resolve}
Monitoring:    {metrics being watched}
Status:        MONITORING — watching for {N} min before declaring resolved
```

### Resolution

```
RESOLVED {HH:MM UTC} — SEV-{N} {title}

Duration:       {N} hours {N} minutes
Users affected: {estimate}
Root cause:     {1-sentence summary — full details in post-mortem}
Fix applied:    {1 sentence}
Verified by:    {metric / test that confirmed resolution}

Post-mortem:    Scheduled {date} at {time} with @{facilitator}
Action items:   {N} items tracked in {ticket system link}

Timeline and full details: {incident channel link}
```

## Stakeholder / Executive Templates

### Initial Escalation (SEV-1/2 — send within 30 min)

**Subject**: [SEV-{N}] {Short title} — INCIDENT IN PROGRESS

```
Hi {name},

We are currently managing a SEV-{N} incident.

WHAT:    {1 sentence describing the failure}
IMPACT:  {who is affected, business impact}
STATUS:  Investigating — IC is @{name}
STARTED: {HH:MM UTC}

We will send updates every {15/30} minutes. Questions: contact @{IC name}.
```

### Update Email (SEV-1/2)

**Subject**: [UPDATE] [SEV-{N}] {Short title} — {HH:MM UTC}

```
Status: {INVESTIGATING | IDENTIFIED | MITIGATING | MONITORING}

Current situation:
{2-3 sentences on what we know and what we are doing}

Next update: {HH:MM UTC} or sooner if status changes.
```

### Resolution Email

**Subject**: [RESOLVED] [SEV-{N}] {Short title}

```
The incident has been resolved as of {HH:MM UTC}.

Summary:
- Duration: {N} hours {N} minutes
- Impact: {who was affected}
- Root cause: {1-2 sentences}
- Fix: {what was done to resolve}

A post-mortem will be completed by {date}. Action items will be tracked in {link}.

Thank you for your patience.
```

## Customer-Facing / Status Page Templates

### Investigating

```
We are investigating an issue affecting {feature/service}. Some users may experience
{symptom: errors | slowness | unavailability}. We will provide an update within {N} minutes.

Started: {HH:MM UTC}
```

### Identified

```
We have identified the cause of the issue affecting {feature/service} and are working on a fix.
{If partial mitigation exists: Some users may already see improvement.}

Started: {HH:MM UTC} | Identified: {HH:MM UTC}
```

### Monitoring

```
A fix has been deployed for the issue affecting {feature/service}. We are monitoring
to confirm full recovery. Most users should now see normal behavior.

Started: {HH:MM UTC} | Fix deployed: {HH:MM UTC}
```

### Resolved

```
This incident has been resolved. {Feature/service} is operating normally.

We apologize for the disruption. A post-incident review will be published within {N} days.

Duration: {N} hours {N} minutes | Resolved: {HH:MM UTC}
```

## Communication Rules

1. **Never go silent**: If you have nothing new to report, send "Still investigating, no new
   findings yet. Next update in {N} min."
2. **Avoid technical jargon** in customer/executive messages — say "our login service" not
   "the OAuth2 PKCE endpoint is returning 500s."
3. **Never speculate publicly** about root cause until confirmed — "We are investigating the
   cause" is always safe.
4. **Time in UTC**: All incident timestamps in UTC. Include local time in parentheses for
   human-facing comms if helpful.
5. **One comms lead per incident**: Multiple people sending conflicting updates causes confusion.
   Designate one person as comms lead for SEV-1/2.
