# Data Architecture Template

## Purpose

The Data Architecture document defines how data is captured, stored, processed, and consumed across the system. It addresses data modeling, storage strategies, integration patterns, governance, and quality requirements.

---

## When to Use

- Designing systems with complex data requirements
- Establishing data management standards
- Planning data infrastructure
- Defining data governance frameworks
- Implementing master data management
- Designing data pipelines and warehouses

---

## Executive Summary

Provide a high-level overview of the data strategy:

```
Data Architecture Vision:
This architecture supports [business objective] through a polyglot persistence 
approach combining [relational/NoSQL/time-series/search] technologies optimized 
for [use case]. The architecture enables [key capability] while maintaining 
[governance requirement].

Key Metrics:
- Data volume: [X TB/PB]
- Query latency target: [X ms]
- Data freshness requirement: [real-time/near-real-time/batch]
- Concurrent users: [X]
- Data retention: [X years/months]
```

---

## Data Domains & Entities

### Domain Definition

```
Domain: [Domain Name]
Purpose: [Business purpose]
Owner: [Team/Person]
Entities:
  - [Entity Name]: [Definition & attributes]
  - [Entity Name]: [Definition & attributes]
```

### Example: E-Commerce Data Domains

```
DOMAIN: Catalog
Purpose: Manage product information and inventory
Owner: Product Team
Entities:
  - Product: SKU, name, description, category, attributes
  - Category: name, hierarchy, rules
  - Inventory: location, quantity, reserved, damaged
  - Pricing: list_price, sale_price, effective_dates, rules

DOMAIN: Orders
Purpose: Track customer orders through fulfillment
Owner: Order Management Team
Entities:
  - Order: order_id, customer_id, created_date, status, items
  - OrderItem: product_id, quantity, unit_price, tax
  - Payment: payment_method, status, transaction_id
  - Shipment: tracking_number, carrier, status, address

DOMAIN: Customers
Purpose: Maintain customer profiles and relationships
Owner: CRM Team
Entities:
  - Customer: customer_id, email, name, status, lifetime_value
  - Address: customer_id, type (billing/shipping), address
  - Preference: communication_channel, frequency, interests
  - Segment: segment_id, rules, campaigns
```

---

## Logical Data Model

### Entity-Relationship Diagram (ERD)

```
+─────────────┐
│  CUSTOMERS  │
│─────────────│
│ id (PK)     │
│ email       │
│ name        │
│ created_at  │
└─────────────┘
       │
       │ 1:M
       │
       ▼
+─────────────┐      +─────────────┐
│   ORDERS    │      │  ORDER_ITEMS│
│─────────────│      │─────────────│
│ id (PK)     │◄────►│ id (PK)     │
│ cust_id(FK) │      │ order_id(FK)│
│ created_at  │      │ product_id  │
│ status      │      │ quantity    │
│ total       │      │ unit_price  │
└─────────────┘      └─────────────┘
       │                     │
       │ 1:M                 │
       │                     │ M:1
       ▼                     ▼
+─────────────┐      +─────────────┐
│  PAYMENTS   │      │  PRODUCTS   │
│─────────────│      │─────────────│
│ id (PK)     │      │ id (PK)     │
│ order_id(FK)│      │ sku         │
│ method      │      │ name        │
│ amount      │      │ price       │
│ status      │      │ category_id │
└─────────────┘      └─────────────┘
```

### Attribute Definitions Table

```
Entity: ORDER
┌──────────────┬──────────────┬─────────────┬────────────────────┐
│ Attribute    │ Type         │ Required    │ Comment            │
├──────────────┼──────────────┼─────────────┼────────────────────┤
│ id           │ BIGINT       │ Yes (PK)    │ Surrogate key      │
│ customer_id  │ BIGINT       │ Yes (FK)    │ Customer reference │
│ order_date   │ TIMESTAMP    │ Yes         │ When order created │
│ status       │ VARCHAR(20)  │ Yes         │ pending/confirmed  │
│ total        │ DECIMAL(12,2)│ Yes         │ Order total amount │
│ currency     │ VARCHAR(3)   │ Yes         │ ISO currency code  │
│ notes        │ TEXT         │ No          │ Order instructions │
│ created_at   │ TIMESTAMP    │ Yes         │ Record created     │
│ updated_at   │ TIMESTAMP    │ Yes         │ Last updated       │
└──────────────┴──────────────┴─────────────┴────────────────────┘
```

---

## Physical Data Model

### SQL Schema Definition

