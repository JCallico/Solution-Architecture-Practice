# API-First Design Principle

## Overview

**Principle**: Design and build APIs before implementing the underlying services.

APIs are contracts that enable integration, reuse, and scalability. Designing the API contract first ensures clean interfaces and enables parallel development of consumers and providers.

## Rationale

- APIs are how systems communicate and integrate
- Good API design prevents breaking changes
- Versioning strategy is critical to evolution
- Consistency across APIs improves developer experience
- API-first enables contract-driven development
- Clear contracts reduce coordination overhead

## Core Implications

### 1. Design API Contracts First
Define the API before implementing the backend:

**API-First Process:**
```
1. Define API Specification (OpenAPI/AsyncAPI)
   ↓
2. Validate with consumers
   ↓
3. Generate documentation, mocks, tests
   ↓
4. Develop backend implementation
   ↓
5. Develop consumer integrations (in parallel)
   ↓
6. Test and iterate
```

**Benefits:**
- Consumers don't block waiting for implementation
- API issues discovered early (easier to fix)
- Both sides can develop and test in parallel
- Clear contract prevents misunderstandings
- Easier to change implementation without affecting API

### 2. Consistent API Design Standards
All APIs follow the same patterns:

**REST API Standards Example:**

```
Resource Naming:
- Use nouns, not verbs
- ✅ /orders, /customers, /products
- ❌ /getOrders, /createCustomer

HTTP Methods:
- GET:    Retrieve resource(s)
- POST:   Create new resource
- PUT:    Replace entire resource
- PATCH:  Modify parts of resource
- DELETE: Remove resource

URL Patterns:
- GET    /orders           → List all orders
- POST   /orders           → Create new order
- GET    /orders/{id}      → Get specific order
- PUT    /orders/{id}      → Replace order
- PATCH  /orders/{id}      → Update order partially
- DELETE /orders/{id}      → Delete order

Filtering/Sorting:
- GET /orders?status=pending&limit=10&offset=20&sort=created_at

Response Format:
{
  "status": "success|error",
  "data": { ... },
  "errors": [ ... ],
  "pagination": {
    "total": 100,
    "limit": 10,
    "offset": 20
  }
}

Error Handling:
- Use standard HTTP status codes
- 400: Bad request (client error)
- 401: Unauthorized (auth required)
- 403: Forbidden (auth denied)
- 404: Not found
- 429: Too many requests (rate limited)
- 500: Server error (internal issue)
```

### 3. Versioning Strategy
Plan for API evolution:

**Versioning Approaches:**

1. **URL Versioning** (Most common)
   ```
   /api/v1/orders
   /api/v2/orders
   
   Pros: Clear version in URL
   Cons: Requires maintaining multiple versions
   ```

2. **Header Versioning**
   ```
   GET /api/orders
   Accept: application/vnd.myapi.v1+json
   
   Pros: Cleaner URLs
   Cons: Versions not obvious in URL
   ```

3. **Query Parameter Versioning**
   ```
   GET /api/orders?version=2
   
   Pros: Simple to test
   Cons: Less standard
   ```

**Versioning Strategy:**

```
Release v1 (Now)
├─ New customers use v1
├─ Support period: 2 years
└─ Deprecation warning after 18 months

Release v2 (Month 6)
├─ Significant improvements
├─ New customers use v2
├─ Existing v1 customers encouraged to migrate
├─ v1 still supported

Release v3 (Month 12)
├─ v1 reaches end of support
├─ v2 is current version
├─ v1 turned off (migration required)
```

**Backwards Compatibility:**
- Add new fields in responses (old clients ignore them)
- Don't remove fields (deprecate instead)
- Don't change field types
- New endpoints for different behavior
- Deprecation period before removal (minimum 6 months)

### 4. API Documentation
Documentation is critical for adoption:

**OpenAPI/Swagger Specification:**

```yaml
openapi: 3.0.0
info:
  title: Order API
  version: 1.0.0
  description: |
    API for managing orders.
    
    # Getting Started
    1. Obtain API key from dashboard
    2. Include in Authorization header
    3. Make requests to endpoints below

servers:
  - url: https://api.example.com/v1

paths:
  /orders:
    get:
      summary: List orders
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [pending, processing, completed]
      responses:
        '200':
          description: Orders list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Order'
        '401':
          description: Unauthorized

    post:
      summary: Create order
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OrderCreate'
      responses:
        '201':
          description: Order created
        '400':
          description: Invalid request

components:
  schemas:
    Order:
      type: object
      properties:
        id:
          type: integer
          description: Unique order ID
        status:
          type: string
          enum: [pending, processing, completed]
        total:
          type: number
          format: double
```

