# Microservices Platform Reference Architecture

## Executive Summary

This reference architecture describes an enterprise-grade microservices platform for organizations scaling from monolithic applications. It provides a complete blueprint for building, deploying, and operating microservices at scale, including all supporting infrastructure, patterns, and operational procedures.

**Key Characteristics:**
- Containerized microservices running on Kubernetes
- Domain-driven design with clear service boundaries
- Event-driven communication with Apache Kafka
- PostgreSQL databases with per-service data ownership
- Comprehensive observability (metrics, logs, traces)
- Security-first design with zero-trust networking
- Automated deployment with GitOps
- 99.95% availability SLA with auto-recovery

**Target Scale:**
- 20-100+ microservices
- 10M+ users
- 10,000+ requests/second at peak
- Multiple availability zones/regions

---

## System Context

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         External Users                      │
└────────────┬────────────────────────────────────┬───────────┘
             │                                    │
     ┌───────▼────────┐              ┌───────────▼────────┐
     │  Web Browser   │              │   Mobile Apps      │
     │   & Desktop    │              │  (iOS/Android)     │
     └───────┬────────┘              └───────┬────────────┘
             │                               │
     ┌───────┴───────────────────────────────┴──────────┐
     │         AWS CloudFront (CDN)                     │
     │    - Static assets caching                       │
     │    - DDoS protection                             │
     └───────┬──────────────────────────────────────────┘
             │
     ┌───────▼──────────────────────────────────────┐
     │      AWS Application Load Balancer           │
     │   - TLS/HTTPS termination                    │
     │   - Request routing                          │
     │   - Rate limiting                            │
     └───────┬──────────────────────────────────────┘
             │
     ┌───────▼────────────────────────────────────────┐
     │    API Gateway Service (Kong/Ambassador)     │
     │  - Authentication/Authorization               │
     │  - API versioning                            │
     │  - Request transformation                    │
     │  - Rate limiting per user/API key            │
     └───────┬───────────────────────────────────────┘
             │
     ┌───────▼─────────────────────────────────┐
     │  Kubernetes Cluster (AWS EKS)           │
     │  ┌───────────────────────────────────┐  │
     │  │  Microservices (containerized)    │  │
     │  │  - Order Service                  │  │
     │  │  - Product Service                │  │
     │  │  - User Service                   │  │
     │  │  - Payment Service                │  │
     │  │  - Inventory Service              │  │
     │  │  - Shipping Service               │  │
     │  │  - And 20+ others                 │  │
     │  └───────────────────────────────────┘  │
     │                                         │
     │  ┌───────────────────────────────────┐  │
     │  │  Infrastructure Services          │  │
     │  │  - Prometheus (metrics)           │  │
     │  │  - Grafana (dashboards)           │  │
     │  │  - Elasticsearch (logging)        │  │
     │  │  - Jaeger (distributed tracing)   │  │
     │  │  - Redis (caching)                │  │
     │  └───────────────────────────────────┘  │
     └─────┬──────────────────────────────────┘
           │
     ┌─────┴──────────────────────────────────┐
     │  Data & Messaging Infrastructure      │
     │  ┌──────────────────────────────────┐ │
     │  │ Databases (PostgreSQL per svc)   │ │
     │  │ - order_db, product_db, etc.     │ │
     │  └──────────────────────────────────┘ │
     │  ┌──────────────────────────────────┐ │
     │  │ Kafka Cluster                    │ │
     │  │ - Event streaming                │ │
     │  │ - Event log/auditability         │ │
     │  │ - Decoupled service integration  │ │
     │  └──────────────────────────────────┘ │
     │  ┌──────────────────────────────────┐ │
     │  │ S3 (Object Storage)              │ │
     │  │ - Images, documents, files       │ │
     │  └──────────────────────────────────┘ │
     └──────────────────────────────────────┘
```

---

## C4 Model - System Architecture

### Level 1: System Context

```
┌────────────────┐
│  End Users     │
└────────┬───────┘
         │ HTTP/HTTPS
         ▼
┌──────────────────────────────┐
│  Microservices Platform      │
│  - Product Catalog           │
│  - Order Management          │
│  - User Management           │
│  - Payment Processing        │
│  - Inventory Management      │
│  - Shipping & Delivery       │
│  - Analytics & Reporting     │
└──────────────────────────────┘
         │ Events (Kafka)
         ▼
