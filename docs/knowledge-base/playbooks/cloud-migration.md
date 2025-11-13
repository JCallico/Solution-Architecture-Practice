# Cloud Migration Playbook

## Overview

Comprehensive guide for planning and executing cloud migration projects. This playbook provides assessment frameworks, migration strategies, execution methodologies, and post-migration optimization approaches to minimize risk and maximize cloud benefits.

---

## Phase 1: Assessment

### 1.1 Application Portfolio Analysis

**Inventory Assessment:**

| Application | Size | Complexity | Data Volume | Dependencies | Critical? |
|-------------|------|-----------|-------------|--------------|-----------|
| Web App | 50K LOC | Medium | 10GB | 3 external | Yes |
| Legacy Batch | 150K LOC | High | 100GB | 5 external | No |
| Mobile API | 30K LOC | Low | 5GB | 2 external | Yes |
| Data Pipeline | 20K LOC | Medium | 500GB | Analytics | Yes |

**Categorization:**

```
Application Portfolio (100 apps)
├─ Migration Ready (40%)
│  ├─ Cloud-native (15%)
│  └─ Lift-and-shift (25%)
├─ Refactoring Candidate (35%)
├─ Hybrid Approach (15%)
└─ Retain On-Premise (10%)
```

**Application Properties to Assess:**

- **Architecture:** Monolithic, microservices, serverless-ready
- **Technology Stack:** Supported in cloud? License implications?
- **Data Dependencies:** Sensitivity, residency requirements
- **User Patterns:** Global, regional, internal
- **SLA Requirements:** RTO, RPO, availability needs
- **Cost Drivers:** Computing, storage, data transfer, licensing
- **Security/Compliance:** Data classification, regulatory requirements
- **Team Expertise:** Existing cloud skills

---

### 1.2 Cloud Readiness Assessment

**Readiness Scoring Matrix (0-5 per category):**

| Category | Level 1 | Level 3 | Level 5 |
|----------|---------|---------|---------|
| Architecture | Monolithic, tightly coupled | Multi-tier, some decoupling | Microservices, cloud-native |
| Infrastructure | Physical servers | Virtualized | Infrastructure as code |
| Deployment | Manual, quarterly | Automated, monthly | CI/CD, continuous |
| Monitoring | Basic logging | Centralized monitoring | Comprehensive observability |
| Security | Perimeter-based | Identity-based | Zero-trust model |
| Skills | No cloud experience | Some cloud exposure | Cloud expert team |
| Database | Single monolithic | Some separation | Database per service |

**Readiness Score = Sum / 35 (number of categories × max level)**

| Score | Assessment | Recommendation |
|-------|-----------|-----------------|
| 0-1 | Not Ready | 6-12 months prep |
| 1-2 | Basic Ready | Start with pilot |
| 2-3 | Ready | Begin migration |
| 3+ | Well Ready | Accelerate migration |

---

### 1.3 TCO (Total Cost of Ownership) Calculation

**On-Premise Costs (3-year projection):**

```
Infrastructure
├─ Hardware acquisition: $500K
├─ Maintenance (5% annually): $75K/year
├─ Facilities (power, cooling, space): $60K/year
└─ Subtotal: $695K

Personnel
├─ Infrastructure team (3 people): $450K/year
├─ DBA (1 person): $120K/year
├─ Security team (part-time): $80K/year
└─ Subtotal: $650K/year × 3 = $1,950K

Software Licenses
├─ Database licensing: $40K/year
├─ Middleware: $30K/year
└─ Subtotal: $70K/year × 3 = $210K

Total On-Premise 3-Year TCO: ~$2.86M
```

**Cloud Costs (3-year projection):**

