# Observability Built-In Principle

## Overview

**Principle**: Systems must be observable through logging, metrics, and tracing.

You can't manage what you can't measure. Observability enables understanding system behavior, detecting issues, and enabling quick diagnosis.

## Rationale

- Distributed systems are complex and opaque
- Issues surface in production, not development
- Quick diagnosis requires rich data
- Observability enables proactive monitoring
- Data-driven decisions require metrics

## Core Implications

### 1. Three Pillars of Observability

**Metrics:**
- Quantitative measurements
- Time-series data
- Example: requests/second, error rate, latency
- Used for monitoring and alerting

**Logs:**
- Detailed event records
- Context and debugging info
- Example: "User 123 attempted login, failed due to invalid password"
- Used for investigation and debugging

**Traces:**
- Request flow through systems
- Performance at each step
- Example: Request enters API → calls Service A → calls Service B → returns
- Used for understanding architecture and bottlenecks

### 2. Structured Logging

**Structured Logs:**
```json
{
  "timestamp": "2025-11-12T10:30:45.123Z",
  "level": "ERROR",
  "message": "Payment processing failed",
  "request_id": "req-12345",
  "user_id": "user-456",
  "service": "payment-service",
  "error": {
    "type": "ConnectionTimeout",
    "message": "Failed to connect to payment gateway",
    "stack_trace": "..."
  },
  "context": {
    "order_id": "order-789",
    "amount": 99.99,
    "gateway": "stripe",
    "retry_count": 2
  }
}
```

**vs. Unstructured Logs:**
```
ERROR: Payment processing failed for user 456, order 789, amount 99.99, gateway stripe, retry 2
```

**Structured Logging Benefits:**
- Machine-searchable and parseable
- Easy to aggregate and analyze
- Can filter, aggregate, correlate
- Enables automated alerting

### 3. Key Metrics

**Application Metrics:**

```
Request Metrics:
- Request rate (requests/second)
- Error rate (errors/second)
- Latency (p50, p95, p99 milliseconds)
- Throughput (requests completed)

Business Metrics:
- Orders placed
- Revenue
- User signups
- Conversion rate

Infrastructure Metrics:
- CPU usage
- Memory usage
- Disk space
- Network I/O
```

**SLI/SLO/SLA:**

```
SLI (Service Level Indicator):
- Measurable metric
- Example: "99% of requests complete in <100ms"

SLO (Service Level Objective):
- Target for SLI
- Example: "Maintain 99% of requests <100ms"

SLA (Service Level Agreement):
- Contract with customers
- Example: "We guarantee 99.9% uptime"
```

### 4. Distributed Tracing

**Trace Example:**
```
User Request
  ├─ API Gateway (5ms)
  │   ├─ Auth Check (2ms)
  │   └─ Route Request (3ms)
  ├─ Service A (100ms)
  │   ├─ Business Logic (50ms)
  │   └─ Database Query (50ms)
  ├─ Service B (80ms)
  │   └─ API Call (80ms)
  └─ Format Response (10ms)

Total: 195ms

Bottleneck: Service A Database Query (50ms)
Next Optimization: Add caching
```

## Implementation Practices

### Observability Architecture

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Application  │  │ Infrastructure │ │ Custom Events│
│ Logs         │  │ Metrics       │  │ Metrics      │
└───────┬──────┘  └────────┬──────┘  └────────┬─────┘
        │                   │                  │
        └───────────────────┼──────────────────┘
                            │
                    ┌───────▼────────┐
                    │ Log Aggregator │
                    │ (ELK, Splunk)  │
                    └────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    ┌───▼───┐           ┌───▼────┐        ┌───▼────┐
    │Search │           │Dashboard│       │Alerts  │
    │& Analysis│        │(Visualize)│    │(Action)│
    └───────┘           └────────┘        └────────┘
```

### Instrumentation Patterns

**Application Instrumentation:**

```python
# Structured Logging
logger.info("Order created", extra={
    "order_id": order.id,
    "user_id": order.user_id,
    "total": order.total,
    "items_count": len(order.items)
})

# Metrics
counter.inc("orders.created")
histogram.observe("order.total", order.total)
gauge.set("inventory.current_level", inventory_count)

# Tracing
with tracer.start_as_current_span("process_payment") as span:
    span.set_attribute("order.id", order.id)
    span.set_attribute("amount", amount)
    result = process_payment(order, amount)
    span.set_attribute("status", result.status)
```

### Common Observability Tools

| Category | Tools |
|----------|-------|
| Metrics | Prometheus, DataDog, New Relic |
| Logs | ELK (Elasticsearch/Logstash/Kibana), Splunk, CloudWatch |
| Traces | Jaeger, Zipkin, AWS X-Ray |
| Combined | DataDog, New Relic, Splunk, Dynatrace |

## Common Scenarios

### Scenario 1: Slow Request
**Situation:** Users report slow page loads.

**Observability Approach:**
1. Check latency metrics → Identify affected endpoints
2. Look at traces → See which service is slow
3. Check service metrics → Find bottleneck (CPU? Database?)
4. Review logs → Find errors or warnings
5. Correlate data → Root cause identified
6. Fix → Implement optimization
7. Verify → Confirm improvement in metrics

### Scenario 2: Error Rate Spike
**Situation:** Error rate suddenly increases.

**Observability Approach:**
1. Alert triggers at high error rate
2. Check logs → See specific error messages
3. Check timestamps → Correlate with deployments/events
4. Check traces → See affected services
5. Check metrics → Identify resource constraints
6. Correlate → Find root cause
7. Respond → Fix issue or rollback

### Scenario 3: Memory Leak
**Situation:** Application memory usage grows over time.

**Observability Approach:**
1. Monitor memory metrics over time
2. Identify trend (steady increase)
3. Correlate with requests (more requests = more memory?)
4. Profile application → Find which objects aren't released
5. Review code → Find leak
6. Fix → Implement proper cleanup
7. Verify → Memory usage stabilizes

## Risks of Ignoring This Principle

❌ **Blind Operation:** Can't see what's happening
❌ **Slow Troubleshooting:** Takes hours to diagnose issues
❌ **Cascading Failures:** Issues not detected until major impact
❌ **No Insights:** Don't understand system behavior
❌ **Reactive Only:** Always firefighting, no proactive improvement

## Best Practices

✅ **Instrument from the start**
Don't add observability after problems occur.

✅ **Use structured logging**
Makes logs machine-searchable.

✅ **Emit business metrics**
Track what matters to business, not just technical metrics.

✅ **Correlate requests**
Use request IDs to track requests through systems.

✅ **Set meaningful alerts**
Alert on business impact, not low-level metrics.

✅ **Dashboards for different audiences**
Executive dashboard ≠ Engineer dashboard.

✅ **Use distributed tracing**
Understand request flow through services.

✅ **Retention policies**
Keep logs for compliance; archive/delete old data.

## Related Principles

- **[Design for Failure](./design-for-failure.md)** - Observability enables detecting failures
- **[Automation Over Manual](./automation-over-manual.md)** - Automate response to alerts
- **[Customer-Centric Design](./customer-centric-design.md)** - Measure customer experience

## References

- _Observability Engineering_ (Charity Majors, Liz Fong-Jones, George Miranda)
- OpenTelemetry (instrumentation standard)
- SRE Book (Site Reliability Engineering)

---

**Last Updated:** November 2025
**Principle Category:** Operations
**Applies To:** All production systems
**Related Documents:** [Observability Guide](../../knowledge-base/guides/observability.md), [Monitoring Standards](../../knowledge-base/standards/monitoring.md)
