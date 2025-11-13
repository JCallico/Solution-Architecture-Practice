# Technology Radar

## Purpose

The Technology Radar provides strategic guidance on which technologies, tools, frameworks, and practices we recommend for adoption across the organization. It helps teams make informed technology decisions aligned with organizational strategy.

---

## How to Use This Radar

The radar is updated quarterly and reflects our collective assessment of technology maturity, organizational readiness, and strategic fit.

**For decision makers:** Use this to understand our technology direction and make technology choices aligned with strategy.

**For architects:** Use this to recommend technologies in designs and ARB submissions.

**For developers:** Use this to understand which technologies are approved for new projects.

---

## Radar Structure

Technologies are positioned in four rings based on our recommendation level:

```
                    ┌─────────────────┐
                    │  ADOPT (Green)  │
                    │  Use broadly    │
                    │                 │
      ┌─────────────┼─────────────────┼─────────────┐
      │             │                 │             │
      │  ┌──────────┼─────────────┐   │             │
      │  │ TRIAL    │  ASSESS     │   │             │
      │  │(Yellow)  │   (Blue)    │   │             │
      │  │ Worth    │ Explore &   │   │             │
      │  │pursuing  │ understand  │   │             │
      │  └──────────┼─────────────┘   │             │
      │             │  HOLD (Red)     │             │
      │             │  Avoid/move off │             │
      │             │                 │             │
      └─────────────┼─────────────────┼─────────────┘

Ring 1 (ADOPT):
Technologies with high confidence. Recommended for appropriate use cases.
Examples: PostgreSQL, Kubernetes, AWS

Ring 2 (TRIAL):
Worth pursuing in projects that can handle some risk. Candidates for adoption.
Examples: Kafka, Rust, Kubernetes operators

Ring 3 (ASSESS):
Explore and understand impact. Monitor before adoption.
Examples: New AI tools, emerging frameworks

Ring 4 (HOLD):
Avoid for new projects. Plan migration off for existing systems.
Examples: Legacy Java frameworks, MySQL 5.7
```

---

## Technology Categories & Recommendations

### 1. Languages & Frameworks

```
ADOPT:
- Python 3.11+
  Status: Primary language for data/backend services
  Rationale: Strong ecosystem, ML/data libraries, operational simplicity
  Use case: Backend services, ML/analytics, scripts
  Adoption: Widely used, excellent team expertise
  
- TypeScript/Node.js (18+)
  Status: Primary language for frontend/APIs
  Rationale: Type safety, large ecosystem, unified stack
  Use case: Frontend, API services, tooling
  Adoption: Widely used, strong community
  
- Go 1.21+
  Status: Primary for infrastructure/ops tools
  Rationale: Performance, simplicity, deployment, Kubernetes ecosystem
  Use case: CLI tools, services, microservices
  Adoption: Growing adoption, strategic importance
  
- Java 21 (LTS)
  Status: Stable for legacy systems, selective new projects
  Rationale: Mature ecosystem, excellent performance, legacy codebase
  Use case: Enterprise systems, existing services
  Adoption: Established, but not for new projects
  
- React 18+
  Status: Primary frontend framework
  Rationale: Large ecosystem, component reusability, team expertise
  Use case: Web applications, dashboards
  Adoption: Standard for all new UI projects

TRIAL:
- Rust 1.70+
  Status: Evaluate for performance-critical systems
  Rationale: Safety, performance, growing ecosystem
  Use case: CLI tools, backend services, systems programming
  Readiness: Team training needed (2-3 weeks)
  POC: Recommend POC for high-performance services
  
- Kotlin on JVM
  Status: Trial for Android development
  Rationale: Modern language, Java interop, type safety
  Use case: Android apps (replacing Java/Kotlin)
  Readiness: Moderate (Java team transition)
  
- Vue 3
  Status: Trial for new dashboards/internal tools
  Rationale: Simpler than React, good for internal tools
  Use case: Admin dashboards, internal tooling
  Readiness: Quick learning curve (1 week)

ASSESS:
- htmx
  Status: Monitor for server-side rendering approach
  Rationale: Emerging pattern, potential complexity reduction
  Use case: Dynamic applications without SPA complexity
  Readiness: Not yet recommended
  
- WebAssembly/WASM
  Status: Monitor for performance-critical frontend code
  Rationale: Emerging capability, limited adoption
  Use case: Graphics, computational heavy code
  Readiness: Not yet recommended for general use

HOLD:
- PHP
  Status: Discontinue use (legacy support only)
  Rationale: Operational complexity, team expertise gap, modern alternatives available
  Migration: Legacy systems in maintenance mode only
  
- CoffeeScript
  Status: Discontinue (legacy only)
  Rationale: Superseded by ES6+/TypeScript
  Migration: Migrate to TypeScript
  
- Scala
  Status: Discontinue for new projects
  Rationale: Complexity, smaller team expertise, Python/Java sufficient
```

