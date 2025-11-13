# E-Commerce Platform Reference Architecture

## Executive Summary

This reference architecture describes a complete, production-ready e-commerce platform capable of handling millions of users, peak traffic events, and complex business requirements. It covers both the business and technical domains with detailed patterns for solving common e-commerce challenges.

**Key Capabilities:**
- Support for 1M+ concurrent users during peak seasons
- Global deployment across multiple regions
- Real-time inventory synchronization
- Multiple payment method support
- Personalized recommendations (machine learning)
- Advanced search with faceted filtering
- Mobile-first design
- 99.99% availability SLA

**Business Domains:**
- Customer management (registration, authentication, profiles)
- Product management (catalog, SKUs, variants)
- Shopping experience (search, browse, recommendations)
- Order management (placement, fulfillment, returns)
- Payment processing (secure, PCI-compliant)
- Inventory management (stock, reservations, sync)
- Shipping & delivery (tracking, label generation)
- Customer support (tickets, chat, knowledge base)
- Analytics & reporting (metrics, dashboards, BI)

---

## System Context Diagram (C4 Level 1)

```
┌────────────────────────────────────────────────────┐
│                   External Users                   │
│  (Browsers, Mobile Apps, Email Clients)            │
└──────┬──────────────────────────┬──────────────────┘
       │                          │
   ┌───▼──────────┐      ┌────────▼────────┐
   │ Web Browser  │      │  Mobile Apps    │
   │ (Desktop)    │      │ (iOS/Android)   │
   └───┬──────────┘      └────────┬────────┘
       │                          │
   ┌───┴──────────────────────────┴─────┐
   │   E-Commerce Platform              │
   │  - Product Catalog & Search        │
   │  - Shopping Cart & Checkout        │
   │  - Order Management                │
   │  - User Accounts & Profiles        │
   │  - Payment Processing              │
   │  - Inventory Management            │
   │  - Recommendations & Analytics     │
   └──────┬──────────────────────────────┘
          │
   ┌──────┴────────────────────┬──────────┐
   │                           │          │
┌──▼──┐  ┌────────┐  ┌────────▼─┐  ┌────▼────┐
│ Mail│  │ Payment │  │ Shipping │  │ External│
│ Svc │  │ Gateway │  │ Providers│  │ Systems │
└─────┘  └────────┘  └──────────┘  └─────────┘
```

---

## Container Diagram (C4 Level 2)

### Customer-Facing Applications

```
┌──────────────────────────────┐
│     Web Application          │
├──────────────────────────────┤
│  React 18+ / TypeScript      │
│  - Product browsing          │
│  - Search & filtering        │
│  - Shopping cart             │
│  - Checkout flow             │
│  - Account management        │
│  - Order tracking            │
└──────────────────────────────┘

┌──────────────────────────────┐
│    Mobile Application        │
├──────────────────────────────┤
│  React Native                │
│  - Same functionality        │
│  - Push notifications        │
│  - QR code scanning          │
│  - Offline support (partial) │
└──────────────────────────────┘

┌──────────────────────────────┐
│   Admin Application          │
├──────────────────────────────┤
│  React / Next.js             │
│  - Product management        │
│  - Order management          │
│  - User management           │
│  - Reporting & Analytics     │
│  - Inventory control         │
│  - Marketing tools           │
└──────────────────────────────┘
```

### Core Services

