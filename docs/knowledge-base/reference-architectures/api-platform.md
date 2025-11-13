# API Platform Reference Architecture

## Overview

Enterprise-grade API Platform architecture supporting multiple API styles (REST, GraphQL, gRPC), comprehensive developer experience, security, and operational excellence.

---

## Part 1: Architecture Overview

### 1.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        External Clients                      │
│              (Web, Mobile, Partner, Public APIs)            │
└────────────────────────────┬────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │   API Gateway   │
                    │  (Routing, Auth)│
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
    ┌───▼──┐           ┌─────▼──┐          ┌────▼──┐
    │REST  │           │GraphQL │          │ gRPC  │
    │Layer │           │ Layer  │          │ Layer │
    └───┬──┘           └─────┬──┘          └────┬──┘
        │                    │                   │
    ┌───▼────────────────────▼───────────────────▼───┐
    │     API Composition / Orchestration Layer      │
    └───┬────────────────────────────────────────────┘
        │
    ┌───▼────────────────────────────────────────────┐
    │      Microservices / Business Logic Layer      │
    │   (Payments, Orders, Inventory, Users, etc)    │
    └────────────────────────────────────────────────┘
        │
    ┌───▼──────────────┬───────────────┬──────────────┐
    │                  │               │              │
┌───▼──┐          ┌───▼──┐        ┌───▼───┐      ┌──▼──┐
│Cache │          │  DB  │        │  Search   │    │ File │
│      │          │      │        │  (ES)     │    │Store │
└──────┘          └──────┘        └──────────┘    └──────┘
```

### 1.2 Platform Capabilities

**API Styles Supported**:
- REST (most common, synchronous)
- GraphQL (query language, real-time)
- gRPC (high-performance, internal)
- WebSockets (real-time bidirectional)
- Webhooks (event notifications)

**Developer Experience**:
- Auto-generated documentation (OpenAPI/Swagger)
- Interactive API explorer
- SDK generation (multiple languages)
- Postman collections
- Rate limit transparency

**Operations**:
- Centralized monitoring and logging
- Request tracing and debugging
- Performance analytics
- Error tracking
- SLA monitoring

---

## Part 2: Platform Components

### 2.1 API Gateway

**Responsibilities**:
```
1. Request Routing
   - Route by path, method, host
   - Load balance across backends
   - Service discovery

2. Authentication & Authorization
   - Verify API keys
   - Validate JWT tokens
   - OAuth token exchange
   - Rate limiting per API key

3. Request/Response Transformation
   - Header manipulation
   - Body transformation
   - Protocol conversion
   - Compression

4. Resilience
   - Circuit breaking
   - Retry with backoff
   - Timeout enforcement
   - Fallback responses
```

**Example Configuration (Kong / AWS API Gateway)**:
```yaml
paths:
  /api/users:
    get:
      x-amazon-apigateway-integration:
        type: http
        uri: http://user-service:3000/users
        httpMethod: GET
        responses:
          "200":
            statusCode: 200
      security:
        - api_key: []
        - bearer_token: []

  /api/orders:
    post:
      x-amazon-apigateway-integration:
        type: http
        uri: http://order-service:3000/orders
        httpMethod: POST
        requestTemplates:
          application/json: |
            {
              "user_id": $input.json('$.user_id'),
              "items": $input.json('$.items')
            }
      security:
        - bearer_token: []

securityDefinitions:
  api_key:
    type: apiKey
    name: x-api-key
    in: header
  bearer_token:
    type: apiKey
    name: Authorization
    in: header
```

### 2.2 Authentication & Authorization Service

**OAuth 2.0 Flow**:
```
1. Client Registration
   - Client ID: abc123
   - Client Secret: xyz789
   - Redirect URI: https://myapp.com/callback

2. Authorization Request
   GET /oauth/authorize?
       client_id=abc123&
       redirect_uri=https://myapp.com/callback&
       scope=read,write&
       response_type=code

3. User Grants Permission
   User logs in and approves access

4. Authorization Code Returned
   Redirect to https://myapp.com/callback?code=auth_code_123

5. Token Exchange
   POST /oauth/token
   client_id=abc123&
   client_secret=xyz789&
   code=auth_code_123&
   grant_type=authorization_code

   Response:
   {
     "access_token": "eyJhbGc...",
     "token_type": "Bearer",
     "expires_in": 3600
   }

