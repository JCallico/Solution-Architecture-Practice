# Integration Architecture Framework

## Overview

The Integration Architecture Framework provides patterns and practices for designing systems that exchange data and coordinate functionality across multiple applications, services, and platforms. It addresses synchronous and asynchronous communication, message formats, orchestration, and integration governance.

## Core Principles

**Loose Coupling**
- Systems independent
- Changes don't cascade
- Can evolve separately
- Reduces dependencies

**Resilience**
- Handle failures gracefully
- Retry mechanisms
- Circuit breakers
- Fallback options

**Scalability**
- Async processing
- Message queuing
- Load balancing
- Horizontal scaling

**Observability**
- Track data flow
- Monitor integration health
- Log transaction flow
- Alert on failures

**Consistency**
- Data synchronization
- Conflict resolution
- Versioning
- Standards

## Integration Styles

### Synchronous Integration

**Request/Response Pattern**
```
System A → Request → System B
         ← Response ←
```

**Characteristics:**
- Immediate response
- Tight coupling
- Direct dependency
- Simple to understand
- Higher latency requirements

**Use Cases:**
- Real-time user actions
- Lookups
- Transactional operations
- Immediate feedback needed

**Technologies:**
- REST/HTTP
- gRPC
- SOAP
- Direct function calls

**Example:**

```python
# Order service calls payment service
import requests

def process_order(order_id, amount):
    # Synchronous call
    payment_response = requests.post(
        'https://payment-service/api/charge',
        json={'amount': amount, 'order_id': order_id},
        timeout=5
    )
    
    if payment_response.status_code == 200:
        return 'Order confirmed'
    else:
        return 'Payment failed'
```

### Asynchronous Integration

**Publish/Subscribe Pattern**
```
System A → Event → Message Broker → System B (if subscribed)
                      ↓
                   System C (if subscribed)
```

**Characteristics:**
- Fire and forget
- Loose coupling
- Eventual consistency
- Higher throughput
- Delayed response

**Use Cases:**
- Notifications
- Background processing
- Multi-system updates
- Analytics
- Audit trails

**Technologies:**
- Message queues (RabbitMQ, Azure Service Bus)
- Event streaming (Kafka, AWS Kinesis)
- Pub/sub (Google Pub/Sub, SNS)

**Example:**

```python
# Order service publishes event
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=['kafka:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

def place_order(order_data):
    # Process order
    order = create_order(order_data)
    
    # Publish event
    producer.send('order-created', {
        'order_id': order.id,
        'customer_id': order.customer_id,
        'total': order.total,
        'timestamp': datetime.now().isoformat()
    })
    
    return order
```

### Hybrid Integration

Combine synchronous and asynchronous:
- Synchronous for critical paths
- Asynchronous for notifications
- Request/reply over message bus
- Saga pattern for transactions

## Integration Patterns

### 1. Request/Reply

**When to Use:**
- Immediate response needed
- Transactional operations
- Small payloads

**Implementation:**

```
Client → Request → Server
      ← Response ←
    (Correlation ID)
```

**Challenge:** Server must be available
**Solution:** Timeouts, circuit breakers

### 2. Publish/Subscribe

**When to Use:**
- Multiple consumers
- Loose coupling
- Event notification

**Implementation:**

```
Publisher → Topic/Channel → Consumer 1
                          → Consumer 2
                          → Consumer N
```

**Challenge:** Message ordering, ordering
**Solution:** Partitions, sequence numbers

### 3. Queue-Based

**When to Use:**
- Work distribution
- Asynchronous processing
- Load leveling

**Implementation:**

```
Producer → Queue → Consumer
        (ordered)  (workers)
```

**Challenge:** Scaling consumers
**Solution:** Multiple workers, priority queues

### 4. Saga Pattern

**Distributed Transaction Across Services**

```
Service A (Order) → Request → Service B (Payment)
  ↓                                ↓
  If fails ←─────── Rollback ─────┘
  
Service B (Payment) → Request → Service C (Inventory)
  ↓                                ↓
  If fails ←─────── Rollback ─────┘
```

**Choreography vs Orchestration:**

**Choreography (Event-Driven):**
```
Order Service: Create order, publish OrderCreated
Payment Service: Listen to OrderCreated, process payment
  If successful: publish PaymentCompleted
  If fails: publish PaymentFailed
Inventory Service: Listen to PaymentCompleted, reserve inventory
  If successful: publish InventoryReserved
  If fails: publish ReservationFailed
```

**Orchestration (Central Coordinator):**
```
Order Saga Orchestrator
  ├─ Call Payment Service
  │  └─ On failure → Call Compensation
  ├─ Call Inventory Service
  │  └─ On failure → Call Compensation
  └─ Call Shipping Service
     └─ On failure → Call Compensation
```

### 5. Event Sourcing

Store state as sequence of events.

```
Initial State
    ↓
Event 1 (OrderCreated)
    ↓
Event 2 (PaymentProcessed)
    ↓
Event 3 (InventoryReserved)
    ↓
Current State (Order Confirmed)
```