```sql
-- Customers table
CREATE TABLE customers (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_status (status)
);

-- Orders table
CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  customer_id BIGINT NOT NULL REFERENCES customers(id),
  order_date TIMESTAMP NOT NULL,
  status VARCHAR(20) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_customer_id (customer_id),
  INDEX idx_order_date (order_date),
  INDEX idx_status (status)
);

-- Order items table
CREATE TABLE order_items (
  id BIGSERIAL PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) DEFAULT 0,
  tax_amount DECIMAL(12,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_order_id (order_id),
  INDEX idx_product_id (product_id)
);

-- Products table (denormalized for catalog queries)
CREATE TABLE products (
  id BIGSERIAL PRIMARY KEY,
  sku VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id BIGINT,
  list_price DECIMAL(12,2),
  cost_price DECIMAL(12,2),
  status VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_sku (sku),
  INDEX idx_category_id (category_id),
  FULLTEXT INDEX idx_name_desc (name, description)
);
```

---

## Polyglot Persistence Strategy

### Storage Technology Selection

```
┌──────────────────┬─────────────────────────────────────────┐
│ Use Case         │ Technology & Rationale                  │
├──────────────────┼─────────────────────────────────────────┤
│ Transactional    │ PostgreSQL                              │
│ Data             │ - ACID compliance                       │
│                  │ - Complex queries                       │
│                  │ - Data integrity                        │
├──────────────────┼─────────────────────────────────────────┤
│ Search & Log     │ Elasticsearch                           │
│ Analytics        │ - Full-text search                      │
│                  │ - Time-series optimization              │
│                  │ - Aggregation queries                   │
├──────────────────┼─────────────────────────────────────────┤
│ Caching &        │ Redis                                   │
│ Sessions         │ - Sub-millisecond latency               │
│                  │ - Session state                         │
│                  │ - Rate limiting counters                │
├──────────────────┼─────────────────────────────────────────┤
│ Document         │ MongoDB                                 │
│ Storage          │ - Flexible schema                       │
│                  │ - Hierarchical data                     │
│                  │ - JSON native                           │
├──────────────────┼─────────────────────────────────────────┤
│ Data            │ Snowflake/BigQuery                       │
│ Warehouse       │ - Petabyte scale                         │
│                  │ - Analytical queries                    │
│                  │ - Time-series analysis                  │
├──────────────────┼─────────────────────────────────────────┤
│ Event Streaming  │ Kafka/Pub-Sub                           │
│                  │ - Event sourcing                        │
│                  │ - Stream processing                     │
│                  │ - Backpressure handling                 │
└──────────────────┴─────────────────────────────────────────┘
```

### Polyglot Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│         Application Layer (Services)                │
├─────────────────────────────────────────────────────┤
│ Order Service │ Product Service │ Customer Service │
└────┬──────────┴────┬──────────┴────┬───────────────┘
     │               │               │
     ├─────┬─────────┼─────────────┬─┤
     │     │         │             │ │
     ▼     ▼         ▼             ▼ ▼
┌─────────────┐ ┌──────────┐ ┌──────────┐
│PostgreSQL   │ │Elasticsearch
 │ Redis      │
│(OLTP)       │ │(Search)    │ │(Cache)   │
└─────────────┘ └──────────┘ └──────────┘
     │
     └───────────┬───────────┐
                 │           │
                 ▼           ▼
            ┌──────────┐  ┌──────────┐
            │Snowflake │  │  Kafka   │
            │(Analytics)  │(Events)  │
            └──────────┘  └──────────┘
```

---

## Data Flow Patterns

### Synchronous Data Flow

```
Request → Service A → PostgreSQL → Response
           (transactional)
```

Example: Place Order
```
POST /orders
  ↓
Order Service
  ↓
BEGIN TRANSACTION
  ├→ INSERT order record
  ├→ UPDATE inventory
  ├→ INSERT payment record
  └→ COMMIT TRANSACTION
  ↓
Cache invalidation (Redis)
  ↓
Return Order (201 Created)
```

### Asynchronous Data Flow

```
Event → Kafka Topic → Consumer 1 → Secondary DB
   ↓
   → Consumer 2 → Cache Update
   ↓
   → Consumer 3 → Analytics Pipeline
```

Example: Order Shipped Event
```
Shipment Updated
  ↓
kafka.publish("order.shipped", {...})
  ↓