6. API Request with Token
   GET /api/user/profile
   Authorization: Bearer eyJhbGc...

7. Token Validation
   - Extract token from header
   - Verify signature using public key
   - Check expiration
   - Verify scopes
   - Return user info from claims
```

**Implementation**:
```python
# Django OAuth2 Provider
from oauthlib.oauth2 import BearerToken

@app.route('/api/user/profile')
@require_oauth('read')  # Require 'read' scope
def get_profile():
    user = g.oauth.user
    return {
        'id': user.id,
        'name': user.name,
        'email': user.email
    }

# Token validation middleware
def validate_token(token):
    payload = jwt.decode(
        token,
        public_key,
        algorithms=['RS256']
    )
    return payload
```

### 2.3 Developer Portal

**Features**:

**1. Interactive API Documentation**:
```
- Endpoint list with descriptions
- Request/response examples
- Try-it-out functionality
- Code samples (multiple languages)
- Error responses documented
```

**2. Account Management**:
```
- API key generation
- Key rotation
- Usage dashboard
- Quota monitoring
- Billing information
```

**3. Application Management**:
```
- OAuth applications
- Webhooks configuration
- Access logs
- API subscription management
```

**Example Portal Interface**:
```
User Portal
├── Dashboard
│   ├── API usage statistics
│   ├── Rate limit status
│   └── Recent errors
├── Documentation
│   ├── REST APIs
│   ├── GraphQL docs
│   └── gRPC services
├── API Keys
│   ├── Create new key
│   ├── Manage keys
│   └── Rotate keys
├── Applications
│   ├── Create OAuth app
│   └── Manage OAuth apps
└── Webhooks
    ├── Create webhook
    └── Manage endpoints
```

**Implementation Technologies**:
- Swagger/OpenAPI UI
- GraphiQL (GraphQL explorer)
- Custom portal (React/Vue + backend)
- Postman/Insomnia integration

### 2.4 Rate Limiting

**Strategy**:
```
Per API Key:
- 1000 requests per minute (basic tier)
- 10000 requests per minute (professional tier)
- Unlimited (enterprise tier)

Per User:
- 100 requests per minute

Per Service:
- 5000 requests per minute

Algorithm: Token Bucket
- Bucket capacity: 1000 tokens
- Refill rate: 1000 tokens per minute
- Each request costs 1 token
- When empty: return 429 Too Many Requests
```

**Implementation**:
```python
import redis
from datetime import datetime, timedelta

class RateLimiter:
    def __init__(self, redis_client):
        self.redis = redis_client
    
    def is_allowed(self, api_key: str, limit: int, window: int):
        """
        Check if request is allowed
        
        Args:
            api_key: Unique API key
            limit: Max requests per window
            window: Time window in seconds
        """
        key = f"ratelimit:{api_key}"
        current = self.redis.incr(key)
        
        if current == 1:
            # First request in window, set expiry
            self.redis.expire(key, window)
        
        return current <= limit

# Middleware usage
@app.before_request
def check_rate_limit():
    api_key = request.headers.get('x-api-key')
    if api_key:
        limiter = RateLimiter(redis_client)
        if not limiter.is_allowed(api_key, limit=1000, window=60):
            return {'error': 'Rate limit exceeded'}, 429
```

**Response Headers**:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 234
X-RateLimit-Reset: 1635789600
Retry-After: 45  # Seconds to wait before retrying
```

### 2.5 Analytics & Monitoring

**Metrics Collected**:
```
Per API Endpoint:
- Request volume
- Average latency
- P95/P99 latency
- Error rate
- Status code distribution
- Client breakdown
- API key usage

Storage:
- Real-time dashboard (last 24 hours)
- Time-series database (long-term)
- Aggregations (hourly, daily)
```

**Example Analytics**:
```
GET /api/users - Last 24 hours
├── Requests: 1.2M
├── Avg Latency: 45ms
├── P99 Latency: 200ms
├── Error Rate: 0.02%
├── Status Codes
│   ├── 200 OK: 99.8%
│   ├── 400 Bad Request: 0.1%
│   ├── 500 Error: 0.05%
│   └── 429 Rate Limited: 0.05%
└── Errors
    ├── Database connection timeout: 35 errors
    ├── Invalid input: 10 errors
    └── Service unavailable: 15 errors
```