```
Compute
├─ Peak load: 200 vCPU × $0.15/hour
├─ Average 40% utilization: ~$26K/month
└─ Annual: $312K × 3 = $936K

Storage
├─ Database: 1TB × $0.25/GB-month: $2.5K/month
├─ Archive: 5TB × $0.05/GB-month: $2.5K/month
└─ Annual: $60K × 3 = $180K

Data Transfer
├─ Outbound: 1PB/month × $0.12/GB: $120K/month
├─ Inter-region: negligible
└─ Annual: $1.44M × 3 = $4.32M (varies greatly)

Personnel
├─ Cloud architects (2): $250K/year
├─ DevOps engineers (3): $360K/year
├─ Subtotal: $610K/year × 3 = $1,830K

Total Cloud 3-Year TCO: ~$7.27M
```

**Key Variables Affecting Cloud TCO:**

1. **Data Transfer Costs:** Often largest variable
2. **Licensing:** Can be cheaper or more expensive
3. **Utilization:** Cloud rewards efficient resource use
4. **Automation:** Fewer manual processes = lower personnel cost

---

### 1.4 Risk Assessment Framework

**Risk Identification Matrix:**

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| Data loss during migration | Low | Critical | Backup/test restore procedures |
| Performance degradation | Medium | High | Load testing, rollback plan |
| Security breach post-migration | Low | Critical | Security audit, zero-trust setup |
| Budget overrun | High | Medium | Cap spending, governance |
| Vendor lock-in | Medium | High | Multi-cloud strategy, abstraction |
| Skilled staff shortage | High | High | Training, external consultants |

**Risk Priority:**

```
Impact
  ▲
  │         ●● Risk: Data Loss
  │           (Probability: 10%, Impact: 95%)
  │         ● ●
  │    ●●●●●● Risk: Budget Overrun
  │    ●●●●●● (Probability: 60%, Impact: 60%)
  │ ●●●●●●●●
  └──────────────────► Probability
```

---

## Phase 2: Strategy Development

### 2.1 The 6 R's Migration Patterns

**1. Rehost (Lift and Shift)**

```
On-Premise        Cloud
  ┌──────┐         ┌──────┐
  │ App  │ ─────→ │ App  │
  │ VM 1 │  Copy  │ EC2  │
  └──────┘   +    └──────┘
  ┌──────┐   Move ┌──────┐
  │ VM 2 │ ─────→ │ EC2  │
  └──────┘        └──────┘

Minimal changes, fastest migration
```

**Characteristics:**
- Timeline: 2-3 weeks per application
- Cost: Often 30% cheaper on cloud
- Complexity: Low
- Future flexibility: Limited

**Example:** VMware VM → AWS EC2

---

**2. Replatform (Lift, Tinker, and Shift)**

```
On-Premise          Cloud
  ┌──────┐          ┌──────┐
  │ App  │          │ App  │
  │ Java │ ─────→ │ Java │
  │ OracleDB│ Reconfig
  └──────┘  └──────┘
             +
          AWS RDS
          (Managed DB)
```

**Characteristics:**
- Timeline: 4-6 weeks per application
- Cost: 40-50% cheaper on cloud
- Complexity: Medium
- Future flexibility: Good

**Example:** Self-managed database → AWS RDS

---

**3. Refactor/Re-architect**

```
Monolith           Microservices
┌─────────┐        ┌────┐ ┌────┐ ┌────┐
│ App     │        │Svc1│ │Svc2│ │Svc3│
│ ├─User  │ ────→  └────┘ └────┘ └────┘
│ ├─Order │        ┌────┐ ┌────┐
│ ├─Prod  │        │Svc4│ │Svc5│
│ └─Report│        └────┘ └────┘
└─────────┘
```

**Characteristics:**
- Timeline: 12-18 months
- Cost: Can be 60% cheaper long-term
- Complexity: High
- Future flexibility: Excellent

**Example:** Monolithic Java app → Microservices on Kubernetes

---

**4. Repurchase (Move to SaaS)**

```
Self-Managed       SaaS
  ┌──────┐         ┌──────┐
  │ HR   │         │ HR   │
  │ App  │ ────→  │ Cloud │
  │ DB   │        │ (Vendor│
  └──────┘        │ Managed)
                  └──────┘
```

**Characteristics:**
- Timeline: 3-6 months
- Cost: Often higher operational cost
- Complexity: Low
- Flexibility: Limited to vendor features

