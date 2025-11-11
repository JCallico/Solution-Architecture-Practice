# Architecture Patterns Library

## Overview

This library catalogs proven architecture patterns used across our organization. Each pattern provides a reusable solution to a common problem, complete with context, implementation guidance, and examples.

## Pattern Categories

### [Microservices Patterns](#microservices-patterns)
Patterns for building and organizing microservices architectures

### [Integration Patterns](#integration-patterns)
Patterns for integrating systems and services

### [Data Patterns](#data-patterns)
Patterns for data architecture and management

### [Cloud Patterns](#cloud-patterns)
Patterns for cloud-native architectures

### [Security Patterns](#security-patterns)
Patterns for secure system design

### [Resilience Patterns](#resilience-patterns)
Patterns for building resilient systems

---

## Microservices Patterns

### API Gateway Pattern
**Problem**: How do clients access microservices when there are many services with different protocols and concerns like security, throttling, and routing?

**Solution**: Implement a single entry point (API Gateway) that routes requests to appropriate microservices and handles cross-cutting concerns.

**When to Use**:
- Multiple microservices with different APIs
- Need centralized authentication/authorization
- Need to aggregate responses from multiple services
- Want to hide service topology from clients

**Benefits**:
- Single entry point simplifies client code
- Centralized cross-cutting concerns
- Can translate between protocols
- Insulates clients from service changes

**Trade-offs**:
- Single point of failure (mitigate with HA)
- Potential performance bottleneck
- Additional complexity

**Implementation**:
```
[Client] → [API Gateway] → [Service A]
                        → [Service B]
                        → [Service C]
```

**Technologies**: Kong, AWS API Gateway, Azure API Management, Apigee, NGINX

**Example**: See [E-Commerce Reference Architecture](../reference-architectures/ecommerce-platform.md)

**Related Patterns**: Backend for Frontend (BFF), Service Mesh

---

### Service Discovery Pattern
**Problem**: How do services find and communicate with each other in a dynamic microservices environment?

**Solution**: Implement a service registry where services register themselves and discover other services.

**When to Use**:
- Dynamic service instances (auto-scaling, containers)
- Services need to find each other at runtime
- Service locations change frequently

**Benefits**:
- Dynamic service location
- Load balancing
- Health checking
- Supports auto-scaling

**Trade-offs**:
- Additional infrastructure component
- Registry must be highly available
- Network overhead for lookups

**Implementation**:
- **Client-Side Discovery**: Client queries registry and chooses instance
- **Server-Side Discovery**: Load balancer queries registry

**Technologies**: Consul, etcd, Eureka, Kubernetes Service Discovery, AWS Cloud Map

**Example**:
```
[Service A] → [Service Registry] ← [Service B registers]
           → [Service B] (discovered)
```

---

### Circuit Breaker Pattern
**Problem**: How do you prevent a failing service from cascading failures across the system?

**Solution**: Wrap service calls with a circuit breaker that monitors for failures and opens the circuit when failure threshold is reached.

**When to Use**:
- External service dependencies
- Services that may fail or have high latency
- Need to prevent cascade failures

**States**:
- **Closed**: Normal operation, requests pass through
- **Open**: Failure threshold reached, fail fast without calling service
- **Half-Open**: After timeout, allow test request to check if service recovered

**Benefits**:
- Prevents cascade failures
- Fail fast reduces resource consumption
- Automatic recovery detection

**Trade-offs**:
- Added complexity
- Tuning thresholds can be challenging
- May hide underlying issues if not monitored

**Technologies**: Hystrix (deprecated but patterns still valid), Resilience4j, Polly, Istio

**Example**:
```java
CircuitBreaker breaker = CircuitBreaker.of("externalService", config);
Try.ofSupplier(CircuitBreaker.decorateSupplier(breaker, externalService::call))
    .recover(throwable -> fallbackResponse())
```

---

### Saga Pattern
**Problem**: How do you maintain data consistency across microservices without distributed transactions?

**Solution**: Use a sequence of local transactions coordinated through events or orchestration.

**When to Use**:
- Business process spans multiple services
- Need consistency without 2PC/XA transactions
- Long-running business transactions

**Approaches**:
1. **Choreography**: Services publish events, others react
2. **Orchestration**: Central coordinator manages saga

**Benefits**:
- Maintains consistency without distributed transactions
- Supports long-running transactions
- Services remain loosely coupled (choreography)

**Trade-offs**:
- Complexity in error handling
- Compensating transactions needed
- Debugging can be challenging

**Example** (Order Saga):
```
Order Created → Reserve Inventory → Process Payment → Ship Order
             ↓ Failure
     Cancel Order ← Release Inventory ← Refund Payment
```