**Benefits:**
- Complete audit trail
- Temporal queries
- Replay for debugging
- Event replay for recovery

**Example:**

```python
# Event sourcing pattern
class OrderAggregate:
    def __init__(self):
        self.events = []
        self.version = 0
    
    def create_order(self, order_id, customer_id, items):
        event = {
            'type': 'OrderCreated',
            'order_id': order_id,
            'customer_id': customer_id,
            'items': items,
            'timestamp': datetime.now()
        }
        self.events.append(event)
        self.version += 1
    
    def apply_payment(self, amount):
        event = {
            'type': 'PaymentApplied',
            'amount': amount,
            'timestamp': datetime.now()
        }
        self.events.append(event)
        self.version += 1
    
    def get_state(self):
        # Replay events to current state
        state = {}
        for event in self.events:
            if event['type'] == 'OrderCreated':
                state['order_id'] = event['order_id']
                state['customer_id'] = event['customer_id']
                state['items'] = event['items']
                state['status'] = 'Created'
            elif event['type'] == 'PaymentApplied':
                state['status'] = 'Paid'
        return state
```

## Message Formats & Protocols

### REST/HTTP

**Synchronous, widely supported**

```bash
POST /api/orders
Content-Type: application/json

{
  "customer_id": "CUST123",
  "items": [
    {"product_id": "PROD456", "quantity": 2}
  ]
}

200 OK
{
  "order_id": "ORD789",
  "status": "confirmed"
}
```

**Best For:**
- Web services
- Simple integrations
- Human-readable
- Wide tool support

**Challenges:**
- Not ideal for streaming
- Polling overhead
- State management

### gRPC

**High-performance, strongly-typed**

```protobuf
service OrderService {
  rpc CreateOrder(OrderRequest) returns (OrderResponse) {}
  rpc GetOrder(GetOrderRequest) returns (Order) {}
  rpc StreamOrders(Empty) returns (stream Order) {}
}

message OrderRequest {
  string customer_id = 1;
  repeated OrderItem items = 2;
}

message OrderResponse {
  string order_id = 1;
  OrderStatus status = 2;
}
```

**Best For:**
- Microservices
- High throughput
- Bidirectional streaming
- Low latency

**Challenges:**
- Steeper learning curve
- Binary format (not human-readable)
- Browser support limited

### Message Queues

**Asynchronous, reliable**

```
Producer:
{
  "message_id": "MSG123",
  "type": "order.created",
  "payload": {
    "order_id": "ORD789",
    "customer_id": "CUST123"
  },
  "timestamp": "2025-11-20T10:30:00Z"
}

Consumer:
- Receives message
- Processes (may fail)
- Acknowledges
- Message removed from queue
```

**Best For:**
- Asynchronous processing
- Decoupling services
- Load leveling
- Guaranteed delivery

**Challenges:**
- Complexity
- Operational overhead
- Eventual consistency

### Event Streaming

**High-volume, replay-capable**

```
Kafka Topic: orders
  ├─ Partition 0
  │  ├─ offset 0: OrderCreated
  │  ├─ offset 1: OrderConfirmed
  │  └─ offset 2: OrderShipped
  └─ Partition 1
     ├─ offset 0: OrderCreated
     └─ offset 1: OrderConfirmed

Consumers can:
- Process from beginning
- Resume from offset
- Consume in parallel
```

**Best For:**
- High-volume events
- Analytics
- Event replay
- Stream processing

## Integration Technologies

### Message Brokers

**RabbitMQ:**
```
- Message queue
- Pattern: Request/Reply, Pub/Sub
- Reliability: Persistent messages
- Scaling: Clustering
- Use: General-purpose messaging
```

**AWS SQS/SNS:**
```
SQS (Queue):
  - Managed queue
  - Guaranteed delivery
  - Scaling: Automatic
  - Cost: Pay-per-request

SNS (Topic):
  - Pub/sub
  - Multiple subscribers
  - Filtering
  - Integration with services
```

**Azure Service Bus:**
```
- Queue and Topic
- Reliable messaging
- Dead-letter handling
- Session support
- Enterprise features
```

### Event Streaming

**Apache Kafka:**
```
- High throughput
- Log-based
- Consumer groups
- Topic partitioning
- Stream processing integration
```

**AWS Kinesis:**
```
- Managed streaming
- Shard-based
- Real-time analytics
- Low latency
- Auto-scaling
```

### API Gateway/Integration Platforms

**API Gateway:**
- Single entry point
- Routing
- Rate limiting
- API versioning
- Schema validation

**MuleSoft:**
```
- iPaaS platform
- Pre-built connectors
- Transformation
- Flow-based design
- Enterprise features
```

**Apache Camel:**
```
- Integration framework
- 300+ components
- Route definition
- Message transformation
- Production proven
```

## Integration Workflow Example

### E-Commerce Order Processing

**Architecture:**