```
API GATEWAY SERVICE:
├─ Request routing to microservices
├─ API versioning (v1, v2, etc.)
├─ Authentication/Authorization (OAuth 2.0)
├─ Rate limiting per user/API key
├─ Request transformation
├─ Response caching
└─ Request logging & monitoring

AUTHENTICATION SERVICE:
├─ User registration
├─ Login/logout
├─ OAuth 2.0 / OpenID Connect
├─ JWT token generation
├─ Session management
├─ Password reset
├─ Multi-factor authentication (MFA)
└─ API key management

PRODUCT SERVICE:
├─ Product catalog management
├─ SKU and variant management
├─ Category & taxonomy
├─ Product images & media
├─ Product information database
├─ Product search support
├─ Pricing rules
└─ Promotion integration

SEARCH SERVICE:
├─ Full-text search (Elasticsearch)
├─ Faceted search (brand, price, category)
├─ Auto-complete suggestions
├─ Search analytics
├─ Relevance tuning
├─ Index synchronization
├─ Search performance optimization
└─ A/B testing for search algorithms

CART SERVICE:
├─ Shopping cart management
├─ Cart persistence (to database)
├─ Cart abandonment tracking
├─ Cart analytics
├─ Promo code application
├─ Cart item validation
├─ Quantity limit enforcement
└─ Cart timeout (30 day expiration)

ORDER SERVICE:
├─ Order creation & placement
├─ Order tracking
├─ Order status updates
├─ Order fulfillment
├─ Return management
├─ Invoice generation
├─ Order history
└─ Cancelled order handling

PAYMENT SERVICE:
├─ Payment gateway integration
├─ Credit card processing (PCI-compliant)
├─ Multiple payment methods
│  ├─ Credit/Debit cards
│  ├─ PayPal / Apple Pay / Google Pay
│  ├─ Bank transfer
│  └─ Cryptocurrency (optional)
├─ Payment validation
├─ Refund processing
├─ Fraud detection
├─ Transaction logging
└─ Currency conversion

INVENTORY SERVICE:
├─ Stock level management
├─ Inventory synchronization
├─ Reservation management
├─ Low stock alerts
├─ Reorder point automation
├─ Multi-warehouse support
├─ Real-time availability check
├─ Inventory forecasting
└─ Backorder management

SHIPPING SERVICE:
├─ Shipping rate calculation
├─ Carrier integration (FedEx, UPS, DHL)
├─ Label generation
├─ Shipment tracking
├─ Return shipping
├─ Address validation
├─ Delivery time estimation
└─ Shipping analytics

NOTIFICATION SERVICE:
├─ Email notifications
│  ├─ Order confirmation
│  ├─ Shipping updates
│  ├─ Delivery notification
│  ├─ Marketing emails
│  └─ Promotional offers
├─ SMS notifications
├─ Push notifications
│  ├─ Order updates
│  ├─ Flash sales
│  └─ Personalized recommendations
├─ In-app messaging
└─ Notification preferences

RECOMMENDATION SERVICE:
├─ Personalized recommendations
│  ├─ Collaborative filtering
│  ├─ Content-based filtering
│  ├─ Hybrid approach (ML models)
│  └─ Real-time personalization
├─ "Customers also bought" suggestions
├─ "Related products" (rule-based)
├─ A/B testing recommendations
├─ Model training & updates
└─ Recommendation analytics

ANALYTICS SERVICE:
├─ Event collection
│  ├─ Page views
│  ├─ Product views
│  ├─ Search queries
│  ├─ Cart events
│  ├─ Purchase events
│  └─ Custom events
├─ User behavior analysis
├─ Funnel analysis
├─ Conversion tracking
├─ Cohort analysis
├─ Revenue reporting
├─ Customer lifetime value
└─ A/B testing platform

CUSTOMER SERVICE:
├─ User profile management
├─ Address book management
├─ Wish list / Favorites
├─ Order history
├─ Account preferences
├─ Newsletter subscriptions
├─ Customer support tickets
└─ Chat / Live support
```

---

## Domain Model (Data Architecture)

### Entity Relationships

