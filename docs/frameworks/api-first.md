# API-First Development

## Overview

API-First is a development strategy where APIs are treated as "first-class citizens" and designed before implementation begins. The API becomes the contract that drives the development process, ensuring consistency, reusability, and excellent developer experience.

## Core Principles

### 1. Design Before Code

**Approach:**
- Design API contract first (OpenAPI, GraphQL schema)
- Review and iterate on design
- Get stakeholder agreement
- Then implement

**Benefits:**
- Early feedback
- Parallel development
- Clear contracts
- Reduced rework

### 2. API as a Product

Treat APIs as products with:
- **Users** - Developers consuming the API
- **Value Proposition** - Solves specific problems
- **User Experience** - Developer experience (DX)
- **Documentation** - Comprehensive guides
- **Support** - Developer assistance
- **Versioning** - Backward compatibility

### 3. Contract-Driven Development

**The Contract:**
```yaml
# OpenAPI 3.0 Example
openapi: 3.0.0
info:
  title: Orders API
  version: 1.0.0
paths:
  /orders:
    post:
      summary: Create new order
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Order'
      responses:
        '201':
          description: Order created
```

**Contract Benefits:**
- Single source of truth
- Automated validation
- Mock server generation
- Client SDK generation
- Documentation generation

### 4. Developer Experience First

**DX Priorities:**
- Intuitive API design
- Comprehensive documentation
- Interactive exploration (Swagger UI)
- Quick start guides
- Code samples
- SDKs in popular languages

## API Design Process

### Phase 1: Discovery

**Activities:**
1. Identify use cases
2. Define user stories
3. Document requirements
4. Research existing patterns
5. Analyze similar APIs

**Deliverables:**
- Use case documentation
- API requirements document
- Stakeholder list

### Phase 2: Design

**Activities:**
1. Design resources and operations
2. Define data models
3. Design error handling
4. Plan versioning strategy
5. Create OpenAPI specification

**Design Considerations:**
- RESTful principles
- Resource naming
- HTTP methods
- Status codes
- Pagination
- Filtering & sorting
- Authentication & authorization

**Example REST API Design:**
```
Resources:
  /customers              - Collection
  /customers/{id}         - Individual resource
  /customers/{id}/orders  - Sub-collection
  
Operations:
  GET /customers          - List customers
  POST /customers         - Create customer
  GET /customers/{id}     - Get customer
  PUT /customers/{id}     - Update customer
  DELETE /customers/{id}  - Delete customer
```

### Phase 3: Validate

**Activities:**
1. Create mock server
2. Build prototype client
3. Conduct design reviews
4. Gather developer feedback
5. Iterate on design

**Tools:**
- Prism (OpenAPI mock server)
- Postman mock servers
- SwaggerHub mocking
- API Blueprint mocking

### Phase 4: Implement

**Activities:**
1. Generate server stubs
2. Implement business logic
3. Add validation
4. Implement security
5. Add monitoring

**Code Generation:**
```bash
# Generate server (Node.js/Express)
openapi-generator generate \
  -i openapi.yaml \
  -g nodejs-express-server \
  -o ./server

# Generate client (TypeScript)
openapi-generator generate \
  -i openapi.yaml \
  -g typescript-axios \
  -o ./client
```

### Phase 5: Test

**Testing Layers:**
1. **Contract Testing** - Validate against spec
2. **Integration Testing** - End-to-end flows
3. **Performance Testing** - Load and stress
4. **Security Testing** - Vulnerability scanning

**Tools:**
- Dredd (contract testing)
- Pact (consumer-driven contracts)
- Postman/Newman (integration testing)
- JMeter/k6 (performance testing)

### Phase 6: Document & Publish

**Documentation:**
- Auto-generated from OpenAPI
- Interactive API explorer
- Getting started guide
- Use case tutorials
- Code examples
- Migration guides

**Publishing:**
- Developer portal
- API catalog
- Versioned documentation
- Changelog

## API Design Patterns

### RESTful API Design

**Resource-Oriented:**
```
GET    /orders           - List orders
POST   /orders           - Create order
GET    /orders/{id}      - Get order
PUT    /orders/{id}      - Update order
DELETE /orders/{id}      - Delete order
PATCH  /orders/{id}      - Partial update
```

**Best Practices:**
- Use nouns for resources (not verbs)
- Use plural names for collections
- Use HTTP methods correctly
- Return appropriate status codes
- Use HATEOAS for discoverability

### GraphQL API Design

**Schema-First:**
```graphql
type Query {
  orders(status: OrderStatus, limit: Int): [Order!]!
  order(id: ID!): Order
}

type Mutation {
  createOrder(input: CreateOrderInput!): Order!
  updateOrder(id: ID!, input: UpdateOrderInput!): Order!
}

type Order {
  id: ID!
  customer: Customer!
  items: [OrderItem!]!
  total: Money!
  status: OrderStatus!
}
```

**Benefits:**
- Type safety
- No over/under-fetching
- Single endpoint
- Introspection
- Strong tooling

