# Design for Failure Principle

## Overview

**Principle**: Systems will fail; design for resilience and graceful degradation.

Failure is inevitable in distributed systems. The goal is not to prevent all failures but to minimize their impact and enable quick recovery.

## Rationale

- Hardware failures are inevitable
- Network failures happen regularly
- Software bugs are discovered in production
- Human errors occur
- Cascading failures amplify impact
- Resilient design limits damage

## Core Implications

### 1. Assume Failure at Every Level

**Where Failures Occur:**
- Hardware failures (disk, memory, CPU)
- Network failures (latency, timeouts, packet loss)
- Service failures (bugs, resource exhaustion)
- Data corruption (rare but possible)
- Human errors (misconfiguration, accidental deletion)
- Third-party service unavailability

**Design Approach:**
- Each component can fail
- Expect network latency and timeouts
- Assume services may be temporarily unavailable
- Treat partial failures as normal

### 2. Resilience Patterns

**Circuit Breaker:**
```
Service Status: CLOSED (working)
  ↓
Failures detected → Opens circuit
  ↓
Service Status: OPEN (failing)
  ↓
Return errors quickly (don't call failing service)
  ↓
After timeout → HALF_OPEN (test recovery)
  ↓
If working → CLOSED
If still failing → OPEN
```

**Retry with Backoff:**
```
Request fails
  ↓
Wait 100ms, retry
  ↓
Still fails
  ↓
Wait 200ms, retry
  ↓
Still fails
  ↓
Wait 400ms, retry
  ↓
(Exponential backoff prevents overwhelming failing service)
```

**Bulkhead Pattern:**
```
Prevent single service exhausting all resources

Connection Pool:
├─ Service A: Max 10 connections
├─ Service B: Max 10 connections
└─ Service C: Max 10 connections

If Service B has issue:
- Service B connections used up
- Service A/C not affected
- Can still serve requests
```

**Timeout and Fallback:**
```
Request → Service A
  ↓
If timeout > 5s → Fallback
  ↓
Fallback Options:
├─ Cache previous result
├─ Default value
├─ Degraded functionality
└─ Error to user
```

**Graceful Degradation:**
```
All features available:
├─ User profile
├─ Recommendations
├─ Social feed
└─ Personalization

If recommendation service fails:
├─ User profile (still works)
├─ Recommendations (use defaults)
├─ Social feed (still works)
└─ Personalization (limited)

User gets partial functionality instead of error
```

### 3. Disaster Recovery

**Recovery Time Objectives:**

| RTO | Definition | Example |
|-----|-----------|---------|
| <1 hour | Critical services | Production database |
| 1-4 hours | Important services | Production APIs |
| 4-24 hours | Useful services | Analytics |
| >24 hours | Nice-to-have | Dev/test systems |

**Recovery Point Objectives:**

| RPO | Definition | Example |
|-----|-----------|---------|
| <1 minute | Critical data | Real-time financial systems |
| <1 hour | Important data | Customer databases |
| <1 day | Regular data | Reports, analytics |
| >1 day | Low-value data | Logs, temporary data |

**Disaster Recovery Strategies:**

1. **Backup & Restore**
   - Regular backups
   - Test restores regularly
   - Longest RTO/RPO

2. **Warm Standby**
   - Secondary system partially running
   - Switch on failure
   - Moderate RTO/RPO
   - Moderate cost

3. **Active-Active**
   - Multiple systems actively serving traffic
   - Instant failover (no switch needed)
   - Shortest RTO (zero)
   - Highest cost

### 4. Fault Tolerance Patterns

**Stateless Services:**
- Each instance identical
- Can handle failure of any instance
- Request routed to available instance
- Simple to scale and recover

**Data Replication:**
```
Primary Database
  ↓ (write)
  ├─ Replica 1 (read)
  ├─ Replica 2 (read)
  └─ Replica 3 (read)

If primary fails: Promote replica to primary
If replica fails: Data still available from others
```

**Distributed Caching:**
```
Cache Nodes:
├─ Node 1 (some data)
├─ Node 2 (some data)
└─ Node 3 (some data)

Each data item replicated on multiple nodes
If node fails: Data still accessible from replicas
```

## Implementation Practices

### Resilience Architecture

