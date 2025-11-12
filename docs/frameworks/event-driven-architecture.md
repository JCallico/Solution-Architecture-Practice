# Event-Driven Architecture

## Overview

Event-Driven Architecture (EDA) is an architectural pattern where system components communicate through the production, detection, and consumption of events. This pattern enables loose coupling, scalability, and real-time processing.

## Core Concepts

### What is an Event?

An event is a significant change in state or an occurrence that happened at a specific point in time.

**Event Characteristics:**
- **Immutable** - Events represent facts that cannot be changed
- **Timestamped** - Events capture when something happened
- **Contextual** - Events contain relevant information about what happened
- **Decoupled** - Event producers don't know who consumes the event

### Event Types

#### 1. Domain Events
Events that represent business-meaningful occurrences:
- `OrderPlaced`
- `PaymentProcessed`
- `InventoryUpdated`
- `CustomerRegistered`

#### 2. Integration Events
Events used for cross-system communication:
- `OrderShipped` (triggers notification service)
- `ProductPriceChanged` (updates catalog service)

#### 3. System Events
Technical events for infrastructure concerns:
- `ServiceStarted`
- `ThresholdExceeded`
- `ErrorOccurred`

## Architecture Patterns

### 1. Event Notification

**Pattern:** Publisher sends lightweight event notifications; consumers request details if interested.

**When to Use:**
- Loose coupling is priority
- Consumers need different levels of detail
- Network bandwidth considerations

**Example:**
```
OrderService → OrderPlaced(orderId) → [Notification, Analytics, Warehouse]
Each service fetches order details as needed
```

### 2. Event-Carried State Transfer

**Pattern:** Event contains all necessary data; consumers maintain local copies.

**When to Use:**
- Reduce coupling between services
- Improve query performance
- Eventual consistency is acceptable

**Example:**
```
ProductService → ProductUpdated(fullProductData) → [Catalog, Recommendation, Search]
Each service stores product data locally
```

### 3. Event Sourcing

**Pattern:** Store all changes as sequence of events; current state is derived from event history.

**When to Use:**
- Audit trail required
- Time-travel queries needed
- Complex domain logic
- CQRS implementation

**Benefits:**
- Complete audit history
- Temporal queries
- Event replay for debugging
- Natural fit for CQRS

**Challenges:**
- Event schema evolution
- Storage requirements
- Query complexity

### 4. CQRS (Command Query Responsibility Segregation)

**Pattern:** Separate read and write models; often combined with event sourcing.

**Components:**
- **Command Model** - Handles writes, validates business rules
- **Query Model** - Optimized read models, eventually consistent
- **Events** - Synchronize command and query models

**Benefits:**
- Optimized read and write models
- Scalability
- Flexibility in data storage

## Key Components

### Event Producer

Component that detects and publishes events.

**Responsibilities:**
- Detect state changes
- Create event messages
- Publish to event bus
- Handle failures

**Best Practices:**
- Use consistent event naming
- Include correlation IDs
- Version events from start
- Keep events immutable

### Event Consumer

Component that subscribes to and processes events.

**Processing Patterns:**

#### Competing Consumers
Multiple instances process from same queue:
```
EventBus → Queue → [Consumer1, Consumer2, Consumer3]
```
- Load balancing
- Scalability
- At-least-once delivery

#### Publish-Subscribe
Each subscriber receives copy:
```
EventBus → Topic → [SubscriberA, SubscriberB, SubscriberC]
```
- Multiple independent consumers
- Fan-out pattern
- Each gets all events

**Best Practices:**
- Idempotent processing
- Handle duplicates
- Dead letter queues
- Retry strategies

### Event Bus/Broker

Infrastructure for routing events from producers to consumers.

**Options:**
- **Apache Kafka** - High throughput, distributed log
- **RabbitMQ** - Feature-rich message broker
- **AWS SNS/SQS** - Cloud-native pub/sub
- **Azure Event Grid** - Serverless event routing
- **Azure Service Bus** - Enterprise messaging
- **Google Cloud Pub/Sub** - Global messaging

## Implementation Patterns

### Saga Pattern

Manage distributed transactions across services using events.

**Choreography Saga:**
```
OrderService → OrderCreated →
  PaymentService → PaymentProcessed →
    InventoryService → InventoryReserved →
      ShippingService → OrderShipped
```

**Orchestration Saga:**
```
SagaOrchestrator coordinates:
  1. Create Order
  2. Process Payment
  3. Reserve Inventory
  4. Ship Order
```

**Compensation:**
- Define compensating transactions
- Handle partial failures
- Maintain saga state

### Outbox Pattern

Ensure reliable event publishing with database transactions.

**Flow:**
1. Business transaction updates database
2. Insert event into outbox table (same transaction)
3. Background process publishes events
4. Mark events as published

**Benefits:**
- Transactional consistency
- At-least-once delivery
- No dual-write problem

### Inbox Pattern

Ensure idempotent event processing.

**Flow:**
1. Receive event
2. Check inbox for duplicate (by event ID)
3. If new, process and record in inbox
4. If duplicate, skip processing

## Event Schema Design

### Schema Structure

```json
{
  "eventId": "uuid",
  "eventType": "OrderPlaced",
  "eventVersion": "1.0",
  "timestamp": "2025-11-12T10:30:00Z",
  "correlationId": "order-123",
  "causationId": "previous-event-id",
  "source": "order-service",
  "data": {
    "orderId": "123",
    "customerId": "456",
    "totalAmount": 99.99,
    "items": [...]
  },
  "metadata": {
    "userId": "789",
    "sessionId": "xyz"
  }
}
```