### gRPC API Design

**Protocol Buffers:**
```protobuf
service OrderService {
  rpc CreateOrder (CreateOrderRequest) returns (Order);
  rpc GetOrder (GetOrderRequest) returns (Order);
  rpc ListOrders (ListOrdersRequest) returns (ListOrdersResponse);
}

message Order {
  string id = 1;
  string customer_id = 2;
  repeated OrderItem items = 3;
  OrderStatus status = 4;
}
```

**Use Cases:**
- Microservice communication
- High-performance requirements
- Streaming (bidirectional)
- Multi-language environments

### Webhook Design

**Event-Driven APIs:**
```json
{
  "event": "order.created",
  "timestamp": "2025-11-12T10:30:00Z",
  "data": {
    "orderId": "123",
    "customerId": "456"
  }
}
```

**Considerations:**
- Retry logic
- Idempotency
- Security (signatures)
- Delivery guarantees

## API Specification Standards

### OpenAPI (Swagger)

**Current Version:** 3.1

**Structure:**
```yaml
openapi: 3.1.0
info:           # API metadata
paths:          # Endpoints
components:     # Reusable components
  schemas:      # Data models
  responses:    # Responses
  parameters:   # Parameters
  securitySchemes: # Authentication
security:       # Security requirements
tags:           # Grouping
```

**Tools:**
- Swagger Editor
- Swagger UI
- SwaggerHub
- Redoc
- Stoplight

### AsyncAPI

**For Event-Driven APIs:**
```yaml
asyncapi: 2.6.0
channels:
  order/created:
    publish:
      message:
        payload:
          type: object
          properties:
            orderId: string
            customerId: string
```

### GraphQL Schema Definition Language (SDL)

**Type System:**
```graphql
schema {
  query: Query
  mutation: Mutation
  subscription: Subscription
}
```

### Protocol Buffers (gRPC)

**Language-Neutral:**
```protobuf
syntax = "proto3";
package orders.v1;
```

## Versioning Strategies

### URI Versioning

```
/v1/orders
/v2/orders
```

**Pros:** Clear, simple
**Cons:** Multiple endpoints

### Header Versioning

```
Accept: application/vnd.company.api+json; version=1
```

**Pros:** Clean URIs
**Cons:** Not visible in browser

### Query Parameter Versioning

```
/orders?version=1
```

**Pros:** Easy to implement
**Cons:** Pollutes query string

### Semantic Versioning

**Format:** MAJOR.MINOR.PATCH

- **MAJOR** - Breaking changes
- **MINOR** - New features (backward compatible)
- **PATCH** - Bug fixes

**API Lifecycle:**
1. **Active** - Current supported version
2. **Deprecated** - Still works, plan migration
3. **Retired** - No longer available

## API Security

### Authentication

**Methods:**
- **API Keys** - Simple, not for user auth
- **OAuth 2.0** - Delegated authorization
- **JWT** - Stateless tokens
- **Basic Auth** - Simple, use with TLS only

**OpenAPI Security Scheme:**
```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
security:
  - bearerAuth: []
```

### Authorization

**Approaches:**
- **RBAC** - Role-based access control
- **ABAC** - Attribute-based access control
- **Scopes** - OAuth 2.0 scopes

### API Security Best Practices

1. **Always use HTTPS**
2. **Validate all inputs**
3. **Rate limiting**
4. **CORS configuration**
5. **API key rotation**
6. **Audit logging**
7. **DDoS protection**
8. **OWASP API Security Top 10**

## API Governance

### Design Standards

**Establish Guidelines:**
- Naming conventions
- Error format
- Pagination approach
- Filtering syntax
- Date/time formats
- Status codes usage

**Example Standards:**
```yaml
# Error Format
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "Invalid customer ID",
    "details": [...]
  }
}

# Pagination
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 100
  }
}
```

### API Review Process

**Review Checklist:**
- [ ] Follows design standards
- [ ] Proper HTTP method usage
- [ ] Appropriate status codes
- [ ] Consistent naming
- [ ] Complete documentation
- [ ] Security implemented
- [ ] Versioning strategy
- [ ] Error handling
- [ ] Performance considered
- [ ] Breaking change review

### API Catalog

**Centralized Registry:**
- All APIs listed
- Ownership information
- Status (active/deprecated/retired)
- Documentation links
- OpenAPI specs
- Dependency mapping

## Developer Experience

### Interactive Documentation

**Tools:**
- Swagger UI - Try API in browser
- Redoc - Beautiful documentation
- Stoplight - Complete platform
- Postman - API client

### Code Samples

**Multiple Languages:**
```bash
# cURL
curl -X POST https://api.example.com/orders \
  -H "Authorization: Bearer token" \
  -d '{"customerId": "123"}'

# JavaScript
const response = await fetch('https://api.example.com/orders', {
  method: 'POST',
  headers: { 'Authorization': 'Bearer token' },
  body: JSON.stringify({ customerId: '123' })
});

# Python
response = requests.post(
  'https://api.example.com/orders',
  headers={'Authorization': 'Bearer token'},
  json={'customerId': '123'}
)
```

