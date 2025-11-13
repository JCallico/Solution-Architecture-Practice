# System Context Template

## Purpose

The System Context diagram is the highest-level C4 model view. It shows the software system you're building (the subject) as a black box in the center, with the users, external systems, and external services around it. It's a starting point for understanding the system architecture.

---

## When to Use

- Starting architectural discussions
- Communicating with non-technical stakeholders
- Understanding system scope and boundaries
- Identifying external dependencies
- Planning integration points

---

## Template Content

### 1. System Overview

**System Name:** [Name of your system]

**Purpose:** [Brief description of what the system does]

**Owner/Team:** [Team responsible for the system]

**Current Status:** [Active, Deprecated, In Development, etc.]

### 2. System Context Diagram

```
[User] --> | uses | [Your System]
[External System A] <--> [Your System]
[External Service B] --> [Your System]
[Your System] --> | manages | [Database]
```

**Diagram tools:**
- PlantUML (text-based, version control friendly)
- Lucidchart / Draw.io (visual, collaborative)
- Miro (whiteboarding, team discussion)
- C4-PlantUML (automated C4 diagrams)

### 3. Users and Actors

**Primary Users:**
- [User Type 1]: [Description, frequency of use, primary goals]
- [User Type 2]: [Description, frequency of use, primary goals]

**Secondary Users:**
- [User Type 3]: [Description, occasional use, specific needs]

**System Actors (external systems):**
- [External System 1]: [Purpose, interaction type, frequency]
- [External System 2]: [Purpose, interaction type, frequency]

### 4. External Dependencies

**External Systems:**
| System | Purpose | Protocol | Frequency | Criticality |
|--------|---------|----------|-----------|-------------|
| Payment Gateway | Process payments | REST API | Per transaction | Critical |
| Email Service | Send notifications | SMTP | On events | High |
| Analytics | Track usage | Webhooks | Continuous | Medium |

**Third-Party Services:**
| Service | Purpose | SLA | Cost |
|---------|---------|-----|------|
| CDN Provider | Content delivery | 99.99% | Per GB |
| Monitoring | System health | 99.9% | Monthly |
| Authentication | User identity | 99.99% | Per user |

**Data Sources:**
- Internal: [CRM system, ERP system, etc.]
- External: [Partner APIs, public data, etc.]

### 5. System Boundary Definition

**What's Inside the System:**
- Core business logic
- User interfaces (web, mobile, API)
- Data processing
- Integration middleware
- Caching layer

**What's Outside the System:**
- Third-party payment processors
- External email services
- Monitoring/observability tools
- CDN services
- Identity providers (unless custom)

### 6. Key Interactions

**User Interactions:**
```
1. Customer places order
   → System validates input
   → System contacts payment gateway
   → System updates inventory
   → System sends confirmation email

2. Administrator monitors system health
   → System provides real-time dashboards
   → System sends alerts on anomalies
```

**System-to-System Interactions:**
```
1. Order System → Payment Gateway
   - Request: POST /charge with order details
   - Response: payment status
   - Frequency: Per transaction
   - Criticality: Critical (failures block orders)

2. System → Analytics
   - Request: POST /events with usage data
   - Frequency: Continuous
   - Criticality: Medium (failures don't affect users)
```

### 7. Data Flows

**High-Level Data Movement:**
```
Users
  ↓
[Your System] (processes data)
  ├─ → Database (stores data)
  ├─ → Cache (fast access)
  ├─ → Search Index (querying)
  └─ → External Services (integrations)
       ├─ → Payment System
       ├─ → Email Service
       ├─ → Analytics
       └─ → Logging/Monitoring
```

### 8. Technology Summary

**Key Technologies:**
- **Language:** [Python, Java, Go, Node.js, etc.]
- **Framework:** [Django, Spring Boot, Express, etc.]
- **Database:** [PostgreSQL, MongoDB, DynamoDB, etc.]
- **Deployment:** [Kubernetes, Lambda, Heroku, etc.]
- **Infrastructure:** [AWS, Azure, GCP, On-premise, etc.]

### 9. Integration Patterns

**Synchronous Integration:**
- REST APIs (request/response)
- gRPC (high-performance)
- GraphQL (flexible queries)

