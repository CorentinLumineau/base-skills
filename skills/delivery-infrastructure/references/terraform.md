# Terraform

<!-- ported from mercure-plugin/skills/delivery-infrastructure/references/terraform.md -->

## Core Concepts

| Concept | Purpose |
|---------|---------|
| Provider | Interface to cloud APIs |
| Resource | Infrastructure component |
| Module | Reusable configuration |
| State | Tracks managed resources |
| Workspace | Isolated state environments |
| Backend | Remote state storage |

## Project Structure

```
infrastructure/
├── modules/           # Reusable modules
│   ├── rds/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   └── ecs/
├── environments/
│   ├── dev/
│   │   ├── main.tf     # Module calls with dev values
│   │   └── terraform.tfvars
│   ├── staging/
│   └── prod/
├── shared/             # Cross-environment resources
└── backend.tf          # State backend config
```

## Module Best Practices

```hcl
# modules/rds/variables.tf
variable "instance_class" {
  type        = string
  description = "RDS instance class"
  validation {
    condition     = can(regex("^db\\.", var.instance_class))
    error_message = "Instance class must start with 'db.'"
  }
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# modules/rds/main.tf
resource "aws_db_instance" "main" {
  identifier     = "${var.project}-${var.environment}"
  instance_class = var.instance_class
  engine         = "postgres"
  engine_version = "16"

  storage_encrypted   = true       # Always encrypt
  deletion_protection = var.environment == "prod"
  multi_az           = var.environment == "prod"

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-db" })
}
```

## State Management

### Remote Backend

```hcl
terraform {
  backend "s3" {
    bucket         = "company-terraform-state"
    key            = "env/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # State locking
  }
}
```

### Common State Operations

```bash
terraform import aws_instance.web i-1234567890  # Import existing resource
terraform state mv module.old module.new         # Rename module
terraform state rm aws_instance.web              # Remove from state (keep in cloud)
terraform state list                              # List managed resources
```

### Remote State Data Source

```hcl
# Read outputs from another state file
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = { bucket = "company-terraform-state", key = "shared/vpc.tfstate" }
}

# Use: data.terraform_remote_state.vpc.outputs.vpc_id
```

## Variables and Validation

```hcl
variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the service"
  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All entries must be valid CIDR blocks."
  }
}

locals {
  is_production = var.environment == "prod"
  name_prefix   = "${var.project}-${var.environment}"
  common_tags   = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

## Sensitive Data Handling

```hcl
variable "db_password" {
  type      = string
  sensitive = true  # Redacted from output and logs
}

resource "random_password" "db" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = random_password.db.result
}
```

## Safety Practices

| Practice | Implementation |
|----------|---------------|
| Plan before apply | Always run `terraform plan` and review |
| Lock state | Use DynamoDB/GCS locking |
| Version pin | Pin provider and module versions |
| Least privilege | IAM role per environment |
| Blast radius | Split state by environment/service |
| Drift detection | Scheduled `terraform plan` in CI |

## CI/CD Integration

```yaml
# Terraform CI pipeline stages
stages:
  - validate: terraform validate && terraform fmt -check
  - plan: terraform plan -out=plan.tfplan
  - review: manual approval for production
  - apply: terraform apply plan.tfplan
```

## Checklist

- [ ] Remote backend with state locking configured
- [ ] State split by environment (separate state files)
- [ ] Provider and module versions pinned
- [ ] Sensitive variables marked as sensitive
- [ ] Validation rules on critical variables
- [ ] Encryption enabled for all storage resources
- [ ] `deletion_protection` on production databases
- [ ] Tags applied consistently via locals
- [ ] CI pipeline runs plan on PRs, apply after merge
- [ ] Drift detection scheduled