```
CUSTOMER Domain:
├─ Customer
│  ├─ ID (UUID)
│  ├─ Email (unique)
│  ├─ Password Hash
│  ├─ Name, Phone
│  ├─ Created At, Updated At
│  └─ Status (active, inactive, deleted)
│
├─ Address
│  ├─ Type (billing, shipping)
│  ├─ Street, City, State, Zip
│  ├─ Country
│  └─ Is Default (boolean)
│
└─ Customer Preferences
   ├─ Newsletter subscription
   ├─ Marketing communications
   └─ Privacy settings

PRODUCT Domain:
├─ Product
│  ├─ ID (UUID)
│  ├─ Name, Description
│  ├─ Category
│  ├─ Brand
│  ├─ Rating, Review Count
│  └─ Created At, Updated At
│
├─ ProductVariant (SKU)
│  ├─ Size, Color, Other attributes
│  ├─ Price
│  ├─ Cost
│  └─ Barcode
│
├─ InventoryLevel
│  ├─ Warehouse
│  ├─ Available Quantity
│  ├─ Reserved Quantity
│  ├─ Damaged/Lost
│  └─ Reorder Point
│
└─ ProductImage
   └─ URL, Primary flag, Alt text

ORDER Domain:
├─ Order
│  ├─ ID (UUID)
│  ├─ Customer ID
│  ├─ Order Date
│  ├─ Status (pending, confirmed, shipped, delivered, cancelled, returned)
│  ├─ Total Amount
│  ├─ Shipping Address
│  ├─ Billing Address
│  └─ Estimated Delivery Date
│
├─ OrderItem
│  ├─ Order ID
│  ├─ Product ID / Variant ID
│  ├─ Quantity
│  ├─ Unit Price
│  ├─ Line Total
│  └─ Status
│
├─ Payment
│  ├─ Order ID
│  ├─ Amount
│  ├─ Payment Method
│  ├─ Status (pending, completed, failed, refunded)
│  ├─ Transaction ID
│  └─ Timestamp
│
├─ Shipment
│  ├─ Order ID
│  ├─ Carrier (FedEx, UPS, etc.)
│  ├─ Tracking Number
│  ├─ Status
│  ├─ Estimated Delivery
│  └─ Actual Delivery
│
└─ Return
   ├─ Order ID / OrderItem ID
   ├─ Reason
   ├─ Status
   ├─ Refund Amount
   └─ Return Tracking Number

PROMOTION Domain:
├─ Coupon
│  ├─ Code
│  ├─ Discount Type (fixed, percentage)
│  ├─ Discount Value
│  ├─ Valid From - To
│  ├─ Max Uses
│  ├─ Min Order Value
│  └─ Applicable Categories
│
├─ Promotion
│  ├─ Type (flash sale, seasonal, etc.)
│  ├─ Valid Period
│  ├─ Discount Rules
│  └─ Targeted Customers
│
└─ Loyalty Program
   ├─ Points per $
   ├─ Points per purchase
   ├─ Redemption rules
   └─ Tier system (Bronze, Silver, Gold)
```

---

## Data Flow

### User Registration & Authentication

```
1. User Registration
   ┌─ User submits email/password via web form
   ├─ HTTPS POST to /auth/register
   ├─ API Gateway routes to Auth Service
   ├─ Auth Service validates email format
   ├─ Check if email already exists (query users table)
   ├─ Hash password using bcrypt (salt included)
   ├─ Insert user record to PostgreSQL
   ├─ Publish UserRegisteredEvent to Kafka
   │  └─ Notification Service consumes event
   │  └─ Send welcome email
   │  └─ Create customer record in CRM
   ├─ Return JWT token to client
   └─ Client stores token in secure storage

2. Login
   ┌─ User submits email/password
   ├─ API Gateway routes to Auth Service
   ├─ Query users table WHERE email = ?
   ├─ Compare password hash (constant-time comparison)
   ├─ Generate JWT token (valid 1 hour)
   ├─ Issue refresh token (valid 30 days)
   ├─ Store refresh token in Redis
   └─ Return tokens to client
```

### Product Search & Browse

```
1. Product Search
   ┌─ User enters search term "blue shirt"
   ├─ Browser sends GET /api/search?q=blue+shirt&limit=20
   ├─ Request hits CloudFront (check cache)
   ├─ CloudFront cache miss, routes to API Gateway
   ├─ API Gateway forwards to Search Service
   ├─ Search Service queries Elasticsearch
   │  └─ Query: match("*", "blue shirt") + filters
   │  └─ Return 20 results with relevance scoring
   ├─ Elasticsearch returns top 20 products
   ├─ Search Service enriches response
   │  └─ Add current prices from Redis cache
   │  └─ Add inventory status
   ├─ Response cached in CloudFront (5 min TTL)
   ├─ API Gateway returns to client
   └─ Browser renders results

Data Synchronization:
┌─ Product Service updates product (name, description)
├─ Publishes ProductUpdatedEvent to Kafka
├─ Search Service consumes event
├─ Updates Elasticsearch index
│  └─ Latency: <1 second for search to reflect change
└─ Cache invalidated in CloudFront
```