**Technologies**: Event bus (Kafka, EventBridge), Workflow engines (Temporal, AWS Step Functions)

---

### Strangler Fig Pattern
**Problem**: How do you migrate from a monolithic application to microservices incrementally?

**Solution**: Gradually replace pieces of the monolith with new microservices, routing traffic between old and new.

**When to Use**:
- Migrating legacy monolith
- Risk-averse incremental approach needed
- Can't afford big-bang rewrite

**Benefits**:
- Low-risk incremental migration
- Continuous delivery during migration
- Can halt and reverse if needed

**Trade-offs**:
- Long migration timeline
- Run two systems simultaneously
- Complex routing logic

**Implementation**:
```
[Facade/Router] → [Monolith] (decreasing)
                → [Service A] (new)
                → [Service B] (new)
```

**Technologies**: NGINX, API Gateway, Feature Flags

---

### Database per Service Pattern
**Problem**: How do you maintain microservices autonomy when they share a database?

**Solution**: Each microservice has its own database, encapsulating its data.

**When to Use**:
- True microservices autonomy needed
- Different services have different data access patterns
- Want to use different database technologies

**Benefits**:
- Service autonomy
- Independent scaling
- Technology choice per service
- Clear ownership

**Trade-offs**:
- Data consistency challenges
- No ACID across services
- Data duplication possible
- Reporting complexity

**Implementation**: Each service has exclusive access to its database schema or database instance

**Complementary Patterns**: Saga for consistency, CQRS for queries, Event Sourcing

---

## Integration Patterns

### Publish-Subscribe Pattern
**Problem**: How do you enable multiple consumers to react to events without tight coupling?

**Solution**: Publishers emit events to a topic; subscribers receive events they're interested in.

**When to Use**:
- Multiple consumers for same event
- Loose coupling desired
- Event-driven architecture
- Async processing

**Benefits**:
- Loose coupling
- Scalability
- Easy to add new consumers
- Temporal decoupling

**Trade-offs**:
- Message ordering challenges
- Debugging complexity
- Eventual consistency

**Technologies**: Kafka, RabbitMQ, AWS SNS/SQS, Azure Service Bus, Google Pub/Sub

**Example**:
```
[Publisher] → [Topic: OrderPlaced] → [Inventory Service]
                                   → [Email Service]
                                   → [Analytics Service]
```

---

### Request-Response Pattern
**Problem**: How do you implement synchronous communication between services?

**Solution**: Client sends request and waits for response from server.

**When to Use**:
- Need immediate response
- Query operations
- User-facing synchronous APIs

**Benefits**:
- Simple mental model
- Immediate feedback
- Strong consistency

**Trade-offs**:
- Tight coupling
- Synchronous blocking
- Cascade failures possible

**Technologies**: HTTP/REST, gRPC, GraphQL

---

### Event Sourcing Pattern
**Problem**: How do you maintain a complete history of changes and enable event-driven architecture?

**Solution**: Store state changes as a sequence of events rather than current state.

**When to Use**:
- Need complete audit trail
- Event-driven architecture
- Temporal queries (state at point in time)
- Complex event processing

**Benefits**:
- Complete audit trail
- Event replay capability
- Temporal queries
- Event-driven architecture enabler

**Trade-offs**:
- Complexity
- Storage requirements
- Event schema evolution
- Query complexity

**Technologies**: Event stores (EventStoreDB, Kafka), CQRS frameworks

**Example**:
```
Events: AccountCreated → Deposited(100) → Withdrawn(50) → Deposited(200)
Current State: Balance = 250
```

---

## Data Patterns

### CQRS (Command Query Responsibility Segregation)
**Problem**: How do you optimize for different read and write patterns in the same system?

**Solution**: Separate read and write models, potentially using different databases.

**When to Use**:
- Very different read and write requirements
- Complex queries on write model
- Event Sourcing used
- High-scale scenarios

**Benefits**:
- Optimized read and write models
- Independent scaling
- Security separation
- Supports Event Sourcing

**Trade-offs**:
- Increased complexity
- Eventual consistency
- Code duplication
- Synchronization challenges

**Implementation**:
```
[Command] → [Write Model] → [Events] → [Read Model] ← [Query]
```

**Technologies**: Event stores, separate databases, materialized views

---

### Data Lake Pattern
**Problem**: How do you store and analyze large volumes of structured and unstructured data?

**Solution**: Centralized repository storing raw data in native format until needed.

**When to Use**:
- Large volumes of diverse data
- Schema-on-read desired
- Advanced analytics and ML
- Long-term data retention

