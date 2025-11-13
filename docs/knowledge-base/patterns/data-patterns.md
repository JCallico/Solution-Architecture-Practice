# Data Patterns

## Overview

Data patterns address challenges in data storage, consistency, access, integration, and processing. These patterns help architect systems that effectively manage data at scale while maintaining consistency and performance.

---

## Data Storage Patterns

### 1. Database per Service

**Problem:** Shared database in microservices creates coupling and scalability limits.

**Solution:** Each microservice owns its database schema. Data sharing happens through APIs, not direct database access.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ User        │     │ Order       │     │ Payment     │
│ Service     │     │ Service     │     │ Service     │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ PostgreSQL  │     │ MongoDB     │     │ PostgreSQL  │
│ (User DB)   │     │ (Orders)    │     │ (Payments)  │
└─────────────┘     └─────────────┘     └─────────────┘
```

**When to use:**
- Microservices architecture
- Independent scaling needed
- Different storage needs per service
- Team autonomy required

**Benefits:**
- Service independence
- Scalability
- Technology choice per service

**Drawbacks:**
- Data consistency challenges
- Complex queries across services
- Operational complexity

---

### 2. Shared Database

**Problem:** Each service needs access to shared data in legacy systems.

**Solution:** Multiple services share the same database, with clear schema ownership.

**When to use:**
- Monolithic systems
- Legacy systems with shared data
- Strong consistency required
- Shared transactions needed

**Benefits:**
- Strong consistency
- Simple queries
- Transaction support

**Drawbacks:**
- Service coupling
- Scalability limits
- Change coordination needed

---

### 3. Polyglot Persistence

**Problem:** One database type doesn't fit all data storage needs.

**Solution:** Use different database technologies for different data types and access patterns.

```
Example selection:
- Relational (PostgreSQL): Transactional data, complex queries
- NoSQL (MongoDB): Document storage, flexible schemas
- Search (Elasticsearch): Full-text search, analytics
- Cache (Redis): High-speed access, sessions
- Time-series (InfluxDB): Metrics, logs
- Graph (Neo4j): Relationships, recommendations
```

**When to use:**
- Multiple data types/formats
- Different performance requirements
- Want to optimize per workload
- Have expertise in multiple databases

**Benefits:**
- Optimal performance per workload
- Flexibility
- Right tool for each job

**Drawbacks:**
- Operational complexity
- More databases to manage
- Team knowledge required

---

## Data Consistency Patterns

### 4. Event Sourcing

**Problem:** Traditional CRUD loses historical data and makes auditing difficult.

**Solution:** Store all changes as immutable events. Current state derived from events.

```
Events:
1. OrderCreated(id: 123, customer: 456, amount: 100)
2. PaymentAuthorized(order: 123, amount: 100)
3. OrderShipped(order: 123, tracking: ABC123)
4. OrderDelivered(order: 123, delivery_date: 2025-11-13)

Current State = Fold(events)
→ Order 123: shipped, paid, delivered
```

**When to use:**
- Audit requirements
- Complex domain logic
- Need event replay
- Temporal queries

**Benefits:**
- Complete audit trail
- Event replay capability
- Temporal queries
- Debugging support

**Drawbacks:**
- Event versioning complexity
- Storage overhead
- Eventual consistency required

---

### 5. CQRS (Command Query Responsibility Segregation)

**Problem:** Read and write patterns have different scalability and complexity needs.

**Solution:** Separate read and write models. Writes to normalized form, reads from optimized views.

```
Write Model:
POST /orders → Order Service → PostgreSQL
(Normalized, ACID, complex)

Read Model:
GET /orders → Read Service → Read Cache
(Denormalized, optimized, stale OK)