**Example:** Oracle ERP → Salesforce Cloud

---

**5. Retire (Decommission)**

```
Unused Applications (20-30% of portfolio)
  ├─ Legacy systems with no active users
  ├─ Duplicate functionality
  └─ Can be safely decommissioned

Cost Savings: Eliminate license + maintenance
```

---

**6. Retain (Keep On-Premise)**

```
Applications to Keep On-Premise:
  ├─ Regulatory restrictions (data residency)
  ├─ Mission-critical with zero latency needs
  ├─ Custom hardware dependencies
  └─ Can remain in hybrid architecture
```

---

### 2.2 Workload Prioritization

**Priority Matrix (Impact vs Effort):**

```
Impact
  ▲
  │  ┌─────────────┐
  │  │   QUICK     │
  │H │   WINS      │  [Prioritize First]
  │  │             │
  │  └─────────────┤
  │       │        │
  │      ┌┴┐       │
  │ ┌────┴─┴─┐     │
  │ │ Strategic│    │
  │M│ Projects │    │ [Medium Priority]
  │ └────┬─┬──┘    │
  │      │ │       │
  │  ┌───┴─┴───┐  │
  │  │  Low    │  │ [Defer]
  │L │ Priority│  │
  │  └─────────┘──┴──
  └────────────────────► Effort
```

**Quick Wins (Migrate First):**
1. Stateless applications
2. No database dependencies
3. < 2 hour migration window
4. Clear success metrics

**Strategic Projects (Migrate Second):**
1. Mission-critical applications
2. High cost/performance impact
3. Support business transformation
4. Foundation for other migrations

**Examples:**

| Workload | Category | Timeline |
|----------|----------|----------|
| Test/Dev environment | Quick Win | Week 1-2 |
| Non-critical legacy app | Quick Win | Week 3-4 |
| High-cost infrastructure | Strategic | Month 2-3 |
| Core revenue system | Strategic | Month 4-6 |

---

### 2.3 Cloud Provider Selection

**Multi-Cloud Decision Matrix:**

| Criteria | AWS | Azure | Google Cloud | On-Prem |
|----------|-----|-------|--------------|---------|
| Market Share | 32% | 23% | 11% | n/a |
| Enterprise Support | Excellent | Excellent | Good | Legacy |
| SQL Database | ✅ RDS | ✅ SQL DB | ✅ Cloud SQL | Oracle |
| Kubernetes | ✅ EKS | ✅ AKS | ✅ GKE | Manual |
| Serverless | ✅ Lambda | ✅ Functions | ✅ Cloud Run | No |
| AI/ML | ✅ Strong | ✅ Strong | ✅ Leader | No |
| Pricing | Competitive | Competitive | Aggressive | High |
| Enterprise License Integration | Good | ✅ Best | Moderate | Native |
| Regional Availability | 30+ | 60+ | 40+ | Fixed |

**Selection Decision Tree:**

```
Do you use Microsoft products?
├─ YES → Azure (best SQL Server integration)
└─ NO → AWS or Google Cloud
        └─ Need enterprise support?
           ├─ YES → AWS
           └─ NO → Google Cloud (better pricing)
```

---

### 2.4 Hybrid Cloud Considerations

**Hybrid Architecture Example:**

```
On-Premise              Public Cloud
┌────────────────┐     ┌──────────────────┐
│ Legacy Systems │     │ SaaS Apps        │
│ (HR, Finance)  │     │ (Salesforce)     │
│                │     │                  │
│ Data Center    │─────│ Direct Connect   │─────│ Web Apps
│ Database       │     │ (Private Link)   │     │ Microservices
└────────────────┘     └──────────────────┘     └──────────┘
        │                       │                      │
        └───────────────────────┴──────────────────────┘
                    Enterprise Network
```

**Hybrid Considerations:**

1. **Network Connectivity:** Dedicated connections (AWS Direct Connect, Azure ExpressRoute)
2. **Data Residency:** Keep sensitive data on-premise
3. **Compliance:** Meet regulatory requirements
4. **Latency:** Keep latency-sensitive apps on-premise
5. **Cost:** Pay for bandwidth and connectivity

