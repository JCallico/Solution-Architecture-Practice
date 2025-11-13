# API Design Guide

## Overview

Comprehensive guide for designing and building robust, scalable, and maintainable APIs. This playbook covers API design principles, multiple API paradigms, documentation standards, security considerations, and implementation best practices.

---

## Part 1: API Design Principles

### 1.1 Core Principles

**Consistency**: Maintain consistent patterns across all APIs
- Naming conventions (camelCase, snake_case)
- Response structures
- Error formats
- Status codes

**Simplicity**: Design intuitive APIs that are easy to understand and use
- Clear resource naming
- Predictable behaviors
- Logical hierarchies
- Minimal learning curve

**Scalability**: Build APIs that can handle growth
- Pagination for large datasets
- Rate limiting for fair use
- Caching strategies
- Stateless design

**Versioning Strategy**: Plan for API evolution
- Semantic versioning (v1, v2, v3)
- Backwards compatibility
- Deprecation timelines
- Migration paths

### 1.2 REST API Design

**Resource-Oriented Design**: Model APIs around resources, not actions

```
Good:
GET    /api/v1/users              # List users
POST   /api/v1/users              # Create user
GET    /api/v1/users/{id}         # Get user
PUT    /api/v1/users/{id}         # Update user
DELETE /api/v1/users/{id}         # Delete user

Avoid:
GET    /api/getUser               # RPC-style
POST   /api/createUser            # RPC-style
GET    /api/user/getUserById?id=1 # RPC-style
```

**HTTP Methods and Semantics**:
- **GET**: Retrieve data (safe, idempotent)
- **POST**: Create new resource (not idempotent)
- **PUT**: Replace entire resource (idempotent)
- **PATCH**: Partial update (idempotent with care)
- **DELETE**: Remove resource (idempotent)

**HTTP Status Codes**:
- **2xx Success**:
  - 200 OK: Request successful
  - 201 Created: Resource created
  - 204 No Content: Success, no response body
- **4xx Client Error**:
  - 400 Bad Request: Invalid input
  - 401 Unauthorized: Authentication required
  - 403 Forbidden: Authorized but denied
  - 404 Not Found: Resource doesn't exist
  - 409 Conflict: State conflict (duplicate, race condition)
  - 422 Unprocessable Entity: Validation failed
- **5xx Server Error**:
  - 500 Internal Server Error: Server error
  - 503 Service Unavailable: Maintenance/overload

**Response Format Consistency**:
```json
Success Response:
{
  "data": {...},
  "meta": {
    "timestamp": "2025-01-01T00:00:00Z",
    "request_id": "req-123"
  }
}

Error Response:
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "User input validation failed",
    "details": [
      {
        "field": "email",
        "issue": "Invalid email format"
      }
    ]
  },
  "meta": {
    "timestamp": "2025-01-01T00:00:00Z",
    "request_id": "req-123"
  }
}
```

### 1.3 GraphQL Design

**Query Language Advantages**:
- Clients request exactly what they need (no over/under-fetching)
- Single request for related data (solves N+1 problem)
- Strong typing and schema
- Excellent developer experience

**Schema Design Best Practices**:
```graphql
type User {
  id: ID!
  email: String!
  name: String!
  createdAt: DateTime!
  orders: [Order!]!
}

type Order {
  id: ID!
  userId: ID!
  items: [OrderItem!]!
  total: Float!
  status: OrderStatus!
}

enum OrderStatus {
  PENDING
  CONFIRMED
  SHIPPED
  DELIVERED
  CANCELLED
}

type Query {
  user(id: ID!): User
  users(limit: Int, offset: Int): [User!]!
  order(id: ID!): Order
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}
```

**When to Use GraphQL**:
- Complex data relationships
- Multiple client types (web, mobile, desktop)
- Rapid API iteration
- Strongly typed contracts needed

**When NOT to Use GraphQL**:
- Simple CRUD operations
- File uploads (problematic)
- Real-time events (use WebSockets/subscriptions instead)
- Simple public APIs

### 1.4 gRPC Design

**Protocol Buffers Benefits**:
- Binary format (smaller, faster)
- Strong schema
- Language-agnostic
- Excellent for microservices

**gRPC Service Definition**:
```protobuf
syntax = "proto3";

service UserService {
  rpc GetUser(GetUserRequest) returns (User);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
  rpc CreateUser(CreateUserRequest) returns (User);
  rpc UpdateUser(UpdateUserRequest) returns (User);
  rpc DeleteUser(DeleteUserRequest) returns (google.protobuf.Empty);
}

message GetUserRequest {
  string id = 1;
}

message User {
  string id = 1;
  string email = 2;
  string name = 3;
  google.protobuf.Timestamp created_at = 4;
}
```

