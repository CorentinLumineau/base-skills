# Deployment Strategies

<!-- ported from mercure-plugin/skills/delivery-ci-cd-delivery/references/deployment.md -->

## Overview

Deployment strategies determine how new versions are released to production. This reference covers common patterns including blue-green, canary, and rolling deployments.

## Quick Reference (80/20)

| Strategy | Risk | Rollback | Use Case |
|----------|------|----------|----------|
| Blue-Green | Low | Instant | Full releases |
| Canary | Low | Fast | Gradual validation |
| Rolling | Medium | Gradual | Zero downtime |
| Recreate | High | Full redeploy | Stateful apps |
| A/B Testing | Low | Instant | Feature testing |

## Patterns

### Pattern 1: Blue-Green Deployment

**When to Use**: Zero-downtime deployments with instant rollback

**Example**:
```yaml
# Kubernetes blue-green deployment
apiVersion: v1
kind: Service
metadata:
  name: app
spec:
  selector:
    app: myapp
    version: blue  # Switch between blue/green
  ports:
    - port: 80
      targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: blue
  template:
    metadata:
      labels:
        app: myapp
        version: blue
    spec:
      containers:
        - name: app
          image: myapp:1.0.0
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: green
  template:
    metadata:
      labels:
        app: myapp
        version: green
    spec:
      containers:
        - name: app
          image: myapp:1.1.0
```

```bash
#!/bin/bash
# blue-green-deploy.sh

CURRENT_COLOR=$(kubectl get service app -o jsonpath='{.spec.selector.version}')
NEW_COLOR=$([[ "$CURRENT_COLOR" == "blue" ]] && echo "green" || echo "blue")

echo "Current: $CURRENT_COLOR, Deploying to: $NEW_COLOR"

# Deploy new version to inactive environment
kubectl set image deployment/app-$NEW_COLOR app=myapp:$NEW_VERSION

# Wait for rollout
kubectl rollout status deployment/app-$NEW_COLOR --timeout=300s

# Health check
for i in {1..10}; do
  if curl -sf "http://app-$NEW_COLOR:8080/health"; then
    echo "Health check passed"
    break
  fi
  sleep 5
done

# Switch traffic
kubectl patch service app -p "{\"spec\":{\"selector\":{\"version\":\"$NEW_COLOR\"}}}"

echo "Traffic switched to $NEW_COLOR"

# Rollback function
rollback() {
  echo "Rolling back to $CURRENT_COLOR"
  kubectl patch service app -p "{\"spec\":{\"selector\":{\"version\":\"$CURRENT_COLOR\"}}}"
}
```

**Anti-Pattern**: Not testing the inactive environment before switching.

### Pattern 2: Canary Deployment

**When to Use**: Gradual rollout with traffic splitting

**Example**:
```yaml
# Istio canary deployment
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: app
spec:
  hosts:
    - app
  http:
    - match:
        - headers:
            x-canary:
              exact: "true"
      route:
        - destination:
            host: app
            subset: canary
    - route:
        - destination:
            host: app
            subset: stable
          weight: 90
        - destination:
            host: app
            subset: canary
          weight: 10
```

```typescript
// Canary deployment controller
interface CanaryConfig {
  steps: number[];           // Traffic percentages: [5, 10, 25, 50, 100]
  analysisInterval: number;  // Seconds between steps
  metrics: MetricThreshold[];
}

class CanaryController {
  constructor(
    private config: CanaryConfig,
    private metricsClient: MetricsClient,
    private trafficManager: TrafficManager
  ) {}

  async deploy(newVersion: string): Promise<DeploymentResult> {
    await this.deployCanary(newVersion);

    for (const percentage of this.config.steps) {
      await this.trafficManager.setCanaryWeight(percentage);
      await this.sleep(this.config.analysisInterval * 1000);

      const analysis = await this.analyzeMetrics();

      if (!analysis.healthy) {
        await this.rollback();
        return { success: false, reason: analysis.failureReason };
      }
    }

    await this.promoteCanary();
    return { success: true };
  }
}
```

**Anti-Pattern**: Canary without metrics analysis.

### Pattern 3: Rolling Deployment

**When to Use**: Gradual instance replacement

**Example**:
```yaml
# Kubernetes rolling update
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2        # Allow 2 extra pods during update
      maxUnavailable: 1  # Keep at least 9 pods running
  selector:
    matchLabels:
      app: myapp
  template:
    spec:
      containers:
        - name: app
          image: myapp:1.0.0
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 5
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
      terminationGracePeriodSeconds: 30
```

```bash
# Rolling deploy with kubectl
kubectl set image deployment/app app=myapp:1.1.0

# Watch rollout status
kubectl rollout status deployment/app

# Rollback if needed
kubectl rollout undo deployment/app

# Rollback to specific revision
kubectl rollout undo deployment/app --to-revision=2
```

**Anti-Pattern**: No readiness probes, causing traffic to unhealthy pods.

### Pattern 4: Feature Flag Deployment

**When to Use**: Decoupling deployment from release

**Example**:
```typescript
class FeatureFlagService {
  async isEnabled(flagKey: string, context: EvaluationContext): Promise<boolean> {
    const flag = await this.client.getFlag(flagKey);
    if (!flag || !flag.enabled) return false;

    if (flag.targetUsers?.includes(context.userId)) return true;
    if (flag.targetGroups?.some(g => context.groups.includes(g))) return true;

    if (flag.rolloutPercentage !== undefined) {
      const hash = this.hashUser(context.userId, flagKey);
      return hash < flag.rolloutPercentage;
    }

    return flag.enabled;
  }
}
```

**Anti-Pattern**: Long-lived feature flags becoming technical debt.

### Pattern 5: Database Migration Strategy

**When to Use**: Coordinating schema changes with deployments

**Example** (Expand-Contract):
```typescript
// Phase 1: Expand — Add new column
await db.query(`ALTER TABLE users ADD COLUMN full_name VARCHAR(255)`);

// Phase 2: Migrate — Backfill data
await db.query(`UPDATE users SET full_name = CONCAT(first_name, ' ', last_name) WHERE full_name IS NULL`);

// Phase 3: Deploy new code — app writes to both columns
// Phase 4: Contract — Remove old columns (after all instances updated)
await db.query(`ALTER TABLE users DROP COLUMN first_name, DROP COLUMN last_name`);
```

**Anti-Pattern**: Breaking schema changes without backward compatibility.

## Checklist

- [ ] Deployment strategy matches risk tolerance
- [ ] Health checks configured for all instances
- [ ] Rollback procedure documented and tested
- [ ] Traffic splitting for canary deployments
- [ ] Metrics-based promotion criteria
- [ ] Database migrations are backward compatible
- [ ] Feature flags for risky changes
- [ ] Deployment pipeline fully automated
- [ ] Post-deployment verification automated
- [ ] Alerting configured for deployment failures
