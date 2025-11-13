# Non-Functional Requirements (NFR) Template

## Purpose

The Non-Functional Requirements (NFR) document defines the quality attributes and constraints that the system must satisfy. While functional requirements define what the system does, NFRs define how well it does it.

---

## When to Use

- Starting new projects or major features
- Defining system quality standards
- Setting performance targets
- Planning capacity and infrastructure
- Creating SLAs and service agreements

---

## Template Content

### 1. Executive Summary

**System Name:** [System/Service Name]

**NFR Scope:** [What aspects of the system are covered]

**Key Constraints:** [Critical limitations or requirements]

**Stakeholders:** [Who cares about these requirements]

---

### 2. Performance Requirements

**Response Time:**

| Operation | P50 | P95 | P99 | Context |
|-----------|-----|-----|-----|---------|
| GET /users/{id} | 50ms | 100ms | 200ms | Cached response |
| POST /orders | 200ms | 500ms | 1000ms | Database write |
| GET /search?q=... | 100ms | 500ms | 2000ms | Index search |
| GET /reports | 5000ms | 10000ms | 30000ms | Aggregation |

**Throughput:**

```
API Gateway:        10,000 RPS
User Service:       5,000 RPS
Order Service:      2,000 RPS
Payment Service:    500 RPS
Database:           5,000 concurrent connections
Cache:              100,000 RPS
```

**Resource Utilization:**

```
CPU:
  Normal load: < 50%
  Peak load: < 80%
  Max: < 95%

Memory:
  Normal: < 60%
  Peak: < 85%
  Max: < 95%

Disk:
  Usage: < 80%
  I/O: < 70% utilization
  Growth rate: [X GB/month]
```

---

### 3. Scalability Requirements

**Expected Growth:**

```
Year 1:
  - Users: 100K
  - Requests/day: 1M
  - Data stored: 10GB

Year 2:
  - Users: 500K
  - Requests/day: 10M
  - Data stored: 50GB

Year 3:
  - Users: 2M
  - Requests/day: 50M
  - Data stored: 200GB
```

**Scaling Strategy:**

**Horizontal (Add more servers):**
- Stateless services (easy to scale)
- Load balanced across instances
- Database read replicas

**Vertical (Add more power):**
- Not preferred for new systems
- Used for database optimization
- Limits on instance sizes

**Auto-Scaling Rules:**
```
Trigger: CPU > 70% for 5 minutes
Action: Add 2 instances
Maximum: 20 instances

Trigger: CPU < 30% for 10 minutes
Action: Remove 1 instance
Minimum: 2 instances
```

---

### 4. Availability & Reliability

**Availability Target:**

```
99.5%   = 43.2 minutes/month downtime
99.9%   = 4.32 minutes/month downtime
99.99%  = 0.43 minutes/month downtime
99.999% = 0.03 minutes/month downtime
```

**Target SLA:** 99.9% (4 nines)

**Recovery Time Objective (RTO):**
- Critical systems: < 15 minutes
- Important systems: < 1 hour
- Non-critical: < 4 hours

**Recovery Point Objective (RPO):**
- Financial data: < 1 hour
- User data: < 4 hours
- Logs: < 24 hours

**Failure Scenarios:**

| Failure | Target Recovery | Mechanism |
|---------|-----------------|-----------|
| Single instance | Automatic | Load balancer failover |
| Database failure | < 15 min | Automated failover to replica |
| Zone outage | < 30 min | Multi-zone deployment |
| Region outage | < 4 hours | DR site or backup region |
| Data corruption | 1 hour | Point-in-time restore |

---

### 5. Security Requirements

**Data Encryption:**

```
At Rest:
  - Algorithm: AES-256
  - Key management: AWS KMS / Azure Key Vault
  - Key rotation: Annual or on demand

In Transit:
  - Protocol: HTTPS/TLS 1.2+
  - Certificate: Valid, auto-renewed
  - Ciphers: Strong, modern algorithms
```

**Authentication:**

