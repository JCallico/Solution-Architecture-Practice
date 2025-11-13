# Performance Guide

## Overview

Comprehensive guide for designing and optimizing high-performance systems. This playbook covers performance principles, patterns, monitoring strategies, and optimization techniques for modern applications.

---

## Part 1: Performance Principles

### 1.1 Key Performance Metrics

**Response Time / Latency**:
- Time from request to first byte
- Target: < 200ms for user-facing APIs
- Target: < 100ms for internal services
- Measured: P50, P95, P99

**Throughput**:
- Requests per second (RPS) capacity
- Transactions per second (TPS)
- Data throughput (MB/s)

**Availability**:
- Uptime percentage (99.9%, 99.99%, etc.)
- Error rate (< 0.1%)
- Target RTO (Recovery Time Objective)
- Target RPO (Recovery Point Objective)

**Resource Utilization**:
- CPU usage (target: 60-70% peak)
- Memory usage (target: 70-80% peak)
- Disk I/O (IOPS, throughput)
- Network bandwidth

### 1.2 Performance Budgets

**Define Acceptable Limits**:
```
API Endpoint: GET /api/products
- Cold cache latency: < 500ms
- Warm cache latency: < 100ms
- 99th percentile latency: < 1000ms
- Error rate: < 0.01%
- Availability: > 99.9%

Web Application:
- Initial page load: < 3 seconds
- Time to Interactive (TTI): < 5 seconds
- Cumulative Layout Shift (CLS): < 0.1
- First Contentful Paint (FCP): < 1.8 seconds
```

**Budget Enforcement**:
- Automated performance tests in CI/CD
- Alerts when budget exceeded
- Regression testing for changes
- Regular performance audits

### 1.3 Performance vs Consistency Trade-offs

**Immediate Consistency**:
- Synchronous updates
- ACID transactions
- Slower but accurate
- Use for: Financial, critical systems

**Eventual Consistency**:
- Asynchronous updates
- Caches and replicas
- Faster but temporary inconsistency
- Use for: User profiles, analytics, recommendations

---

## Part 2: Performance Patterns

### 2.1 Caching Strategy

**Multi-Level Caching**:
```
Client Request
  ↓
Browser Cache (HTTP cache headers)
  ↓ Miss
CDN / Edge Cache (static assets)
  ↓ Miss
Application Cache (Redis, Memcached)
  ↓ Miss
Database Query
  ↓
Store → Cache → Return to client
```

**Cache Invalidation Strategies**:

1. **Time-Based (TTL)**:
```
Cache-Control: max-age=3600  # Expire after 1 hour
```

2. **Event-Based**:
```
User updates profile
  → Publish "user:123:updated" event
  → Cache listener receives event
  → Invalidate user:123 from cache
```

3. **Write-Through**:
```
Write to database
  ↓
Update cache immediately
  ↓
Return success
```

4. **Write-Behind**:
```
Write to cache immediately
  ↓
Return success to client
  ↓
Async write to database
```

**Cache Warming**:
```
Application startup:
1. Load frequently accessed data into cache
2. Pre-compute expensive calculations
3. Load reference data

Example:
- Load top 100 products
- Load all categories
- Pre-compute aggregated stats
```

### 2.2 Database Optimization

**Query Optimization**:
```sql
-- Bad: Full table scan
SELECT * FROM orders WHERE customer_id = 123

-- Good: Indexed column
SELECT id, amount, status FROM orders 
WHERE customer_id = 123  -- indexed
ORDER BY created_at DESC
LIMIT 20

-- Bad: N+1 query problem
for order in orders:
  customer = query("SELECT * FROM customers WHERE id = ?", order.customer_id)
  
-- Good: Join or batch query
SELECT o.*, c.name FROM orders o
JOIN customers c ON o.customer_id = c.id

-- Good: Batch query
SELECT * FROM customers WHERE id IN (123, 456, 789)
```

**Indexing Strategy**:
```sql
-- Index heavily filtered columns
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);

-- Composite index for common queries
CREATE INDEX idx_orders_customer_status 
ON orders(customer_id, status, created_at DESC);

-- Partial index for common filter
CREATE INDEX idx_orders_active 
ON orders(customer_id) WHERE status != 'cancelled';
```

**Connection Pooling**:
```
Max Connections: 100
Min Idle: 10
Max Idle: 30
Connection Timeout: 10s

Benefits:
- Reuse connections (expensive to create)
- Limit total connections
- Queue waiting requests
- Prevent "connection storm"
```

