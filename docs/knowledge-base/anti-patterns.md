# Anti-Patterns

## Purpose

This guide documents common architecture and design anti-patterns—approaches that seem reasonable but cause problems at scale. Learning to recognize and avoid anti-patterns is as important as understanding patterns.

---

## When to Recognize Anti-Patterns

You may be experiencing an anti-pattern if you observe:
- Frequent production issues or outages
- Systems becoming harder to modify over time
- Performance degradation without obvious cause
- Escalating operational complexity
- High team churn or frustration
- Inability to meet non-functional requirements

---

## Architecture & Design Anti-Patterns

### 1. Big Ball of Mud

**Description:**
A monolithic system without clear structure or separation of concerns. Code is tightly coupled, dependencies are bidirectional, and there's no clear architecture.

**Problem Indicators:**
```
✗ No logical module organization
✗ Circular dependencies between components
✗ Everything depends on everything
✗ No clear separation of concerns
✗ Difficult to understand the system
✗ Changes in one area break other areas
✗ High cognitive load for new developers
```

**Why It's Problematic:**
```
1. Change Risk: Modifying code affects unpredictable areas
2. Testing Difficulty: Components can't be tested in isolation
3. Scaling Limitations: Can't scale individual components
4. Onboarding Cost: New engineers take months to understand
5. Maintenance Burden: Simple changes require extensive testing
6. Regression Risk: Bug fixes introduce new bugs elsewhere
```

**Example:**
```python
# ❌ Big Ball of Mud (anti-pattern)
# user_service.py - 5,000 lines
class UserService:
    def __init__(self, db):
        self.db = db
        self.email_service = EmailService(db)  # Hard dependency
        self.notification_service = NotificationService()
        self.audit_service = AuditService(db)
        self.reporting_service = ReportingService(db)
    
    def create_user(self, user_data):
        # Complex logic mixing concerns
        user = self._validate_user(user_data)
        
        # Database operations
        result = self.db.insert('users', user)
        
        # Email sending
        self.email_service.send_welcome(user)
        
        # Notifications
        self.notification_service.notify_admins(user)
        
        # Auditing
        self.audit_service.log_user_creation(user)
        
        # Reporting
        self.reporting_service.update_user_metrics()
        
        return result
    
    def _validate_user(self, data):
        # 100+ lines of validation logic mixed with business logic
        pass
```

**How to Fix It:**
```python
# ✅ Clear separation of concerns (improved)
# domain/user.py
@dataclass
class User:
    email: str
    name: str
    
    def validate(self) -> bool:
        """Domain-level validation"""
        if not self.email or '@' not in self.email:
            raise ValueError("Invalid email")
        return True

# application/user_service.py
class UserService:
    def __init__(
        self,
        user_repo: UserRepository,
        email_service: EmailService,
        event_bus: EventBus
    ):
        self.user_repo = user_repo
        self.email_service = email_service
        self.event_bus = event_bus
    
    def create_user(self, user_data: dict) -> User:
        # Single responsibility: Orchestrate user creation
        user = User(**user_data)
        user.validate()
        
        saved_user = self.user_repo.save(user)
        
        # Publish event for other services to handle
        self.event_bus.publish(UserCreatedEvent(saved_user))
        
        return saved_user

# Separate services handle their concerns
# infrastructure/email_service.py
class EmailService:
    def send_welcome_email(self, user: User) -> None:
        """Send welcome email"""
        pass

# events/handlers.py
@event_handler(UserCreatedEvent)
def send_welcome_email(event: UserCreatedEvent):
    email_service.send_welcome_email(event.user)

@event_handler(UserCreatedEvent)
def notify_admins(event: UserCreatedEvent):
    notification_service.notify_admins(f"New user: {event.user.email}")
```

**Remediation Steps:**
1. **Identify domains:** Group related functionality
2. **Define boundaries:** Create module/service boundaries
3. **Reduce coupling:** Use dependency injection
4. **Publish events:** Decouple with event-driven architecture
5. **Incremental refactoring:** Extract one module at a time
6. **Add tests:** Increase test coverage as you refactor

---

### 2. God Object

**Description:**
A single class/module that knows too much and does too much. Violates the Single Responsibility Principle.

**Problem Indicators:**
```
✗ Class has 10+ responsibilities
✗ Class touches many unrelated domains
✗ Class has 5,000+ lines of code
✗ Hard to name (needs "Manager", "Handler", "Utility")
✗ Many different reasons to change it
✗ Difficult to test (requires mocking many dependencies)
```