**Benefits**:
- Store any data type
- Cost-effective storage
- Flexibility in analysis
- Single source of truth

**Trade-offs**:
- Can become data swamp without governance
- Performance challenges
- Security complexity
- Requires data cataloging

**Technologies**: AWS S3 + Athena + Glue, Azure Data Lake, Google Cloud Storage + BigQuery

---

## Cloud Patterns

### Auto-Scaling Pattern
**Problem**: How do you handle variable load efficiently?

**Solution**: Automatically scale resources based on demand metrics.

**When to Use**:
- Variable load patterns
- Cost optimization needed
- Performance SLAs

**Benefits**:
- Cost optimization
- Performance under load
- Automatic response to demand

**Trade-offs**:
- Configuration complexity
- Cold start issues
- Scaling lag

**Approaches**:
- Horizontal scaling (add instances)
- Vertical scaling (increase instance size)

**Technologies**: Kubernetes HPA, AWS Auto Scaling, Azure VMSS

---

### Cache-Aside Pattern
**Problem**: How do you improve performance by caching frequently accessed data?

**Solution**: Application checks cache first, loads from database on miss, and populates cache.

**When to Use**:
- Frequently read, infrequently updated data
- Database load reduction needed
- Performance improvement required

**Benefits**:
- Improved performance
- Reduced database load
- Flexible caching logic

**Trade-offs**:
- Cache inconsistency possible
- Complex invalidation logic
- Cold cache performance

**Technologies**: Redis, Memcached, AWS ElastiCache, Azure Cache

---

## Security Patterns

### Zero Trust Pattern
**Problem**: How do you secure resources in a world where network perimeter is porous?

**Solution**: Never trust, always verify. Authenticate and authorize every request regardless of origin.

**When to Use**:
- Cloud and hybrid environments
- Remote workforce
- Micro-segmentation needed
- High security requirements

**Principles**:
- Verify explicitly
- Least privilege access
- Assume breach

**Technologies**: Identity providers, mTLS, service mesh, policy engines

---

### API Gateway Authentication Pattern
**Problem**: How do you centralize authentication for microservices?

**Solution**: API Gateway authenticates requests and passes identity information to backend services.

**When to Use**:
- Multiple microservices
- Consistent authentication needed
- OAuth/OIDC flows

**Benefits**:
- Centralized authentication
- Services don't handle auth complexity
- Consistent security model

**Technologies**: Kong, AWS API Gateway + Cognito, Azure API Management + AAD

---

## Resilience Patterns

### Bulkhead Pattern
**Problem**: How do you isolate failures to prevent system-wide impact?

**Solution**: Partition resources to isolate failures to specific components.

**When to Use**:
- Critical system isolation needed
- Prevent resource exhaustion
- Multi-tenant systems

**Benefits**:
- Failure isolation
- Resource protection
- Predictable degradation

**Example**: Separate thread pools for different services

---

### Retry Pattern
**Problem**: How do you handle transient failures?

**Solution**: Automatically retry failed operations with configurable backoff.

**When to Use**:
- Transient failures expected
- Network calls
- Idempotent operations

**Strategies**:
- Simple retry
- Exponential backoff
- Jitter

**Trade-offs**:
- Can amplify problems
- Retry storms
- Increased latency

---

## Pattern Selection Guide

| Scenario | Recommended Patterns |
|----------|---------------------|
| Building microservices | API Gateway, Service Discovery, Circuit Breaker, Database per Service |
| Event-driven system | Publish-Subscribe, Event Sourcing, Saga, CQRS |
| Cloud migration | Strangler Fig, Auto-Scaling, Cache-Aside |
| High availability | Circuit Breaker, Retry, Bulkhead |
| Security | Zero Trust, API Gateway Authentication |
| Data management | CQRS, Event Sourcing, Data Lake |

## Using Patterns

### Best Practices
1. **Understand the Problem**: Ensure pattern addresses your actual problem
2. **Consider Trade-offs**: Every pattern has trade-offs
3. **Start Simple**: Don't over-engineer
4. **Combine Patterns**: Patterns work together
5. **Document Decisions**: Use ADRs to record pattern choices

### Pattern Anti-Patterns
- ❌ Using patterns for the sake of patterns
- ❌ Not considering trade-offs
- ❌ Copy-paste without understanding context
- ❌ Over-engineering simple problems

## Contributing Patterns

Have a pattern to share?
1. Use the [pattern template](../../templates/pattern-template.md)
2. Include context, problem, solution, trade-offs
3. Provide examples from real projects
4. Submit pull request

---

[Back to Knowledge Base](./README.md) | [Home](../../README.md)