**Denormalization**:
```sql
-- Normalized (slower for reads, faster for writes)
SELECT 
  o.id, o.total,
  c.name, c.email,
  COUNT(oi.id) as item_count
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id

-- Denormalized (faster reads, requires sync)
SELECT 
  id, total, customer_name, customer_email, item_count
FROM orders
WHERE id = 123

-- Trade-off: Fast reads vs data consistency
```

### 2.3 Load Balancing

**Distribution Algorithms**:

1. **Round Robin**: Cycle through servers
```
Request 1 → Server A
Request 2 → Server B
Request 3 → Server C
Request 4 → Server A
```

2. **Least Connections**: Route to least busy
```
Server A: 5 connections
Server B: 2 connections ← Route here
Server C: 8 connections
```

3. **Weighted**: Account for capacity
```
Server A (8 CPU):  weight=80
Server B (4 CPU):  weight=40
Server C (2 CPU):  weight=20

80/(80+40+20) = 50% of traffic to A
```

4. **IP Hash**: Session affinity
```
hash(client_ip) % num_servers = server_index
Same client always goes to same server
```

### 2.4 Asynchronous Processing

**Queue-Based Async**:
```
User submits long task
  ↓
Queue message (Kafka, RabbitMQ, SQS)
  ↓ Immediate response: "Task queued"
  ↓
Worker processes task
  ↓
Update status / callback client
```

**Benefits**:
- Non-blocking user experience
- Smooth load distribution
- Survivable to failures (queue persists)
- Fair resource sharing

**Implementation**:
```
POST /api/reports/generate
Response: {
  "task_id": "task-123",
  "status": "queued"
}

GET /api/reports/task-123/status
Response: {
  "status": "processing",
  "progress": 45
}

GET /api/reports/task-123/status (later)
Response: {
  "status": "complete",
  "result_url": "s3://bucket/report-123.pdf"
}
```

### 2.5 Content Delivery Network (CDN)

**CDN Caching**:
```
User in Tokyo requests image
  ↓
CDN Edge Tokyo has cached copy
  ↓ Immediate delivery (low latency)

User in NYC requests same image
  ↓
CDN Edge NYC has cached copy
  ↓ Immediate delivery

Origin server serves only cache misses
```

**Cache Headers for CDN**:
```
GET /static/image.jpg
Cache-Control: public, max-age=31536000  # Cache 1 year
ETag: "abc123"

GET /api/data
Cache-Control: private, max-age=60  # Cache 1 min, user-specific
```

---

## Part 3: Monitoring & Profiling

### 3.1 Key Performance Indicators (KPIs)

**Application Metrics**:
- Response time (P50, P95, P99)
- Error rate (errors per minute)
- Request rate (RPS)
- Resource utilization (CPU, memory)

**Business Metrics**:
- Conversion rate
- Page abandonment rate
- Search relevance
- Feature adoption

### 3.2 Monitoring Tools

**Application Performance Monitoring (APM)**:
- Datadog
- New Relic
- Dynatrace
- Elastic APM

**Profiling**:
```
CPU Profiling: Where is CPU time spent?
Memory Profiling: What's allocating memory?
I/O Profiling: Disk/network latency?

Results:
Function A: 35% CPU
Function B: 22% CPU
Function C: 18% CPU
  ↓
Optimize Function A for 35% improvement
```

**Tracing**:
```
User Request → API Gateway (5ms)
             → User Service (20ms)
             → Order Service (15ms)
             → Payment Service (50ms) ← Bottleneck
             → Cache write (5ms)
             
Total: 95ms
Improvement: Optimize Payment Service
```

### 3.3 Bottleneck Identification

**Process**:
1. Collect baseline metrics
2. Identify slow operations
3. Profile to find root cause
4. Optimize highest impact areas
5. Measure improvement
6. Repeat

**Common Bottlenecks**:
- **Database queries**: Add indexes, cache, denormalize
- **Network calls**: Parallel requests, caching, batching
- **Computation**: Algorithm optimization, caching results
- **I/O operations**: Async, batching, buffering
- **Memory**: Reduce allocations, GC tuning, pooling

---

## Part 4: Optimization Techniques

### 4.1 Code Optimization

**Algorithm Efficiency**:
```
Bad: O(n²) nested loop
for item in items:
  for order in orders:
    if item.id == order.item_id:
      process(order)

Good: O(n + m) with index
item_map = {item.id: item for item in items}
for order in orders:
  if order.item_id in item_map:
    process(order)
```