┌──────────────────────────────┐
│  Event Processing &          │
│  Analytics Systems           │
│  - Stream processing         │
│  - Data warehouse            │
│  - Machine learning          │
└──────────────────────────────┘
```

### Level 2: Container Diagram

```
Microservices Platform Container
├── API Gateway Container
│   ├── Authentication & Authorization
│   ├── Rate Limiting & Throttling
│   ├── Request Validation
│   └── API Versioning
│
├── Core Service Containers
│   ├── User Service (Authentication, profiles)
│   ├── Product Service (Product catalog)
│   ├── Order Service (Order lifecycle)
│   ├── Payment Service (Payment processing)
│   ├── Inventory Service (Stock management)
│   └── Shipping Service (Delivery tracking)
│
├── Supporting Service Containers
│   ├── Notification Service (Email, SMS, push)
│   ├── Search Service (Elasticsearch)
│   ├── Analytics Service (Data aggregation)
│   └── Recommendations Service (ML-based)
│
├── Infrastructure Containers
│   ├── Logging Stack (ELK)
│   ├── Monitoring Stack (Prometheus/Grafana)
│   ├── Tracing Stack (Jaeger)
│   └── Service Mesh (Istio)
│
└── Data Containers
    ├── PostgreSQL Databases
    ├── Redis Cache
    ├── Elasticsearch
    ├── Kafka Cluster
    └── S3 Object Storage
```

---

## Service Decomposition

### Service Catalog (Example: E-Commerce Platform)

```
┌─────────────────────────────────────────────────────────────┐
│                    SERVICE INVENTORY                        │
├─────────────────┬────────────────┬──────────────────────────┤
│ Domain          │ Service Name   │ Key Responsibilities     │
├─────────────────┼────────────────┼──────────────────────────┤
│ User            │ User Service   │ - Authentication         │
│                 │                │ - User profiles          │
│                 │                │ - Authorization          │
├─────────────────┼────────────────┼──────────────────────────┤
│ Product         │ Product Service│ - Product catalog        │
│                 │                │ - Product search         │
│                 │                │ - Product reviews        │
├─────────────────┼────────────────┼──────────────────────────┤
│ Order           │ Order Service  │ - Order creation         │
│                 │                │ - Order tracking         │
│                 │                │ - Order fulfillment      │
├─────────────────┼────────────────┼──────────────────────────┤
│ Payment         │ Payment Service│ - Payment processing     │
│                 │                │ - Refunds                │
│                 │                │ - Billing                │
├─────────────────┼────────────────┼──────────────────────────┤
│ Inventory       │ Inventory Svce │ - Stock management       │
│                 │                │ - Reservations           │
│                 │                │ - Restocking            │
├─────────────────┼────────────────┼──────────────────────────┤
│ Shipping        │ Shipping Svce  │ - Shipping calculation   │
│                 │                │ - Delivery tracking      │
│                 │                │ - Return management      │
├─────────────────┼────────────────┼──────────────────────────┤
│ Communication   │ Notify Service │ - Email notifications    │
│                 │                │ - SMS messages           │
│                 │                │ - Push notifications     │
├─────────────────┼────────────────┼──────────────────────────┤
│ Analytics       │ Analytics Svce │ - Data collection        │
│                 │                │ - Reporting              │
│                 │                │ - BI integration         │
└─────────────────┴────────────────┴──────────────────────────┘
```

### Service Boundaries (Domain-Driven Design)

```
Each service has:
✓ Clear, single responsibility
✓ Dedicated database (no shared tables)
✓ Well-defined API contracts
✓ Autonomous deployment capability
✓ Independent scalability
✓ Own monitoring and alerting

Service Dependencies:
- Synchronous: REST APIs for immediate responses
- Asynchronous: Kafka events for eventual consistency
- Shared: Only common libraries, no shared data

Data Ownership:
- User Service owns user credentials and profiles
- Product Service owns product information
- Order Service owns order records (not shared)
- Inventory Service owns stock information
```

---

## Technology Stack

### Detailed Technology Selections

```
FRONTEND LAYER:
├─ Web App: React 18+ / TypeScript
├─ Mobile App: React Native / Kotlin + Swift
└─ CDN: AWS CloudFront

API LAYER:
├─ API Gateway: Kong / Ambassador
├─ Service Mesh: Istio (traffic, security, observability)
├─ Authentication: OAuth 2.0 / OpenID Connect
└─ Rate Limiting: Distributed (Redis-backed)

COMPUTE LAYER:
├─ Container Runtime: Docker 24+
├─ Orchestration: Kubernetes 1.28+ (AWS EKS)
├─ Service Framework: Spring Boot / FastAPI / Express.js
└─ Deployment: GitOps (ArgoCD)