## Implementation Practices

### API Design Review Checklist

Before publishing API:

- [ ] Resource naming follows standards (nouns, plural)
- [ ] HTTP methods used correctly
- [ ] Status codes appropriate
- [ ] Error responses well-documented
- [ ] Pagination implemented (if applicable)
- [ ] Filtering/sorting supported (if applicable)
- [ ] Rate limiting defined
- [ ] Authentication/authorization clear
- [ ] OpenAPI spec complete and accurate
- [ ] Documentation examples provided
- [ ] Backwards compatibility considered
- [ ] Versioning strategy defined
- [ ] Change log maintained
- [ ] Deprecation policy documented

### SDK/Client Library Generation

Automatically generate SDKs from OpenAPI spec:

```
OpenAPI Specification
        ↓
Code Generators (OpenAPI Generator)
        ↓
SDKs for multiple languages:
├─ Python SDK
├─ JavaScript SDK
├─ Java SDK
├─ Go SDK
└─ C# SDK

Benefits:
- No manual SDK maintenance
- Always consistent with API
- Developers get auto-complete/IDE support
- Type safety (in typed languages)
```

### Pagination Standards

```
Request:
GET /orders?limit=10&offset=20

Response:
{
  "data": [ ... ],
  "pagination": {
    "total": 1500,
    "limit": 10,
    "offset": 20,
    "has_more": true,
    "next_offset": 30,
    "prev_offset": 10
  }
}

Alternative (Cursor-based):
GET /orders?limit=10&cursor=abc123

Response:
{
  "data": [ ... ],
  "pagination": {
    "has_more": true,
    "next_cursor": "xyz789"
  }
}

Cursor-based benefits:
- Efficient for large datasets
- Handles additions/deletions during pagination
- Can't skip to middle
```

### Rate Limiting

```
Rate Limit Headers:
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1234567890

Rate Limit Exceeded Response:
HTTP 429 Too Many Requests
Retry-After: 60

{
  "error": "rate_limit_exceeded",
  "message": "API rate limit exceeded",
  "retry_after": 60
}
```

## Common Scenarios

### Scenario 1: Backwards Incompatible Change
**Situation:** Need to change API response format.

**Approach:**
1. Create v2 endpoint with new format
2. Deprecate v1 (6-month notice)
3. Keep v1 running during deprecation period
4. Customers migrate to v2
5. Shut down v1 after deprecation period

### Scenario 2: New Field Addition
**Situation:** Need to add new field to response.

**Approach:**
1. Add field to v1 response
2. Old clients ignore new field (no change needed)
3. New clients can use new field
4. No version bump needed

### Scenario 3: Internal Service API
**Situation:** API only used by internal services.

**Approach:**
- Still use OpenAPI specification
- Still design carefully
- Versioning less strict than public APIs
- Can change faster but still communicate with consumers

## Risks of Ignoring This Principle

❌ **Breaking Changes:** Consumers break when API changes
❌ **Integration Delays:** Unclear contracts cause delays
❌ **Inconsistency:** Different APIs follow different patterns
❌ **Poor Developer Experience:** Hard to use inconsistent APIs
❌ **Maintenance Burden:** Poorly designed APIs require constant fixing

## Best Practices

✅ **Use OpenAPI/AsyncAPI specifications**
Standard format for API design and documentation.

✅ **Design for backwards compatibility**
Make additions easy; make removal/change hard.

✅ **Deprecate before removing**
Give consumers 6+ months notice before removing API versions.

✅ **Document with examples**
Show real-world usage examples in documentation.

✅ **Provide SDKs/client libraries**
Generated from OpenAPI spec.

✅ **Version APIs explicitly**
Make versions clear in URL or headers.

✅ **Test API design with consumers**
Get feedback from actual users before launch.

✅ **Monitor API usage**
Understand how APIs are actually used; it informs future design.

## Related Principles

- **[Modularity and Loose Coupling](./modularity-and-loose-coupling.md)** - APIs enable modularity
- **[Reuse and Standardization](./reuse-and-standardization.md)** - Standard API design across organization
- **[Customer-Centric Design](./customer-centric-design.md)** - APIs are products; design for users

## References

- OpenAPI Specification (swagger.io)
- AsyncAPI Specification (asyncapi.io)
- RESTful API Best Practices (Microsoft REST API Guidelines)
- _The Design of Web APIs_ (Arnaud Lauret)

---

**Last Updated:** November 2025
**Principle Category:** Design
**Applies To:** All services exposing APIs or integrating with other services
**Related Documents:** [API Standards](../../knowledge-base/standards/api-standards.md), [API Design Guide](../../knowledge-base/guides/api-design.md)
