# Integration Patterns

## Overview

Integration patterns address communication and data flow between distributed systems. These patterns handle async messaging, event-driven architecture, and system-to-system communication.

---

## Messaging Patterns

### 1. Point-to-Point (Queue)

**Problem:** Sender needs reliable delivery to single consumer.

**Solution:** Message queue holds messages until consumer processes.

```
Sender → Message Queue → Consumer
  ↓          ↓            ↓
Message    Persisted    Processed
sent       to disk      and deleted
```

**Guarantee:** Exactly once (if not reprocessed)

**Use cases:**
- Email delivery
- Payments
- Order processing

---

### 2. Publish-Subscribe (Topic)

**Problem:** Single event needs to reach multiple consumers.

**Solution:** Event published to topic, all subscribers receive copy.

```
Publisher → Event Topic → Subscriber 1
              ↓           Subscriber 2
              ↓           Subscriber 3
           Message        (all get event)
          multicast
```

**Guarantee:** At-least-once per subscriber

**Use cases:**
- Events (user registered, order shipped)
- Notifications
- Data synchronization

---

### 3. Message Bus

**Problem:** Complex integration between many services.

**Solution:** Central bus routes messages between services.

```
Service A → Bus → Service B
Service C → ↓  → Service D
Service E ← ↓  ← Service F
```

**Patterns:**
- Peer-to-peer: Services communicate directly
- Broker: Central message broker routes
- Hybrid: Mix of both

---

### 4. Request-Reply

**Problem:** Sender needs response from receiver.

**Solution:** Sender sends request, waits for reply.

```
Request: Sender → Queue → Receiver
              ↓
Receiver processes
              ↓
Reply: Sender ← Queue ← Receiver
```

**Implementation:** Message ID correlation

---

## Routing Patterns

### 5. Content-Based Router

**Problem:** Route messages based on content.

**Solution:** Inspect message, route to appropriate destination.

```
Order message
  ├─ Priority=High → Urgent Queue
  ├─ Type=Express → Express Handler
  └─ Default → Standard Queue
```

---

### 6. Message Filter

**Problem:** Consumer only wants certain messages.

**Solution:** Filter messages before delivery.

```
All events → Filter (type == "order") → Consumer
                                       (only sees
                                        order events)
```

---

### 7. Aggregator

**Problem:** Need to combine multiple messages into one.

**Solution:** Aggregate related messages.

```
Message 1 ─┐
Message 2 ─┼─ Aggregator → Combined message
Message 3 ─┘   (correlate by ID)
```

**Use cases:**
- Collect order items into order
- Combine payment events
- Batch processing

---

## Transformation Patterns

### 8. Message Translator

**Problem:** Different systems use different message formats.

**Solution:** Translate between formats.

```
System A Format          Translator          System B Format
{                                            [
  "firstName": "John"    ──────→   {          "first_name": "John"
  "lastName": "Doe"                 "first_name": "John"
}                                   "last_name": "Doe"
                                 }
                                ]
```

---

## Event-Driven Patterns

### 9. Event Sourcing

**Problem:** Lose history of what happened.

**Solution:** Store all events, derive state from them.

```
Events:
1. OrderCreated(id: 123, items: [...])
2. PaymentProcessed(order: 123, amount: 100)
3. OrderShipped(order: 123)
4. OrderDelivered(order: 123)

Current State = Reduce(events)
```

---

### 10. Event Notification

**Problem:** Changes in one service need to notify other services.

**Solution:** Services publish events when changes occur.

```
Order Service (changes order)
  ↓
Publishes: order.shipped event
  ↓
Subscribed services receive event:
  - Inventory Service (update stock)
  - Notification Service (send email)
  - Analytics Service (update metrics)
```

---

## Reliability Patterns

### 11. Idempotent Receiver

**Problem:** Duplicate messages cause problems.

**Solution:** Receiver can safely process same message multiple times.

```
Implementation:
1. Store processed message IDs in database
2. On receipt, check if message ID already processed
3. If yes, skip processing, return cached result
4. If no, process and store ID

Idempotent operations:
- Set state: OK to repeat
- Add 1: NOT idempotent (need check)
- Email send: Use ID deduplication
```

---

### 12. Dead Letter Queue

**Problem:** Failed messages pile up in main queue.

**Solution:** Move failed messages to dead letter queue.

```
Message Queue
  ├─ Process
  ├─ Success → Delete
  ├─ Failure (retry 3x)
  └─ Still failing → Dead Letter Queue
                     ↓
                 Manual review
                 ↓
                 Fix & replay or discard
```

---

## Data Flow Patterns

### 13. Saga Pattern

**Problem:** Distributed transaction across services.

**Solution:** Break into steps, compensate on failure.

```
Choreography (event-driven):
Order Created → Inventory Reserved → Payment Charged → Order Shipped
  ↓ (fail)       ↓ (fail)            ↓ (fail)          ↓ (fail)
Compensate   Compensate           Compensate        Compensate
```

---

## References

- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/)
- [Microservices Patterns](https://microservices.io/patterns/)
- Envelope Wrapper
- Content Enricher
- Content Filter
- Claim Check

### Endpoint Patterns
- Messaging Gateway
- Transactional Client
- Polling Consumer
- Event-Driven Consumer
- Service Activator

### System Management
- Control Bus
- Detour
- Wire Tap
- Message History

## Related Resources

- [API Design Guide](../playbooks/api-design-guide.md)
- [Reference Architecture: API Platform](../reference-architectures/api-platform.md)
- [Microservices Framework](../../frameworks/microservices.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