DATA LAYER:
├─ Relational: PostgreSQL 15+ (per-service databases)
├─ Cache: Redis 7+ (session store, query cache)
├─ Search: Elasticsearch 8+ (full-text search)
├─ Events: Kafka 3.6+ (event streaming)
├─ Object Store: AWS S3 (images, files, documents)
└─ Data Warehouse: Snowflake / BigQuery (analytics)

OBSERVABILITY:
├─ Metrics: Prometheus + Grafana
├─ Logging: ELK Stack (Elasticsearch, Logstash, Kibana)
├─ Tracing: Jaeger (distributed tracing)
├─ APM: DataDog (optional, advanced)
└─ Alerting: AlertManager + PagerDuty

INFRASTRUCTURE:
├─ Cloud: AWS (EC2, RDS, S3, etc.)
├─ IaC: Terraform 1.5+
├─ CI/CD: GitHub Actions
├─ Git: GitHub Enterprise
├─ Configuration: Helm + Kustomize
└─ Secrets: AWS Secrets Manager

SUPPORTING:
├─ Version Control: Git
├─ Documentation: MkDocs
├─ Issue Tracking: Jira
├─ Communication: Slack
└─ Incident Response: PagerDuty
```

---

## Data Architecture

### Database Strategy

```
Database per Service Pattern:
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ User Service │    │Product Service│  │Order Service │
├──────────────┤    ├──────────────┤   ├──────────────┤
│user_db       │    │product_db     │   │order_db      │
│ Tables:      │    │ Tables:       │   │ Tables:      │
│ - users      │    │ - products    │   │ - orders     │
│ - profiles   │    │ - categories  │   │ - items      │
│ - roles      │    │ - reviews     │   │ - totals     │
└──────────────┘    └──────────────┘   └──────────────┘

Benefits:
✓ Service independence (schema changes isolated)
✓ Technology flexibility (different DB per service)
✓ Scalability (each service scales independently)

Challenges:
✗ Distributed transactions (solved with Saga pattern)
✗ Eventual consistency (accepted)
✗ Cross-service queries (solved with events)
```

### Data Consistency Strategy

```
IMMEDIATE CONSISTENCY (Sync):
- REST API calls within transaction
- Use case: User creates order (must reserve inventory immediately)
- Risk: Cascading failures

EVENTUAL CONSISTENCY (Async with Events):
- Publish event, consumers update their data
- Use case: Order created → Send email notification
- Benefit: Resilience, scalability, decoupling
- Consistency window: <1 second typical

Implementation: SAGA PATTERN
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│ Order Service│       │Inventory Svce│      │Payment Service│
│              │       │              │      │              │
│ Create Order │       │              │      │              │
│              │──────>│ Reserve Stock│      │              │
│              │       │              │      │              │
│              │       │  Emit Inv... │      │              │
│              │       │ ReservedEvent│      │              │
│              │       │              │      │              │
│ Emit Order   │       │              │──┐   │              │
│ CreatedEvent │       │              │  │   │              │
│              │       │              │  │   │              │
│              │       │              │  └──>│Charge Card  │
│              │       │              │      │              │
│              │       │              │      │Emit Payment  │
│              │       │              │      │ ChargedEvent │
│              │       │              │      │              │

If Payment Fails:
├─ Inventory Service compensates (release reservation)
├─ Order Service compensates (mark order failed)
└─ Notify user (payment declined)
```

---

## Deployment Architecture

### CI/CD Pipeline

```
Developer Push to Git
    ↓
GitHub Actions Triggered
    ├─ Run Tests
    │  ├─ Unit tests
    │  ├─ Integration tests
    │  └─ Contract tests
    ├─ Build Container Image
    │  ├─ Run security scan
    │  ├─ Push to ECR
    │  └─ Tag with git sha
    ├─ Run Quality Checks
    │  ├─ SonarQube analysis
    │  ├─ Lint checks
    │  └─ Dependency scan (Snyk)
    └─ Deploy to Test Environments
       ├─ Staging (blue)
       ├─ E2E tests
       └─ Performance tests

Manual Approval for Production
    ↓
Deploy to Production (Blue-Green)
    ├─ Version N (Blue) - Running
    ├─ Version N+1 (Green) - New
    ├─ Traffic router
    ├─ Canary: 10% → Green
    ├─ Monitor (5 min)
    ├─ Canary: 50% → Green
    ├─ Monitor (5 min)
    ├─ Canary: 100% → Green
    └─ Keep Blue for rollback (1 hour)