### 2. Cloud Platforms & Infrastructure

```
ADOPT:
- AWS
  Status: Primary cloud provider
  Services:
    - Compute: EKS (Kubernetes), Lambda, EC2
    - Database: RDS (PostgreSQL), DynamoDB, ElastiCache
    - Storage: S3, EBS
    - Networking: VPC, CloudFront
  Rationale: Mature ecosystem, Kubernetes integration, cost optimization
  Adoption: 80% of workloads
  
- Kubernetes (EKS)
  Status: Primary container orchestration
  Version: 1.28+
  Rationale: Industry standard, extensive tooling, vendor-agnostic
  Use case: All containerized workloads
  Adoption: 90% of microservices
  
- Infrastructure as Code (Terraform)
  Status: Standard IaC tool
  Version: 1.5+
  Rationale: Multi-cloud, large ecosystem, team expertise
  Use case: All infrastructure definitions
  Adoption: 100% of new infrastructure

TRIAL:
- Azure
  Status: Trial for specific workloads
  Rationale: Evaluate for enterprise integration, AI/ML services
  Use case: Specific scenarios (enterprise requirements)
  Readiness: POC before adoption
  
- Google Cloud (GCP)
  Status: Trial for specific workloads
  Rationale: BigQuery, AI/ML, data analytics
  Use case: Analytics, ML workloads
  Readiness: Evaluating

ASSESS:
- Serverless AWS services (Lambda, Step Functions)
  Status: Evaluate for specific use cases
  Rationale: Cost, operational simplicity, cold start concerns
  Use case: Event-driven, variable workloads
  
HOLD:
- On-premises private cloud
  Status: Wind down legacy systems
  Rationale: Cloud-first strategy, operational overhead
  Migration: Consolidate to cloud
```

### 3. Data & Databases

```
ADOPT:
- PostgreSQL 15+
  Status: Primary relational database
  Use case: OLTP, transactional systems, relational data
  Rationale: Powerful, open-source, excellent performance
  Adoption: 85% of relational data
  
- Redis 7.2+
  Status: Primary caching & session store
  Use case: High-performance caching, session storage
  Rationale: Sub-millisecond latency, extensive ecosystem
  Adoption: All systems requiring caching
  
- Elasticsearch 8.0+
  Status: Primary search & log aggregation
  Use case: Full-text search, log analytics
  Rationale: Powerful search, excellent ecosystem
  Adoption: 80% of search use cases
  
- Kafka 3.6+
  Status: Primary event streaming
  Use case: Event sourcing, stream processing
  Rationale: High throughput, fault-tolerant, ecosystem
  Adoption: 90% of event-driven systems

TRIAL:
- MongoDB 7.0+
  Status: Trial for document storage
  Rationale: Flexible schema, horizontal scaling
  Use case: Document storage (not primary), rapid development
  Readiness: POC recommended
  
- TimescaleDB (PostgreSQL extension)
  Status: Trial for time-series data
  Rationale: PostgreSQL native, time-series optimized
  Use case: Metrics, time-series queries
  
- Apache Spark
  Status: Trial for big data processing
  Rationale: Distributed processing, large datasets
  Use case: ETL, data warehousing

ASSESS:
- DuckDB
  Status: Assess for analytics
  Rationale: In-process OLAP, emerging
  Use case: Analytical queries
  
- Snowflake
  Status: Assess for data warehouse
  Rationale: Cloud-native warehouse, powerful
  Use case: Enterprise analytics
  Readiness: Evaluating with data team

HOLD:
- MySQL 5.7
  Status: Discontinue use (migration required)
  Rationale: EOL approaching (Oct 2025)
  Migration: Migrate to PostgreSQL
  Timeline: Complete by Q4 2025
  
- MongoDB 4.x
  Status: Discontinue older versions
  Rationale: Security updates, performance
  Migration: Upgrade or replace
  
- Cassandra
  Status: Avoid for new projects
  Rationale: Operational complexity, PostgreSQL suitable
```

