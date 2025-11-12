# Domain-Driven Design (DDD)

Domain-Driven Design is a software development approach that focuses on modeling software to match the business domain.

## Overview

DDD emphasizes collaboration between technical and domain experts to create a shared understanding of the business domain, which is then reflected in the software design.

**Created by:** Eric Evans (2003)

## Core Concepts

### 1. Ubiquitous Language
A common vocabulary shared by developers and domain experts.

**Benefits:**
- Reduces miscommunication
- Aligns code with business concepts
- Improves documentation quality
- Facilitates knowledge transfer

**Practice:**
- Use business terms in code (classes, methods, variables)
- Avoid technical jargon in domain logic
- Refine language through conversations
- Document in [ADRs](./adr-framework.md) when terms evolve

### 2. Bounded Contexts
Explicit boundaries within which a particular model is defined and applicable.

**Key Principles:**
- Each context has its own model
- Same term can mean different things in different contexts
- Contexts have explicit interfaces
- Align with team boundaries when possible

**Example:**
```
┌─────────────────────┐      ┌─────────────────────┐
│  Order Management   │      │    Shipping         │
│                     │      │                     │
│  Order = Purchase   │──────│  Order = Shipment   │
│  Request            │      │  Request            │
└─────────────────────┘      └─────────────────────┘
```

### 3. Context Mapping
Understanding and documenting relationships between bounded contexts.

**Context Relationship Patterns:**

| Pattern | Description | Use When |
|---------|-------------|----------|
| **Partnership** | Teams collaborate on integration | Shared success, mutual dependency |
| **Shared Kernel** | Shared model subset | Small overlap, high cohesion |
| **Customer-Supplier** | Downstream depends on upstream | Clear provider-consumer relationship |
| **Conformist** | Downstream conforms to upstream | No negotiation power, accept model |
| **Anti-corruption Layer** | Translation layer protects downstream | Upstream model doesn't fit, legacy integration |
| **Open Host Service** | Published API for all consumers | Many consumers, stable interface |
| **Published Language** | Well-documented shared format | Industry standards, cross-organization |
| **Separate Ways** | No integration | Independent functionality |

### 4. Strategic Design

**Building Blocks:**

#### Entities
Objects with unique identity that persists over time.

```java
public class Order {
    private OrderId id;  // Identity
    private CustomerId customerId;
    private OrderStatus status;
    // ... entity logic
}
```

#### Value Objects
Immutable objects defined by their attributes, not identity.

```java
public class Money {
    private final BigDecimal amount;
    private final Currency currency;
    // ... value object (immutable)
}
```

#### Aggregates
Cluster of entities and value objects with a root entity.

**Rules:**
- External references only to aggregate root
- Invariants enforced by aggregate root
- Transactional boundary
- Unit of persistence

```
Aggregate: Order
├── Order (Root)
├── OrderLineItem
├── OrderLineItem
└── ShippingAddress
```

#### Repositories
Provide collection-like interface for aggregate persistence.

```java
public interface OrderRepository {
    Order findById(OrderId id);
    void save(Order order);
    List<Order> findByCustomer(CustomerId customerId);
}
```

#### Domain Services
Operations that don't belong to entities or value objects.

```java
public class PricingService {
    Money calculatePrice(Order order, PricingRules rules);
}
```

#### Domain Events
Something significant that happened in the domain.

```java
public class OrderPlaced {
    private OrderId orderId;
    private CustomerId customerId;
    private LocalDateTime occurredAt;
}
```

### 5. Tactical Design Patterns

**Layered Architecture:**
```
┌──────────────────────────────────┐
│   Presentation Layer             │
├──────────────────────────────────┤
│   Application Layer              │  ← Orchestrates use cases
├──────────────────────────────────┤
│   Domain Layer                   │  ← Business logic
├──────────────────────────────────┤
│   Infrastructure Layer           │  ← Technical concerns
└──────────────────────────────────┘
```