---

## Phase 3: Execution

### 3.1 Wave Planning

**Migration Wave Timeline:**

```
Wave 1 (Months 1-2): Preparation & Quick Wins
├─ Setup cloud infrastructure
├─ Migrate test/dev environment
└─ Build operational procedures

Wave 2 (Months 3-4): Early Adopters
├─ Migrate non-critical production apps
├─ Validate procedures and automation
└─ Build team expertise

Wave 3 (Months 5-9): Core Systems
├─ Migrate primary revenue systems
├─ Optimize for cloud (right-sizing, caching)
└─ Decommission on-premise infrastructure

Wave 4 (Months 10-12): Legacy & Cleanup
├─ Migrate remaining legacy systems
├─ Finalize on-premise decommissioning
└─ Complete cost optimization
```

**Wave Decision Criteria:**

| Wave | Risk Level | Complexity | Dependencies |
|------|-----------|-----------|--------------|
| 1 | Low | Low | Standalone apps |
| 2 | Low-Medium | Low-Medium | < 3 dependencies |
| 3 | Medium-High | High | 3+ dependencies |
| 4 | High | High | Interdependent |

---

### 3.2 Migration Runbooks

**Template Runbook for Application X:**

```yaml
Application: User Service
Migration Approach: Rehost
Target: AWS EC2 + RDS
Scheduled Downtime: 2 hours (weekend)
Rollback Time: 30 minutes

Pre-Migration Checklist:
  [ ] AMI image built and tested
  [ ] RDS database created and configured
  [ ] Security groups and IAM roles configured
  [ ] VPN/Direct Connect tested
  [ ] DNS plan documented
  [ ] Team trained and on-call

Migration Steps:
  1. (T-30min) Notify users of maintenance window
  2. (T-20min) Final database backup
  3. (T-15min) Stop application on-premise
  4. (T-10min) Database replication catchup
  5. (T-5min) DNS cutover to cloud endpoint
  6. (T-0) Start application on cloud
  7. (T+5min) Verify application health
  8. (T+30min) Confirm successful migration

Post-Migration:
  [ ] Monitor application metrics
  [ ] Verify data integrity
  [ ] Test user workflows
  [ ] Decommission on-premise servers
  [ ] Update documentation

Rollback Criteria:
  - Application errors > 1%
  - Database replication lag > 5 seconds
  - Response time > 5 seconds
  - Data corruption detected

Rollback Steps:
  1. DNS cutover back to on-premise
  2. Resume on-premise application
  3. Verify user access restored
  4. Investigate cloud issue
```

---

### 3.3 Testing and Validation

**Testing Strategy:**

```
Functional Testing
├─ Unit tests (automated)
├─ Integration tests (automated)
├─ UAT (manual, business users)
└─ Production smoke tests

Performance Testing
├─ Load testing (peak capacity)
├─ Stress testing (beyond capacity)
├─ Soak testing (24+ hours)
└─ Failover testing

Security Testing
├─ Vulnerability scanning
├─ Penetration testing
├─ Compliance validation
└─ Access control verification

Data Validation
├─ Record count comparison (on-premise vs cloud)
├─ Data integrity checks (checksums)
├─ Data completeness verification
└─ Historical data validation
```

**Test Failure Resolution:**

```
Test Failure
├─ Performance Issue?
│  ├─ Profile code
│  ├─ Check database indexing
│  ├─ Verify resource allocation
│  └─ Optimize queries
├─ Functional Issue?
│  ├─ Identify code differences
│  ├─ Check environment config
│  ├─ Verify dependencies
│  └─ Deploy fix
└─ Data Issue?
   ├─ Verify migration scripts
   ├─ Check data transformations
   ├─ Validate source data
   └─ Re-migrate if necessary
```

---

### 3.4 Rollback Procedures

**Automated Rollback Plan:**