Health Checks (Every 10s)
    ├─ HTTP 200 on /health
    ├─ Readiness probe success
    └─ No spike in error rate
```

### GitOps Deployment

```
Git Repository Structure:
├─ infrastructure/
│  ├─ base/
│  │  ├─ user-service/
│  │  │  ├─ deployment.yaml
│  │  │  ├─ service.yaml
│  │  │  └─ configmap.yaml
│  │  ├─ product-service/
│  │  │  └─ ...
│  │  └─ shared/
│  │     ├─ namespaces.yaml
│  │     ├─ rbac.yaml
│  │     └─ network-policies.yaml
│  │
│  └─ overlays/
│     ├─ dev/
│     │  ├─ kustomization.yaml
│     │  └─ patches/
│     ├─ staging/
│     │  ├─ kustomization.yaml
│     │  └─ patches/
│     └─ production/
│        ├─ kustomization.yaml
│        └─ patches/

Workflow:
1. Developer: git push app code
2. GitHub Actions: Build image, push to ECR
3. Operator: Update image tag in overlays/prod/kustomization.yaml
4. git push kustomization update
5. ArgoCD: Detects change, applies to cluster
6. Kubernetes: Rolling update with health checks
7. ArgoCD: Monitors cluster state vs git

Benefit: Single source of truth (Git)
- All infrastructure in version control
- Audit trail of all changes
- Easy rollback (git revert)
- GitOps tools auto-sync cluster to git state
```

---

## Operational Procedures

### Health Checks & Auto-Recovery

```
Kubernetes Probes per Service:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service
spec:
  template:
    spec:
      containers:
      - name: order-service
        livenessProbe:
          httpGet:
            path: /health/live
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 3
          # Kill container if 3 failed checks (30 sec failure)
        
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
          # Remove from load balancer if not ready
        
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        
        volumeMounts:
        - name: logs
          mountPath: /var/log/app

Result:
✓ Pod crashes → Kubernetes auto-restarts
✓ Pod unhealthy → Kubernetes replaces
✓ Resource limits exceeded → Pod evicted/restarted
✓ Database connection lost → Pod marked not ready
```

### Monitoring & Alerting Rules

```
Key Metrics to Monitor:

Application Metrics:
- Request latency (P50, P95, P99)
- Request error rate
- Active connections
- Cache hit rate
- Queue depth

Example Alert Rules:

1. High Error Rate
   IF error_rate > 0.01 (1%) for 2 minutes
   THEN page on-call engineer

2. High Latency
   IF latency_p95 > 500ms for 5 minutes
   THEN notify in Slack (warning)

3. Low Cache Hit Rate
   IF cache_hit_rate < 70% for 10 minutes
   THEN notify team (potential performance issue)

4. Database Connection Pool Exhausted
   IF db_connections / max_connections > 0.9
   THEN alert (service might fail under load)

5. Kafka Consumer Lag
   IF consumer_lag > 10000 messages
   THEN alert (processing falling behind)

Resource Alerts:

1. Pod CPU Throttling
   IF cpu_usage > 80% for 5 minutes
   THEN recommend increasing limits or scaling

2. Memory Usage High
   IF memory_usage > 85% for 5 minutes
   THEN alert (potential OOM)

3. Node CPU/Memory
   IF node_resource_usage > 80%
   THEN consider scaling cluster

4. Disk Space
   IF disk_free < 10%
   THEN alert (potential system issues)
```

### Incident Response Runbook

```
ALERT: Order Service Error Rate Spike (5% → 10%)

Step 1: Initial Assessment (2 min)
├─ Check error logs in Elasticsearch
│  └─ SELECT logs WHERE service=order AND level=ERROR
├─ Check recent deployments
│  └─ Check ArgoCD for recent changes
├─ Check external dependencies
│  └─ Is database responding?
│  └─ Is Kafka healthy?
│  └─ Is payment service responsive?
└─ Page on-call architect if unclear

Step 2: Diagnosis (5-10 min)
├─ Review Jaeger traces for failing request path
├─ Check database query performance (slow queries?)
├─ Check Kafka lag (consuming fast enough?)
├─ Look for recent code changes
│  └─ If recent deployment, consider rollback
└─ Run SQL EXPLAIN ANALYZE on slow queries

Step 3: Mitigation (10 min)
├─ Option A: Rollback recent deployment
│  └─ git revert [bad commit]
│  └─ ArgoCD auto-syncs within 3 minutes
│
├─ Option B: Scale service up
│  └─ kubectl scale deployment order-service --replicas=5
│  └─ New pods take ~30 seconds to start
│
├─ Option C: Increase circuit breaker threshold (temporary)
│  └─ Reduce timeout, fail fast
│
└─ Option D: Restart pods (if memory leak)
    └─ kubectl rollout restart deployment/order-service