├─ Customer Notification Service
│  └─ Send email notification
├─ Analytics Pipeline
│  └─ Update metrics
├─ Recommendation Engine
│  └─ Train personalization models
```

---

## Data Lifecycle & Retention

### Retention Policy

```
Domain              │ Hot Storage │ Warm Storage │ Archive │ Delete
─────────────────────┼─────────────┼──────────────┼─────────┼────────
Transactional       │ 1 year      │ 3 years      │ 7 years │ Auto
(Orders, Customers) │ PostgreSQL  │ S3 (backup)  │ Glacier │
─────────────────────┼─────────────┼──────────────┼─────────┼────────
Analytics/Events    │ 90 days     │ 2 years      │ 5 years │ Auto
(Logs, Metrics)     │ Snowflake   │ S3 (Parquet) │ Glacier │
─────────────────────┼─────────────┼──────────────┼─────────┼────────
Real-time Cache     │ Active only │ N/A          │ N/A     │ TTL
(Redis)             │ TTL: 1 hour │ N/A          │ N/A     │ 1 hour
─────────────────────┼─────────────┼──────────────┼─────────┼────────
PII Data            │ Encrypted   │ Masked       │ N/A     │ GDPR
(Personal Info)     │ PostgreSQL  │ Archives     │ Delete  │ 30 days
```

---

## Data Governance & Quality

### Data Quality Metrics

```
Metric              │ Target   │ Check Location        │ Alert Threshold
────────────────────┼──────────┼───────────────────────┼─────────────────
Completeness        │ > 99.5%  │ ETL pipeline          │ < 99%
Accuracy            │ > 99%    │ Validation rules      │ < 98%
Timeliness          │ <4 hours │ Ingestion monitoring  │ >6 hours
Uniqueness (PK)     │ 100%     │ Database constraints  │ Duplicates found
Consistency         │ 100%     │ Cross-system checks   │ Mismatches
Validity            │ > 99.5%  │ Schema validation     │ < 99%
```

### Data Quality Rules

```yaml
Rules:
  - customer_email:
      type: email_format
      required: true
      unique: true
      
  - order_total:
      type: decimal
      precision: 12
      scale: 2
      minimum: 0
      
  - order_status:
      type: enum
      valid_values: [pending, confirmed, shipped, delivered, cancelled]
      
  - order_date:
      type: timestamp
      required: true
      check: order_date <= CURRENT_TIMESTAMP
      
  - inventory_quantity:
      type: integer
      minimum: 0
      check: quantity >= 0
```

---

## Master Data Management

### Customer Master Data

```
Attributes:
  id (System ID)
  email (Unique identifier)
  name
  phone
  created_date
  customer_segment
  lifetime_value
  status

Golden Record Approach:
  - Customer created in CRM system (source of truth)
  - Distributed to: Order system, Analytics, Recommendation engine
  - Updates synchronized via event stream
  - Conflicts resolved by CRM as master
```

### Product Master Data

```
Attributes:
  sku (Unique identifier)
  name
  description
  category_id
  list_price
  cost_price
  supplier_id
  status

Golden Record Approach:
  - Product created in Product Information Management (PIM)
  - Synchronized to: Catalog DB, Search Index, Warehouse
  - Price changes published as events
  - Status transitions audited
```

---

## Integration Patterns

### Batch ETL

```python
# Daily inventory sync from warehouse
def sync_inventory_from_warehouse():
    """Sync product inventory daily at 2 AM UTC"""
    
    # Extract from source
    warehouse_data = extract_from_warehouse_db()
    
    # Transform
    transformed = transform_for_catalog(warehouse_data)
    
    # Validate
    validate_data_quality(transformed)
    
    # Load
    load_to_postgres(transformed)
    invalidate_cache()
    
    # Log
    log_sync_metrics(rows_processed, duration)
```

### Real-time CDC (Change Data Capture)

```
PostgreSQL → Debezium → Kafka Topic → Consumers
             (CDC)      (order.*)

Example: When order inserted/updated:
  1. PostgreSQL WAL captures change
  2. Debezium reads change
  3. Message published to Kafka
  4. Consumers react:
     - Search indexer updates Elasticsearch
     - Cache invalidator updates Redis
     - Analytics collector updates Snowflake
```

### API-Based Integration

```
Service A needs Customer data from Service B:

Service A
  ↓
Customer Service (API)
  ├→ Query cache (Redis) → hit: return
  └→ Query DB (PostgreSQL) → miss: return + cache
  ↓
Service A

Caching strategy: TTL 1 hour or event-based invalidation
Circuit breaker: Timeout 2s, failure rate 50%
```

---

## Data Security & Privacy

### Encryption

```
At Rest:
  - Database encryption: TDE (Transparent Data Encryption)
  - Backup encryption: AES-256
  - Sensitive fields: Application-level encryption (customers.ssn)

