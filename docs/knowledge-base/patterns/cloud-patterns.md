# Cloud Patterns

## Overview

Cloud-native patterns address resilience, scalability, performance, and operational aspects of cloud systems. These patterns enable systems to leverage cloud advantages while managing challenges.

---

## Resilience Patterns

### 1. Circuit Breaker

**Problem:** Cascading failures when calling failing services.

**Solution:** Monitor calls, break circuit if threshold exceeded.

```
States:
- CLOSED (normal): Calls pass through
- OPEN (broken): Calls fail immediately
- HALF_OPEN (recovery): Some calls allowed

Transition:
CLOSED → [failure threshold] → OPEN
OPEN → [timeout] → HALF_OPEN
HALF_OPEN → [success] → CLOSED
HALF_OPEN → [failure] → OPEN
```

**When to use:**
- External API calls
- Database connections
- Inter-service communication

---

### 2. Retry Pattern

**Problem:** Transient failures cause cascading issues.

**Solution:** Automatically retry failed requests.

```
Retry Strategy:
1. Exponential backoff: 100ms, 200ms, 400ms, 800ms...
2. Jitter: Add randomness to prevent thundering herd
3. Max retries: Limit attempts (3-5 typical)
4. Idempotency: Ensure safe to retry

Example:
Attempt 1: fail (wait 100ms)
Attempt 2: fail (wait 200ms)
Attempt 3: fail (wait 400ms)
Attempt 4: success
```

---

### 3. Bulkhead Pattern

**Problem:** Single point of failure brings down entire system.

**Solution:** Isolate resources into compartments (bulkheads).

```
Microservices: Each service isolated
  Service A failures don't affect Service B

Thread pools: Separate pools per service
  Service B threads don't starve Service A

Network: VPC subnets isolate resources

Database: Connection pool limits
```

---

## Scalability Patterns

### 4. Horizontal Scaling

**Problem:** Single server has capacity limits.

**Solution:** Add more servers, distribute load.

```
Load Balancer
  ├─ Server 1
  ├─ Server 2
  ├─ Server 3
  └─ Server N

Benefits:
- Handle more traffic
- Fault tolerance (lose one, others continue)
- Independent updates
```

---

### 5. Vertical Scaling

**Problem:** Single server saturated.

**Solution:** Increase resources (CPU, memory) of existing server.

**Note:** Limited by maximum hardware size.

---

### 6. Caching Patterns

**Cache-Aside:**
```
Read:
  1. Check cache
  2. If miss, load from database
  3. Cache result
  4. Return

Write:
  1. Update database
  2. Invalidate cache entry
```

**Write-Through:**
```
Write:
  1. Write to cache
  2. Write to database
  3. Confirm success
  
Benefit: Cache always consistent
Drawback: Write latency
```

---

## Operational Patterns

### 7. Health Endpoint Monitoring

**Problem:** Load balancer doesn't know if instance is healthy.

**Solution:** Provide health check endpoint.

```
GET /health
Response:
{
  "status": "healthy",
  "checks": {
    "database": "ok",
    "cache": "ok",
    "disk_space": "ok"
  },
  "timestamp": "2025-11-13T10:00:00Z"
}

Load Balancer:
- Polls /health every 10 seconds
- If 3 failures, removes from rotation
- Retries after 30 seconds
```

---

### 8. Throttling

**Problem:** Excessive load degrades service.

**Solution:** Limit request rate.

```
Strategies:
1. Per-user: 100 req/minute per user
2. Per-IP: 1000 req/minute per IP
3. Per-API-key: 10,000 req/day
4. Global: Total 100,000 req/sec

Response when throttled:
HTTP 429 Too Many Requests
Retry-After: 60 (seconds)
```

---

### 9. Queue-Based Load Leveling

**Problem:** Spiky load causes failures.

**Solution:** Queue requests, process at steady rate.

```
Users → Queue → Consumer Pool
  Requests arrive at variable rate
  Consumers process at constant rate
  Queue absorbs bursts

Benefits:
- Smooth load
- No overload
- Decoupled processing
```

---

## Deployment Patterns

### 10. Blue-Green Deployment

**Problem:** Deploying new version causes downtime.

**Solution:** Run two identical environments, switch traffic.

```
Blue Environment: Current production
Green Environment: New version

Traffic: 100% to Blue
Deploy: To Green
Test: Green fully
Switch: 100% to Green
Rollback: Easy (switch back to Blue)
```

---

### 11. Canary Deployment

**Problem:** Deploying to everyone at once risks production.

**Solution:** Route small % of traffic to new version.

```
Version 1.0: 95% of traffic
Version 1.1: 5% of traffic

Monitor 1.1:
- Error rates
- Latency
- User complaints

If all good after 1 hour:
10% → 25% → 50% → 100%

If issues:
Immediately revert to 0%
```

---

### 12. Rolling Deployment

**Problem:** Can't take service offline for deployment.

**Solution:** Deploy to instances one at a time.

```
Deployment:
1. Remove Instance 1 from load balancer
2. Deploy to Instance 1
3. Add Instance 1 back
4. (Repeat for Instance 2, 3, N)

Benefit: No downtime, service always available
Requirement: Multiple instances and load balancing
```

---

## Data Patterns

### 13. Sharding

**Problem:** Single database can't handle data volume.

**Solution:** Split data across multiple databases.

```
Sharding Strategy: By customer_id % 4
  Shard 0: customers 0,4,8,12...
  Shard 1: customers 1,5,9,13...
  Shard 2: customers 2,6,10,14...
  Shard 3: customers 3,7,11,15...

Query:
- Calculate shard: customer_id % 4
- Query specific shard
```

---

### 14. Materialized View

**Problem:** Complex queries on large datasets are slow.

**Solution:** Pre-compute and cache query results.

```
Source tables (normalized) → Materialized view (denormalized)
                                     ↓
                          Fast read queries
                                     ↓
                          Periodic refresh
```

---

## References

- [Cloud Design Patterns](https://docs.microsoft.com/en-us/azure/architecture/patterns/)
- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)
- Valet Key

### Design & Implementation
- Ambassador
- Anti-Corruption Layer
- Backends for Frontends
- Compute Resource Consolidation
- External Configuration Store
- Gateway Aggregation
- Gateway Offloading
- Gateway Routing
- Leader Election
- Sidecar
- Strangler Fig

### Messaging
- Asynchronous Request-Reply
- Claim Check
- Choreography
- Competing Consumers
- Pipes and Filters
- Priority Queue
- Publisher-Subscriber
- Queue-Based Load Leveling
- Scheduler Agent Supervisor

### Resiliency
- Bulkhead Isolation
- Circuit Breaker
- Compensating Transaction
- Health Endpoint Monitoring
- Leader Election
- Queue-Based Load Leveling
- Retry
- Throttling

### Security
- Federated Identity
- Gatekeeper
- Valet Key

## Related Resources

- [Well-Architected Framework](../../frameworks/well-architected.md)
- [Microservices Framework](../../frameworks/microservices.md)
- [Cloud Migration Playbook](../playbooks/cloud-migration.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
