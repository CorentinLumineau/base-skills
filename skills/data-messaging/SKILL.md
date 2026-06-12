---
name: data-messaging
description: >
  Use when implementing message queues or event-driven architectures. Covers
  patterns for decoupled, scalable systems with async communication. Do NOT use
  for database design (use data-data-persistence) or CI/CD pipelines.
allowed-tools: Read Grep Glob
metadata:
  type: knowledge
  license: MIT
  compatibility: always-on
---

<!-- ported from mercure-plugin/skills/data-messaging/ -->

# Messaging & Event-Driven Patterns

Asynchronous messaging patterns for decoupled, scalable systems.

## Quick Reference (80/20)

Focus on these three decisions (80% of messaging success):

| Decision | Key Factor | Default Choice |
|----------|-----------|----------------|
| Broker selection | Throughput vs simplicity | Kafka for streams, RabbitMQ for tasks |
| Delivery guarantee | Business requirements | At-least-once + idempotent consumers |
| Error handling | Failure recovery | Dead letter queues with retry |

## Broker Comparison

| Feature | Kafka | RabbitMQ | SQS/SNS |
|---------|-------|----------|---------|
| Model | Log-based stream | Message broker | Managed queue |
| Ordering | Per-partition | Per-queue (FIFO) | FIFO optional |
| Throughput | Very high (millions/s) | High (10K+/s) | High (managed) |
| Retention | Configurable (days/forever) | Until consumed | 14 days max |
| Replay | Yes (offset reset) | No | No |
| Use case | Event streaming, audit logs | Task queues, RPC | Cloud-native async |
| Ops burden | High (ZooKeeper/KRaft) | Medium | None (managed) |

## Core Patterns

### Point-to-Point (Queue)

One producer, one consumer per message. Use for task distribution.

```
Producer --> [Queue] --> Consumer
                     --> Consumer  (competing consumers)
```

### Publish-Subscribe (Topic)

One producer, many consumers. Use for event broadcasting.

```
Producer --> [Topic] --> Consumer A (notifications)
                     --> Consumer B (analytics)
                     --> Consumer C (audit)
```

### Request-Reply

Synchronous-style communication over async transport.

```
Client --> [Request Queue] --> Server
Client <-- [Reply Queue]   <-- Server
```

## Delivery Guarantees

| Guarantee | Behavior | Risk |
|-----------|----------|------|
| At-most-once | Fire and forget | Message loss |
| At-least-once | Retry until ack | Duplicates |
| Exactly-once | Transactional | Performance cost |

**Default recommendation**: At-least-once delivery with idempotent consumers.

### Idempotent Consumer Pattern

```python
def handle_message(message):
    idempotency_key = message.headers["idempotency-key"]

    if already_processed(idempotency_key):
        return  # Skip duplicate

    process(message)
    mark_processed(idempotency_key)
    acknowledge(message)
```

## Dead Letter Queues (DLQ)

Messages that fail processing after retries go to a DLQ for investigation.

```yaml
retry_policy:
  max_retries: 3
  backoff: exponential
  initial_delay: 1s
  max_delay: 30s
  dlq: "orders-dlq"
```

**DLQ handling**:
1. Alert on DLQ depth > 0
2. Inspect failed messages (log reason)
3. Fix the consumer bug
4. Replay messages from DLQ

## Message Design

```json
{
  "id": "evt-uuid-1234",
  "type": "order.created",
  "source": "order-service",
  "time": "2024-01-15T10:30:00Z",
  "datacontenttype": "application/json",
  "data": {
    "orderId": "ORD-5678",
    "amount": 99.99,
    "currency": "USD"
  }
}
```

**Best practices**:
- Include correlation ID for tracing
- Use CloudEvents format for interoperability
- Keep messages small (< 1MB); use claim-check for large payloads
- Version your schemas (Avro, Protobuf, JSON Schema)

## Checklist

### Design Phase
- [ ] Broker selected based on requirements (Kafka vs RabbitMQ vs managed)
- [ ] Delivery guarantee chosen (default: at-least-once)
- [ ] Message schema defined with versioning
- [ ] Dead letter queue strategy planned

### Implementation
- [ ] Idempotent consumers implemented
- [ ] Retry policy with exponential backoff configured
- [ ] DLQ monitoring and alerting in place
- [ ] Correlation IDs included for tracing

### Operations
- [ ] Consumer lag monitored
- [ ] DLQ depth alerting configured
- [ ] Schema compatibility enforced
- [ ] Capacity planning documented

## Output Format

When referenced during a workflow, apply these standards by:
- Reporting async pattern conformance issues with component name, pattern type, and specific gap (e.g., "OrderConsumer: missing idempotency key check for at-least-once delivery")
- Using severity model: CRITICAL = BLOCK (no DLQ configured, message loss risk), HIGH = WARN (missing idempotent consumer, no retry policy), MEDIUM = INFO (schema versioning gap, missing correlation ID)
- Providing specific broker configuration recommendations and message design corrections
- Flagging dead letter handling gaps with suggested DLQ policies and alerting thresholds

## Worked Examples

### Broker Selection

**Input**: "We need to process 50K order events/second with replay capability for debugging. Team has 3 engineers, running on AWS."

**Output**: **Kafka** (managed via Amazon MSK). Rationale: (1) 50K/s throughput needs log-based streaming. (2) Replay via offset reset — RabbitMQ and SQS don't support replay. (3) MSK reduces ops burden. Trade-off: higher learning curve than SQS, but replay requirement eliminates SQS. Partition strategy: partition by `orderId` for per-order ordering guarantee.

### Dead Letter Queue Handling

**Input**: `order-processing` consumer fails on message `evt-uuid-5678` with `PaymentGatewayTimeout` after 3 retries.

**Output**: (1) Alert fired: DLQ depth = 1. (2) Inspect failure reason: `PaymentGatewayTimeout` after 3 retries (1s, 2s, 4s exponential backoff). (3) Diagnosis: transient gateway issue (not a consumer bug). (4) Action: verify gateway healthy, then replay from DLQ. (5) Prevention: increase `max_retries` to 5 and `max_delay` to 60s for payment consumers.

## When to Load References

- **For Kafka patterns**: See `references/kafka-patterns.md`
- **For RabbitMQ patterns**: See `references/rabbitmq-patterns.md`
- **For event-driven architecture**: See `references/event-driven.md`