**Asynchronous Integration:**
- Message queues (eventual consistency)
- Event streams (publish/subscribe)
- Webhooks (callbacks)

**Data Integration:**
- Batch ETL (periodic data sync)
- Real-time sync (CDC - Change Data Capture)
- Polling (periodic queries)

### 10. Security Context

**Authentication:**
- Who can access the system? [Internal users, external partners, public, etc.]
- How do they authenticate? [OAuth, API keys, SAML, etc.]

**Authorization:**
- What can different users do? [Admin, User, Guest, etc.]
- What data can they access? [Own data, team data, all data, etc.]

**Data Protection:**
- Sensitive data handled? [PII, financial, health, etc.]
- How is it protected? [Encryption, masks, tokenization, etc.]

**External Access:**
- Which external systems need access?
- What permissions do they have?
- How is access revoked?

### 11. Constraints & Assumptions

**Technical Constraints:**
- Legacy system dependencies
- Performance requirements
- Scalability needs
- Reliability/uptime requirements

**Business Constraints:**
- Budget limitations
- Timeline requirements
- Compliance requirements
- Team skill constraints

**Assumptions:**
- [System will integrate with X service]
- [Database capacity sufficient for Y scale]
- [Network bandwidth adequate for Z throughput]
- [Team size of N sufficient for maintenance]

### 12. Future Considerations

**Planned Expansions:**
- New user types
- New external integrations
- New data sources
- Geographic expansion
- Scale requirements

**Migration Path:**
- Dependencies to replace
- Systems to deprecate
- Modernization priorities

---

## Example: E-Commerce System

### System Overview

**System Name:** ECommerce Platform

**Purpose:** Online retail platform allowing customers to browse products, place orders, track shipments, and manage returns.

**Owner:** E-Commerce Team

**Status:** Active (continuously enhanced)

### System Context Diagram

```
┌─────────────┐
│  Customer   │
│   Portal    │
└──────┬──────┘
       │ browses, purchases
       ↓
┌──────────────────────┐
│  E-Commerce System   │
│  (Your System)       │
└──────┬──┬──┬────┬────┘
       │  │  │    │
  ┌────┘  │  │    └──────┬──────────┐
  │       │  │           │          │
  ↓       ↓  ↓           ↓          ↓
[DB] [Cache][Search] [Payment]  [Email]
      [Inventory] [Shipping] [Analytics]
```

### Users and Actors

**Primary Users:**
- **Shoppers:** Browse products, place orders, track shipments (high frequency)
- **Administrators:** Manage inventory, view reports, handle returns (daily)

**Secondary Users:**
- **Customer Support:** View orders, process refunds (as needed)
- **Finance:** View revenue reports, reconcile payments (weekly)

**System Actors:**
- Payment Gateway: Process credit card transactions
- Email Service: Send order confirmations and shipping updates
- Shipping Provider: Track and deliver packages
- Analytics Platform: Track user behavior and conversion

### External Dependencies

| System | Purpose | Protocol | Frequency | Criticality |
|--------|---------|----------|-----------|-------------|
| Stripe | Process payments | REST API | Per order | Critical |
| SendGrid | Send emails | REST API | Per event | High |
| FedEx API | Get shipping rates | SOAP/REST | Per order | High |
| Google Analytics | Track user behavior | JavaScript SDK | Continuous | Medium |

---

## Best Practices

1. **Keep It Simple:** System Context should be understandable in < 5 minutes
2. **Clear Boundaries:** Clearly distinguish your system from external systems
3. **Label Interactions:** Show types of interaction (REST, gRPC, events, etc.)
4. **Show Data Flow:** Indicate direction of data movement
5. **Document Criticality:** Mark which systems are essential vs. optional
6. **Include Legend:** Explain colors, shapes, and symbols used
7. **Version Control:** Keep diagrams in version control with code
8. **Review Regularly:** Update when external dependencies change

---

## Related Resources

- [C4 Model Framework](../../frameworks/c4-model.md)
- [Container Diagram Template](./container-diagram-template.md)
- [Solution Architecture Template](./solution-architecture-template.md)
- [Architecture Vision Template](./architecture-vision-template.md)
- [Technical Design Template](./technical-design-template.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
