# Kubernetes

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/kubernetes.md -->

## Core Resources

| Resource | Purpose |
|----------|---------|
| Deployment | Manage stateless apps with rolling updates |
| StatefulSet | Manage stateful apps with persistent identity |
| Service | Network access to pods (ClusterIP, NodePort, LoadBalancer) |
| ConfigMap | Non-sensitive configuration data |
| Secret | Sensitive data (base64 encoded) |
| Ingress | External HTTP/HTTPS access with routing |

## Production Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: production
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: registry/api:v1.2.3  # Always pin version, never use :latest
          ports:
            - containerPort: 8080
          resources:
            requests: { cpu: 100m, memory: 256Mi }
            limits:   { cpu: 500m, memory: 512Mi }
          readinessProbe:
            httpGet: { path: /health/ready, port: 8080 }
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet: { path: /health/live, port: 8080 }
            initialDelaySeconds: 15
            periodSeconds: 20
          env:
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef: { name: api-secrets, key: db-password }
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: topology.kubernetes.io/zone
          whenUnsatisfiable: DoNotSchedule
```

## Service and Ingress

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 8080
  selector:
    app: api
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  tls:
    - hosts: [api.example.com]
      secretName: api-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service: { name: api, port: { number: 80 } }
```

## Configuration Management

### External Secrets (for production secrets)

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: api-secrets
spec:
  refreshInterval: 1h
  secretStoreRef: { name: aws-secrets, kind: ClusterSecretStore }
  target: { name: api-secrets }
  data:
    - secretKey: db-password
      remoteRef: { key: prod/api/db-password }
```

### ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-config
data:
  LOG_LEVEL: "info"
  CACHE_TTL: "300"
```

## Autoscaling

### Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef: { apiVersion: apps/v1, kind: Deployment, name: api }
  minReplicas: 3
  maxReplicas: 20
  metrics:
    - type: Resource
      resource: { name: cpu, target: { type: Utilization, averageUtilization: 70 } }
    - type: Pods
      pods: { metric: { name: http_requests_per_second }, target: { type: AverageValue, averageValue: 1000 } }
```

## Network Policies

```yaml
# Default deny all ingress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes: [Ingress]

---
# Allow specific traffic
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-api-ingress
spec:
  podSelector:
    matchLabels: { app: api }
  ingress:
    - from:
        - namespaceSelector: { matchLabels: { name: ingress } }
      ports:
        - port: 8080
```

## Pod Disruption Budget

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
spec:
  minAvailable: 2  # Or use maxUnavailable: 1
  selector:
    matchLabels: { app: api }
```

## Best Practices Summary

| Practice | Implementation |
|----------|---------------|
| Pin image versions | `image: app:v1.2.3`, never `:latest` |
| Set resource limits | Both requests and limits on every container |
| Health probes | readinessProbe + livenessProbe |
| Spread across zones | `topologySpreadConstraints` |
| Network policies | Default deny, explicit allow |
| Pod disruption budgets | Protect during node maintenance |
| Secrets management | External Secrets Operator, not raw Secrets |
| Non-root containers | `securityContext: { runAsNonRoot: true }` |

## Checklist

- [ ] Resource requests and limits set
- [ ] Readiness and liveness probes configured
- [ ] Rolling update strategy defined
- [ ] Pod disruption budgets in place
- [ ] Network policies restrict traffic
- [ ] Topology spread across availability zones
- [ ] Secrets managed via External Secrets Operator
- [ ] HPA configured for variable-load services
- [ ] Image versions pinned (no :latest)