### Checkout & Payment

```
1. Order Creation
   ┌─ User submits order with cart items
   ├─ API: POST /api/orders with auth token
   ├─ Order Service receives request
   ├─ Validate cart items (product exists, prices current)
   ├─ Reserve inventory from Inventory Service
   │  └─ Saga pattern: if inventory unavailable, fail
   ├─ Create Order record (status: pending)
   ├─ Publish OrderCreatedEvent
   │  ├─ Payment Service: Charge payment method
   │  ├─ Shipping Service: Calculate shipping cost
   │  ├─ Notification Service: Send confirmation email
   │  └─ Analytics Service: Log purchase event
   ├─ Wait for PaymentChargedEvent (async)
   ├─ Update Order status to confirmed
   ├─ Publish OrderConfirmedEvent
   │  └─ Inventory Service: Commit reservation
   │  └─ Fulfillment Service: Begin picking
   └─ Return order details to client

2. Payment Processing
   ┌─ Payment Service receives OrderCreatedEvent
   ├─ Validate payment method
   ├─ Call payment gateway (Stripe/PayPal/etc)
   │  └─ Charge customer's card
   │  └─ Handle 3D Secure authentication
   │  └─ Retry on failure (3 attempts)
   ├─ Record transaction in database
   ├─ Publish PaymentChargedEvent (or PaymentFailedEvent)
   ├─ If failed: Publish OrderFailedEvent
   │  └─ Order Service compensates (mark failed)
   │  └─ Inventory Service compensates (release reservation)
   └─ If succeeded: Order proceeds to fulfillment
```

---

## Deployment Architecture

### Multi-Region Deployment

```
Global Traffic Routing:
┌──────────────────────────────────────┐
│   Route 53 (DNS)                     │
│   - Geo-routing (nearest region)     │
│   - Health check based routing       │
│   - Latency based routing            │
└──────┬──────────────────────────────┘
       │
   ┌───┴─────────────────┬──────────────┐
   │                     │              │
US-EAST-1 Region    EU-WEST-1 Region  AP-SOUTHEAST-1
├─ ALB                ├─ ALB           ├─ ALB
├─ EKS Cluster        ├─ EKS Cluster   ├─ EKS Cluster
│  ├─ 50 pods         │  ├─ 30 pods    │  ├─ 20 pods
│  └─ 10 nodes        │  └─ 6 nodes    │  └─ 4 nodes
├─ RDS Primary        ├─ RDS Replica   ├─ RDS Replica
│  └─ PostgreSQL      │  └─ Read       │  └─ Read
├─ Kafka cluster      ├─ Kafka replica ├─ Local cache
├─ Redis cluster      ├─ Redis replica └─ Local queue
├─ Elasticsearch      ├─ Elasticsearch
└─ S3 buckets         └─ S3 buckets

Data Replication:
- PostgreSQL primary (US-EAST-1) → read replicas (other regions)
- Synchronous replication <1 sec latency
- Cross-region failover automated via Route 53 health checks
- DynamoDB global tables for session/cache data

Cache Distribution:
- CloudFront origin: Primary US-EAST-1
- Edge locations: 200+ global locations
- Static assets cached 24 hours
- API responses cached 5 minutes (by region)
```

### Kubernetes Deployment