**Example:**
```python
# ❌ God Object (anti-pattern)
class OrderHandler:
    def __init__(self, db, email, payment, inventory, shipping, reporting):
        self.db = db
        self.email = email
        self.payment = payment
        self.inventory = inventory
        self.shipping = shipping
        self.reporting = reporting
    
    def process_order(self, order_data):
        # Validation
        if not self._validate_order(order_data):
            return None
        
        # Database
        order = self.db.create_order(order_data)
        
        # Payment
        payment_result = self.payment.charge(order.total)
        if not payment_result:
            return None
        
        # Inventory
        for item in order.items:
            self.inventory.reserve(item.product_id, item.quantity)
        
        # Shipping
        shipping = self.shipping.calculate_shipping(order.address)
        self.db.update_order(order.id, {'shipping_cost': shipping})
        
        # Email
        self.email.send_confirmation(order)
        
        # Reporting
        self.reporting.update_sales_metrics()
        
        return order
```

**How to Fix It:**
```python
# ✅ Single Responsibility (improved)
class OrderService:
    def __init__(
        self,
        order_repo: OrderRepository,
        event_bus: EventBus
    ):
        self.order_repo = order_repo
        self.event_bus = event_bus
    
    def create_order(self, order_data: dict) -> Order:
        """Single responsibility: Create order"""
        order = Order(**order_data)
        order.validate()
        
        saved_order = self.order_repo.save(order)
        
        # Other services handle their concerns via events
        self.event_bus.publish(OrderCreatedEvent(saved_order))
        
        return saved_order

# Separate services per domain
class PaymentService:
    def charge_order(self, order: Order) -> PaymentResult:
        pass

class InventoryService:
    def reserve_items(self, order: Order) -> None:
        pass

class ShippingService:
    def calculate_shipping(self, order: Order) -> ShippingCost:
        pass

# Event handlers for notification
@event_handler(OrderCreatedEvent)
def send_confirmation(event: OrderCreatedEvent):
    email_service.send_order_confirmation(event.order)

@event_handler(PaymentChargedEvent)
def update_metrics(event: PaymentChargedEvent):
    reporting_service.record_sale(event.order)
```

---

### 3. Golden Hammer / Hammer and Nail

**Description:**
Applying the same solution to every problem because you're familiar with it, regardless of suitability.

**Problem Indicators:**
```
✗ "We use [technology] for everything"
✗ Forcing a tool into situations where it's poor fit
✗ Ignoring evidence that a different approach works better
✗ High operational complexity for simple problems
✗ Team expertise doesn't match technology choice
```

**Example:**
```
Scenario: Team is very experienced with Kubernetes

❌ Anti-pattern - Using K8s everywhere:
- Single-service application deployed to K8s
- Scheduled batch job running in K8s
- Short-lived data processing in K8s
- Monolithic application because "that's how we deploy"

Results:
- Operational overhead for simple workloads
- Kubernetes complexity not needed
- Team overspends on infrastructure
- Poor performance for some workloads

✅ Better approach - Right tool for the job:
- Microservices: K8s ✓ (provides value)
- Scheduled batch: AWS Lambda ✓ (simpler, cheaper)
- Data processing: AWS Batch or Spark ✓ (optimized)
- Monolith: ECS or EC2 ✓ (simpler than K8s)
```

---

### 4. Lava Flow

**Description:**
Dead code, obsolete constructs, and forgotten experiments that accumulate and clutter the codebase.

**Problem Indicators:**
```
✗ Code commented out for months
✗ Unused imports and dependencies
✗ Experimental features no longer in use
✗ Old configuration files
✗ Deprecation warnings ignored
✗ Unused environment variables
```

**Remediation:**
```bash
# Regular cleanup practices

# 1. Remove dead code
- Code coverage reports (identify unused code)
- Static analysis tools (SonarQube, Pylint)
- Regular refactoring sprints (1 day per sprint)

# 2. Version control
- Don't leave code commented out - delete it
- Git history is the "backup" of removed code
- Trust version control instead of commenting out

# 3. Dependency management
# Regularly audit dependencies
pip audit  # Python
npm audit  # Node.js
cargo audit  # Rust

# 4. Configuration cleanup
# Document what each configuration does
# Remove unused environment variables
# Archive obsolete configuration files

# 5. Feature flags for experiments
# Use feature flags instead of leaving code commented
# Remove flags after experiment/decision
```