```
Methods:
  - Password: Min 12 chars, complexity required
  - MFA: Required for admin accounts
  - API Keys: Rotated every 90 days
  - OAuth 2.0: For third-party integrations

Password Policy:
  - Minimum length: 12 characters
  - Complexity: Upper, lower, number, symbol
  - History: Don't reuse last 5 passwords
  - Expiration: Compromise-driven (no forced expiration)
```

**Authorization:**

```
RBAC (Role-Based Access Control)
  - Admin: Full access
  - Manager: Team access
  - User: Own data access
  - Guest: Read-only

ABAC (Attribute-Based):
  - Attribute: Department == "Finance"
  - Attribute: Time.hour between 9-17
  - Attribute: Location.country in ["US", "CA"]
```

**Compliance:**

```
Standards:
  - OWASP Top 10 mitigation
  - PCI-DSS (if handling cards)
  - GDPR (if EU users)
  - HIPAA (if health data)
  - SOC 2 Type II (if B2B)

Regular Security:
  - Annual penetration testing
  - Quarterly security audits
  - Dependency vulnerability scanning
  - Code security scanning (SAST)
```

---

### 6. Maintainability Requirements

**Code Quality:**

```
Metrics:
  - Code coverage: > 80%
  - Cyclomatic complexity: < 10
  - Duplication: < 5%
  - Technical debt ratio: < 10%

Standards:
  - Follow language style guides
  - Automated formatting (prettier, black)
  - Linting with automated enforcement
  - Architecture compliance checks
```

**Documentation:**

```
Requirements:
  - API documentation (OpenAPI/Swagger)
  - Architecture Decision Records (ADRs)
  - Runbooks for common operations
  - Troubleshooting guides
  - Design document for complex features

Maintenance:
  - Keep documentation in repo
  - Update with code changes
  - Regular reviews (quarterly)
```

**Testing:**

```
Unit Tests:
  - Coverage: > 80%
  - Speed: All tests in < 5 minutes
  - Isolation: No external dependencies

Integration Tests:
  - Coverage: Critical paths
  - Speed: < 30 minutes
  - Database: Use test database

E2E Tests:
  - Smoke tests: Core workflows
  - Run: Pre-deployment
  - Environment: Staging only
```

---

### 7. Observability Requirements

**Logging:**

```
Log Levels:
  - DEBUG: Dev/staging only
  - INFO: Important events
  - WARNING: Unusual but handled
  - ERROR: System errors

Retention:
  - Development: 7 days
  - Staging: 30 days
  - Production: 90 days

PII Handling:
  - Never log passwords, tokens
  - Mask credit cards (show last 4 only)
  - Anonymize user IPs
  - Purge old PII automatically

Format (structured logging):
{
  "timestamp": "2025-01-15T10:30:00Z",
  "level": "ERROR",
  "service": "order-service",
  "request_id": "req-abc123",
  "user_id": 123,
  "message": "Payment processing failed",
  "error": "timeout",
  "duration_ms": 30500
}
```

**Metrics:**

```
Application Metrics:
  - Request rate (RPS)
  - Response time (P50, P95, P99)
  - Error rate (by status code)
  - Cache hit ratio
  - Database query time

Infrastructure Metrics:
  - CPU utilization
  - Memory usage
  - Disk I/O
  - Network throughput
  - Container restarts

Business Metrics:
  - Orders per minute
  - Conversion rate
  - Customer acquisition cost
  - Revenue impact
```

**Alerting:**

```
Critical (page oncall):
  - Service down (0 requests/min)
  - Error rate > 10%
  - P99 latency > 5 seconds
  - Database unavailable

High (create ticket):
  - P99 latency > 2 seconds
  - Error rate > 1%
  - CPU > 80% for 10 minutes
  - Disk > 85% full

Medium (dashboard):
  - P95 latency > 1 second
  - Memory > 75% for 5 minutes
  - Unusual traffic pattern
```

---

### 8. Compliance & Governance

**Regulatory Requirements:**