Step 4: Validation (5 min)
├─ Monitor error rate for 5 min
├─ Check latency returned to normal
├─ Verify database still healthy
├─ No cascading errors to other services
└─ Customer impact acceptable?

Step 5: Root Cause Analysis (1+ hours after resolution)
├─ What caused the issue?
├─ Why didn't tests catch it?
├─ How do we prevent recurrence?
├─ Do we need to add monitoring/alerting?
└─ Post-mortem and team learning
```

---

## Security Architecture

```
Defense-in-Depth Approach:

Layer 1: Network Security
├─ VPC with private subnets (no direct internet)
├─ Network ACLs restricting traffic
├─ Security groups per service
└─ Service mesh mutual TLS (mTLS)

Layer 2: API Security
├─ All traffic encrypted (TLS 1.2+)
├─ Authentication: OAuth 2.0 + JWT
├─ Authorization: RBAC per API
├─ Rate limiting per user/API key
├─ Input validation & sanitization
└─ Output encoding to prevent XSS

Layer 3: Data Security
├─ Database encryption at rest (AWS KMS)
├─ Encryption in transit (TLS)
├─ Secrets managed by AWS Secrets Manager
├─ No secrets in code, logs, or containers
├─ Field-level encryption for PII
└─ Regular access reviews

Layer 4: Application Security
├─ Dependencies scanned for vulnerabilities
├─ Code scanned for secrets/hardcoded passwords
├─ Dependency updates within 1 week of security patches
├─ Container images scanned before deployment
├─ Runtime security monitoring (falco)
└─ Audit logging for sensitive operations

Layer 5: Identity & Access
├─ Service-to-service: mTLS certificates
├─ User authentication: OAuth 2.0
├─ Authorization: Policy-based (RBAC)
├─ Audit logging: Who did what when
├─ Regular access reviews (quarterly)
└─ Principle of least privilege
```

---

## Scalability Strategy

```
Scaling Dimensions:

HORIZONTAL SCALING (add replicas):
Service: Order Service
├─ Current: 5 replicas (5 requests/sec each = 25 req/sec)
├─ Under load: Auto-scale to 20 replicas (100 req/sec)
├─ Limit: 100 replicas (server limits)
└─ If needed: Shard by region

VERTICAL SCALING (bigger instances):
├─ Current: t3.medium (2 CPU, 4 GB RAM)
├─ Upgrade to: t3.large (2 CPU, 8 GB RAM)
├─ Further: t3.xlarge (4 CPU, 16 GB RAM)
└─ Limit: Diminishing returns, go horizontal instead

CACHING:
├─ Redis: Cache frequently accessed data
│  └─ Product catalog: 10GB dataset, <100ms access
├─ CDN: Cache static assets
│  └─ CSS/JS/images cached globally
└─ Database: Query result caching

DATABASE SCALING:
├─ Read replicas: Distribute read traffic
├─ Sharding: Partition data by customer/product
├─ CQRS: Separate read/write models
└─ Event sourcing: Immutable event log

KAFKA SCALING:
├─ Partitions: Parallelism within topic
│  └─ orders topic: 10 partitions = 10 parallel consumers
├─ Consumer groups: Scale consuming
│  └─ Multiple consumers reading from same topic
└─ Message batching: Reduce overhead

Expected Load:
- Baseline: 1,000 req/sec (50 services × 20 req/sec)
- Peak: 10,000 req/sec (10x during sales/events)
- Emergency: 50,000 req/sec (if viral/press)

Scaling Path:
Peak (10k req/sec):
├─ 5 services at 20 replicas each
├─ 20 Kafka brokers with 100+ partitions per topic
├─ 10+ database read replicas
└─ All geographic caching layers

Emergency (50k req/sec):
├─ Shard services by region/customer
├─ Massive Kafka cluster
├─ Database sharding
└─ Request dropping/queuing (graceful degradation)
```

---

## Related Resources

- [Microservices Framework](../../frameworks/microservices.md)
- [Domain-Driven Design Guide](../../frameworks/domain-driven-design.md)
- [Microservices Transformation Playbook](../playbooks/microservices-transformation.md)
- [API Design Guide](../playbooks/api-design-guide.md)
- [Security Guide](../playbooks/security-guide.md)
- [Performance Guide](../playbooks/performance-guide.md)
- [Architecture Decisions - Microservices](./decisions.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
