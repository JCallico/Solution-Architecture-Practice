# Architecture Patterns Library

## Overview

This library catalogs proven architecture patterns used across our organization. Each pattern provides a reusable solution to a common problem, complete with context, implementation guidance, and examples.

## Pattern Categories

- [**Microservices Patterns**](#microservices-patterns) - Patterns for building and organizing microservices architectures
- [**Integration Patterns**](#integration-patterns) - Patterns for integrating systems and services
- [**Data Patterns**](#data-patterns) - Patterns for data architecture and management
- [**Cloud Patterns**](#cloud-patterns) - Patterns for cloud-native architectures
- [**Security Patterns**](#security-patterns) - Patterns for secure system design
- [**Resilience Patterns**](#resilience-patterns) - Patterns for building resilient systems

---

## Microservices Patterns

### API Gateway Pattern
**Problem**: How do clients access microservices when there are many services with different protocols and concerns like security, throttling, and routing?

**Solution**: Implement a single entry point (API Gateway) that routes requests to appropriate microservices and handles cross-cutting concerns.

**When to Use**:
- Multiple microservices with different APIs
- Need centralized authentication/authorization
- Need to aggregate responses from multiple services
- Want to hide service topology from clients

**Benefits**:
- Single entry point simplifies client code
- Centralized cross-cutting concerns
- Can translate between protocols
- Insulates clients from service changes

**Trade-offs**:
- Single point of failure (mitigate with HA)
- Potential performance bottleneck
- Additional complexity

**Implementation**:
```
[Client] → [API Gateway] → [Service A]
                        → [Service B]
                        → [Service C]
```

**Technologies**: Kong, AWS API Gateway, Azure API Management, Apigee, NGINX

**Example**: See [E-Commerce Reference Architecture](../reference-architectures/ecommerce-platform.md)

**Related Patterns**: Backend for Frontend (BFF), Service Mesh

---

### Service Discovery Pattern
**Problem**: How do services find and communicate with each other in a dynamic microservices environment?

**Solution**: Implement a service registry where services register themselves and discover other services.

**When to Use**:
- Dynamic service instances (auto-scaling, containers)
- Services need to find each other at runtime
- Service locations change frequently

**Benefits**:
- Dynamic service location
- Load balancing
- Health checking
- Supports auto-scaling

**Trade-offs**:
- Additional infrastructure component
- Registry must be highly available
- Network overhead for lookups

**Implementation**:
- **Client-Side Discovery**: Client queries registry and chooses instance
- **Server-Side Discovery**: Load balancer queries registry

**Technologies**: Consul, etcd, Eureka, Kubernetes Service Discovery, AWS Cloud Map

**Example**:
```
[Service A] → [Service Registry] ← [Service B registers]
           → [Service B] (discovered)
```

---

### Circuit Breaker Pattern
**Problem**: How do you prevent a failing service from cascading failures across the system?

**Solution**: Wrap service calls with a circuit breaker that monitors for failures and opens the circuit when failure threshold is reached.

**When to Use**:
- External service dependencies
- Services that may fail or have high latency
- Need to prevent cascade failures

**States**:
- **Closed**: Normal operation, requests pass through
- **Open**: Failure threshold reached, fail fast without calling service
- **Half-Open**: After timeout, allow test request to check if service recovered

**Benefits**:
- Prevents cascade failures
- Fail fast reduces resource consumption
- Automatic recovery detection

**Trade-offs**:
- Added complexity
- Tuning thresholds can be challenging
- May hide underlying issues if not monitored

**Technologies**: Hystrix (deprecated but patterns still valid), Resilience4j, Polly, Istio

**Example**:
```java
CircuitBreaker breaker = CircuitBreaker.of("externalService", config);
Try.ofSupplier(CircuitBreaker.decorateSupplier(breaker, externalService::call))
    .recover(throwable -> fallbackResponse())
```

---

### Saga Pattern
**Problem**: How do you maintain data consistency across microservices without distributed transactions?

**Solution**: Use a sequence of local transactions coordinated through events or orchestration.

**When to Use**:
- Business process spans multiple services
- Need consistency without 2PC/XA transactions
- Long-running business transactions

**Approaches**:
1. **Choreography**: Services publish events, others react
2. **Orchestration**: Central coordinator manages saga

**Benefits**:
- Maintains consistency without distributed transactions
- Supports long-running transactions
- Services remain loosely coupled (choreography)

**Trade-offs**:
- Complexity in error handling
- Compensating transactions needed
- Debugging can be challenging

**Example** (Order Saga):
```
Order Created → Reserve Inventory → Process Payment → Ship Order
             ↓ Failure
     Cancel Order ← Release Inventory ← Refund Payment
```

**Technologies**: Event bus (Kafka, EventBridge), Workflow engines (Temporal, AWS Step Functions)

---

### Strangler Fig Pattern
**Problem**: How do you migrate from a monolithic application to microservices incrementally?

**Solution**: Gradually replace pieces of the monolith with new microservices, routing traffic between old and new.

**When to Use**:
- Migrating legacy monolith
- Risk-averse incremental approach needed
- Can't afford big-bang rewrite

**Benefits**:
- Low-risk incremental migration
- Continuous delivery during migration
- Can halt and reverse if needed

**Trade-offs**:
- Long migration timeline
- Run two systems simultaneously
- Complex routing logic

**Implementation**:
```
[Facade/Router] → [Monolith] (decreasing)
                → [Service A] (new)
                → [Service B] (new)
```

**Technologies**: NGINX, API Gateway, Feature Flags

---

### Database per Service Pattern
**Problem**: How do you maintain microservices autonomy when they share a database?

**Solution**: Each microservice has its own database, encapsulating its data.

**When to Use**:
- True microservices autonomy needed
- Different services have different data access patterns
- Want to use different database technologies

**Benefits**:
- Service autonomy
- Independent scaling
- Technology choice per service
- Clear ownership

**Trade-offs**:
- Data consistency challenges
- No ACID across services
- Data duplication possible
- Reporting complexity

**Implementation**: Each service has exclusive access to its database schema or database instance

**Complementary Patterns**: Saga for consistency, CQRS for queries, Event Sourcing

---

## Integration Patterns

### Publish-Subscribe Pattern
**Problem**: How do you enable multiple consumers to react to events without tight coupling?

**Solution**: Publishers emit events to a topic; subscribers receive events they're interested in.

**When to Use**:
- Multiple consumers for same event
- Loose coupling desired
- Event-driven architecture
- Async processing

**Benefits**:
- Loose coupling
- Scalability
- Easy to add new consumers
- Temporal decoupling

**Trade-offs**:
- Message ordering challenges
- Debugging complexity
- Eventual consistency

**Technologies**: Kafka, RabbitMQ, AWS SNS/SQS, Azure Service Bus, Google Pub/Sub

**Example**:
```
[Publisher] → [Topic: OrderPlaced] → [Inventory Service]
                                   → [Email Service]
                                   → [Analytics Service]
```

---

### Request-Response Pattern
**Problem**: How do you implement synchronous communication between services?

**Solution**: Client sends request and waits for response from server.

**When to Use**:
- Need immediate response
- Query operations
- User-facing synchronous APIs

**Benefits**:
- Simple mental model
- Immediate feedback
- Strong consistency

**Trade-offs**:
- Tight coupling
- Synchronous blocking
- Cascade failures possible

**Technologies**: HTTP/REST, gRPC, GraphQL

---

### Event Sourcing Pattern
**Problem**: How do you maintain a complete history of changes and enable event-driven architecture?

**Solution**: Store state changes as a sequence of events rather than current state.

**When to Use**:
- Need complete audit trail
- Event-driven architecture
- Temporal queries (state at point in time)
- Complex event processing

**Benefits**:
- Complete audit trail
- Event replay capability
- Temporal queries
- Event-driven architecture enabler

**Trade-offs**:
- Complexity
- Storage requirements
- Event schema evolution
- Query complexity

**Technologies**: Event stores (EventStoreDB, Kafka), CQRS frameworks

**Example**:
```
Events: AccountCreated → Deposited(100) → Withdrawn(50) → Deposited(200)
Current State: Balance = 250
```

---

## Data Patterns

### CQRS (Command Query Responsibility Segregation)
**Problem**: How do you optimize for different read and write patterns in the same system?

**Solution**: Separate read and write models, potentially using different databases.

**When to Use**:
- Very different read and write requirements
- Complex queries on write model
- Event Sourcing used
- High-scale scenarios

**Benefits**:
- Optimized read and write models
- Independent scaling
- Security separation
- Supports Event Sourcing

**Trade-offs**:
- Increased complexity
- Eventual consistency
- Code duplication
- Synchronization challenges

**Implementation**:
```
[Command] → [Write Model] → [Events] → [Read Model] ← [Query]
```

**Technologies**: Event stores, separate databases, materialized views

---

### Data Lake Pattern
**Problem**: How do you store and analyze large volumes of structured and unstructured data?

**Solution**: Centralized repository storing raw data in native format until needed.

**When to Use**:
- Large volumes of diverse data
- Schema-on-read desired
- Advanced analytics and ML
- Long-term data retention

**Benefits**:
- Store any data type
- Cost-effective storage
- Flexibility in analysis
- Single source of truth

**Trade-offs**:
- Can become data swamp without governance
- Performance challenges
- Security complexity
- Requires data cataloging

**Architecture Layers**:
1. **Ingestion**: Raw data from sources
2. **Bronze Layer**: Raw data stored as-is
3. **Silver Layer**: Cleaned, validated data
4. **Gold Layer**: Aggregated, business-ready data

**Key Considerations**:
- Data governance and catalog
- Quality validation and anomaly detection
- Security and PII handling
- Metadata management
- Cost optimization

**Technologies**: AWS S3 + Athena + Glue, Azure Data Lake, Google Cloud Storage + BigQuery, HDFS

**Example**:
```
Raw Data Sources:
- POS transactions (structured)
- Customer clickstream (semi-structured)
- Product images (unstructured)
- Weather data (external)

Processing:
Bronze (raw) → Silver (cleaned) → Gold (aggregated)

Consumers:
- BI dashboards
- Data scientists (ML models)
- Operational reports
```

**Related Patterns**: Data Vault, Staging Area

---

### Data Vault Pattern
**Problem**: How do you design a data warehouse that's flexible, scalable, and maintainable across multiple source systems?

**Solution**: Model warehouse using Hubs (business keys), Links (relationships), and Satellites (attributes with history).

**When to Use**:
- Enterprise data warehouses with multiple sources
- Frequent source system changes
- Need complete historical tracking
- Complex relationships between entities
- High-volume data loading

**Core Components**:
1. **Hubs**: Business keys only (Customer, Product, Order)
2. **Links**: Relationships between hubs (Customer-Product purchase relationship)
3. **Satellites**: Descriptive attributes with temporal tracking

**Benefits**:
- Extremely flexible to source changes
- Complete historical tracking
- Supports late-arriving facts
- Scalability for large enterprises
- Full auditability
- Resilient to data model changes

**Trade-offs**:
- Complex initial understanding
- More tables than traditional schemas
- Requires metadata-driven loading processes
- Not ideal for small datasets
- Steeper learning curve

**Example**:
```
Hub_Customer
- CustomerKey (PK)
- CustomerID (business key)
- LoadDate

Link_Customer_Product_Purchase
- LinkKey (PK)
- CustomerKey (FK)
- ProductKey (FK)
- LoadDate

Sat_Customer_Details
- SatKey (PK)
- CustomerKey (FK)
- CustomerName
- Email
- Address
- EffectiveDate
- EndDate
- IsCurrent
```

**Technologies**: SQL Server, Oracle, Snowflake, BigQuery, PostgreSQL

**Related Patterns**: Slowly Changing Dimensions, Fact Table

---

### Master Data Management (MDM) Pattern
**Problem**: How do you maintain a single source of truth for critical business data duplicated across multiple systems?

**Solution**: Create authoritative master data repository with synchronization and governance mechanisms.

**When to Use**:
- Data duplicated across systems
- Data quality issues affecting decisions
- Regulatory requirements
- Frequent manual reconciliations needed
- Multiple system integrations

**Implementation Approaches**:
1. **Registry Model**: Stores references/IDs, actual data in source systems
2. **Repository Model**: Stores actual master data, systems reference it
3. **Hybrid Model**: Mix per entity type

**Core Capabilities**:
- Golden record creation and maintenance
- Deduplication and matching algorithms
- Survivorship rules (which values "win")
- Quality scoring and profiling
- Governance and stewardship
- Change tracking and auditing

**Benefits**:
- Single source of truth
- Improved data quality
- Reduced reconciliation overhead
- Better customer/product insights
- Regulatory compliance

**Trade-offs**:
- Complex implementation
- Ongoing governance overhead
- Change management challenges
- Requires domain expertise
- Integration complexity

**Technologies**: Informatica, SAP MDG, Talend, Collibra, custom solutions

---

### Slowly Changing Dimensions (SCD) Pattern
**Problem**: How do you track changes to dimension attributes over time in a data warehouse?

**Solution**: Store historical versions of dimension records with effective dating to enable temporal analysis.

**When to Use**:
- Dimensions change (customer address, product category, employee title)
- Need historical analysis and "as-of" reporting
- Regulatory or audit requirements
- Temporal trend analysis needed

**SCD Types**:

**Type 0** - No change tracking:
```
Customer (immutable)
- CustomerID, Name, Address
```

**Type 1** - Overwrite old values:
```
Customer
- CustomerID, Name (updated), Address (updated)
```

**Type 2** - Track full history with effective dates:
```
Customer
- CustomerID, Name, Address
- EffectiveDate, EndDate, IsCurrent (Y/N)

2024-01-01: John Smith, 123 Main St (IsCurrent=Y)
2024-06-15: John Smith, 456 Oak Ave (New row, IsCurrent=Y, Previous row EndDate=2024-06-14)
```

**Type 3** - Keep previous values:
```
Customer
- CustomerID
- Name (current), PreviousName
- Address (current), PreviousAddress
```

**Type 4** - Track in separate history table:
```
Customer table (current only)
Customer_History table (all changes with dates)
```

**Benefits**:
- Historical analysis capability
- Temporal "as-of" queries
- Complete audit trail
- Regulatory compliance
- Trend analysis support

**Trade-offs**:
- Increased storage requirements
- Complex dimension maintenance
- Query complexity increases
- ETL complexity

**Example**:
```
EffectiveDate: 2024-01-01, EndDate: 2024-06-14
John Smith, 123 Main St, IsCurrent=N

EffectiveDate: 2024-06-15, EndDate: NULL
John Smith, 456 Oak Ave, IsCurrent=Y

Query: Customer address on 2024-03-01?
Answer: 123 Main St
```

**Technologies**: SQL Server, Snowflake, BigQuery, PostgreSQL

---

### Time Series Data Pattern
**Problem**: How do you efficiently store, index, and query time-stamped data points with high write volume?

**Solution**: Optimize storage, indexing, and compression specifically for time-series characteristics.

**When to Use**:
- Sensor data, metrics, monitoring
- Stock prices, financial ticks
- Application logs with timestamps
- Event streams ordered by time
- High-volume write scenarios

**Characteristics**:
- High write volume (millions of points/second)
- Time-ordered arrival expected
- Immutable (updates rare)
- Time-range queries common
- Aggregations over time frequent
- Retention policies (keep recent, archive old)

**Optimization Techniques**:
1. **Compression**: Special algorithms for repeated/similar values
2. **Partitioning**: By time (hourly, daily buckets)
3. **Retention Policies**: Age off old data, tiered storage
4. **Downsampling**: Reduce resolution for old data (1-minute → 1-hour)
5. **Clustering**: Group related series together

**Benefits**:
- Optimized for high write speeds
- Efficient time-range queries
- Built-in compression reduces storage
- Horizontal scalability
- Cost efficiency
- Automatic retention management

**Trade-offs**:
- Limited for ad-hoc, non-time queries
- Limited multi-dimensional querying
- Specialized tools/knowledge required
- Not ideal for transactional updates

**Technologies**: InfluxDB, Prometheus, TimescaleDB, AWS Timestream, Azure Data Explorer, Google Cloud BigTable

**Example**:
```
Sensor Data:
Timestamp | SensorID | Temperature | Humidity
2025-01-01 08:00 | Sensor1 | 22.5 | 45%
2025-01-01 08:01 | Sensor1 | 22.6 | 45%
2025-01-01 08:02 | Sensor1 | 22.7 | 46%

Query: 7-day rolling average temperature
Use compression for January data, downsampled hourly
```

**Related Patterns**: Data Lake

---

## Cloud Patterns

### Auto-Scaling Pattern
**Problem**: How do you handle variable load efficiently while optimizing costs?

**Solution**: Automatically scale resources based on demand metrics, adding/removing capacity dynamically.

**When to Use**:
- Variable load patterns (peak and off-peak)
- Cost optimization critical
- Performance SLAs must be maintained
- Cloud-native applications

**Benefits**:
- Cost optimization (pay for what you use)
- Performance under load
- Automatic response to demand
- No manual intervention required
- Predictable capacity

**Trade-offs**:
- Configuration complexity (thresholds, metrics)
- Cold start issues (new instances take time)
- Scaling lag (delay detecting need)
- Can cause cascading failures if misconfigured
- Stabilization challenges

**Scaling Approaches**:

1. **Horizontal Scaling**: Add/remove instances
2. **Vertical Scaling**: Increase/decrease instance size (less common, requires restart)
3. **Hybrid**: Combine horizontal and vertical

**Scaling Metrics**:
- CPU utilization
- Memory usage
- Network bandwidth
- Request count
- Custom application metrics
- Scheduled scaling (predictable patterns)

**Implementation**:
```
Load Monitor → Scaling Decision Engine → Add/Remove Instances
↓ Metrics: CPU > 70% → Scale up
↓ Metrics: CPU < 30% → Scale down
```

**Technologies**: Kubernetes HPA, AWS Auto Scaling, Azure VMSS, GCP Autoscaling

**Example**:
```
Target: 70% CPU utilization
Metric: Current CPU 85%
Action: Add 2 instances
Result: CPU drops to 72%
```

**Related Patterns**: Load Balancing, Circuit Breaker

---

### Cache-Aside Pattern
**Problem**: How do you improve performance by caching frequently accessed data?

**Solution**: Application checks cache first; on miss, loads from database and populates cache.

**When to Use**:
- Frequently read, infrequently updated data
- Database load reduction critical
- Performance improvement required
- Acceptable stale data briefly

**Benefits**:
- Improved performance (cache hit faster)
- Reduced database load
- Flexible caching logic
- Works with existing databases
- Easy to implement

**Trade-offs**:
- Cache inconsistency possible (stale data)
- Complex invalidation logic
- Cold cache performance impact
- Cache penetration (all misses to DB)
- Requires cache TTL strategy

**Flow**:
```
1. Check cache for key
2. If hit: return cached value
3. If miss:
   a. Query database
   b. Store in cache
   c. Return value
```

**Invalidation Strategies**:
1. **TTL-based**: Expire after time period
2. **Event-based**: Invalidate on data change
3. **Write-through**: Update cache on write
4. **Lazy deletion**: Check validity on read

**Technologies**: Redis, Memcached, AWS ElastiCache, Azure Cache, Hazelcast

**Example** (Python):
```python
def get_user(user_id):
    # Check cache
    cached = cache.get(f"user:{user_id}")
    if cached:
        return cached
    
    # Miss: get from DB
    user = db.query(f"SELECT * FROM users WHERE id = {user_id}")
    
    # Populate cache (TTL: 1 hour)
    cache.set(f"user:{user_id}", user, ttl=3600)
    return user
```

**Related Patterns**: Write-Behind Cache, Cache-Through, Event Sourcing

---

### Load Balancing Pattern
**Problem**: How do you distribute traffic across multiple servers to avoid overloading any single instance?

**Solution**: Route incoming requests across multiple servers using various distribution algorithms.

**When to Use**:
- Multiple servers available
- High traffic volume
- Need to prevent single server overload
- High availability required

**Load Balancing Algorithms**:
1. **Round Robin**: Distribute sequentially
2. **Least Connections**: Route to least busy server
3. **Weighted Round Robin**: Account for server capacity differences
4. **IP Hash**: Route based on client IP (session affinity)
5. **Random**: Random server selection
6. **Custom**: Application-specific logic

**Benefits**:
- Distribute traffic fairly
- Prevent server overload
- Improved availability
- Scalability

**Trade-offs**:
- Added component (potential SPOF)
- Session management complexity
- Debugging difficulty
- Configuration overhead

**Implementation Levels**:
- **DNS-based**: Round-robin DNS
- **Layer 4 (TCP/UDP)**: Transport level
- **Layer 7 (HTTP)**: Application level

**Technologies**: NGINX, HAProxy, AWS ELB/ALB/NLB, Azure Load Balancer, GCP Load Balancing

---

### Multi-Region Deployment Pattern
**Problem**: How do you deploy applications across multiple geographic regions for high availability and low latency?

**Solution**: Deploy applications in multiple regions with data replication and traffic routing.

**When to Use**:
- Global user base
- Need low latency in multiple regions
- Disaster recovery across regions
- Regulatory data residency
- High availability critical

**Architecture Components**:
1. **Application in each region**: Independent deployments
2. **Data replication**: Sync between regions
3. **Traffic routing**: Direct users to nearest region
4. **Failover mechanism**: Redirect if region fails

**Deployment Models**:
1. **Active-Active**: All regions serve traffic
2. **Active-Passive**: Primary region only, failover to secondary
3. **Multi-Region Active**: Different services in different regions

**Benefits**:
- Lower latency (users hit nearest region)
- Disaster recovery across regions
- High availability (region failure tolerance)
- Regulatory compliance (data residency)

**Trade-offs**:
- Increased complexity
- Data consistency challenges
- Higher cost (replicate infrastructure)
- Operational overhead
- Latency for data sync

**Technologies**: AWS Route 53, Azure Traffic Manager, Google Cloud Load Balancing, Kubernetes Federation

---

### Serverless Pattern
**Problem**: How do you build scalable applications without managing infrastructure?

**Solution**: Deploy functions/code that scale automatically, billed only for execution time.

**When to Use**:
- Variable/unpredictable load
- Short-running operations
- Event-driven workloads
- Development velocity important
- Cost optimization critical

**Characteristics**:
- No infrastructure management
- Auto-scaling (handled by provider)
- Pay-per-execution
- Stateless functions
- Short execution times

**Benefits**:
- Reduced operational overhead
- Automatic scaling
- Cost efficient (pay for use)
- Fast time to market
- No infrastructure to manage

**Trade-offs**:
- Vendor lock-in
- Cold start latency
- Execution time limits
- Stateless (no local storage)
- Limited to short operations
- Harder debugging/monitoring

**Patterns**:
1. **Function as a Service (FaaS)**: AWS Lambda, Azure Functions
2. **Backend as a Service (BaaS)**: Firebase, AWS Amplify
3. **Containers as a Service**: AWS ECS Fargate, Google Cloud Run

**Technologies**: AWS Lambda, Azure Functions, Google Cloud Functions, IBM Cloud Functions

**Example**:
```
Event (S3 upload) → Lambda function → Process image → Store result
Automatic scaling: 0 to 1000s of concurrent executions
```

**Related Patterns**: Event-Driven Architecture, Microservices

---

### Content Delivery Network (CDN) Pattern
**Problem**: How do you deliver static content with low latency to globally distributed users?

**Solution**: Distribute content across edge servers located near users worldwide.

**When to Use**:
- Global user base
- Static content delivery
- Need low latency
- High bandwidth requirements
- Cache-friendly content

**Benefits**:
- Reduced latency (content closer to users)
- Bandwidth savings (cached at edge)
- Reduced origin server load
- DDoS protection
- Geographic redundancy

**Trade-offs**:
- Cache invalidation complexity
- Cost (bandwidth to edges)
- Dynamic content challenges
- TTL tuning complexity

**Content Types**:
- Static assets (images, CSS, JS)
- Video streaming
- Software downloads
- API responses (with caching)

**Technologies**: CloudFront (AWS), Akamai, Cloudflare, Azure CDN, Google Cloud CDN

**Example**:
```
User in Tokyo → CDN Edge Tokyo → Static image (cached)
User in NYC → CDN Edge NYC → Static image (cached)
Origin server serves only cache misses
```

---

## Security Patterns

### Zero Trust Architecture Pattern
**Problem**: How do you secure resources in a world where network perimeter is porous (cloud, remote work, BYOD)?

**Solution**: Never trust, always verify. Authenticate and authorize every request, regardless of origin.

**When to Use**:
- Cloud and hybrid environments
- Remote workforce (VPN insufficient)
- Micro-segmentation desired
- High security requirements
- Insider threat mitigation

**Core Principles**:
1. **Verify Explicitly**: Always authenticate and authorize
2. **Least Privilege Access**: Minimum required permissions
3. **Assume Breach**: Design as if already compromised
4. **Micro-segmentation**: Isolate network into small zones
5. **Encrypt Everywhere**: Data in transit and at rest

**Implementation Components**:
- **Identity**: Strong authentication (MFA required)
- **Access Control**: Attribute-based access control (ABAC)
- **Encryption**: All data encrypted
- **Monitoring**: Continuous logging and anomaly detection
- **Network**: Micro-segmentation, least privilege network

**Benefits**:
- Reduced breach impact
- Better insider threat protection
- Works for distributed/remote teams
- Accommodates BYOD
- Improved compliance posture

**Trade-offs**:
- Implementation complexity
- Performance overhead (auth/encryption)
- Organizational change required
- Higher operational cost
- User experience impact (MFA fatigue)

**Technologies**: Identity providers (Azure AD, Okta), mTLS, service mesh (Istio), policy engines (OPA)

**Example**:
```
Traditional Perimeter:
Firewall → Everyone trusted inside

Zero Trust:
Every request → Identity verification → Permission check → Micro-segmented network → Encrypt
```

**Related Patterns**: API Gateway Authentication, Encryption, Network Segmentation

---

### API Gateway Authentication Pattern
**Problem**: How do you centralize authentication for microservices without embedding auth in each service?

**Solution**: API Gateway authenticates requests and passes identity information to backend services.

**When to Use**:
- Multiple microservices behind gateway
- Consistent authentication needed
- OAuth 2.0/OIDC flows required
- Token-based auth preferred

**Authentication Methods**:
1. **API Keys**: Simple but limited
2. **OAuth 2.0**: Delegated access, refresh tokens
3. **OpenID Connect (OIDC)**: OAuth 2.0 + identity layer
4. **JWT**: Stateless, self-contained tokens
5. **mTLS**: Mutual TLS certificates

**Flow**:
```
Client → API Gateway (validates token) → Claims added to request → Microservice
                                      ↓
                              Identity Provider (validate token)
```

**Benefits**:
- Centralized authentication logic
- Services don't handle auth complexity
- Consistent security model
- Easy policy enforcement
- Reduced token validation overhead

**Trade-offs**:
- Single point of failure (API Gateway availability)
- Additional network hop
- Token size/overhead
- Clock skew issues (JWT validation)

**Technologies**: Kong, AWS API Gateway + Cognito, Azure API Management + Azure AD, Keycloak, Auth0

**Implementation** (JWT):
```
1. Client authenticates with identity provider
2. Provider returns JWT token
3. Client sends request with Authorization: Bearer <JWT>
4. API Gateway validates JWT signature
5. Extracts claims (user_id, roles, etc.)
6. Adds to request headers
7. Routes to microservice
```

**Security Considerations**:
- Always use HTTPS
- Validate token signature
- Check token expiration
- Verify issuer and audience
- Implement token refresh

---

### OAuth 2.0 / OpenID Connect (OIDC) Pattern
**Problem**: How do you enable secure, delegated access without sharing passwords?

**Solution**: Use OAuth 2.0 for authorization and OIDC for authentication (identity).

**When to Use**:
- User login/sign-up needed
- Third-party app integration
- Mobile/SPA applications
- Social login integration
- Need to delegate access without passwords

**OAuth 2.0 Grant Types**:

1. **Authorization Code**: Web applications, most secure
2. **Implicit**: SPAs (less secure, being deprecated)
3. **Client Credentials**: Service-to-service, no user
4. **Resource Owner Password**: Desktop apps (not recommended)
5. **Refresh Token**: Obtain new access tokens

**OIDC**: OAuth 2.0 + Identity layer
- User info endpoint
- ID token (JWT with identity)
- Standardized claims

**Flow** (Authorization Code):
```
User → Application → Redirect to Identity Provider
                 ↓ User logs in
               ← Authorization code
       ↓
       Exchange code for tokens (backend)
       ↓ Get access token + refresh token
       ↓
       Access protected resources
```

**Benefits**:
- Passwords never shared with app
- Delegated access control
- Can revoke without changing password
- Supports MFA
- Industry standard
- Social login integration

**Trade-offs**:
- Complexity (many moving parts)
- Token management overhead
- Clock skew issues
- Token size (JWT)
- Redirect flow complexity

**Security Best Practices**:
- Always use HTTPS
- Validate redirect URIs
- Use PKCE (Proof Key for Code Exchange)
- Short-lived access tokens (15 min)
- Long-lived refresh tokens (7 days)
- Rotate refresh tokens

**Technologies**: Okta, Azure AD, Auth0, Keycloak, Google Identity, AWS Cognito

---

### Encryption Pattern
**Problem**: How do you protect sensitive data from unauthorized access?

**Solution**: Encrypt data in transit and at rest using industry-standard algorithms.

**When to Use**:
- Handling sensitive data (PII, financial, health)
- Compliance requirements (GDPR, HIPAA, PCI-DSS)
- Multi-tenant systems
- Any customer data

**Encryption Types**:

1. **In Transit**: TLS 1.2+
   - HTTPS for web
   - mTLS for service-to-service
   - VPN for network traffic

2. **At Rest**: AES-256
   - Database encryption
   - File system encryption
   - Backup encryption

**Key Management**:
- Centralized key store (Key Vault)
- Key rotation policy
- Access controls on keys
- Audit key usage
- Secure key generation

**Benefits**:
- Data confidentiality
- Regulatory compliance
- Breach mitigation (encrypted data less valuable)
- Industry standard

**Trade-offs**:
- Performance overhead
- Key management complexity
- Increased CPU usage
- Debugging difficulty (encrypted data)

**Technologies**: 
- TLS: OpenSSL, NGINX, AWS ALB
- Key Management: AWS KMS, Azure Key Vault, HashiCorp Vault
- Encryption: Transparent Data Encryption (TDE), application-level encryption

**Example**:
```
Data at rest:
Customer table encrypted with AES-256 key
Key stored in Azure Key Vault

Data in transit:
HTTPS (TLS 1.3) between client and API
mTLS between microservices

Key rotation: Every 90 days
```

---

### Secret Management Pattern
**Problem**: How do you securely store and access secrets (passwords, API keys, tokens)?

**Solution**: Centralized secret management with encryption, access control, and audit logging.

**When to Use**:
- Database credentials
- API keys and tokens
- Certificates and keys
- Any sensitive credentials

**Best Practices**:
1. **Never hardcode secrets**: Use secret management tools
2. **Rotation**: Regularly rotate secrets
3. **Access control**: Only services needing secret can access
4. **Encryption**: Secrets encrypted at rest
5. **Audit**: Log all access to secrets
6. **Least privilege**: Minimum required access

**Secret Retrieval**:
```
Application → Secret Manager API → Authenticate → Check permissions
                                             ↓
                                      Return decrypted secret
```

**Technologies**: AWS Secrets Manager, Azure Key Vault, HashiCorp Vault, Kubernetes Secrets, Docker Secrets

**Anti-patterns**:
- ❌ Hardcoded credentials in code
- ❌ Committing secrets to git
- ❌ Passing secrets in environment variables (logged)
- ❌ Sharing credentials between environments
- ❌ Long-lived, static credentials

---

### Rate Limiting & DDoS Protection Pattern
**Problem**: How do you protect services from abuse, overload, and DDoS attacks?

**Solution**: Implement rate limiting to control traffic and DDoS protection at network/application layers.

**When to Use**:
- Public APIs
- Authentication endpoints
- Resource-intensive operations
- SaaS platforms
- High-value targets

**Rate Limiting Strategies**:
1. **Per User**: Limit requests per authenticated user
2. **Per IP**: Limit requests from single IP
3. **Global**: Total system request limit
4. **Sliding Window**: Time-window based
5. **Token Bucket**: Smooth burst handling

**DDoS Protection Layers**:
1. **Network Layer**: ISP/CDN protection
2. **Transport Layer**: Infrastructure DDoS mitigation
3. **Application Layer**: Rate limiting, WAF

**Benefits**:
- Prevent service overload
- Protect from malicious actors
- Fair resource sharing
- API abuse prevention

**Trade-offs**:
- Legitimate user impact possible
- Configuration complexity
- Threshold tuning required

**Implementation**:
```
Request arrives → Check rate limit → Within limit: process
                               → Over limit: return 429 Too Many Requests
```

**Technologies**: AWS WAF, Cloudflare, API gateway rate limiting, NGINX rate limiting

**Example**:
```
Rate limit: 100 requests per minute per IP
Client 1: 50 requests/minute → OK
Client 2: 150 requests/minute → 429 errors for excess
Attack: 10,000 requests/minute → Blocked at edge
```

**Related Patterns**: Circuit Breaker, API Gateway

---

## Resilience Patterns

### Bulkhead Pattern
**Problem**: How do you isolate failures to prevent system-wide impact?

**Solution**: Partition resources (threads, memory, connections) to isolate failures to specific components.

**When to Use**:
- Critical system isolation needed
- Prevent resource exhaustion
- Multi-tenant systems
- Shared resources between services
- Cascade failure prevention

**Implementation Approaches**:

1. **Thread Pool Isolation**:
```
Service A thread pool (10 threads)
Service B thread pool (10 threads)
Service C thread pool (10 threads)

If Service A hangs: only uses 10 threads, others unaffected
```

2. **Process/Container Isolation**:
```
Separate containers per service
Each with resource limits (memory, CPU)
Failures isolated to container
```

3. **Database Connection Pool**:
```
Connection pool size: 20
If one query hangs: uses some connections
Remaining connections available for other queries
```

**Benefits**:
- Failure isolation
- Resource protection
- Predictable degradation
- System survives partial failures
- Clear resource allocation

**Trade-offs**:
- Resource overheads (extra threads, processes)
- Tuning complexity (pool sizes, timeouts)
- Potential underutilization
- Monitoring overhead

**Technologies**: Kubernetes resource limits, Hystrix (deprecated), Resilience4j, Polly, thread pool management

**Example**:
```
Payment Service hangs → Payment thread pool saturated
↓
Inventory Service unaffected (separate thread pool)
Order Service unaffected (separate thread pool)
Users can still query inventory while payment fails
```

**Related Patterns**: Circuit Breaker, Timeout, Retry

---

### Retry Pattern
**Problem**: How do you handle transient failures automatically?

**Solution**: Automatically retry failed operations with configurable backoff strategy.

**When to Use**:
- Transient failures expected (network hiccups)
- Network calls (HTTP, database)
- Idempotent operations only
- Temporary overload conditions

**Retry Strategies**:

1. **Simple Retry**: Immediate retry
   - Retry count: 3
   - Risk: Retry storms

2. **Exponential Backoff**: Increasing delays
   ```
   Attempt 1: Immediate
   Attempt 2: Wait 1 second
   Attempt 3: Wait 2 seconds
   Attempt 4: Wait 4 seconds
   Attempt 5: Wait 8 seconds
   ```

3. **Exponential Backoff with Jitter**: Add randomness
   ```
   Backoff = 2^attempt + random(0, 2^attempt)
   Prevents thundering herd
   ```

4. **Linear Backoff**: Increasing linearly
   ```
   Attempt 1: Immediate
   Attempt 2: Wait 1 second
   Attempt 3: Wait 2 seconds
   Attempt 4: Wait 3 seconds
   ```

**Benefits**:
- Automatic transient failure handling
- Reduces manual intervention
- Improves availability
- Works for temporary issues

**Trade-offs**:
- Can amplify problems (retry storms)
- Increased latency (waiting between retries)
- Not suitable for non-idempotent operations
- Resource consumption

**Idempotency Requirement**:
- Retrying must not cause side effects
- Safe operations: GET, reads, queries
- Unsafe: POST without idempotency key, DELETE

**Technologies**: Resilience4j, AWS SDK, Spring Retry, Polly, HTTP clients with built-in retry

**Example**:
```
GET /api/data
Network timeout → Retry after 1s → Success

POST /api/data (with idempotency key)
Network failure → Retry after 1s → Safe (idempotency key prevents duplication)

DELETE /api/data (no idempotency key)
Network failure → DON'T retry without verification
```

---

### Timeout Pattern
**Problem**: How do you prevent indefinite waits for operations that may never complete?

**Solution**: Set maximum time to wait for operation; fail fast if timeout exceeded.

**When to Use**:
- External service calls
- Database queries
- Any blocking operation with uncertainty
- Need bounded response time

**Timeout Levels**:

1. **Connection Timeout**: Time to establish connection
   - Typical: 5-10 seconds
   - Detects network issues early

2. **Read Timeout**: Time waiting for response data
   - Typical: 15-30 seconds
   - Detects slow/hanging services

3. **Overall Timeout**: Total operation time
   - Typical: 30-60 seconds
   - Prevents indefinite waits

**Benefits**:
- Bounded latency
- Prevents resource exhaustion
- Fail fast detection
- Better user experience (timeout vs. hang)

**Trade-offs**:
- Timeout too short: Legitimate requests fail
- Timeout too long: Users wait too long
- Cascading timeouts (chain of calls)
- Tuning complexity

**Implementation**:
```
Start timer → Make request → Wait up to timeout
                           ↓ Timeout expires
                           Return error / retry
                           ↓ Response arrives in time
                           Return result
```

**Timeout Chain Issue**:
```
User timeout: 10s
↓ Service A calls Service B (timeout: 5s)
↓ Service B calls Service C (timeout: 2s)
Service C needs 4s → timeout
Service B retries → timeout
Service A fails → timeout

Solution: Timeout should decrease through call chain
```

**Technologies**: HTTP clients (urllib3, requests, httpx), database drivers, message queues, gRPC

**Example**:
```
curl --max-time 10 https://api.example.com/data
Socket timeout: 5 seconds
Read timeout: 10 seconds
```

**Related Patterns**: Circuit Breaker, Retry, Bulkhead

---

### Fallback / Graceful Degradation Pattern
**Problem**: How do you provide reduced functionality when services fail?

**Solution**: Use fallback mechanisms to degrade gracefully rather than failing completely.

**When to Use**:
- Non-critical services fail
- Cache available
- Alternative sources available
- Partial functionality acceptable
- User experience important

**Fallback Strategies**:

1. **Cache Fallback**: Return stale cache if service down
2. **Default Values**: Use sensible defaults
3. **Alternative Service**: Call backup service
4. **Reduced Features**: Disable non-essential features
5. **Queuing**: Queue requests for later

**Example - E-commerce**:
```
Primary: Database (recommendations)
  ↓ Timeout/error
Fallback 1: Cache (yesterday's recommendations)
  ↓ Not available
Fallback 2: Default recommendations (popular items)
  ↓ Still failed
Fallback 3: Show no recommendations, load page

User still sees product page (degraded but functional)
```

**Benefits**:
- Better user experience
- Service continues (reduced capability)
- Improved perceived availability
- Prevents cascading failures

**Trade-offs**:
- Logic complexity (multiple code paths)
- Data freshness (using cache)
- User confusion (inconsistent experience)
- Testing complexity

**Technologies**: Circuit Breaker libraries, caching, API gateway fallback, feature flags

---

### Health Check Pattern
**Problem**: How do you know if a service is healthy and ready to serve traffic?

**Solution**: Implement health check endpoints that validate service status.

**When to Use**:
- Load balancer needs service status
- Container orchestration (Kubernetes)
- Auto-scaling decisions
- Monitoring and alerting
- Rolling deployments

**Health Check Types**:

1. **Shallow**: Service process running
   ```
   GET /health → 200 OK
   ```

2. **Deep**: Dependencies verified
   ```
   GET /health/deep
   - Database connection: OK
   - Cache: OK
   - Message queue: OK
   ```

3. **Readiness**: Ready to accept traffic
   ```
   GET /ready
   Returns 200 if warmed up, dependencies available
   ```

4. **Liveness**: Still running (haven't crashed)
   ```
   GET /alive
   Quick check, used to restart unhealthy containers
   ```

**Implementation**:
```java
@GetMapping("/health")
public ResponseEntity<Health> health() {
    try {
        // Check database
        database.getConnection();
        // Check cache
        cache.ping();
        return ResponseEntity.ok(new Health("UP"));
    } catch (Exception e) {
        return ResponseEntity.status(503)
            .body(new Health("DOWN", e.getMessage()));
    }
}
```

**Benefits**:
- Automated failure detection
- Fast recovery (remove unhealthy instance)
- Supports auto-scaling
- Prevents cascading failures

**Trade-offs**:
- Health check load on service
- False positives/negatives
- Dependency on check accuracy
- Latency (deep checks slower)

**Best Practices**:
- Liveness checks: fast, lightweight
- Readiness checks: thorough
- Timeout: 5-10 seconds
- Interval: 10-30 seconds
- Failure threshold: 3+ failures

**Technologies**: Kubernetes probes, Spring Boot Actuator, custom endpoints

---

### Compensating Transaction Pattern
**Problem**: How do you undo a transaction that spans multiple services without distributed transactions?

**Solution**: Define compensating actions that undo each service's transaction on failure.

**When to Use**:
- Long-running transactions across services
- ACID not available across services
- Saga pattern implementation
- Need to undo state changes

**Example - Order Processing**:
```
1. Create Order → Success
2. Reserve Inventory → Success
3. Charge Payment → FAILS
   ↓
   Compensating:
   - Release Inventory (undo step 2)
   - Cancel Order (undo step 1)
```

**Implementation Approaches**:

1. **Orchestration**: Central coordinator manages compensations
2. **Choreography**: Services listen and compensate via events

**Compensation Steps**:
```
Withdraw $100 (payment service)
  ↓
Record transaction (ledger service)
  ↓
Email confirmation (notification)
  ↓ Notification fails
  ← Refund $100 (undo withdraw)
  ← Reverse transaction (undo ledger)
  ← Notify failure (partial compensation)
```

**Benefits**:
- Eventual consistency without 2PC
- Handles long-running transactions
- Services remain independent
- Clear rollback mechanism

**Trade-offs**:
- Complex implementation
- Debugging difficult
- Compensating transactions can fail
- Temporal consistency (time gap between action and rollback)

**Challenges**:
- What if compensation fails?
- How do you notify users (action happened, then rolled back)?
- Third-party service (can't always compensate)
- Human intervention might be needed

**Technologies**: Temporal, AWS Step Functions, Axon Framework, Saga frameworks

---

### Queue-Based Load Leveling Pattern
**Problem**: How do you handle variable load without overwhelming backend services?

**Solution**: Use a queue to buffer requests, allowing backend to process at sustainable rate.

**When to Use**:
- Bursty traffic patterns
- Long-running operations
- Backend can't handle peaks
- Need to smooth load

**Flow**:
```
Heavy Load → Queue → Steady Processing
100 requests/sec → Queue (buffer) → Backend (10 requests/sec)
All queued, processed in order
```

**Benefits**:
- Handles traffic spikes
- Protects backend from overload
- Better resource utilization
- Fair request processing (FIFO)

**Trade-offs**:
- Increased latency (request in queue)
- Queue infrastructure needed
- Need monitoring (queue size)
- Potential message loss (if not persisted)

**Technologies**: RabbitMQ, Kafka, AWS SQS, Azure Service Bus

**Example**:
```
Peak traffic: 1000 orders/sec
Backend capacity: 100 orders/sec

Without queue: 900 requests fail/timeout
With queue: All queued, processed sequentially
User waits, but gets success
```

**Related Patterns**: Publish-Subscribe, Message Queue

---

## Pattern Selection Guide

| Scenario | Recommended Patterns |
|----------|---------------------|
| Building microservices | API Gateway, Service Discovery, Circuit Breaker, Database per Service |
| Event-driven system | Publish-Subscribe, Event Sourcing, Saga, CQRS |
| Cloud migration | Strangler Fig, Auto-Scaling, Cache-Aside |
| High availability | Circuit Breaker, Retry, Bulkhead |
| Security | Zero Trust, API Gateway Authentication |
| Data management | CQRS, Event Sourcing, Data Lake |

## Using Patterns

### Best Practices
1. **Understand the Problem**: Ensure pattern addresses your actual problem
2. **Consider Trade-offs**: Every pattern has trade-offs
3. **Start Simple**: Don't over-engineer
4. **Combine Patterns**: Patterns work together
5. **Document Decisions**: Use ADRs to record pattern choices

### Pattern Anti-Patterns
- ❌ Using patterns for the sake of patterns
- ❌ Not considering trade-offs
- ❌ Copy-paste without understanding context
- ❌ Over-engineering simple problems

## Contributing Patterns

Have a pattern to share?
1. Use the [pattern template](../../templates/pattern-template.md)
2. Include context, problem, solution, trade-offs
3. Provide examples from real projects
4. Submit pull request

---

[Back to Knowledge Base](./README.md) | [Home](../../README.md)