```
Detection (5 minutes)
├─ Alert triggers (error rate > 5%)
└─ Manual approval required

Preparation (10 minutes)
├─ Notify stakeholders
├─ Verify rollback procedure
└─ Prepare on-premise application

Execution (5 minutes)
├─ DNS cutover (back to on-premise)
├─ Application startup verification
└─ Database consistency check

Validation (10 minutes)
├─ Test critical workflows
├─ Verify user access
└─ Confirm on-premise stability

Communication (Ongoing)
├─ Update incident ticket
├─ Notify stakeholders
└─ Schedule root cause analysis
```

---

## Phase 4: Post-Migration

### 4.1 Optimization Strategies

**Compute Optimization:**

```
Before                      After
┌─────────────────────┐     ┌─────────────┐
│ t3.large (8 GB)     │     │ t3.medium   │
│ Avg 20% utilized    │────→│ (4 GB)      │
│ Cost: $60/month     │     │ Cost: $30/month
└─────────────────────┘     └─────────────┘
Savings: 50%
```

**Database Optimization:**

- Identify slow queries
- Add indexes strategically
- Archive old data
- Partition large tables
- Consider read replicas for reporting

**Storage Optimization:**

- Compress backups
- Use tiered storage (hot/cold)
- Archive infrequently accessed data
- Delete temporary files

---

### 4.2 Cost Management

**Cost Governance Framework:**

```
Monthly Cloud Bill: $50K

Budget Breakdown:
├─ Compute (40%): $20K
│  └─ Right-size instances
├─ Storage (30%): $15K
│  └─ Archive old data
├─ Data Transfer (20%): $10K
│  └─ Reduce cross-region transfer
└─ Licenses (10%): $5K
   └─ Optimize license usage
```

**Cost Monitoring Dashboard:**

- Daily spend tracking
- Cost anomaly alerts
- Reserved capacity planning
- Waste identification reports

---

### 4.3 Performance Tuning

**Monitoring Stack:**

```
Application                Cloud Monitoring
├─ Logs → Centralized log platform
├─ Metrics → Metrics store (Prometheus/CloudWatch)
├─ Traces → Distributed tracing (Jaeger/X-Ray)
└─ Alerts → Alert management
```

**Performance Optimization Checklist:**

- [ ] Database query optimization
- [ ] Caching strategy (application, distributed)
- [ ] CDN configuration for static assets
- [ ] API rate limiting and throttling
- [ ] Connection pooling
- [ ] Auto-scaling policies

---

### 4.4 Security Hardening

**Security Post-Migration Checklist:**

- [ ] Implement zero-trust network access
- [ ] Enable encryption at rest and in transit
- [ ] Configure IAM roles and policies
- [ ] Enable logging and audit trails
- [ ] Set up vulnerability scanning
- [ ] Implement secrets management
- [ ] Enable DDoS protection
- [ ] Configure WAF rules
- [ ] Conduct security assessment
- [ ] Implement compliance controls

---

## Success Metrics

**Track These KPIs:**

| Metric | Target | Measurement |
|--------|--------|-------------|
| Migration Completion | 100% on schedule | Actual date vs planned |
| Cost Reduction | 30% annually | TCO comparison |
| Uptime | 99.95% | Monitoring data |
| Performance | No degradation | Latency comparison |
| Team Productivity | +20% | Deployment frequency |
| Security Incidents | Zero | Security audit results |

---

## Common Pitfalls to Avoid

1. **Underestimating complexity:** Plan 2x time for interdependent systems
2. **Not testing failover:** Always test rollback procedures
3. **Ignoring data residency:** Comply with regional regulations
4. **Not optimizing post-migration:** Cloud doesn't automatically reduce costs
5. **Insufficient team training:** Invest in cloud skill development
6. **Not monitoring costs:** Implement cost governance from day one
7. **Vendor lock-in risk:** Consider multi-cloud strategy for critical workloads

---

## Related Resources

- [Cloud Patterns](../patterns/cloud-patterns.md)
- [Security Patterns](../patterns/security-patterns.md)
- [Reference Architecture: Data Platform](../reference-architectures/data-platform.md)
- [Microservices Transformation Playbook](./microservices-transformation.md)