**Alerting**:
```
Alert when:
- P99 latency > 500ms
- Error rate > 1%
- 429 rate limit errors spike
- Service unavailable (all 5xx)
```

---

## Part 3: API Implementation Patterns

### 3.1 REST API Design

**Resource-Oriented**:
```
// Resource-based URLs (good)
GET    /api/users              # List all users
POST   /api/users              # Create user
GET    /api/users/123          # Get user 123
PUT    /api/users/123          # Update user 123
DELETE /api/users/123          # Delete user 123

GET    /api/users/123/orders   # User's orders
GET    /api/orders/456         # Order 456
POST   /api/orders/456/items   # Add item to order

// Action-based URLs (bad)
GET    /api/getUser?id=123
POST   /api/createUser
GET    /api/getUserOrders?user_id=123
```

**Versioning**:
```
// Version in URL (recommended)
GET /api/v1/users        # Version 1
GET /api/v2/users        # Version 2

// Version in header (alternative)
GET /api/users
Accept: application/vnd.company.v1+json

// Keep old versions running
- v1: Deprecated, support 6 more months
- v2: Current stable version
- v3: New features, beta
```

**Response Format**:
```json
{
  "data": {
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "meta": {
    "timestamp": "2025-01-15T10:30:00Z",
    "request_id": "req-abc123"
  }
}

// Error response
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with id 123 not found",
    "status": 404
  },
  "meta": {
    "timestamp": "2025-01-15T10:30:00Z",
    "request_id": "req-abc123"
  }
}
```

### 3.2 GraphQL API Design

**Schema Definition**:
```graphql
type User {
  id: ID!
  name: String!
  email: String!
  orders: [Order!]!
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
  total: Float!
  status: OrderStatus!
  createdAt: DateTime!
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}

type Query {
  user(id: ID!): User
  users(limit: Int = 10, offset: Int = 0): [User!]!
  order(id: ID!): Order
  searchOrders(query: String!): [Order!]!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
  
  createOrder(input: CreateOrderInput!): Order!
  updateOrder(id: ID!, input: UpdateOrderInput!): Order!
}

input CreateUserInput {
  name: String!
  email: String!
}

input UpdateUserInput {
  name: String
  email: String
}

input CreateOrderInput {
  userId: ID!
  items: [OrderItemInput!]!
}

input OrderItemInput {
  productId: ID!
  quantity: Int!
}
```

**Query Examples**:
```graphql
# Get user and their orders
query {
  user(id: 123) {
    id
    name
    email
    orders {
      id
      total
      status
      items {
        productId
        quantity
      }
    }
  }
}

# Mutation - Create order
mutation {
  createOrder(input: {
    userId: 123
    items: [
      { productId: 456, quantity: 2 },
      { productId: 789, quantity: 1 }
    ]
  }) {
    id
    total
    status
  }
}
```

**Implementation (Python/Graphene)**:
```python
import graphene

class UserType(graphene.ObjectType):
    id = graphene.ID()
    name = graphene.String()
    email = graphene.String()
    orders = graphene.List(lambda: OrderType)
    
    def resolve_orders(self, info):
        return Order.objects.filter(user_id=self.id)

class Query(graphene.ObjectType):
    user = graphene.Field(UserType, id=graphene.ID(required=True))
    users = graphene.List(UserType, limit=graphene.Int(default_value=10))
    
    def resolve_user(self, info, id):
        return User.objects.get(id=id)
    
    def resolve_users(self, info, limit):
        return User.objects.all()[:limit]

class CreateUserMutation(graphene.Mutation):
    class Arguments:
        name = graphene.String(required=True)
        email = graphene.String(required=True)
    
    user = graphene.Field(UserType)
    
    def mutate(self, info, name, email):
        user = User.objects.create(name=name, email=email)
        return CreateUserMutation(user=user)

class Mutation(graphene.ObjectType):
    create_user = CreateUserMutation.Field()

schema = graphene.Schema(query=Query, mutation=Mutation)
```

### 3.3 gRPC Services

