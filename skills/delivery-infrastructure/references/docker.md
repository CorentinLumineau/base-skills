# Docker

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/docker.md -->

## Dockerfile Quick Reference

| Instruction | Purpose |
|-------------|---------|
| FROM | Base image (use specific tag, not :latest) |
| RUN | Execute commands (combine with && to reduce layers) |
| COPY | Copy files (prefer over ADD) |
| WORKDIR | Set working directory |
| ENV | Environment variables |
| EXPOSE | Document ports (informational only) |
| CMD | Default command (can be overridden) |
| ENTRYPOINT | Container entry point (not easily overridden) |

## Multi-Stage Build: Node.js

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
RUN addgroup -g 1001 app && adduser -u 1001 -G app -s /bin/sh -D app
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json .
USER app
EXPOSE 8080
CMD ["node", "dist/server.js"]
```

## Multi-Stage Build: Go

```dockerfile
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /server ./cmd/server

FROM gcr.io/distroless/static-debian12
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /server /server
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/server"]
```

## Multi-Stage Build: Python

```dockerfile
FROM python:3.12-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim
RUN useradd --create-home --shell /bin/bash app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /home/app
COPY --chown=app:app . .
USER app
EXPOSE 8000
CMD ["gunicorn", "app:create_app()", "--bind", "0.0.0.0:8000", "--workers", "4"]
```

## Layer Caching Best Practices

Order instructions from least to most frequently changing:

```dockerfile
# 1. Base image (changes rarely)
FROM node:20-alpine

# 2. System deps (changes rarely)
RUN apk add --no-cache dumb-init

# 3. Package files (changes on dep updates)
COPY package*.json ./
RUN npm ci

# 4. Source code (changes frequently)
COPY . .
RUN npm run build
```

## Security Hardening

| Practice | Implementation |
|----------|---------------|
| Non-root user | `USER app` (never run as root) |
| Minimal base image | Alpine, distroless, or slim variants |
| No secrets in image | Use runtime env vars or mounted secrets |
| Read-only filesystem | `--read-only` flag at runtime |
| Pin base image digest | `FROM node:20-alpine@sha256:abc123` |
| Scan for vulnerabilities | `docker scout`, `trivy`, `grype` |
| Remove unnecessary tools | No curl, wget, shell in production images |

### .dockerignore

```
.git
node_modules
*.md
.env*
Dockerfile*
docker-compose*
.github
tests
```

## Docker Compose (Development)

```yaml
services:
  app:
    build: .
    ports: ["8080:8080"]
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/myapp
    depends_on:
      db: { condition: service_healthy }

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes: [db-data:/var/lib/postgresql/data]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d myapp"]
      interval: 5s
      retries: 5

volumes:
  db-data:
```

## Image Size Optimization

| Technique | Impact |
|-----------|--------|
| Multi-stage builds | Only ship runtime, not build tools |
| Alpine/distroless | 5-50MB vs 200-800MB for full images |
| Combine RUN commands | Fewer layers, smaller image |
| `.dockerignore` | Exclude unnecessary files from build context |
| `--no-install-recommends` | Skip optional apt packages |
| Clean caches in same RUN | `rm -rf /var/lib/apt/lists/*` |

## Checklist

- [ ] Multi-stage build separates build and runtime
- [ ] Non-root user configured
- [ ] Base image pinned to specific version
- [ ] `.dockerignore` excludes unnecessary files
- [ ] No secrets baked into image
- [ ] Health check defined
- [ ] Image scanned for vulnerabilities
- [ ] Layer order optimized for caching