---

## Performance Anti-Patterns

### 5. N+1 Query Problem

**Description:**
Querying the database in a loop, resulting in 1 initial query + N additional queries for N items.

**Example:**
```python
# ❌ N+1 queries (anti-pattern)
def get_orders_with_customer():
    orders = db.query("SELECT * FROM orders")  # Query 1
    
    for order in orders:  # Iterate N times
        customer = db.query(  # Query 2, 3, 4, ... N+1
            "SELECT * FROM customers WHERE id = %s",
            order.customer_id
        )
        order.customer = customer
    
    return orders
# Total: 1 + N database queries

# ✅ Better: Join or eager load
def get_orders_with_customer():
    orders = db.query("""
        SELECT o.*, c.* FROM orders o
        JOIN customers c ON o.customer_id = c.id
    """)  # Single query with join
    
    return orders
# Total: 1 database query

# Or with ORM
orders = session.query(Order).options(
    joinedload(Order.customer)  # Eager load
).all()
# Total: 1-2 queries depending on ORM optimization
```

**How to Identify:**
```python
# Enable SQL logging
# Check query log to count number of queries
# Use ORM query inspection tools

# Example: SQLAlchemy
from sqlalchemy import event
from sqlalchemy.engine import Engine
import logging

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# Now run your code and examine SQL logs
orders = session.query(Order).all()  # Should see 1 query, not N+1
```

**Remediation:**
1. **Use joins:** Select related data in one query
2. **Eager loading:** Load relationships upfront (joinedload, selectinload)
3. **Batch queries:** Group similar queries
4. **Caching:** Cache customer data that changes infrequently
5. **Query optimization:** Use EXPLAIN ANALYZE to understand query performance

---

### 6. Synchronous I/O in Blocking Context

**Description:**
Making blocking I/O calls (database, API, file operations) in a context where it blocks other requests.

**Example:**
```python
# ❌ Synchronous I/O blocking (anti-pattern)
from flask import Flask, request

app = Flask(__name__)

@app.route('/order')
def create_order():
    # Receives request
    order_data = request.json
    
    # Saves to database (blocks request)
    order = db.save(order_data)
    
    # Calls external payment API (blocks request, 1-2 seconds)
    result = payment_service.charge(order.total)
    
    # Sends email (blocks request, can take several seconds)
    email_service.send_confirmation(order)
    
    # User waits for all of this to complete
    return {'order_id': order.id}

# Result: Request takes 10+ seconds, database pool exhausted
```

**How to Fix It:**
```python
# ✅ Asynchronous I/O (improved)
from flask import Flask, request
from celery import Celery

app = Flask(__name__)
celery = Celery(app.name)

@app.route('/order')
def create_order():
    order_data = request.json
    
    # Save synchronously (required for response)
    order = db.save(order_data)
    
    # Publish event for async processing
    event_bus.publish(OrderCreatedEvent(order))
    
    # Return immediately (user doesn't wait)
    return {'order_id': order.id}

# Async task handlers
@celery.task
def handle_order_created(order_id):
    order = db.get(order_id)
    
    # Charge payment (can fail gracefully)
    try:
        payment_service.charge(order.total)
    except PaymentError as e:
        # Handle failure (retry, notify, etc.)
        logger.error(f"Payment failed: {e}")
    
    # Send email (eventual, not blocking request)
    email_service.send_confirmation(order)

# Result: Request returns immediately, tasks process in background
```

---

### 7. Chatty I/O

**Description:**
Making multiple small network calls instead of one larger request.

**Example:**
```python
# ❌ Chatty I/O (multiple API calls)
def get_product_with_details(product_id):
    # Call 1: Get product
    product = api.get(f'/products/{product_id}')
    
    # Call 2: Get category
    category = api.get(f'/categories/{product.category_id}')
    
    # Call 3: Get reviews
    reviews = api.get(f'/products/{product_id}/reviews')
    
    # Call 4: Get recommendations
    recommendations = api.get(f'/products/{product_id}/recommendations')
    
    return {
        'product': product,
        'category': category,
        'reviews': reviews,
        'recommendations': recommendations
    }

# Result: 4 network round-trips, ~500-1000ms latency

# ✅ Better: Batch or single call
def get_product_with_details(product_id):
    # Single call with embedded data
    product = api.get(
        f'/products/{product_id}',
        params={'include': 'category,reviews,recommendations'}
    )
    
    return product

# Result: 1 network round-trip, ~100-200ms latency
```