```
Kubernetes Cluster Architecture:

Node Groups (EC2 Auto Scaling):
├─ Production-optimized (t3.xlarge)
│  ├─ 10-30 nodes depending on load
│  ├─ Auto-scale based on CPU/memory
│  ├─ Spot instances for non-critical workloads (50% cost)
│  └─ On-demand for critical services
├─ Memory-optimized (r5.2xlarge)
│  ├─ 2-5 nodes for caching tier
│  └─ High-memory services (analytics, ML)
└─ Compute-optimized (c5.2xlarge)
   ├─ 1-3 nodes for batch processing
   └─ Real-time processing (Kafka consumers)

Service Deployment:
├─ API Gateway: 5 replicas (always-on)
├─ Auth Service: 3 replicas (critical)
├─ Product Service: 3-10 replicas (scales with traffic)
├─ Search Service: 3-5 replicas (scales with traffic)
├─ Order Service: 5-15 replicas (scales with traffic)
├─ Payment Service: 3-5 replicas (critical)
├─ Inventory Service: 5-10 replicas
├─ Notification Service: 3-5 replicas (non-critical)
├─ Analytics Service: 2-3 replicas (async, batch)
└─ Supporting services: As needed

Persistent Workloads:
├─ Prometheus: 1 replica (metrics)
├─ Elasticsearch: 3-5 data nodes (redundancy)
├─ Kafka: 3-5 brokers (message replication)
├─ Redis: 3 nodes (cluster mode)
└─ Databases: External (RDS for managed service)
```

---

## Performance Optimization

### Caching Strategy

```
Layer 1: Browser Cache
├─ Static assets: 1 day (CSS, JS, images)
├─ HTML pages: 5 minutes
└─ API responses: 5 minutes (GET requests only)

Layer 2: CDN (CloudFront)
├─ Images: 24 hours
├─ CSS/JS: 7 days
├─ HTML: 5 minutes
├─ API responses (product data): 10 minutes
└─ Gzip compression enabled

Layer 3: API Response Cache (API Gateway)
├─ GET /products: 5 min cache
├─ GET /search: 1 min cache
├─ GET /product/{id}: 10 min cache
├─ POST/PUT: No cache (always fresh)
└─ Cache key includes user permissions (per-user caching)

Layer 4: Application Cache (Redis)
├─ User profiles: 30 min TTL
├─ Product catalog: 1 hour TTL
├─ Category data: 24 hours TTL
├─ Session data: 30 day TTL
├─ Cart items: 30 days TTL
├─ Shopping recommendations: 24 hours TTL
└─ Cache warming: Pre-load hot data at startup

Layer 5: Database Query Cache
├─ Query result caching (app level)
├─ Materialized views for reports
├─ Read replicas for reporting queries
└─ No server-side query cache (use app layer)

Cache Invalidation:
├─ TTL-based: Automatic expiration
├─ Event-based: Product updated → invalidate product caches
├─ Manual: Admin action triggers cache clear
├─ Queue-based: Batch updates invalidate in batches
└─ Strategy: Invalidate broadly, validate on miss
```

### Database Performance

```
Schema Optimization:

products table:
├─ Columns: id, name, description, category_id, created_at
├─ Indexes:
│  ├─ PRIMARY KEY (id)
│  ├─ INDEX (category_id) - for filtering
│  └─ FULLTEXT INDEX (name, description) - for search
└─ Size: 100M rows, 50GB

orders table:
├─ Columns: id, customer_id, created_at, status, total
├─ Indexes:
│  ├─ PRIMARY KEY (id)
│  ├─ INDEX (customer_id, created_at) - for customer order history
│  ├─ INDEX (status, created_at) - for order processing
│  └─ INDEX (created_at) - for time-range queries
└─ Size: 500M rows, 200GB

Partitioning Strategy:
├─ orders table: Partition by date (month)
│  └─ Each month 40M orders → each partition 8GB
│  └─ Queries on recent orders very fast
│  └─ Archive old partitions to separate storage
└─ analytics table: Partition by week

Query Optimization:
├─ SELECT * → SELECT specific columns needed
├─ Avoid correlated subqueries → use JOIN
├─ Use prepared statements → prevent SQL injection
├─ EXPLAIN ANALYZE → understand query plans
├─ Index on WHERE clauses → speed up filtering
├─ Covering indexes → avoid table lookups
└─ Statistics maintained → accurate query optimizer

Connection Pooling:
├─ Each service maintains pool of 10-50 connections
├─ Total pool size: 500-1000 connections max
├─ Timeout on idle connections (15 min)
├─ Connection health checks (ping)
└─ Connection reuse across requests
```

### Search Performance