Sync: Event Stream
Order Created Event → Update Read Cache
```

**When to use:**
- Read/write ratios are very different (100:1)
- Complex read queries
- Multiple read formats needed
- High read performance critical

**Benefits:**
- Read performance
- Scalability
- Complex queries simplified
- Separate scaling

**Drawbacks:**
- Eventual consistency
- Complexity
- Cache invalidation
- Dual model maintenance

---

### 6. Saga Pattern

**Problem:** Distributed transactions across services needed, but 2PC not viable.

**Solution:** Break transaction into compensating actions. If step fails, compensate previous steps.

```
Reserve Inventory → Charge Payment → Ship Order
        ↓              ↓                ↓
   [Success]      [Success]       [Fails]
                                    ↓
                          Refund Payment
                                    ↓
                          Release Inventory

Types:
- Choreography: Services emit events, others react
- Orchestration: Coordinator directs each step
```

**When to use:**
- Distributed transactions needed
- Services can't use 2PC
- Long-running transactions
- Eventual consistency OK

**Benefits:**
- Works without 2PC
- Maintains consistency across services
- Flexible coordination

**Drawbacks:**
- Complex logic
- Harder to reason about
- Compensation logic needed
- Testing complexity

---

## Data Access Patterns

### 7. Repository Pattern

**Problem:** Data access logic scattered throughout business logic.

**Solution:** Encapsulate data access in repository objects.

```python
class UserRepository:
    def get_by_id(self, user_id):
        return User.objects.filter(id=user_id).first()
    
    def get_by_email(self, email):
        return User.objects.filter(email=email).first()
    
    def save(self, user):
        user.save()
        return user
    
    def delete(self, user_id):
        User.objects.filter(id=user_id).delete()

# Usage
class UserService:
    def __init__(self, user_repo):
        self.user_repo = user_repo
    
    def create_user(self, email, name):
        user = User(email=email, name=name)
        return self.user_repo.save(user)
```

**When to use:**
- Clean separation of concerns
- Testable code
- Multiple data sources
- Complex queries

**Benefits:**
- Decoupled from database
- Testable
- Reusable
- Consistent interface

---

### 8. Active Record Pattern

**Problem:** Separating business logic from data access adds complexity.

**Solution:** Database rows represented as objects with embedded data access.

```ruby
# Active Record example (Ruby on Rails)
class User < ApplicationRecord
  has_many :orders
  
  def self.find_by_email(email)
    where(email: email).first
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
end

# Usage
user = User.find_by_email('john@example.com')
user.orders.each { |order| puts order.total }
user.save
```

**When to use:**
- Simple CRUD operations
- Rapid development
- Simple domain models
- Small to medium projects

**Benefits:**
- Simplicity
- Rapid development
- Familiar pattern
- Less boilerplate

**Drawbacks:**
- Testing difficulty
- Tight coupling
- Scaling complexity
- Doesn't work for complex domains

---

## Data Integration Patterns

### 9. ETL (Extract, Transform, Load)

**Problem:** Need to integrate data from multiple systems.

**Solution:** Extract data from source, transform to target format, load to destination.

```
Source Systems
    ↓
[Extract] → Pull data from sources
    ↓
[Transform] → Clean, validate, map, aggregate
    ↓
[Load] → Insert into target system
    ↓
Target System
```

**Implementations:**
- Batch ETL: Scheduled (nightly, hourly)
- Streaming ETL: Real-time processing
- Tools: Apache Airflow, Talend, Informatica, custom

---

### 10. Change Data Capture (CDC)

**Problem:** Need to keep systems synchronized as data changes.

**Solution:** Capture database changes, propagate to other systems.

```
Source Database
    ↓
[CDC] → Detect INSERT/UPDATE/DELETE
    ↓
Change Stream (Kafka, Event Hub)
    ↓
Consumers (update cache, sync warehouse, notify services)
```

**Tools:**
- Debezium (CDC framework)
- Native database triggers
- Log-based CDC

---

## Data Performance Patterns

### 11. Caching

**Problem:** Database queries are slow, need faster access.

**Solution:** Keep frequently accessed data in fast-access cache.

```
Read Request
    ↓