```
GDPR (EU):
  - User right to access data
  - User right to deletion
  - Data breach notification (72 hours)
  - Data processing agreements
  - Privacy by design

PCI-DSS (Payment Cards):
  - Secure cardholder data
  - Regular security testing
  - Maintain firewall
  - Restrict data access
  - Monitor and test regularly

SOC 2 (Service providers):
  - Security: Access controls, encryption
  - Availability: Uptime targets, redundancy
  - Integrity: Accurate processing
  - Confidentiality: Data protection
  - Privacy: Data usage policies
```

**Change Management:**

```
Process:
  1. Propose change (RFC)
  2. Review and approval
  3. Test in staging
  4. Schedule deployment
  5. Deploy to production
  6. Monitor for issues
  7. Document change

Rollback Plan:
  - Each change has rollback procedure
  - Tested before deployment
  - Automated when possible
  - Manual review if issues occur
```

---

### 9. Usability Requirements

**User Interface:**

```
Accessibility (WCAG 2.1 AA):
  - Keyboard navigation
  - Screen reader support
  - Color contrast ratios
  - Alt text for images
  - Focus indicators

Performance:
  - Page load: < 3 seconds
  - Interactive: < 5 seconds
  - CLS: < 0.1
  - FID: < 100ms
  - LCP: < 2.5 seconds
```

**Mobile:**

```
Support:
  - iOS 13+
  - Android 8+

Performance:
  - Works on 3G networks
  - App size: < 50MB
  - Battery aware (reduce refresh)

Features:
  - Offline mode (cached data)
  - Touch-optimized (44px min)
  - Responsive design
```

---

### 10. Deployment & Operational Requirements

**Deployment Frequency:**
- Target: Daily deployments
- Minimum: Weekly deployments
- Maximum downtime per deploy: 0 minutes (zero-downtime deployment)

**Deployment Process:**
```
1. Code review (2 approvals)
2. Run test suite (100% pass)
3. Build Docker image
4. Push to registry
5. Deploy to staging
6. Run smoke tests
7. Deploy to production (canary)
8. Monitor for 1 hour
9. Full rollout
```

**Monitoring & Alerting:**
- Uptime monitoring: 24/7
- Alert response: < 15 minutes
- Escalation: Defined procedures
- On-call rotation: [Schedule]

**Incident Response:**
```
Severity 1 (Down):
  - Page oncall immediately
  - Declare incident
  - Focus on restore
  - Target resolution: < 1 hour

Severity 2 (Degraded):
  - Create incident ticket
  - Investigate root cause
  - Implement fix
  - Target resolution: < 4 hours

Severity 3 (Minor):
  - Log issue
  - Schedule fix
  - Address in next sprint
```

---

### 11. Cost Requirements

**Budget Constraints:**

```
Infrastructure:      $50,000/year
Tools & Services:    $10,000/year
Personnel:           $200,000/year

Performance targets:
  - Cost per user: < $1/month
  - Cost per request: < $0.0001
  - Infrastructure cost: < 20% of revenue
```

**Cost Optimization:**

```
Strategies:
  - Use spot instances: 70% cost savings
  - Reserved capacity: 40% discount
  - Auto-scaling: Pay for actual usage
  - Caching: Reduce database load
  - CDN: Reduce bandwidth costs
```

---

### 12. Environmental Requirements

**Operating Environments:**

```
Development:
  - Local machine development
  - Docker compose setup
  - In-memory databases allowed
  - No security restrictions

Staging:
  - Mirrors production
  - Production-like database
  - Load testing allowed
  - Security testing required

Production:
  - High availability setup
  - Multi-region deployment
  - Full monitoring
  - Automated backups
```

**Infrastructure Requirements:**

```
Compute:
  - Min instance: t3.medium
  - Max instance: m5.2xlarge
  - Auto-scaling: 2-20 instances

Storage:
  - Database: 500GB
  - Object storage: 1TB
  - Backups: 2 years retention

Network:
  - VPC isolation
  - Private subnets
  - NAT gateway for outbound
```

---

## Related Resources

- [Technical Design Template](./documents/technical-design-template.md)
- [Architecture Vision Template](./documents/architecture-vision-template.md)
- [Performance Guide](../knowledge-base/playbooks/performance-guide.md)
- [Security Guide](../knowledge-base/playbooks/security-guide.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