In Transit:
  - HTTPS/TLS 1.2+ for all network communication
  - Encrypted connections between services (mTLS)
  - Kafka over SSL

Key Management:
  - Keys stored in HSM or Cloud KMS
  - Key rotation every 90 days
  - Access logs for key operations
```

### PII Handling

```
Classification:
  - Sensitive: email, phone, SSN, credit card
  - Personal: name, address
  - Non-sensitive: product category, order amount

Controls:
  - Sensitive fields stored encrypted
  - Access restricted by role
  - Audit all reads of sensitive data
  - Masks in logs/backups
  - Deletion compliance with GDPR (30-day window)
```

---

## Performance Optimization

### Indexing Strategy

```sql
-- Create indexes for common queries
CREATE INDEX idx_orders_customer_date 
  ON orders(customer_id, order_date DESC);

CREATE INDEX idx_order_items_product 
  ON order_items(product_id);

CREATE INDEX idx_products_category_price 
  ON products(category_id, list_price);

-- Analyze query plans
EXPLAIN ANALYZE
  SELECT o.id, o.total, COUNT(*) items
  FROM orders o
  JOIN order_items oi ON o.id = oi.order_id
  WHERE o.customer_id = $1
  GROUP BY o.id;
```

### Caching Strategy

```
Query → Check Redis (cache)
         Hit: Return cached result (TTL: 1 hour)
         Miss: Query DB → Cache → Return

Cache keys:
  - customer:{id} → Customer profile (TTL: 1h)
  - inventory:{sku} → Stock levels (TTL: 5m)
  - product:{id} → Product details (TTL: 24h)

Invalidation:
  - Event-based: When data changes, invalidate immediately
  - TTL-based: Automatic expiration
  - Pattern-based: Clear product:* when catalog updated
```

### Query Optimization

```sql
-- Bad: N+1 query problem
SELECT * FROM orders WHERE customer_id = $1;
-- For each order, query items (N additional queries)

-- Good: Batch fetch
SELECT o.*, COUNT(oi.id) as item_count
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.customer_id = $1
GROUP BY o.id;

-- With pagination
OFFSET $2 LIMIT $3;
```

---

## Monitoring & Observability

### Data Health Metrics

```
Metrics to Monitor:
  - Table row counts by domain
  - Replication lag (for replicas)
  - Index fragmentation
  - Cache hit ratio
  - Query response time percentiles (P50, P95, P99)
  - Database connections (active/max)
  - Backup success/failure
  - Data ingestion volume and latency
```

### Alerts

```yaml
Alerts:
  - IndexFragmentation > 20%: Vacuum/reindex required
  - ReplicationLag > 5 seconds: Check network/resources
  - CacheHitRatio < 80%: Increase cache size or TTL
  - QueryLatencyP99 > 1000ms: Query optimization needed
  - FailedRecords > 100 per hour: Data quality issue
  - DataFreshness > 6 hours: Ingestion pipeline issue
```

---

## Documentation & Lineage

### Data Lineage Example

```
Customer Input (Customer API)
  ↓
Validated & Normalized (Data Pipeline)
  ├─→ PostgreSQL (customers table) ← Source of Truth
  ├─→ Elasticsearch (customer index)
  └─→ Cache (Redis)
       ↓
  Consumed By:
  - Order Service (via API)
  - Analytics Platform (nightly batch)
  - ML Model Training (daily)
  - Reporting Dashboard (real-time)
```

---

## Data Architecture Review Checklist

- [ ] All data domains identified and documented
- [ ] Entities and relationships clearly defined
- [ ] Storage technology choices justified
- [ ] Data lifecycle and retention policies defined
- [ ] PII classification and protection controls specified
- [ ] Data quality rules and metrics established
- [ ] Integration patterns and ETL/ELT processes designed
- [ ] Backup and disaster recovery procedures documented
- [ ] Performance optimization strategies planned
- [ ] Security and compliance requirements addressed
- [ ] Monitoring and alerting configured
- [ ] Team ownership assigned to each domain

---

## Related Resources

- [Data Platform Reference Architecture](../knowledge-base/reference-architectures/data-platform.md)
- [Data Patterns](../knowledge-base/patterns/data-patterns.md)
- [Technical Design Template](./documents/technical-design-template.md)
- [Database Design Best Practices](../knowledge-base/playbooks/data-platform.md)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Elasticsearch Documentation](https://www.elastic.co/guide/index.html)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