**Hexagonal Architecture (Ports & Adapters):**
- Domain at center
- Ports define interfaces
- Adapters implement technical details
- Technology-agnostic domain

## Applying DDD in Our Practice

### When to Use DDD

✅ **Good For:**
- Complex business logic
- Long-lived systems
- Collaboration with domain experts
- Multiple bounded contexts
- Event-driven systems

❌ **Overkill For:**
- CRUD applications
- Simple data transformations
- Short-term tactical solutions
- Small team, simple domain

### DDD in Architecture Reviews

Include in [ARB submissions](../processes/arb/README.md):

- [ ] Bounded contexts identified
- [ ] Context map documented
- [ ] Ubiquitous language defined
- [ ] Aggregates designed
- [ ] Domain events identified
- [ ] Integration patterns chosen

### DDD and Microservices

DDD naturally aligns with [microservices](./microservices.md):

- Each microservice = one bounded context
- Aggregates define service boundaries
- Domain events for inter-service communication
- Anti-corruption layers for legacy integration

## DDD Patterns Library

### Event Storming
Workshop technique for exploring complex domains.

**Process:**
1. Domain events (orange) - What happened?
2. Commands (blue) - What causes events?
3. Aggregates (yellow) - What handles commands?
4. Bounded contexts (pink) - Group related concepts
5. Context mapping - How contexts relate

### Specification Pattern
Encapsulate business rules in reusable objects.

```java
public interface Specification<T> {
    boolean isSatisfiedBy(T candidate);
}

public class OverdueOrderSpec implements Specification<Order> {
    public boolean isSatisfiedBy(Order order) {
        return order.getDueDate().isBefore(LocalDate.now()) 
            && order.getStatus() != OrderStatus.PAID;
    }
}
```

### Repository Pattern
Abstract data persistence.

**Benefits:**
- Domain stays persistence-ignorant
- Easier testing (mock repositories)
- Swap implementations
- Clear aggregate boundaries

## Best Practices

1. **Start with Events** - Event storming reveals domain structure
2. **Refine Language** - Continuously improve ubiquitous language
3. **Protect Boundaries** - Use anti-corruption layers for integration
4. **Keep Aggregates Small** - Easier to understand and test
5. **Model for Today** - Don't over-engineer for future scenarios
6. **Separate Read/Write** - Consider [CQRS](../knowledge-base/patterns/data-patterns.md#cqrs) for complex domains
7. **Document Context Maps** - Critical for team alignment

## Resources

### Books
- *Domain-Driven Design* - Eric Evans (the "blue book")
- *Implementing Domain-Driven Design* - Vaughn Vernon (the "red book")
- *Domain-Driven Design Distilled* - Vaughn Vernon (quick intro)
- *Patterns, Principles, and Practices of DDD* - Scott Millett

### Our Resources
- [Microservices Architecture](./microservices.md)
- [Event-Driven Architecture](../knowledge-base/patterns/README.md#event-driven)
- [Data Patterns](../knowledge-base/patterns/data-patterns.md)
- [API Design Guide](../knowledge-base/playbooks/api-design-guide.md)

### Training
- [DDD Workshop](../training/workshops/README.md)
- [Microservices Learning Path](../training/learning-paths/microservices.md)

## Common Pitfalls

❌ **Anemic Domain Model** - Entities with only getters/setters
❌ **God Aggregates** - Aggregates that are too large
❌ **Ignoring Bounded Contexts** - One model for everything
❌ **Technology-Driven Design** - Letting DB schema drive domain
❌ **Premature Abstraction** - Complex patterns for simple domains
❌ **Skipping Ubiquitous Language** - Technical terms in domain

---

**Last Updated:** November 2025  
**Related:** [Microservices](./microservices.md) | [Event-Driven Architecture](../knowledge-base/patterns/README.md) | [Data Patterns](../knowledge-base/patterns/data-patterns.md)

*For DDD training, see [Architecture Fundamentals](../training/learning-paths/architecture-fundamentals.md)*