```
┌─────────────────────────────────────────────┐
│ Load Balancer (Health-checked)              │
│ ├─ Remove unhealthy instances               │
│ └─ Distribute across instances              │
├─────────────────────────────────────────────┤
│ Application Tier (Multiple instances)       │
│ ├─ Stateless (easier failover)              │
│ ├─ Circuit breakers (fail fast)             │
│ ├─ Timeouts (don't hang indefinitely)       │
│ ├─ Retries (handle transient failures)      │
│ └─ Degradation (partial functionality)      │
├─────────────────────────────────────────────┤
│ Data Layer (Replicated)                     │
│ ├─ Primary-replica setup                    │
│ ├─ Multi-zone replication                   │
│ ├─ Point-in-time recovery capability        │
│ └─ Regular backup testing                   │
├─────────────────────────────────────────────┤
│ Monitoring & Alerting                       │
│ ├─ Detect failures early                    │
│ ├─ Alert on anomalies                       │
│ └─ Enable quick response                    │
└─────────────────────────────────────────────┘
```

### Chaos Engineering

Test resilience by intentionally causing failures:

**Common Chaos Tests:**
- Kill random instances
- Inject network latency
- Cause database failures
- Throttle network bandwidth
- Fill disk space
- Consume CPU/memory

**Tools:**
- Chaos Monkey (Netflix)
- Gremlin (commercial chaos platform)
- Kubernetes chaos (chaoskube)

### Observability for Resilience

```
Metrics (What's happening):
├─ Error rates
├─ Latency
├─ Success rates
└─ Resource utilization

Logs (Why it happened):
├─ Error messages
├─ Stack traces
└─ Contextual information

Traces (Where requests go):
├─ Request path through services
├─ Performance at each step
└─ Where bottlenecks are

Alerts (Take action):
├─ High error rate → investigate
├─ High latency → scale
├─ Component failure → failover
```

## Common Scenarios

### Scenario 1: Service Dependency Failure
**Situation:** Payment service is down; orders can't complete.

**Resilience Approach:**
1. Timeout: Don't wait forever for payment service
2. Circuit breaker: Detect failure, stop calling
3. Fallback: Queue order for later processing
4. Degradation: User sees "payment processing" instead of error
5. Recovery: Auto-retry when service recovers

### Scenario 2: Database Failure
**Situation:** Primary database becomes unavailable.

**Resilience Approach:**
1. Replication: Data is on replicas
2. Failover: Promote replica to primary
3. Application updates: Connection string points to new primary
4. Recovery: Restore/rebuild failed primary
5. Testing: Regular failover drills

### Scenario 3: Region Outage
**Situation:** Entire cloud region goes down.

**Resilience Approach:**
1. Multi-region deployment
2. Data replicated across regions
3. DNS failover to another region
4. Auto-scaling in other region
5. Traffic redirected automatically

## Risks of Ignoring This Principle

❌ **Outages:** Single point of failure causes downtime
❌ **Cascading Failures:** One failure takes down entire system
❌ **Data Loss:** Failures without backups lose data
❌ **Customer Impact:** Extended downtime, angry customers
❌ **High MTTR:** Manual recovery takes hours

## Best Practices

✅ **Assume failure will happen**
Design with this assumption.

✅ **Implement circuit breakers**
Detect failures and stop making failing calls.

✅ **Use timeouts**
Don't wait forever for responses.

✅ **Implement retries**
Handle transient failures automatically.

✅ **Plan for degradation**
Partial functionality better than complete failure.

✅ **Replicate critical data**
Enable recovery from failures.

✅ **Test disaster recovery regularly**
Practice failover; don't assume it works.

✅ **Monitor actively**
Detect failures early; enable quick response.

## Related Principles

- **[Observability Built-In](./observability-built-in.md)** - Detecting failures
- **[Automation Over Manual](./automation-over-manual.md)** - Automated recovery
- **[Scalability and Performance](./scalability-and-performance.md)** - Scaling for resilience

## References

- _Release It!_ (Michael Nygard)
- _Site Reliability Engineering_ (Betsy Beyer, et al.)
- _Building Microservices_ (Sam Newman)
- Netflix Chaos Engineering

---

**Last Updated:** November 2025
**Principle Category:** Quality
**Applies To:** All production systems
**Related Documents:** [Disaster Recovery Plan](../../knowledge-base/guides/disaster-recovery.md), [High Availability Guide](../../knowledge-base/guides/high-availability.md)
