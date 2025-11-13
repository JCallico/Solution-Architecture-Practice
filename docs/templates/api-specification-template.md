# API Specification Template

## Purpose

The API Specification document formally defines all aspects of an API using OpenAPI 3.0 standard. It serves as a contract between API provider and consumer, enabling API documentation generation, client SDK generation, and testing.

---

## When to Use

- Designing new APIs before implementation
- Documenting existing APIs
- Sharing API contracts with partners
- Generating client SDKs
- Creating interactive API documentation
- API versioning and deprecation

---

## OpenAPI 3.0 Specification Template

```yaml
openapi: 3.0.0
info:
  title: API Name
  description: |
    Brief description of the API.
    
    ## Key Features
    - Feature 1
    - Feature 2
    - Feature 3
  version: 1.0.0
  contact:
    name: API Support
    email: api-support@example.com
    url: https://example.com/support
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html

servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging-api.example.com/v1
    description: Staging server
  - url: http://localhost:3000/v1
    description: Development server

tags:
  - name: Users
    description: User management operations
  - name: Orders
    description: Order operations
  - name: Products
    description: Product catalog

paths:
  /users:
    get:
      summary: List all users
      description: Returns a paginated list of users
      operationId: listUsers
      tags:
        - Users
      parameters:
        - name: limit
          in: query
          description: Number of items to return
          required: false
          schema:
            type: integer
            default: 20
            minimum: 1
            maximum: 100
        - name: offset
          in: query
          description: Number of items to skip
          required: false
          schema:
            type: integer
            default: 0
            minimum: 0
        - name: filter
          in: query
          description: Filter by user status
          required: false
          schema:
            type: string
            enum: [active, inactive, suspended]
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
              examples:
                success:
                  summary: List of users
                  value:
                    data:
                      - id: 1
                        name: John Doe
                        email: john@example.com
                        status: active
                      - id: 2
                        name: Jane Smith
                        email: jane@example.com
                        status: active
                    pagination:
                      total: 100
                      limit: 20
                      offset: 0
                      has_more: true
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
      security:
        - apiKey: []
        - bearerAuth: []

    post:
      summary: Create a new user
      description: Creates a new user account
      operationId: createUser
      tags:
        - Users
      requestBody:
        description: User data
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
            examples:
              valid:
                summary: Valid user creation
                value:
                  name: John Doe
                  email: john@example.com
                  password: SecurePass123!
      responses:
        '201':
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
          headers:
            Location:
              schema:
                type: string
              description: URI of the newly created user
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          $ref: '#/components/responses/Conflict'
      security:
        - bearerAuth: []

  /users/{userId}:
    get:
      summary: Get a user by ID
      operationId: getUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          description: User ID
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: User details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'
      security:
        - apiKey: []

    put:
      summary: Update a user
      operationId: updateUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserRequest'
      responses:
        '200':
          description: User updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'
      security:
        - bearerAuth: []

    delete:
      summary: Delete a user
      operationId: deleteUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      responses:
        '204':
          description: User deleted
        '404':
          $ref: '#/components/responses/NotFound'
      security:
        - bearerAuth: []

  /orders:
    post:
      summary: Create an order
      operationId: createOrder
      tags:
        - Orders
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrderRequest'
      responses:
        '201':
          description: Order created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
        '400':
          $ref: '#/components/responses/BadRequest'
      security:
        - bearerAuth: []

components:
  schemas:
    User:
      type: object
      required:
        - id
        - name
        - email
        - status
        - created_at
      properties:
        id:
          type: integer
          format: int64
          description: User ID
        name:
          type: string
          description: User's full name
          minLength: 1
          maxLength: 255
        email:
          type: string
          format: email
          description: User's email address
        status:
          type: string
          enum: [active, inactive, suspended]
          description: User status
        created_at:
          type: string
          format: date-time
          description: Creation timestamp
        updated_at:
          type: string
          format: date-time
          description: Last update timestamp

    CreateUserRequest:
      type: object
      required:
        - name
        - email
        - password
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 255
        email:
          type: string
          format: email
        password:
          type: string
          format: password
          minLength: 8
          description: Must contain uppercase, lowercase, number, symbol

    UpdateUserRequest:
      type: object
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 255
        email:
          type: string
          format: email
        status:
          type: string
          enum: [active, inactive, suspended]

    UserList:
      type: object
      required:
        - data
        - pagination
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        pagination:
          $ref: '#/components/schemas/Pagination'

    Order:
      type: object
      required:
        - id
        - user_id
        - items
        - total
        - status
        - created_at
      properties:
        id:
          type: integer
          format: int64
        user_id:
          type: integer
          format: int64
        items:
          type: array
          items:
            $ref: '#/components/schemas/OrderItem'
        total:
          type: number
          format: double
          minimum: 0
        status:
          type: string
          enum: [pending, confirmed, shipped, delivered, cancelled]
        created_at:
          type: string
          format: date-time

    OrderItem:
      type: object
      required:
        - product_id
        - quantity
        - unit_price
      properties:
        product_id:
          type: integer
        quantity:
          type: integer
          minimum: 1
        unit_price:
          type: number
          format: double
          minimum: 0

    CreateOrderRequest:
      type: object
      required:
        - user_id
        - items
      properties:
        user_id:
          type: integer
          format: int64
        items:
          type: array
          minItems: 1
          items:
            type: object
            required:
              - product_id
              - quantity
            properties:
              product_id:
                type: integer
              quantity:
                type: integer
                minimum: 1

    Pagination:
      type: object
      required:
        - total
        - limit
        - offset
        - has_more
      properties:
        total:
          type: integer
          description: Total number of items
        limit:
          type: integer
          description: Items per page
        offset:
          type: integer
          description: Number of items skipped
        has_more:
          type: boolean
          description: Whether more items exist

    Error:
      type: object
      required:
        - error
      properties:
        error:
          type: object
          required:
            - code
            - message
          properties:
            code:
              type: string
              description: Machine-readable error code
            message:
              type: string
              description: Human-readable error message
            details:
              type: object
              description: Additional error context
        request_id:
          type: string
          description: Unique request identifier for debugging

  responses:
    BadRequest:
      description: Invalid request parameters
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            error:
              code: INVALID_REQUEST
              message: Email is required
              details:
                field: email
            request_id: req-abc123

    Unauthorized:
      description: Missing or invalid authentication
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            error:
              code: UNAUTHORIZED
              message: Invalid API key

    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            error:
              code: NOT_FOUND
              message: User not found

    Conflict:
      description: Resource conflict (e.g., duplicate email)
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            error:
              code: CONFLICT
              message: Email already exists

    InternalServerError:
      description: Unexpected server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

  securitySchemes:
    apiKey:
      type: apiKey
      name: x-api-key
      in: header
      description: API key for authentication

    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT token for authentication

  headers:
    X-RateLimit-Limit:
      schema:
        type: integer
      description: Request limit per window

    X-RateLimit-Remaining:
      schema:
        type: integer
      description: Remaining requests in current window

    X-RateLimit-Reset:
      schema:
        type: integer
        format: unix-time
      description: Time when rate limit resets
```

