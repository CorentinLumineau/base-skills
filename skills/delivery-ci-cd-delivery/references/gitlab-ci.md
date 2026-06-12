# GitLab CI

<!-- ported from mercure-plugin/skills/delivery-ci-cd-delivery/references/gitlab-ci.md -->

## Overview

GitLab CI/CD is integrated directly into GitLab, providing powerful pipeline capabilities. This reference covers pipeline configuration, stages, and advanced patterns.

## Quick Reference (80/20)

| Concept | Purpose |
|---------|---------|
| Pipeline | Collection of jobs organized in stages |
| Stage | Group of jobs that run in parallel |
| Job | Individual task with scripts |
| Runner | Agent that executes jobs |
| Artifact | Files passed between jobs |
| Cache | Dependencies reused across pipelines |

## Patterns

### Pattern 1: Basic Pipeline Structure

**When to Use**: Standard CI/CD pipeline

**Example**:
```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - deploy

default:
  image: node:20-alpine
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/
    policy: pull

variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"
  FF_USE_FASTZIP: "true"

.node_setup:
  before_script:
    - npm ci --cache .npm --prefer-offline

lint:
  stage: lint
  extends: .node_setup
  script:
    - npm run lint
  cache:
    policy: pull-push

test:
  stage: test
  extends: .node_setup
  script:
    - npm test -- --coverage
  coverage: '/All files\s+\|\s+[\d.]+\s+\|\s+[\d.]+\s+\|\s+[\d.]+\s+\|\s+([\d.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
      junit: junit.xml
    paths:
      - coverage/
    expire_in: 1 week

build:
  stage: build
  extends: .node_setup
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 day
  only:
    - main
    - merge_requests

deploy_staging:
  stage: deploy
  script:
    - ./deploy.sh staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - main

deploy_production:
  stage: deploy
  script:
    - ./deploy.sh production
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

**Anti-Pattern**: No stages defined, all jobs run in default stage.

### Pattern 2: Include and Extend

**When to Use**: Reusing configuration across projects

**Example**:
```yaml
# templates/node-ci.yml (in shared repository)
.node_defaults:
  image: node:20-alpine
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/

.lint_template:
  extends: .node_defaults
  stage: lint
  script:
    - npm ci
    - npm run lint

.test_template:
  extends: .node_defaults
  stage: test
  script:
    - npm ci
    - npm test

# Project .gitlab-ci.yml
include:
  - project: 'devops/ci-templates'
    ref: main
    file: '/templates/node-ci.yml'
  - local: '/.gitlab/security.yml'
  - template: Security/SAST.gitlab-ci.yml

stages:
  - lint
  - test
  - build
  - security
  - deploy

lint:
  extends: .lint_template

test:
  extends: .test_template
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'

build:
  extends: .build_template
  only:
    - main
    - merge_requests
```

**Anti-Pattern**: Copy-pasting CI configuration between projects.

### Pattern 3: Rules and Workflow

**When to Use**: Conditional job execution

**Example**:
```yaml
workflow:
  rules:
    # Don't run on draft MRs
    - if: $CI_MERGE_REQUEST_TITLE =~ /^Draft:/
      when: never
    # Run on merge requests
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    # Run on main branch
    - if: $CI_COMMIT_BRANCH == "main"
    # Run on tags
    - if: $CI_COMMIT_TAG

test:
  stage: test
  script:
    - npm test
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_TAG
      when: manual
    - when: never
```

**Anti-Pattern**: Using `only/except` instead of `rules` (deprecated).

### Pattern 4: Dynamic Child Pipelines

**When to Use**: Monorepos, dynamic pipeline generation

**Example**:
```yaml
# Parent pipeline
stages:
  - generate
  - trigger

generate_pipelines:
  stage: generate
  image: python:3.11
  script:
    - python scripts/generate-pipelines.py
  artifacts:
    paths:
      - generated-pipelines/

trigger_service_a:
  stage: trigger
  trigger:
    include:
      - artifact: generated-pipelines/service-a.yml
        job: generate_pipelines
    strategy: depend
  rules:
    - changes:
        - services/service-a/**/*
```

**Anti-Pattern**: Single monolithic pipeline for monorepos.

### Pattern 5: Environments and Review Apps

**When to Use**: Managed deployments with review apps

**Example**:
```yaml
# Dynamic review environments
review:
  stage: review
  script:
    - kubectl apply -f k8s/review/
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: https://$CI_COMMIT_REF_SLUG.review.example.com
    on_stop: stop_review
    auto_stop_in: 1 week
  rules:
    - if: $CI_MERGE_REQUEST_IID

stop_review:
  stage: review
  script:
    - kubectl delete namespace review-$CI_COMMIT_REF_SLUG
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop
  rules:
    - if: $CI_MERGE_REQUEST_IID
      when: manual

production:
  stage: production
  script:
    - ./deploy.sh production
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
  resource_group: production  # Prevent concurrent deploys
```

**Anti-Pattern**: No environment tracking, manual deployment management.

### Pattern 6: Secrets and Variables

**When to Use**: Secure credential management

**Example**:
```yaml
deploy:
  stage: deploy
  script:
    # HashiCorp Vault integration
    - export DB_PASSWORD=$(vault kv get -field=password secret/db)

  # Protect secrets in job output
  secrets:
    DATABASE_URL:
      vault: production/db/url@secrets
  id_tokens:
    VAULT_ID_TOKEN:
      aud: https://vault.example.com
```

**Anti-Pattern**: Storing secrets in repository or exposing in logs.

## Checklist

- [ ] Pipeline stages logically organized
- [ ] Templates used for reusable configuration
- [ ] Include files for shared configuration
- [ ] Rules used instead of only/except
- [ ] Environments defined for deployments
- [ ] Review apps for merge requests
- [ ] Secrets managed securely
- [ ] Caching configured for dependencies
- [ ] Artifacts passed between jobs
- [ ] Resource groups prevent concurrent deploys