### 4. Message Brokers & Event Systems

```
ADOPT:
- Kafka 3.6+
  Status: Primary event broker
  Use case: Event streaming, log aggregation, stream processing
  Rationale: High throughput, ordering guarantees, fault tolerance
  Adoption: 90% of event systems
  
- AWS SQS/SNS
  Status: Alternate for simple messaging
  Use case: Simple async messaging, serverless applications
  Rationale: Managed service, no operational overhead
  Adoption: 40% of messaging needs

TRIAL:
- Kafka Streams
  Status: Trial for stream processing
  Rationale: Lightweight, embeddable stream processor
  Use case: Real-time stream processing
  Readiness: Evaluating

HOLD:
- RabbitMQ 3.x
  Status: Discontinue use (legacy support only)
  Rationale: Operational complexity, Kafka superior
  Migration: Migrate to Kafka
  Timeline: Q4 2024
  
- Amazon MQ
  Status: Avoid for new projects
  Rationale: Higher cost, Kafka/SQS preferred
```

### 5. Container Technologies

```
ADOPT:
- Docker 24+
  Status: Standard container runtime
  Use case: All containerized applications
  Rationale: Industry standard, excellent ecosystem
  Adoption: 95% of new applications
  
- Kubernetes 1.28+
  Status: Primary orchestration platform
  Deployment: AWS EKS
  Rationale: Industry standard, extensive ecosystem
  Adoption: 90% of containerized workloads

TRIAL:
- Docker BuildKit
  Status: Trial for container builds
  Rationale: Improved build performance
  Use case: CI/CD pipelines

ASSESS:
- Podman
  Status: Assess as Docker alternative
  Rationale: Daemonless, rootless containers
  Readiness: Not yet recommended

HOLD:
- Docker Swarm
  Status: Discontinue use
  Rationale: Kubernetes is superior
  
- Cloud Run
  Status: Avoid for long-running services
  Rationale: Use Kubernetes instead
```

### 6. API Technologies

```
ADOPT:
- REST APIs (with HTTP/2)
  Status: Standard API approach
  Use case: Public APIs, third-party integrations
  Rationale: Wide adoption, excellent tooling
  Adoption: 85% of APIs
  
- OpenAPI 3.0
  Status: Standard for API documentation
  Use case: All REST API specifications
  Rationale: Industry standard, code generation
  Adoption: 95% of APIs

TRIAL:
- GraphQL
  Status: Trial for specific use cases
  Rationale: Flexible queries, over-fetching reduction
  Use case: Complex data requirements, flexible clients
  Readiness: 2-3 week learning curve
  
- gRPC
  Status: Trial for service-to-service communication
  Rationale: Performance, strong typing, streaming
  Use case: Microservices, high performance
  Readiness: Language-specific implementation

ASSESS:
- tRPC
  Status: Assess for type-safe APIs
  Rationale: End-to-end type safety
  Readiness: Emerging ecosystem

HOLD:
- SOAP/XML-based services
  Status: Discontinue (legacy maintenance only)
  Rationale: REST/GraphQL superior
  Migration: REST APIs preferred
```

### 7. Development Tools & CI/CD

```
ADOPT:
- Git (GitHub)
  Status: Standard version control
  Use case: All source code
  Rationale: Industry standard, excellent tooling
  Adoption: 100% of projects
  
- GitHub Actions
  Status: Standard CI/CD platform
  Use case: All build, test, deploy automation
  Rationale: Integrated with GitHub, excellent ecosystem
  Adoption: 95% of projects
  
- Terraform 1.5+
  Status: Standard Infrastructure as Code
  Use case: All infrastructure definitions
  Rationale: Multi-cloud, powerful, team expertise
  Adoption: 100% of infrastructure
  
- Docker/Docker Compose
  Status: Standard for local development
  Use case: Development environments
  Rationale: Consistency with production

TRIAL:
- ArgoCD
  Status: Trial for GitOps deployment
  Rationale: Declarative, Git-driven deployment
  Use case: Kubernetes deployments
  
- Helm
  Status: Trial for Kubernetes package management
  Rationale: Template management, complex deployments
  Use case: Helm charts for applications

ASSESS:
- Pulumi
  Status: Assess for IaC alternative
  Rationale: Programming language approach
  Readiness: Evaluating with platform team
```