**Common Causes:**
```
1. REST API design (separate endpoints for each resource)
2. Lack of embedding/expansion in API
3. N+1 problem in API calls instead of database queries
4. Missing batch endpoints

Remediation:
- Use GraphQL (query exactly what you need)
- Support field expansion in REST APIs (?include=category,reviews)
- Batch API endpoints (/products/batch)
- API gateway aggregation
```

---

## Scalability Anti-Patterns

### 8. Shared State in Distributed Systems

**Description:**
Using shared mutable state in a distributed environment where consistency is difficult.

**Problem:**
```
Server 1              Server 2
  ↓ (read)             ↓ (read)
  user.balance=100     user.balance=100
  ↓ (local)            ↓ (local)
  balance-=50          balance-=50
  user.balance=50      user.balance=50
  ↓ (write)            ↓ (write)
  Save to DB           Save to DB
  Result: balance=50 (not 0!)
```

**Example:**
```python
# ❌ Shared state (anti-pattern)
# In-memory cache shared across instances
cache = {}

@app.route('/user/<user_id>')
def get_user(user_id):
    # Check in-memory cache
    if user_id in cache:
        return cache[user_id]  # Stale data
    
    # Fetch from database
    user = db.get_user(user_id)
    
    # Cache locally (only this instance sees it)
    cache[user_id] = user
    
    return user

# Problem: 
# - Instance 1 caches user, Instance 2 doesn't know about it
# - Data inconsistency across instances
# - Cache doesn't survive restart
```

**How to Fix It:**
```python
# ✅ Distributed cache (improved)
# Use Redis for shared state
import redis

cache = redis.Redis(host='redis-host')

@app.route('/user/<user_id>')
def get_user(user_id):
    # Check distributed cache
    cached = cache.get(f'user:{user_id}')
    if cached:
        return json.loads(cached)
    
    # Fetch from database
    user = db.get_user(user_id)
    
    # Cache in distributed system (all instances see it)
    cache.setex(f'user:{user_id}', 3600, json.dumps(user))
    
    return user
```

**Better Approaches:**
1. **Stateless design:** No instance state, all state in external store
2. **Distributed cache:** Use Redis, Memcached for shared state
3. **Event sourcing:** Store state as immutable events
4. **CQRS:** Separate read and write models

---

### 9. Tight Coupling in Microservices

**Description:**
Microservices that depend on each other synchronously, creating a distributed monolith.

**Example:**
```python
# ❌ Tight coupling (distributed monolith)
# Order Service
@app.route('/orders', methods=['POST'])
def create_order():
    # Synchronous call to inventory service
    inventory_result = requests.post(
        'http://inventory-service/reserve',
        json={'items': order_items}
    )
    if inventory_result.status != 200:
        return error(400, "Out of stock")
    
    # Synchronous call to payment service
    payment_result = requests.post(
        'http://payment-service/charge',
        json={'amount': order_total}
    )
    if payment_result.status != 200:
        return error(400, "Payment failed")
    
    # Synchronous call to shipping service
    shipping_result = requests.post(
        'http://shipping-service/arrange',
        json={'address': order_address}
    )
    
    return {'order_id': order.id}

# Problems:
# - All services must be available (no independent scaling)
# - Failure cascades (payment fails -> whole order fails)
# - Latency adds up (3 services = 3x slower)
# - Difficult to scale independently
```

**How to Fix It:**
```python
# ✅ Event-driven asynchronous (improved)
# Order Service publishes OrderCreatedEvent
@app.route('/orders', methods=['POST'])
def create_order():
    order = Order(**order_data)
    order.validate()
    
    saved_order = db.save(order)
    
    # Publish event (fire and forget)
    event_bus.publish(OrderCreatedEvent(saved_order))
    
    # Return immediately
    return {'order_id': saved_order.id}

# Other services subscribe to events
@event_handler(OrderCreatedEvent)
def handle_inventory(event):
    # Inventory Service
    try:
        reserve_items(event.order)
        event_bus.publish(InventoryReservedEvent(event.order))
    except OutOfStockError:
        event_bus.publish(OrderFailedEvent(event.order))

@event_handler(OrderCreatedEvent)
def handle_payment(event):
    # Payment Service
    try:
        charge_order(event.order)
        event_bus.publish(PaymentChargedEvent(event.order))
    except PaymentError:
        event_bus.publish(OrderFailedEvent(event.order))

@event_handler(OrderCreatedEvent)
def handle_shipping(event):
    # Shipping Service
    calculate_and_arrange_shipping(event.order)
    event_bus.publish(ShippingArrangedEvent(event.order))

# Benefits:
# - Services can fail independently
# - Each service scales independently
# - System is resilient to failures
# - Faster response time for API calls
```