**Protocol Buffers Definition**:
```protobuf
syntax = "proto3";

package api.v1;

message User {
  int32 id = 1;
  string name = 2;
  string email = 3;
}

message GetUserRequest {
  int32 id = 1;
}

message CreateUserRequest {
  string name = 1;
  string email = 2;
}

message Empty {}

service UserService {
  rpc GetUser (GetUserRequest) returns (User);
  rpc ListUsers (Empty) returns (stream User);
  rpc CreateUser (CreateUserRequest) returns (User);
  rpc DeleteUser (GetUserRequest) returns (Empty);
}
```

**gRPC Implementation (Python)**:
```python
import grpc
from api.v1 import user_pb2, user_pb2_grpc

class UserServicer(user_pb2_grpc.UserServiceServicer):
    def GetUser(self, request, context):
        user = User.objects.get(id=request.id)
        return user_pb2.User(
            id=user.id,
            name=user.name,
            email=user.email
        )
    
    def ListUsers(self, request, context):
        for user in User.objects.all():
            yield user_pb2.User(
                id=user.id,
                name=user.name,
                email=user.email
            )
    
    def CreateUser(self, request, context):
        user = User.objects.create(
            name=request.name,
            email=request.email
        )
        return user_pb2.User(
            id=user.id,
            name=user.name,
            email=user.email
        )

# Server setup
server = grpc.server(
    concurrent.futures.ThreadPoolExecutor(max_workers=10)
)
user_pb2_grpc.add_UserServiceServicer_to_server(
    UserServicer(), server
)
server.add_insecure_port('[::]:50051')
server.start()
```

---

## Part 4: Security Implementation

### 4.1 API Key Management

**Workflow**:
```
1. Developer requests API key via portal
2. System generates random key (32 chars)
3. Key stored hashed in database
4. Key displayed once (developer copies)
5. Requests include: Authorization: Bearer <key>

Key Format:
sk_live_abc123... (secret key for operations)
pk_live_xyz789... (public key for client)
```

**Validation**:
```python
def validate_api_key(key: str) -> Optional[APIKey]:
    # Hash the provided key
    key_hash = hash_sha256(key)
    
    # Look up in database
    api_key = APIKey.objects.filter(
        key_hash=key_hash,
        is_active=True
    ).first()
    
    if not api_key:
        return None
    
    # Update last used timestamp
    api_key.last_used = datetime.now()
    api_key.save()
    
    return api_key
```

### 4.2 JWT Token Handling

**Token Structure**:
```
Header.Payload.Signature

Signature verification:
1. Split token into 3 parts
2. Verify signature using public key
3. Check not expired
4. Check issuer matches
```

**Implementation**:
```python
import jwt
from datetime import datetime, timedelta

def create_token(user_id: int, expires_in: int = 3600) -> str:
    """Create JWT token"""
    payload = {
        'sub': user_id,  # Subject (user)
        'iat': datetime.utcnow(),  # Issued at
        'exp': datetime.utcnow() + timedelta(seconds=expires_in),
        'iss': 'api.example.com'  # Issuer
    }
    
    token = jwt.encode(
        payload,
        private_key,
        algorithm='RS256'
    )
    return token

def validate_token(token: str) -> dict:
    """Validate and decode JWT token"""
    try:
        payload = jwt.decode(
            token,
            public_key,
            algorithms=['RS256'],
            issuer='api.example.com'
        )
        return payload
    except jwt.ExpiredSignatureError:
        raise ValueError("Token expired")
    except jwt.InvalidSignatureError:
        raise ValueError("Invalid signature")
```

### 4.3 Rate Limiting & DDoS Protection

**Layers**:
```
1. WAF (Web Application Firewall)
   - Detect and block obvious attacks
   - IP reputation blocking
   - Geo-blocking

2. API Gateway Rate Limiting
   - Per API key limits
   - Per user limits
   - Per IP limits

3. Application Rate Limiting
   - Specific endpoint limits
   - Custom rules (e.g., login attempts)

4. CDN DDoS Protection
   - Automatically absorb large attacks
   - Scrub malicious traffic
```

---

## Part 5: Operations & Monitoring

### 5.1 Deployment

**Environment Tiers**:
```
Development:
- Localhost, personal testing
- No rate limits
- Mock external services

Staging:
- Pre-production environment
- Same configs as production
- Limited test data
- Performance testing

Production:
- Live environment
- Rate limiting enabled
- Full security
- Monitoring & alerting
```

**Deployment Process**:
```
1. Code review & testing
2. Build Docker image
3. Push to registry
4. Update Kubernetes deployment
5. Health check
6. Gradual rollout (canary)
7. Monitoring
8. Rollback if issues
```