```
Elasticsearch Optimization:

Index Configuration:
├─ products index
│  ├─ Shards: 10 (parallelism)
│  ├─ Replicas: 2 (availability + read scaling)
│  ├─ Refresh interval: 1 second
│  ├─ Mapping: Define field types
│  │  ├─ name: text (full-text search)
│  │  ├─ category: keyword (exact match)
│  │  ├─ price: scaled_float (numeric range)
│  │  └─ created_at: date
│  └─ Size: 50GB (10B documents)

Search Queries:
├─ Simple text search: 100ms (10k results/sec)
├─ Complex faceted search: 200ms (5k results/sec)
├─ Auto-complete: 50ms (100k suggestions/sec)
└─ Aggregations (analytics): 1-5 sec (per-category stats)

Index Updates:
├─ Bulk indexing: 100k docs/sec (batch inserts)
├─ Incremental updates: 10k docs/sec (real-time)
├─ Full re-index: 2-4 hours (all 10B documents)
└─ Zero-downtime indexing: Alias switching

Query Performance:
├─ Use query filters (not filters in aggregations)
├─ Avoid wildcard queries at start (*blue)
├─ Use bool query for complex logic
├─ Cache aggregations (rarely change)
└─ Pagination: Use search_after (not from/size)
```

---

## Security & Compliance

```
PCI-DSS Compliance (Credit Card Processing):
├─ No card data stored in application
├─ Use payment tokenization (Stripe, PayPal)
├─ PCI-compliant gateway handles processing
├─ TLS 1.2+ for all card data transmission
├─ No card data in logs/backups
├─ Quarterly security assessments
├─ Vulnerability scanning
└─ Incident response plan

GDPR Compliance (EU User Data):
├─ User consent required for marketing
├─ Right to access (export data)
├─ Right to deletion (30-day window)
├─ Right to rectification (update data)
├─ Data portability (export in standard format)
├─ Privacy by design (encrypt PII)
└─ Data processing agreements with vendors

Security Measures:
├─ Authentication: OAuth 2.0 + JWT
├─ Encryption at rest: AES-256
├─ Encryption in transit: TLS 1.2+
├─ API keys: Rotate monthly
├─ Secrets management: AWS Secrets Manager
├─ Access control: RBAC (admin, support, read-only)
├─ Audit logging: All changes logged
├─ Rate limiting: 100 req/sec per API key
└─ DDoS protection: CloudFlare, AWS Shield
```

---

## Operations & Monitoring

### Health Checks & Alerts

```
Alerting Rules:

Service Health:
- Error rate > 1% for 5 minutes → Page on-call
- Latency P95 > 500ms for 10 minutes → Alert Slack
- Service unavailable > 1 minute → Page immediately
- Database connection pool > 90% → Alert team

Data Pipeline:
- Kafka consumer lag > 10k messages → Alert
- Database replication lag > 5 seconds → Alert
- Search index lag > 1 minute → Alert

Business Metrics:
- Conversion drop > 10% → Alert manager
- Revenue drop > 20% → Page executive on-call
- Cart abandonment spike → Alert marketing
- Refund rate > 5% → Investigate

Infrastructure:
- Node CPU > 80% for 10 min → Auto-scale up
- Memory usage > 90% → Alert
- Disk space < 10% → Emergency alert
- Network latency > 100ms → Investigate
```

### Runbooks

```
Incident: Search Service Down

Diagnosis (2 min):
- Check Elasticsearch cluster health
- Check node status
- Review recent deployments
- Check disk space

Resolution (5 min):
Option A: Restart service
  kubectl rollout restart deployment/search-service
  
Option B: Scale down (reduce load)
  kubectl scale deployment/search-service --replicas=1
  
Option C: Rollback
  git revert [bad commit]
  ArgoCD syncs automatically

Validation (5 min):
- Test search endpoint
- Monitor latency
- Check error rate
- Verify results quality
```

---

## Related Resources

- [Microservices Platform Reference Architecture](./microservices-platform.md)
- [API Design Guide](../playbooks/api-design-guide.md)
- [Performance Guide](../playbooks/performance-guide.md)
- [Security Guide](../playbooks/security-guide.md)
- [Data Architecture Template](../templates/data-architecture-template.md)
- [Architecture Review Process](../processes/arb/README.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