### Schema Evolution

**Strategies:**
1. **Add Only** - Only add optional fields
2. **Versioning** - Use semantic versioning
3. **Transformation** - Upcasting old events
4. **Schema Registry** - Centralized schema management

**Best Practices:**
- Never remove fields
- Make new fields optional
- Document breaking changes
- Support multiple versions

## Event Ordering

### Ordering Guarantees

**Global Ordering:**
- All events ordered system-wide
- Difficult to scale
- Rarely needed

**Partition Ordering:**
- Events for same key ordered
- Kafka partitions
- SQS FIFO queues
- Scalable approach

**No Ordering:**
- Maximum scalability
- Application handles ordering
- Design for eventual consistency

### Handling Out-of-Order Events

**Techniques:**
1. **Version Numbers** - Track entity versions
2. **Timestamps** - Compare event times
3. **Causal Ordering** - Track event dependencies
4. **Sequence Numbers** - Partition-level ordering

## Error Handling

### Retry Strategies

**Exponential Backoff:**
```
Retry 1: 1 second
Retry 2: 2 seconds
Retry 3: 4 seconds
Retry 4: 8 seconds
```

**Circuit Breaker:**
- Stop retrying after threshold
- Prevent cascade failures
- Periodic recovery attempts

### Dead Letter Queues

**Purpose:**
- Store failed messages
- Manual intervention
- Analysis and debugging

**When to DLQ:**
- Exceeded retry limit
- Poison messages
- Schema validation failures

## Monitoring & Observability

### Key Metrics

**Event Metrics:**
- Event production rate
- Event consumption rate
- Processing latency
- Error rates
- Queue depth

**Business Metrics:**
- Events by type
- Processing time by event type
- Failed events by reason

### Distributed Tracing

**Correlation:**
- Trace events across services
- Correlation IDs
- Causation IDs
- OpenTelemetry integration

**Visualization:**
- Event flow diagrams
- Latency analysis
- Bottleneck identification

## Testing Strategies

### Unit Testing
- Test event creation
- Test event handlers in isolation
- Mock event bus

### Integration Testing
- Test event flow
- Test with real message broker
- Verify ordering guarantees

### Contract Testing
- Verify event schemas
- Consumer-driven contracts
- Schema compatibility testing

### Chaos Engineering
- Simulate message loss
- Test duplicate handling
- Verify compensation logic

## Best Practices

### Design Principles

1. **Events are Facts** - Immutable, past tense
2. **Single Responsibility** - One event per business occurrence
3. **Self-Contained** - Include necessary context
4. **Versioned** - Support evolution
5. **Correlated** - Traceable across services

### Operational Excellence

1. **Monitoring** - Comprehensive event tracking
2. **Alerting** - Detect anomalies quickly
3. **Replay Capability** - Recover from failures
4. **Schema Registry** - Centralized management
5. **Documentation** - Document all events

### Common Pitfalls

❌ **Event Coupling** - Events too specific to consumers
❌ **God Events** - Events containing everything
❌ **Missing Idempotency** - Not handling duplicates
❌ **Ignoring Ordering** - Assuming global order
❌ **No Versioning** - Breaking changes without migration
❌ **Synchronous Mindset** - Expecting immediate consistency

## Use Cases

### E-commerce Platform
- Order processing
- Inventory management
- Payment processing
- Shipping notifications

### IoT Systems
- Sensor data streaming
- Real-time analytics
- Alert processing
- Device state management

### Financial Services
- Transaction processing
- Fraud detection
- Audit logging
- Market data distribution

### Social Media
- Activity streams
- Notifications
- Content distribution
- Analytics

## Migration Strategies

### Strangler Fig Pattern

1. Identify bounded context
2. Introduce event bus
3. Dual-write events
4. Migrate consumers gradually
5. Remove old integration

### Event Interception

1. Intercept database changes (CDC)
2. Publish as events
3. Gradual consumer adoption
4. Eventual removal of interception

## Tools & Technologies

### Message Brokers
- **Apache Kafka** - Distributed streaming platform
- **RabbitMQ** - AMQP message broker
- **NATS** - Cloud-native messaging
- **Apache Pulsar** - Multi-tenant messaging

### Cloud Services
- **AWS EventBridge** - Serverless event bus
- **AWS SNS/SQS** - Pub/sub and queuing
- **Azure Event Grid** - Event routing
- **Azure Service Bus** - Enterprise messaging
- **Google Cloud Pub/Sub** - Global messaging

### Frameworks
- **Spring Cloud Stream** - Event-driven microservices
- **MassTransit** - .NET message bus
- **NServiceBus** - Enterprise service bus
- **Axon Framework** - Event sourcing & CQRS

## Related Resources

- [Microservices Architecture](./microservices.md)
- [Domain-Driven Design](./domain-driven-design.md)
- [Integration Patterns](../knowledge-base/patterns/integration-patterns.md)
- [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md)

## References

- _Enterprise Integration Patterns_ by Gregor Hohpe
- _Building Event-Driven Microservices_ by Adam Bellemare
- _Designing Data-Intensive Applications_ by Martin Kleppmann
- [AWS Event-Driven Architecture](https://aws.amazon.com/event-driven-architecture/)
- [Azure Event-Driven Architecture](https://docs.microsoft.com/azure/architecture/guide/architecture-styles/event-driven)

---

**Last Updated:** November 2025  
**Related:** [Microservices](./microservices.md) | [DDD](./domain-driven-design.md) | [Integration Patterns](../knowledge-base/patterns/integration-patterns.md)