**When to Use gRPC**:
- High-performance microservices
- Service-to-service communication
- Real-time bidirectional streaming
- Language-agnostic contracts needed

**When NOT to Use gRPC**:
- Public/external APIs (harder to test)
- Browser clients (HTTP/2 limitations)
- Simple APIs (complexity overhead)

---

## Part 2: API Documentation

### 2.1 OpenAPI/Swagger Specification

**Document all APIs in OpenAPI 3.0+ format**:
```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
  description: API for managing users

paths:
  /api/v1/users:
    get:
      summary: List all users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
        - name: offset
          in: query
          schema:
            type: integer
            default: 0
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'
    post:
      summary: Create new user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
        '400':
          description: Validation error
```

### 2.2 Documentation Standards

**Every endpoint must include**:
- Clear description of purpose
- All parameters with types and constraints
- Request body schema (if applicable)
- Response schema with all status codes
- Example requests and responses
- Error scenarios and handling
- Pagination details (if applicable)
- Rate limit information

**Code Examples in Multiple Languages**:
```bash
# cURL
curl -X GET "https://api.example.com/api/v1/users?limit=10" \
  -H "Authorization: Bearer token" \
  -H "Content-Type: application/json"

# Python
import requests
response = requests.get(
    "https://api.example.com/api/v1/users",
    params={"limit": 10},
    headers={"Authorization": "Bearer token"}
)

# JavaScript
fetch('https://api.example.com/api/v1/users?limit=10', {
  headers: {
    'Authorization': 'Bearer token',
    'Content-Type': 'application/json'
  }
})
```

### 2.3 Developer Portal

**Self-Service Documentation**:
- Interactive API explorer
- Sandbox/testing environment
- SDK generation
- Code samples and tutorials
- Authentication setup guides
- Rate limit documentation

**Tools**: Swagger UI, ReDoc, Postman, Developer.io

---

## Part 3: Security

### 3.1 Authentication

**OAuth 2.0 / OpenID Connect (Recommended)**:
```
1. User logs in via identity provider
2. Provider returns access token
3. Client includes token in Authorization header
4. API validates token and extracts user info
```

**API Key (For Service-to-Service)**:
```
X-API-Key: sk_live_1234567890
```

**JWT (JSON Web Token)**:
```json
Header: {
  "alg": "HS256",
  "typ": "JWT"
}

Payload: {
  "sub": "user_123",
  "email": "user@example.com",
  "exp": 1234567890,
  "iat": 1234567800
}

Signature: HMACSHA256(base64(header) + "." + base64(payload), secret)
```

**mTLS (Mutual TLS) for Service-to-Service**:
- Both client and server authenticate with certificates
- Highest security for internal communication

### 3.2 Authorization

**Role-Based Access Control (RBAC)**:
```
Token includes roles: ["user", "admin"]
API checks: user in ["admin"] → authorize
           user in ["user", "admin"] → authorize
           user not in ["admin"] → deny (403)
```

**Attribute-Based Access Control (ABAC)**:
```
User attributes: {
  "department": "engineering",
  "level": "senior",
  "team": "platform"
}

Policy: Allow if (department == "engineering" AND level >= "senior")
```

### 3.3 Rate Limiting

**Strategies**:
1. **Per User**: Limit per authenticated user ID
2. **Per IP**: Limit per client IP address
3. **Global**: Total API request limit
4. **Token Bucket**: Allow bursts within window

**Implementation**:
```
Rate limit: 100 requests per minute per user
Headers returned:
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1609459200

If exceeded:
HTTP 429 Too Many Requests
Retry-After: 60
```

### 3.4 API Key Management

**Best Practices**:
- Generate cryptographically secure keys
- Rotate keys regularly
- Never log full keys
- Support key expiration
- Allow per-key scopes/permissions
- Revoke compromised keys immediately

---

## Part 4: Implementation

### 4.1 Pagination

**Cursor-Based (Preferred for Performance)**:
```
GET /api/v1/users?limit=20&after=eyJpZCI6IDEyM30=

Response:
{
  "data": [...],
  "pagination": {
    "limit": 20,
    "has_more": true,
    "next_cursor": "eyJpZCI6IDE0M30="
  }
}
```

**Offset-Based (Simple but less efficient)**:
```
GET /api/v1/users?limit=20&offset=0

Response:
{
  "data": [...],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "total": 500,
    "has_more": true
  }
}
```