### 8. Observability & Monitoring

```
ADOPT:
- Prometheus
  Status: Standard metrics platform
  Use case: Application and infrastructure metrics
  Rationale: Industry standard, excellent Kubernetes integration
  Adoption: 95% of systems
  
- Grafana
  Status: Standard visualization & dashboarding
  Use case: Metrics visualization, alerting
  Rationale: Powerful, extensive datasource support
  Adoption: 95% of systems
  
- ELK Stack (Elasticsearch, Logstash, Kibana)
  Status: Standard for log aggregation
  Use case: Centralized logging
  Rationale: Powerful search, excellent ecosystem
  Adoption: 90% of systems
  
- Datadog
  Status: Enterprise observability platform
  Use case: Full observability (metrics, logs, APM)
  Rationale: Comprehensive, good for enterprise
  Adoption: 70% of production systems

TRIAL:
- OpenTelemetry
  Status: Trial for observability instrumentation
  Rationale: Standardized, multi-backend support
  Use case: Application instrumentation

ASSESS:
- New Relic
  Status: Assess as observability alternative
  Rationale: Another comprehensive option
  Readiness: Evaluating with ops team
```

---

## Technology Radar Version History

```
Version 1.0 (November 2025): Initial radar
- 8 categories: Languages, Cloud, Data, Messaging, Containers, APIs, Tools, Observability
- 40+ technologies evaluated
- Quarterly update cadence established

Significant Changes:
- PostgreSQL: Adopt (primary relational DB)
- Kafka: Adopt (primary event streaming)
- AWS EKS: Adopt (primary Kubernetes platform)
- RabbitMQ: Hold (discontinue use)
- MySQL 5.7: Hold (EOL approaching)
```

---

## Quarterly Review Process

```
Q1 (Jan-Mar):
- Initial radar assessment
- Technology team input gathering
- Architecture board review

Q2 (Apr-Jun):
- 6-month progress review
- New technology assessment
- Adoption tracking

Q3 (Jul-Sep):
- Mid-year strategy alignment
- Emerging tech evaluation
- Discontinuation planning

Q4 (Oct-Dec):
- Annual radar update
- Next year strategy planning
- Team feedback incorporation

Change Process:
1. Technology suggestion (any team member)
2. Research & evaluation (architecture team)
3. ARB review & discussion
4. Radar update & publication
5. Team communication
```

---

## Decision Matrix for Technology Selection

Use this matrix when evaluating whether a technology should be ADOPT/TRIAL/ASSESS/HOLD:

```
ADOPT Decision Criteria:
☑ Proven in production (multiple systems)
☑ Team expertise available
☑ Strong vendor/community support
☑ Aligns with architectural strategy
☑ Cost-effective long-term
☑ Security/compliance requirements met
☑ No better alternative available
→ Recommended for standard use

TRIAL Decision Criteria:
☑ Proven in other organizations
☑ Addresses specific problem better than alternatives
☑ Acceptable risk for contained projects
☑ Team capable of learning
☑ Vendor/community shows promise
☑ Exit strategy if unsuccessful
→ Worth pursuing in projects that can handle some risk

ASSESS Decision Criteria:
☑ Emerging but showing promise
☑ Potential strategic value
☑ Not yet production-ready for us
☑ Worth monitoring closely
☑ No action required yet
→ Monitor and evaluate, don't adopt yet

HOLD Decision Criteria:
☑ Better alternatives available
☑ Operational complexity too high
☑ Team expertise gap
☑ End-of-life or declining support
☑ Architectural misalignment
☑ Cost prohibitive
→ Avoid for new projects, plan migration for existing use
```

---

## Related Resources

- [Technology Selection Guide](./technology-selection.md)
- [Tool Recommendations](./tool-recommendations.md)
- [POC Template](../templates/poc-template.md)
- [Technology Evaluation Template](../templates/technology-evaluation-template.md)
- [ARB Submission Template](../templates/arb-submission-template.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