**Lazy Loading**:
```
# Bad: Load everything
user = User.find(123)
user.orders (loads all)
user.addresses (loads all)

# Good: Load on demand
user = User.find(123)
user.orders (not loaded yet)
when needed: user.orders  # Load only when used
```

**Object Pooling**:
```
# Expensive objects created frequently
buffer_pool = BufferPool(size=100, buffer_size=4096)
buffer = buffer_pool.acquire()
use(buffer)
buffer_pool.release(buffer)  # Reuse, not recreate
```

### 4.2 Database Tuning

**Query Analysis**:
```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;

Seq Scan on orders  (cost=0.00..35.50)
  Filter: (customer_id = 123)

-- Missing index! Cost too high

CREATE INDEX idx_customer_id ON orders(customer_id);

Index Scan using idx_customer_id (cost=0.29..4.31)
  Index Cond: (customer_id = 123)

-- Much better!
```

**Batch Processing**:
```
# Bad: Individual inserts
for item in items:
  db.execute("INSERT INTO items VALUES (?)", item)  # 1000 queries

# Good: Batch insert
db.executemany("INSERT INTO items VALUES (?)", items)  # 1 query
# or
INSERT INTO items VALUES (a), (b), (c), ...  # Single statement
```

### 4.3 Network Optimization

**Compression**:
```
Response headers:
Content-Encoding: gzip

Before: 100KB
After: 20KB (80% reduction)
Cost: 5ms compression time
Savings: 80ms network latency
```

**Request/Response Batching**:
```
# Bad: Multiple requests
GET /api/products/123
GET /api/products/456
GET /api/products/789

# Good: Single batch request
POST /api/products/batch
Body: {
  "ids": [123, 456, 789]
}
```

**HTTP/2 Server Push**:
```
Client requests HTML
Server responds with HTML
Server also pushes CSS, JS automatically
Client doesn't need separate requests
```

### 4.4 Infrastructure Scaling

**Vertical Scaling**:
- Increase instance size (CPU, memory)
- Simpler but limited (instance size limits)
- Requires downtime for many systems

**Horizontal Scaling**:
- Add more instances
- Load balance across them
- Handles unlimited growth
- More complex operational management

**Auto-Scaling**:
```
CPU > 70% for 5 minutes → Add 2 instances
CPU < 30% for 10 minutes → Remove 1 instance

Metrics:
- CPU utilization
- Memory usage
- Request count
- Custom metrics
```

---

## Part 5: Performance Optimization Checklist

### Frontend
- [ ] Minify CSS, JS, HTML
- [ ] Image optimization (WebP, compression)
- [ ] Code splitting for lazy loading
- [ ] Cache busting for updated assets
- [ ] CDN for static content
- [ ] Compression (gzip/brotli)
- [ ] HTTP/2 enabled
- [ ] CSS/JS load order optimized

### Backend
- [ ] Database indexes on filter columns
- [ ] Query optimization (no N+1)
- [ ] Connection pooling configured
- [ ] Caching strategy (Redis/Memcached)
- [ ] Asynchronous processing for long tasks
- [ ] API response compression
- [ ] Rate limiting configured
- [ ] Timeouts configured

### Operations
- [ ] Load balancing configured
- [ ] Auto-scaling policies defined
- [ ] Monitoring and alerting in place
- [ ] APM tool integrated
- [ ] Performance tests in CI/CD
- [ ] Regular profiling and optimization
- [ ] Capacity planning
- [ ] SLA monitoring

---

## Part 6: Performance Testing

**Load Testing**:
```
k6 script:
- Simulate 1000 concurrent users
- Target: GET /api/products
- Duration: 10 minutes
- Monitor: Response time, error rate
- Result: System stable, P95 < 200ms
```

**Stress Testing**:
```
- Increase load until system fails
- Find breaking point
- Identify bottleneck
- Example: Fails at 5000 RPS (database bottleneck)
```

**Endurance Testing**:
```
- Run at normal load for extended period (24+ hours)
- Identify: Memory leaks, connection leaks
- Monitor: Memory growth, error rate increase
```

---

## Related Resources

- [Cloud Patterns](../patterns/cloud-patterns.md)
- [Resilience Patterns](../patterns/resilience-patterns.md)
- [Well-Architected Framework](../../frameworks/well-architected.md)
- [Google Web Vitals](https://web.dev/vitals/)
- [AWS Performance Best Practices](https://docs.aws.amazon.com/wellarchitected/latest/performance-pillar/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