Check Cache (Redis)
    ├─ Hit: Return cached result (< 1ms)
    └─ Miss: Query database, cache result, return
              (50-500ms)
```

**Cache Patterns:**
- **Look-aside:** Application checks cache, loads from DB if miss
- **Write-through:** Write to cache and DB together
- **Write-behind:** Write to cache, async to DB

**Invalidation Strategies:**
- TTL-based: Expire after time
- Event-based: Invalidate on change
- Manual: Explicit invalidation

---

### 12. Materialized View

**Problem:** Complex queries are slow on normalized data.

**Solution:** Pre-compute and store query results, update incrementally.

```sql
-- Source tables (normalized)
SELECT orders.id, customers.name, SUM(items.price)
FROM orders
JOIN customers ON orders.customer_id = customers.id
JOIN order_items items ON orders.id = items.order_id
GROUP BY orders.id

-- Instead, maintain materialized view:
CREATE MATERIALIZED VIEW order_summary AS
(pre-computed results)

-- Query materialized view (fast)
SELECT * FROM order_summary WHERE customer_id = 123
```

---

### 13. Indexing Strategy

**Problem:** Queries on large tables are slow.

**Solution:** Create indexes on frequently queried columns.

```sql
-- Single column index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Composite index (column order matters)
CREATE INDEX idx_orders_date_status 
  ON orders(order_date DESC, status);

-- Covering index (includes all needed columns)
CREATE INDEX idx_orders_cover 
  ON orders(customer_id, status) 
  INCLUDE (order_date, total);

-- Full-text index (text search)
CREATE FULLTEXT INDEX idx_products_text
  ON products(name, description);
```

**Guidelines:**
- Index columns in WHERE clauses
- Index columns in JOIN conditions
- Consider column selectivity
- Monitor for unused indexes

---

## Data Validation Patterns

### 14. Schema Validation

**Problem:** Inconsistent or invalid data in system.

**Solution:** Enforce schema at various layers.

```
Layers:
1. Database constraints: NOT NULL, UNIQUE, CHECK
2. Application validation: Type checking, business rules
3. API validation: JSON Schema, OpenAPI
4. Message validation: Protobuf, Avro schemas
```

---

### 15. Eventual Consistency Pattern

**Problem:** Strong consistency across distributed systems is expensive.

**Solution:** Accept temporary inconsistency, eventually consistent.

```
Time 0: Write to Service A
        Service A: value = 10
        Service B: value = old

Time 50ms: Event propagated via message queue
          Service A: value = 10
          Service B: value = 10 (caught up)

Trade-off: Slightly stale reads for better performance/availability
```

---

## Related Patterns

See also:
- [Integration Patterns](./integration-patterns.md)
- [Design Patterns](./design-patterns.md)
- [Cloud Patterns](./cloud-patterns.md)

---

## References

- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- [CQRS](https://martinfowler.com/bliki/CQRS.html)
- [Saga Pattern](https://microservices.io/patterns/data/saga.html)
- [Polyglot Persistence](https://martinfowler.com/bliki/PolyglotPersistence.html)
- Row Data Gateway
- Data Access Object (DAO)

### Data Processing
- Batch Processing
- Stream Processing
- Lambda Architecture
- Kappa Architecture
- ETL/ELT
- Change Data Capture (CDC)

### Data Integration
- Database Replication
- Database Sharding
- Database Federation
- Data Lake
- Data Warehouse
- Data Mart
- Data Mesh

### Caching Patterns
- Cache-Aside
- Read-Through
- Write-Through
- Write-Behind
- Refresh-Ahead
- Distributed Cache

### Data Quality
- Data Validation
- Data Cleansing
- Master Data Management
- Data Lineage
- Data Cataloging

## Related Resources

- [Reference Architecture: Data Platform](../reference-architectures/data-platform.md)
- [Cloud Patterns](./cloud-patterns.md)
- [Domain-Driven Design](../../frameworks/domain-driven-design.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