```
Web App
  ↓
API Gateway
  ↓
Order Service (REST)
  ├─→ Order Database
  └─→ Kafka Topic: order-events
      ├─→ Payment Service (Consumer)
      ├─→ Inventory Service (Consumer)
      └─→ Notification Service (Consumer)
  
Payment Service
  ├─→ Stripe API (external)
  └─→ Kafka Topic: payment-events
  
Inventory Service
  └─→ Kafka Topic: inventory-events

Notification Service
  ├─→ Email Service (SMTP)
  └─→ SMS Service (Twilio)
```

**Flow:**

```
1. User creates order
   POST /orders → Order Service

2. Order Service
   - Validates order
   - Saves to database
   - Publishes "OrderCreated" event

3. Payment Service (Consumer)
   - Listens to "OrderCreated"
   - Calls Stripe API
   - Publishes "PaymentSucceeded" or "PaymentFailed"

4. Inventory Service (Consumer)
   - Listens to "PaymentSucceeded"
   - Reserves inventory
   - Publishes "InventoryReserved"

5. Notification Service (Consumer)
   - Listens to all events
   - Sends confirmation emails
   - Sends SMS notifications

6. Order Service (listens to events)
   - Updates order status
   - Publishes "OrderConfirmed"
```

## Integration Governance

### API Contract Management

**OpenAPI Specification:**
```yaml
openapi: 3.0.0
info:
  title: Order API
  version: 1.0.0
paths:
  /orders:
    post:
      summary: Create order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OrderRequest'
      responses:
        '201':
          description: Order created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
components:
  schemas:
    OrderRequest:
      type: object
      required:
        - customer_id
        - items
      properties:
        customer_id:
          type: string
        items:
          type: array
```

### Versioning Strategy

**URL-Based:**
```
POST /api/v1/orders    (old)
POST /api/v2/orders    (new)
```

**Header-Based:**
```
POST /api/orders
X-API-Version: 2
```

**Deprecation:**
```
Headers indicate deprecation date
Clients migrate to new version
Old version removed after grace period
```

### Data Synchronization

**Challenges:**
- System A and B out of sync
- Temporary inconsistency
- Conflicting changes

**Solutions:**

**Master Data Management (MDM):**
- Single source of truth
- Other systems reference
- Reduces conflicts

**Eventual Consistency:**
- Accept temporary inconsistency
- Audit trails for resolution
- Timestamp-based ordering

**Compensation:**
- Detect inconsistency
- Trigger correction
- Audit for resolution

## Integration Patterns Decision Tree

```
Need immediate response?
├─ Yes → Synchronous (REST/gRPC)
│        ├─ Simple API? → REST
│        └─ High performance? → gRPC
└─ No → Asynchronous
        ├─ Single consumer? → Queue
        ├─ Multiple consumers? → Pub/Sub
        └─ Replay events? → Event Streaming

Need guaranteed delivery?
├─ Yes → Persistent Queue/Topic
└─ No → Can tolerate loss? → In-memory

Transaction scope?
├─ Single service → Transactional
├─ Multiple services → Saga
└─ Event replay → Event Sourcing
```

## Integration Monitoring

**Key Metrics:**
- Message latency (p50, p95, p99)
- Throughput (messages/second)
- Error rate
- Consumer lag
- Queue depth
- Dead letter queue

**Observability:**
```
Logs:
  - Message payloads (sanitized)
  - Processing time
  - Errors and retries

Traces:
  - Request ID across services
  - Latency per hop
  - Service dependencies

Metrics:
  - Counters (messages processed)
  - Gauges (queue depth)
  - Histograms (latencies)
```

## Best Practices

✅ **Design for Failures**
Assume systems will fail.

✅ **Idempotent Processing**
Safe to process message multiple times.

✅ **Schema Versioning**
Support old and new formats.

✅ **Correlation IDs**
Track requests across systems.

✅ **Dead Letter Handling**
Process failed messages separately.

✅ **Monitoring & Alerting**
Know when things break.

✅ **Testing Integration**
Test with real dependencies or mocks.

❌ **Tight Coupling**
Changes cascade across systems.

❌ **Synchronous for Everything**
Creates bottlenecks and failures.

❌ **Lost Messages**
No guaranteed delivery.

❌ **No Observability**
Can't diagnose problems.

## Related Resources

- [Event-Driven Architecture](./event-driven-architecture.md)
- [Microservices Architecture](./microservices.md)
- [API-First Design](./api-first.md)
- [Well-Architected Frameworks](./well-architected.md)

## References

- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/)
- [Kafka: The Definitive Guide](https://www.confluent.io/resources/kafka-the-definitive-guide/)
- [Building Microservices](https://learning.oreilly.com/library/view/building-microservices-2nd/9781492034018/) (Newman)
- [AWS Integration Patterns](https://docs.aws.amazon.com/prescriptive-guidance/)

---

**Last Updated:** November 2025  
**Related:** [Event-Driven Architecture](./event-driven-architecture.md) | [Microservices Architecture](./microservices.md) | [API-First Design](./api-first.md)