### 5.2 Monitoring & Alerting

**Metrics Dashboard**:
```
Real-time (Last 1 hour)
├── Request Rate: 5,432 req/min
├── Avg Latency: 45ms
├── P99 Latency: 234ms
├── Error Rate: 0.05%
├── Cache Hit Rate: 85%
├── Active Connections: 2,341
└── CPU/Memory: 65% / 72%

By Endpoint (Last 24 hours)
├── GET /api/users: 234K req, 42ms avg
├── POST /api/orders: 123K req, 156ms avg
├── GET /api/products: 567K req, 23ms avg
└── ...

By API Key (Last 24 hours)
├── Key A (Integration 1): 450K req
├── Key B (Mobile App): 320K req
├── Key C (Web App): 280K req
└── ...
```

**Alerts**:
```
Critical:
- P99 latency > 1 second
- Error rate > 5%
- Service unavailable
- Database connection failed

High:
- P99 latency > 500ms
- Error rate > 1%
- Rate limit errors spike
- Cache miss rate > 20%

Medium:
- P95 latency > 200ms
- 4xx error rate > 0.5%
- Disk usage > 80%
- Memory usage > 85%
```

---

## Part 6: Deployment Options

### 6.1 Cloud Deployment

**AWS**:
```
- API Gateway (managed)
- Cognito (authentication)
- Lambda (serverless functions)
- RDS (database)
- ElastiCache (caching)
- CloudFront (CDN)
- CloudWatch (monitoring)
```

**Azure**:
```
- API Management (gateway)
- Azure AD (authentication)
- App Service / Container Instances
- SQL Database / Cosmos DB
- Redis Cache
- CDN
- Application Insights
```

**Kubernetes**:
```
- Ingress Controller (API Gateway)
- Service Mesh (Istio for traffic mgmt)
- Deployments (API services)
- StatefulSets (databases)
- ConfigMaps/Secrets (configuration)
- Prometheus (monitoring)
```

### 6.2 Scalability

**Horizontal Scaling**:
```
API Gateway
    ↓
├─ Instance 1
├─ Instance 2
├─ Instance 3
└─ Instance N

Load Balanced
Auto-scaled based on:
- CPU > 70%
- Memory > 80%
- RPS > threshold
```

**Database Scaling**:
```
Read Replicas for read-heavy workloads:
Master (writes)
  ├─ Replica 1 (read)
  ├─ Replica 2 (read)
  └─ Replica N (read)

Caching layer to reduce database load:
API Gateway
  ↓ Cache miss
Database
  ↓
Cache (Redis)
  ↓
API Gateway
  ↓ Cache hit
Cache
```

---

## Cost Considerations

**Typical Architecture Costs** (AWS):
```
API Gateway:     $3.50/M requests
EC2 Instances:   $1,000-5,000/month (depending on size)
RDS Database:    $500-2,000/month
ElastiCache:     $300-1,000/month
CloudFront CDN:  ~$0.085/GB
Monitoring:      ~$200/month

Total (Typical): $2,500-9,500/month

Cost Optimization:
- Use spot instances for non-critical workloads
- Reserved instances for stable baseline
- Auto-scaling to match demand
- CDN caching to reduce origin requests
```

---

## Example Implementation

**Minimal Production API Platform**:
```
1. API Gateway
   - Simple routing
   - Basic authentication (API keys)
   - Rate limiting (1000 req/min)

2. 2-3 REST API Services
   - Containerized (Docker)
   - Load balanced

3. PostgreSQL Database
   - Encrypted at rest
   - Daily automated backups
   - Read replica for reporting

4. Redis Cache
   - User sessions
   - API response caching
   - Rate limit counters

5. Monitoring
   - CloudWatch / Datadog
   - Basic alerts (errors, latency)

6. Developer Portal
   - API documentation (OpenAPI)
   - API key management
   - Basic analytics
```

---

## Related Resources

- [API Design Guide](../playbooks/api-design-guide.md)
- [Security Patterns](../patterns/security-patterns.md)
- [Cloud Patterns](../patterns/cloud-patterns.md)
- [API Gateway Patterns](../patterns/integration-patterns.md)
- [Performance Guide](../playbooks/performance-guide.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