---

## API Design Best Practices

### Naming Conventions

**Resources (Nouns):**
```
/users (collection)
/users/{userId} (single item)
/users/{userId}/orders (sub-resource)
```

**Methods (Verbs):**
```
GET /users          → List users
POST /users         → Create user
GET /users/{id}     → Get specific user
PUT /users/{id}     → Replace user
PATCH /users/{id}   → Partial update
DELETE /users/{id}  → Delete user
```

### Versioning

```
URL Path (Recommended):
  /api/v1/users
  /api/v2/users

Header:
  Accept: application/vnd.company.v1+json

Query Parameter:
  /api/users?version=1
```

### Error Handling

```
Always return JSON error responses:
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with id 123 not found",
    "details": {
      "user_id": 123
    }
  },
  "request_id": "req-abc123"
}

Status Codes:
  200 OK - Success
  201 Created - Resource created
  204 No Content - Success (no body)
  400 Bad Request - Invalid input
  401 Unauthorized - Auth required
  403 Forbidden - Authenticated but not allowed
  404 Not Found - Resource not found
  409 Conflict - State conflict
  429 Too Many Requests - Rate limited
  500 Internal Server Error - Server error
  503 Service Unavailable - Temporarily down
```

---

## Documentation Generation

**From OpenAPI specification, auto-generate:**

- Swagger UI (interactive documentation)
- ReDoc (beautiful API docs)
- API client libraries
- Server stubs
- Test cases

**Tools:**
- Swagger Codegen
- OpenAPI Generator
- Spectacle
- Stoplight

---

## Testing the API

```bash
# Using curl
curl -X GET http://localhost:3000/v1/users \
  -H "x-api-key: abc123" \
  -H "Content-Type: application/json"

# Using httpie
http GET localhost:3000/v1/users x-api-key:abc123

# Using Postman (import OpenAPI spec)
# File → Import → Paste OpenAPI YAML

# Using automated tests
npm install @apidevtools/swagger-cli
swagger-cli validate openapi.yaml
```

---

## Related Resources

- [API Design Guide](../knowledge-base/playbooks/api-design-guide.md)
- [Technical Design Template](./documents/technical-design-template.md)
- [API Platform Reference Architecture](../knowledge-base/reference-architectures/api-platform.md)
- [OpenAPI 3.0 Specification](https://spec.openapis.org/oas/v3.0.3)
- [Swagger Editor](https://editor.swagger.io/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
