---
name: diagram-mermaid
description: >
  Use when creating or reviewing diagrams using Mermaid syntax: flowcharts, sequence diagrams,
  entity-relationship diagrams, state machines, Gantt charts, class diagrams, and C4 architecture
  diagrams. Covers syntax reference, best practices, and layout tips for all major Mermaid
  diagram types. Do NOT use for generating images — Mermaid produces text-based diagram
  definitions that render in Markdown-compatible tools.
license: MIT
compatibility: >
  Always-on knowledge skill. Works with any agent that can produce Markdown.
  Rendered in GitHub, GitLab, Notion, Obsidian, and any Mermaid-compatible viewer.
metadata:
  type: knowledge
  domain: documentation
allowed-tools:
  - Read
  - Write
---

<!-- ported from mercure-plugin/skills/diagram-mermaid/ -->

# Mermaid Diagrams

**triggers**: Documenting architecture, illustrating a workflow, mapping state transitions,
showing sequence of API calls, creating an ER diagram, Gantt chart for a project plan

## Quick Reference

Mermaid diagrams are embedded in Markdown code blocks:

````markdown
```mermaid
{diagram content}
```
````

## Flowchart

```mermaid
flowchart TD
    A[Start] --> B{Decision?}
    B -->|Yes| C[Action A]
    B -->|No| D[Action B]
    C --> E[End]
    D --> E
```

### Syntax

```
flowchart {direction}
```

| Direction | Meaning |
|-----------|---------|
| `TD` / `TB` | Top-down |
| `LR` | Left-right |
| `RL` | Right-left |
| `BT` | Bottom-top |

**Node shapes**:
```
A[Rectangle]
B(Rounded)
C{Diamond / Decision}
D((Circle))
E>Asymmetric]
F[(Database)]
G[[Subprocess]]
```

**Edge types**:
```
A --> B         Arrow
A --- B         Line (no arrow)
A -.-> B        Dotted arrow
A ==> B         Thick arrow
A -->|label| B  Arrow with label
```

**Subgraphs**:
```
subgraph title
  A --> B
end
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant Client
    participant API
    participant DB

    Client->>API: POST /login {email, password}
    API->>DB: SELECT user WHERE email=?
    DB-->>API: user row
    API-->>Client: 200 {token}

    Client->>API: GET /profile (Bearer token)
    API-->>Client: 200 {profile}
```

### Syntax

```
sequenceDiagram
    participant A
    participant B

    A->>B: message           Solid arrow
    A-->>B: message          Dotted arrow (response)
    A-x B: message           Cross-end (async, fire-and-forget)
    A-)B: message            Open arrow (async)

    Note over A,B: text      Note spanning participants
    Note right of B: text    Note on one side

    loop {label}
      A->>B: retry
    end

    alt {condition}
      A->>B: path 1
    else {other}
      A->>B: path 2
    end

    opt {optional}
      A->>B: optional path
    end
```

## Entity-Relationship Diagram

```mermaid
erDiagram
    USER {
        uuid id PK
        string email UK
        string name
        timestamp created_at
    }
    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total
        string status
    }
    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
    }
    PRODUCT {
        uuid id PK
        string name
        decimal price
    }

    USER ||--o{ ORDER : "places"
    ORDER ||--|{ ORDER_ITEM : "contains"
    PRODUCT ||--o{ ORDER_ITEM : "appears in"
```

### Relationship Notation

```
||  Exactly one
|{  One or more
o|  Zero or one
o{  Zero or more
```

```
A ||--|| B     One-to-one
A ||--|{ B     One-to-many
A |o--o{ B     Zero-or-one to zero-or-many
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle

    Idle --> Processing : submit
    Processing --> Success : complete
    Processing --> Failed : error
    Failed --> Idle : retry
    Success --> [*]

    state Processing {
        [*] --> Validating
        Validating --> Executing
        Executing --> [*]
    }
```

### Syntax

```
stateDiagram-v2
    [*] --> State1      Initial transition
    State1 --> [*]      Terminal transition
    State1 --> State2 : event label
    State1 --> State2 : event [guard]

    state "Long name" as SN

    state ForkState <<fork>>
    state JoinState <<join>>
```

## Class Diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound() void
    }

    class Dog {
        +String breed
        +fetch() void
    }

    class Cat {
        +Boolean indoor
        +purr() void
    }

    Animal <|-- Dog : extends
    Animal <|-- Cat : extends
    Dog "1" --> "*" Owner : belongsTo
```

### Relationship Types

| Symbol | Meaning |
|--------|---------|
| `<|--` | Inheritance |
| `*--` | Composition |
| `o--` | Aggregation |
| `-->` | Association |
| `..>` | Dependency |
| `..` | Link (plain) |

### Visibility

| Symbol | Visibility |
|--------|-----------|
| `+` | Public |
| `-` | Private |
| `#` | Protected |
| `~` | Package |

## Gantt Chart

```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Design
        Architecture      :done,    des1, 2024-01-01, 2024-01-07
        UI Mockups        :done,    des2, 2024-01-05, 2024-01-12
    section Development
        Backend API       :active,  dev1, 2024-01-10, 2024-01-24
        Frontend          :         dev2, 2024-01-17, 2024-01-31
    section Testing
        Integration tests :         test1, after dev1, 7d
        UAT               :crit,    test2, after dev2, 5d
```

### Task States

| State | Meaning |
|-------|---------|
| `done` | Completed |
| `active` | In progress |
| `crit` | Critical path |
| (none) | Planned |

## C4 Architecture Diagrams

### Context Diagram (C4)

```mermaid
C4Context
    title System Context — Payment Service

    Person(customer, "Customer", "Places orders")
    System(payment, "Payment Service", "Processes payments")
    System_Ext(stripe, "Stripe", "Payment gateway")
    System_Ext(bank, "Bank", "Issues refunds")

    Rel(customer, payment, "Submits payment", "HTTPS")
    Rel(payment, stripe, "Charges card", "HTTPS API")
    Rel(stripe, bank, "Processes transaction", "Banking network")
```

### Container Diagram (C4)

```mermaid
C4Container
    title Container Diagram — API System

    Person(user, "User")
    Container(spa, "Web App", "React", "Single-page application")
    Container(api, "API", "Node.js", "REST API")
    ContainerDb(db, "Database", "PostgreSQL", "User and order data")
    Container_Ext(cache, "Cache", "Redis", "Session cache")

    Rel(user, spa, "Uses", "HTTPS")
    Rel(spa, api, "Calls", "HTTPS/JSON")
    Rel(api, db, "Reads/writes", "SQL")
    Rel(api, cache, "Reads/writes", "Redis protocol")
```

## Diagram Best Practices

1. **Left-to-right for processes**: `LR` direction reads naturally for workflows
2. **Top-down for hierarchies**: `TD` for trees, org charts, class hierarchies
3. **Keep it focused**: One concept per diagram — split large diagrams
4. **Label relationships**: Unlabeled edges often need more context
5. **Use subgraphs for grouping**: Cluster related nodes visually
6. **Consistent naming**: Use the same names as in code (`UserService`, not `User Service`)
7. **Add a title**: Use `---\ntitle: Name\n---` frontmatter or inline title

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Quotes in node labels | Use `["text with spaces"]` not bare text with spaces |
| Special characters breaking parse | Wrap label in quotes: `A["text & text"]` |
| Arrow direction reversed | Check `A --> B` direction; swap if needed |
| Diagram too wide | Switch to `TD` or split into subgraphs |
| Missing `end` for subgraph | Always close `subgraph` with `end` |
| `stateDiagram` vs `stateDiagram-v2` | Use `v2` — it supports nested states |