### SDK Generation

**Auto-Generated Clients:**
- TypeScript/JavaScript
- Python
- Java
- C#
- Go
- Ruby
- PHP

### Developer Portal

**Components:**
- Getting started guide
- API reference
- Tutorials
- Code samples
- Sandbox environment
- Support resources
- API key management
- Usage analytics

## Monitoring & Analytics

### API Metrics

**Track:**
- Request rate
- Response time (p50, p95, p99)
- Error rate
- Endpoint popularity
- Client versions
- Geographic distribution

### Observability

**Components:**
- Logging - Structured logs
- Metrics - Time-series data
- Tracing - Request flow
- Alerting - Proactive monitoring

**Tools:**
- Datadog
- New Relic
- Prometheus + Grafana
- ELK Stack
- AWS CloudWatch
- Azure Monitor

## Testing Strategies

### Contract Testing

**Validate Specification:**
```javascript
// Using Dredd
const hooks = require('hooks');

hooks.before('Orders > Create Order', (transaction) => {
  transaction.request.headers.Authorization = 'Bearer test-token';
});
```

### Consumer-Driven Contracts

**Pact Example:**
```javascript
// Consumer test
const provider = new Pact({...});

await provider.addInteraction({
  state: 'order exists',
  uponReceiving: 'a request for order',
  withRequest: {
    method: 'GET',
    path: '/orders/123'
  },
  willRespondWith: {
    status: 200,
    body: { id: '123', status: 'pending' }
  }
});
```

### Performance Testing

**Load Testing:**
```javascript
// k6 example
import http from 'k6/http';

export default function() {
  http.post('https://api.example.com/orders',
    JSON.stringify({ customerId: '123' }),
    { headers: { 'Content-Type': 'application/json' } }
  );
}
```

## Tools & Platforms

### Design & Documentation
- **Stoplight Studio** - API design platform
- **SwaggerHub** - OpenAPI design & documentation
- **Postman** - API development environment
- **Insomnia** - API client and design

### Mocking & Testing
- **Prism** - OpenAPI mock server
- **WireMock** - HTTP mock server
- **Pact** - Contract testing
- **Dredd** - API testing framework

### API Management
- **Kong** - API gateway
- **Apigee** - Full API management
- **AWS API Gateway** - Managed gateway
- **Azure API Management** - Enterprise APIM
- **MuleSoft** - Integration platform

### Code Generation
- **OpenAPI Generator** - Multi-language generation
- **Swagger Codegen** - Client/server generation
- **GraphQL Code Generator** - GraphQL tooling

## Best Practices

### Design Guidelines

✅ **Use Nouns for Resources** - `/orders` not `/getOrders`  
✅ **Be Consistent** - Same patterns across APIs  
✅ **Use HTTP Correctly** - Right methods and status codes  
✅ **Version from Start** - Plan for evolution  
✅ **Document Everything** - Comprehensive docs  
✅ **Think Long-Term** - Design for change  
✅ **Prioritize DX** - Easy to understand and use

### Common Pitfalls

❌ **No Versioning** - Breaking changes without plan  
❌ **Inconsistent Naming** - Different patterns  
❌ **Poor Error Messages** - Generic errors  
❌ **Missing Documentation** - Incomplete or outdated  
❌ **Over-Engineering** - Too complex initially  
❌ **Ignoring Standards** - Reinventing wheels  
❌ **No Governance** - Inconsistent APIs across org

## Migration to API-First

### Step 1: Assessment
- Inventory existing APIs
- Identify gaps in documentation
- Review consistency
- Assess tooling

### Step 2: Standards Definition
- Design guidelines
- Naming conventions
- Error handling patterns
- Versioning strategy

### Step 3: Tooling Setup
- API design platform
- Mock servers
- Documentation portal
- Testing frameworks

### Step 4: Pilot Project
- Select new API
- Follow API-first process
- Gather learnings
- Refine approach

### Step 5: Scale
- Train teams
- Establish governance
- Retrofit existing APIs
- Build API catalog

## Related Resources

- [RESTful API Design Guide](../knowledge-base/playbooks/api-design-playbook.md)
- [Microservices Architecture](./microservices.md)
- [API Security Patterns](../knowledge-base/patterns/security-patterns.md)
- [Integration Patterns](../knowledge-base/patterns/integration-patterns.md)

## References

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [GraphQL Specification](https://spec.graphql.org/)
- [REST API Design Rulebook](https://www.oreilly.com/library/view/rest-api-design/9781449317904/)
- [API Design Patterns](https://www.manning.com/books/api-design-patterns)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Google API Design Guide](https://cloud.google.com/apis/design)

---

**Last Updated:** November 2025  
**Related:** [Microservices](./microservices.md) | [Integration Patterns](../knowledge-base/patterns/integration-patterns.md) | [API Playbook](../knowledge-base/playbooks/api-design-playbook.md)