### 4.2 Filtering and Sorting

**Standard Query Parameters**:
```
GET /api/v1/users?
  name=john&              # Filter: name contains "john"
  status=active&          # Filter: status equals "active"
  created_after=2025-01-01&  # Filter: created after date
  sort=-created_at&       # Sort: by created_at descending
  limit=20

Filters:
- Exact match: ?status=active
- Range: ?age[gte]=18&age[lte]=65
- Multiple values: ?status=active,pending
- Date range: ?created[gte]=2025-01-01&created[lte]=2025-12-31
```

### 4.3 Error Handling

**Consistent Error Format**:
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "User with ID 999 does not exist",
    "status_code": 404,
    "request_id": "req-abcd-1234",
    "timestamp": "2025-01-01T00:00:00Z",
    "details": {
      "resource_type": "User",
      "resource_id": "999"
    }
  }
}
```

**Error Codes**:
- `INVALID_REQUEST`: Malformed request
- `VALIDATION_ERROR`: Input validation failed
- `AUTHENTICATION_REQUIRED`: Missing auth
- `INSUFFICIENT_PERMISSIONS`: Forbidden
- `RESOURCE_NOT_FOUND`: 404
- `CONFLICT`: State conflict
- `RATE_LIMITED`: Too many requests
- `INTERNAL_ERROR`: Server error

### 4.4 Caching Strategies

**HTTP Caching Headers**:
```
GET /api/v1/products/123

Response:
Cache-Control: public, max-age=3600  # Cache 1 hour
ETag: "123abc"                        # Version identifier
Last-Modified: Mon, 01 Jan 2025 00:00:00 GMT

Client cached request:
If-None-Match: "123abc"  # Send ETag
If-Modified-Since: Mon, 01 Jan 2025 00:00:00 GMT

Response (if unchanged):
304 Not Modified
```

**Caching Policy by Method**:
- **GET**: Cache safe
- **HEAD**: Cache safe
- **POST/PUT/DELETE**: Don't cache
- **POST with idempotency key**: May cache safely

---

## Part 5: API Versioning

### 5.1 Versioning Strategy

**URL Path (Recommended)**:
```
GET /api/v1/users     # Version 1
GET /api/v2/users     # Version 2 (different response structure)
```

**Header-Based**:
```
GET /api/users
Accept: application/vnd.myapp.v2+json
```

**Query Parameter**:
```
GET /api/users?version=2
```

### 5.2 Deprecation Process

```
1. Announce deprecation (6+ months notice)
   - Blog post
   - Email to API users
   - In API documentation

2. Support period (6 months)
   - Old version still works
   - New version available

3. Sunset date
   - Stop supporting old version
   - Redirect to new version
   - Final 30-day notice

Timeline:
v1 deprecated: Jan 1, 2025
v2 available: Jan 1, 2025
v1 sunset: Jul 1, 2025
```

---

## Part 6: Best Practices Checklist

### Design
- [ ] Resource-oriented design (not RPC-style)
- [ ] Consistent naming conventions
- [ ] Meaningful HTTP status codes
- [ ] Standardized response format
- [ ] Versioning strategy defined
- [ ] Error format consistent

### Documentation
- [ ] OpenAPI/Swagger spec maintained
- [ ] All endpoints documented
- [ ] Code examples provided
- [ ] Error scenarios documented
- [ ] Authentication documented
- [ ] Rate limits documented

### Security
- [ ] Authentication required (except public endpoints)
- [ ] HTTPS/TLS enforced
- [ ] Input validation implemented
- [ ] SQL injection/XSS prevention
- [ ] Rate limiting configured
- [ ] CORS policy defined
- [ ] API keys rotated regularly

### Performance
- [ ] Pagination implemented
- [ ] Caching headers configured
- [ ] Timeouts configured
- [ ] Connection pooling used
- [ ] Database queries optimized
- [ ] Monitoring/alerting in place

### Operations
- [ ] Request logging (without sensitive data)
- [ ] Error tracking (Sentry, Datadog, etc.)
- [ ] Performance monitoring (APM)
- [ ] Usage analytics
- [ ] SLA monitoring
- [ ] Incident response plan

---

## Related Resources

- [Integration Patterns](../patterns/integration-patterns.md)
- [Reference Architecture: API Platform](../reference-architectures/api-platform.md)
- [Security Patterns](../patterns/security-patterns.md)
- [OpenAPI Specification](https://swagger.io/specification/)
- [REST API Best Practices](https://restfulapi.net/)
- [GraphQL Best Practices](https://graphql.org/learn/best-practices/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