---

## Cloud Anti-Patterns

### 10. Configuration Drift

**Description:**
Infrastructure configuration diverging from code/templates, making systems unreproducible.

**Example:**
```
Initial Setup:
# Terraform defines 2 instances
resource "aws_instance" "web" {
  count = 2
  instance_type = "t3.medium"
  root_block_device {
    volume_size = 50
  }
}

Manual Change (Problem):
1. Engineer SSH into instance
2. Manually updates security group
3. Manually increases disk volume
4. Manually installs additional packages
5. No record in version control

Result:
- Terraform shows "no changes needed" (wrong)
- Manual configuration diverges from Terraform
- Cannot recreate infrastructure from code
- Disaster recovery fails
- Different instances have different config
```

**How to Fix It:**
```bash
# 1. Version control all infrastructure
# All changes through code, not manual

# 2. IaC for everything
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web" {
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count                = 2
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.medium"
  security_groups      = [aws_security_group.web.id]
  
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  
  user_data = base64encode(file("${path.module}/init.sh"))
  
  tags = {
    Name = "web-${count.index + 1}"
  }
}

# 3. Immutable infrastructure pattern
# Don't SSH into instances to fix things
# Instead: recreate instance with corrected image

# 4. Policy as code
# Enforce compliance programmatically
resource "aws_config_rule" "required_tags" {
  name = "required-tags"
  
  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
  
  input_parameters = jsonencode({
    tag1Key = "Environment"
    tag2Key = "Owner"
  })
}
```

---

## Microservices Anti-Patterns

### 11. Distributed Monolith

**Description:**
Microservices that are synchronized and tightly coupled, creating the worst of both worlds.

**Symptoms:**
```
✗ Services must be deployed together
✗ Failure in one service takes down others
✗ All services run at same pace
✗ Complex distributed transactions
✗ Difficult to debug
✗ No benefits of microservices, all costs
```

**Remediation:**
- Use event-driven architecture (async)
- Accept eventual consistency
- Clear API contracts
- Independent deployments
- Service discovery

---

## Data Anti-Patterns

### 12. N+1 Query Problem (Already Covered Above)

### 13. Select * (Poor Query Performance)

**Description:**
Selecting all columns when only a few are needed.

**Example:**
```sql
-- ❌ Inefficient (fetches all columns)
SELECT * FROM users;
-- Returns: id, username, email, password_hash, phone, address, bio, preferences, created_at, updated_at, deleted_at, etc.
-- Transmits unnecessary data over network
-- Uses more memory

-- ✅ Better (select needed columns)
SELECT id, username, email FROM users;
-- Returns only what's needed
-- Faster network transmission
-- Less memory usage
```

---

### 14. Missing Database Indexes

**Description:**
Queries on large tables without proper indexes cause full table scans.

**Example:**
```sql
-- ❌ Query without index (slow on large tables)
SELECT * FROM orders WHERE customer_id = 123;
-- Scans entire orders table (millions of rows)
-- Takes seconds/minutes

-- ✅ With index (fast)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
SELECT * FROM orders WHERE customer_id = 123;
-- Uses index to find rows instantly
-- Takes milliseconds
```

---

## Anti-Pattern Prevention Checklist

```
□ Code reviews (catch patterns early)
□ Static analysis tools (SonarQube, Pylint, ESLint)
□ Architecture reviews (ARB process)
□ Performance testing (load testing, profiling)
□ Monitoring and observability (identify issues in production)
□ Team training (share knowledge of patterns)
□ Documentation (record decisions and rationale)
□ Refactoring sprints (regular cleanup)
□ Metrics (track complexity, technical debt)
```

---

## Related Resources

- [Design Patterns](./design-patterns.md)
- [Architecture Principles](./principles.md)
- [Architecture Review Process](../processes/arb/README.md)
- [Performance Guide](../playbooks/performance-guide.md)
- [Security Guide](../playbooks/security-guide.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
