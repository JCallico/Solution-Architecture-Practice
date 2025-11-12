# Twelve-Factor App Methodology

## Overview

The Twelve-Factor App methodology is a set of best practices for building Software-as-a-Service (SaaS) applications that are:
- **Portable** - Run on any platform
- **Scalable** - Scale independently
- **Resilient** - Handle failures
- **Maintainable** - Easy to modify
- **Deployable** - Simple to deploy

The methodology was developed from experience building and running hundreds of applications and thousands of developer-hours in the Heroku ecosystem.

## The Twelve Factors

### 1. Codebase

**Principle:** One codebase tracked in version control, many deploys.

**Requirements:**
- Single source of truth for code
- Version control (Git) for all code
- One codebase per application
- Multiple instances can exist (production, staging, development)

**Best Practices:**

```bash
# Good: Single repo with one app
solution-architecture-practice/
  ├── src/
  ├── config/
  ├── tests/
  └── .git/

# Bad: Multiple codebases or no version control
app-code/
service-code/
legacy-code/
```

**Key Guidance:**
- Never mix code from multiple applications
- Use branches for feature development
- Tag releases in version control
- Keep codebase in sync across environments

**Deployment Strategy:**
```
Main Branch → Build → Test → Deploy to Staging → Deploy to Prod
  ↓
All deploys come from same codebase
  ↓
Different config for each environment
```

### 2. Dependencies

**Principle:** Explicitly declare and isolate dependencies.

**Requirements:**
- Declare all dependencies explicitly
- Isolate dependencies from system packages
- Never rely on system-wide packages
- Include dependency versions

**Best Practices:**

```
JavaScript (Node.js):
  package.json - Declares dependencies
  npm install/yarn install - Installs from lock file

Python:
  requirements.txt - Declares dependencies
  pip install - Installs specified versions

Java:
  pom.xml - Maven dependency management
  build.gradle - Gradle dependency management

Ruby:
  Gemfile - Declares gems
  Bundler - Isolates gems
```

**Implementation Example:**

```javascript
// package.json - Explicit declaration with version
{
  "name": "my-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "dotenv": "^16.0.0",
    "postgresql": "^4.0.0"
  }
}

// package-lock.json - Lock file ensures reproducibility
{
  "dependencies": {
    "express": {
      "version": "4.18.2"
    }
  }
}
```

**Containerization:**
```dockerfile
# Dockerfile - Dependencies explicitly declared
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

CMD ["node", "index.js"]
```

**Key Guidance:**
- Use version pinning (avoid latest)
- Use lock files for reproducibility
- Don't assume system libraries exist
- Document dependency requirements
- Use containers for isolation

### 3. Config

**Principle:** Store configuration in environment variables.

**Requirements:**
- Separate code from configuration
- Never store secrets in codebase
- Use environment variables for all config
- Config changes without code changes

**What is Config:**
```
✅ Database URL
✅ API keys
✅ Feature flags
✅ Logging levels
✅ Cache settings

❌ Application code
❌ Static assets
❌ Constants (hardcoded)
```

**Best Practices:**

```javascript
// Good: Config from environment
const config = {
  databaseUrl: process.env.DATABASE_URL,
  apiKey: process.env.API_KEY,
  logLevel: process.env.LOG_LEVEL || 'info',
  nodeEnv: process.env.NODE_ENV
};

// Bad: Config in code
const config = {
  databaseUrl: 'postgres://user:pass@host/db',
  apiKey: 'secret-key-12345',
  logLevel: 'debug'
};
```

**Environment Variable Management:**

```bash
# .env file (local development only, never commit)
DATABASE_URL=postgres://localhost/mydb
API_KEY=dev-key-12345
LOG_LEVEL=debug

# Load in application
require('dotenv').config();
const dbUrl = process.env.DATABASE_URL;
```

**Configuration by Environment:**

```
Development:
  DATABASE_URL=postgres://localhost/mydb_dev
  LOG_LEVEL=debug
  DEBUG=true

Staging:
  DATABASE_URL=postgres://db-staging.internal/mydb
  LOG_LEVEL=info
  DEBUG=false

Production:
  DATABASE_URL=postgres://db-prod.internal/mydb
  LOG_LEVEL=error
  DEBUG=false
```

**Secrets Management:**
- AWS Secrets Manager
- Azure Key Vault
- HashiCorp Vault
- Kubernetes Secrets
- Never store in version control

**Key Guidance:**
- Environment variables for all config
- No config in code
- Different config per deployment
- Secrets never in repository
- Document all configuration options

### 4. Backing Services

**Principle:** Treat backing services as attached resources.

**Concept:** A backing service is any service consumed over the network as part of application operation.

**Examples:**
```
Databases:
  - PostgreSQL
  - MySQL
  - MongoDB
  - DynamoDB

Cache:
  - Redis
  - Memcached

Message Queues:
  - RabbitMQ
  - SQS
  - Kafka

External Services:
  - Email (SendGrid)
  - SMS (Twilio)
  - Payment (Stripe)
  - Analytics
```

**Best Practices:**

```javascript
// Good: Backing service as attached resource
const db = new Database(process.env.DATABASE_URL);
const cache = new Redis(process.env.REDIS_URL);
const email = new EmailService(process.env.EMAIL_API_KEY);

// Resource can be switched by changing URL
// Dev: local PostgreSQL
// Prod: managed RDS

// Can easily swap implementations
const cache = process.env.CACHE_TYPE === 'redis' 
  ? new Redis(process.env.REDIS_URL)
  : new Memcached(process.env.MEMCACHED_URL);
```

**Loose Coupling:**
- No hardcoded connections
- Connection via configuration
- Treat all services equally
- No difference between local/remote

**Resource Pooling:**
```javascript
// Use connection pooling
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,        // max pool size
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Reuse connections
const client = await pool.connect();
try {
  const result = await client.query('SELECT * FROM users');
} finally {
  client.release();
}
```

**Health Checks:**
```javascript
// Verify backing service is available
app.get('/health', async (req, res) => {
  try {
    await db.query('SELECT 1');
    await redis.ping();
    res.status(200).json({ status: 'healthy' });
  } catch (error) {
    res.status(503).json({ status: 'unhealthy', error: error.message });
  }
});
```

**Key Guidance:**
- Resources via URLs/connection strings
- Switch resources by changing config
- No difference local vs production
- Implement retry logic
- Monitor backing service health

### 5. Build, Release, Run

**Principle:** Strictly separate build, release, and run stages.

**Stages:**

```
Code → Build → Release → Run
↓       ↓       ↓        ↓
Source  Artifact Release  Process
        (Compiled) (Deployed)
```

**Build Stage:**
- Compile code
- Fetch dependencies
- Run tests
- Create artifact (Docker image, JAR, binary)

**Release Stage:**
- Take build artifact
- Combine with configuration
- Create release (versioned)
- Tag and version

**Run Stage:**
- Start release in execution environment
- No further changes
- Stateless processes

**Implementation Example:**

```bash
# Build Stage
docker build -t myapp:1.0.0 .
# Produces: myapp:1.0.0 image

# Release Stage
docker run -e DATABASE_URL=... myapp:1.0.0
docker push myregistry.com/myapp:1.0.0
# Config and artifact combined, versioned as release

# Run Stage
kubectl run myapp:1.0.0 --env DATABASE_URL=...
# Immutable artifact runs with specific config
```

**Best Practices:**

```yaml
CI/CD Pipeline:
  Build:
    - Checkout code
    - Install dependencies
    - Run tests
    - Compile/package
    - Build Docker image
    - Push to registry

  Release:
    - Pull build artifact
    - Tag release version
    - Deploy to staging
    - Run smoke tests
    - Deploy to production

  Run:
    - Start container/process
    - Monitor health
    - Handle crashes (restart)
```

**Key Guidance:**
- Automate all stages
- Each release is immutable
- Build once, deploy many
- Production code is not modified
- No hotfixes in production

### 6. Processes

**Principle:** Execute app as one or more stateless processes.

**Requirements:**
- Processes are stateless
- Session data in backing service
- No sticky sessions
- Horizontal scalability

**Stateless Design:**

```javascript
// Bad: State in process memory
let cache = {};

app.get('/user/:id', (req, res) => {
  if (cache[req.params.id]) {
    return res.json(cache[req.params.id]);
  }
  // If this process dies, cache is lost
  // Scales only within single process
});

// Good: State in backing service
app.get('/user/:id', async (req, res) => {
  // Query from persistent store
  const user = await db.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
  // Or from cache service
  const cached = await redis.get(`user:${req.params.id}`);
  res.json(cached || user);
});
```

**Session Management:**

```
Approach: Store sessions in Redis/Database
├── User logs in
├── Session stored in Redis
├── Client gets session ID (cookie)
├── Subsequent requests use session ID
├── Any process can handle request (stateless)
└── Session persists across process restarts

Not Approach: Store sessions in process memory
├── User logs in
├── Session stored in process memory
├── Client gets cookie
├── Must route to same process (sticky sessions)
├── If process crashes, session lost
└── Difficult to scale horizontally
```

**File System Considerations:**

```javascript
// Bad: Writing to local file system
fs.writeFileSync('/tmp/cache.txt', data);
// Lost when process restarts
// Not shared across processes

// Good: Use backing service
await s3.putObject({
  Bucket: 'myapp-files',
  Key: `cache-${timestamp}.txt`,
  Body: data
});
// Persists across restarts
// Shared across all processes
```

**Key Guidance:**
- No local state
- Use backing services for state
- Restart processes without data loss
- Scale by adding processes
- Implement request routing

### 7. Port Binding

**Principle:** Export HTTP service via port binding.

**Concept:** App is completely self-contained and exports HTTP service by binding to a port.

**Requirements:**
- Self-contained application
- No application server required
- Export HTTP service via port
- Other apps can use as backing service

**Best Practices:**

```javascript
// Node.js - Self-contained HTTP server
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World');
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

```python
# Python - Self-contained HTTP server
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World'

if __name__ == '__main__':
    port = os.getenv('PORT', 3000)
    app.run(host='0.0.0.0', port=port)
```

```java
// Java - Self-contained with embedded server
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
// Embedded Tomcat server included in JAR
```

**One App Consuming Another:**

```javascript
// Service A
const app = require('./serviceA');
// Export as module
module.exports = app;

// Service B can use Service A
const fetch = require('node-fetch');
const response = await fetch('http://service-a:3000/');

// Or in code as library
const serviceA = require('service-a');
const result = await serviceA.someMethod();
```

**Port Configuration:**

```
Development:
  PORT=3000
  APP_URL=http://localhost:3000

Staging:
  PORT=8080
  APP_URL=https://staging.example.com

Production:
  PORT=3000 (behind load balancer)
  APP_URL=https://api.example.com
```

**Key Guidance:**
- No external application server
- HTTP service self-contained
- Export via port binding
- Configurable port
- Stateless HTTP service

### 8. Concurrency

**Principle:** Scale out via the process model.

**Concept:** Use process model for concurrency and scaling.

**Process Model:**
```
Web process:      Handles HTTP requests
Worker process:   Handles background jobs
Admin process:    One-off tasks
```

**Examples:**

```bash
# Production configuration
web=4          # 4 web processes
worker=2       # 2 background workers
scheduler=1    # 1 scheduling process
```

**Scaling:**

```
1. Scale out by adding processes
   4 web processes → 8 web processes (double throughput)

2. Process manager handles restarts
   Process crashes → automatically restarted

3. Load balancer distributes requests
   Requests distributed across processes
```

**Implementation:**

```javascript
// Process type: web
if (process.env.PROCESS_TYPE === 'web') {
  const express = require('express');
  const app = express();
  app.listen(process.env.PORT);
}

// Process type: worker
if (process.env.PROCESS_TYPE === 'worker') {
  const queue = require('./queue');
  queue.process(async (job) => {
    await processJob(job);
  });
}

// Process type: scheduler
if (process.env.PROCESS_TYPE === 'scheduler') {
  setInterval(async () => {
    await runScheduledTask();
  }, process.env.SCHEDULE_INTERVAL);
}
```

**Docker Compose Example:**

```yaml
version: '3'
services:
  web:
    build: .
    environment:
      - PROCESS_TYPE=web
      - PORT=3000
    ports:
      - "80:3000"
    depends_on:
      - db
      - queue

  worker:
    build: .
    environment:
      - PROCESS_TYPE=worker
    depends_on:
      - db
      - queue

  scheduler:
    build: .
    environment:
      - PROCESS_TYPE=scheduler
    depends_on:
      - db
```

**Key Guidance:**
- Use process manager (systemd, docker, Kubernetes)
- Each process type handles one responsibility
- Horizontal scaling via process count
- Automatic process restarts
- Load balancing across processes

### 9. Disposability

**Principle:** Maximize robustness with fast startup and graceful shutdown.

**Fast Startup:**
- Quick application initialization
- Minimal startup dependencies
- Lazy-load when possible
- Ready to handle requests quickly

**Graceful Shutdown:**
- Finish in-flight requests
- Close connections cleanly
- Persist data before exit
- Handle SIGTERM signal

**Best Practices:**

```javascript
const express = require('express');
const app = express();
let server;

// Fast startup
async function start() {
  // Minimal initialization
  await db.connect();
  
  server = app.listen(process.env.PORT, () => {
    console.log('Ready');
  });
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully');
  
  // Stop accepting new requests
  server.close();
  
  // Wait for in-flight requests to complete
  // (typically 30 seconds)
  setTimeout(() => {
    process.exit(0);
  }, 30000);
});

start();
```

**Docker Implementation:**

```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY . .
RUN npm ci --only=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

ENTRYPOINT ["node", "server.js"]

# Properly forwards signals for graceful shutdown
```

**Kubernetes Implementation:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: myapp
    image: myapp:1.0.0
    # Allows time for graceful shutdown
    terminationGracePeriodSeconds: 30
    lifecycle:
      preStop:
        exec:
          command: ["/bin/sh", "-c", "sleep 15"]
```

**Key Guidance:**
- Fast startup (seconds not minutes)
- Handle SIGTERM signal
- Close connections properly
- Persist in-flight work
- Automatic restart on crash

### 10. Dev/Prod Parity

**Principle:** Keep development, staging, and production as similar as possible.

**The Three Gaps:**

**1. Time Gap**
- Dev: code written Monday
- Prod: deployed Friday
- **Solution:** Deploy frequently (daily/hourly)

**2. Personnel Gap**
- Dev: developer makes code changes
- Ops: operations deploys to production
- **Solution:** Developers control deployment

**3. Tools Gap**
- Dev: SQLite database
- Prod: PostgreSQL database
- **Solution:** Same databases everywhere

**Best Practices:**

```
Development:
  - Docker running full app stack
  - Same versions as production
  - Realistic data (sample or production copy)
  - Same external services (or mocks)

Staging:
  - Exact production replica
  - Same infrastructure setup
  - Same scaling configuration
  - Real load testing

Production:
  - Same as staging
  - Same code, config, processes
  - Full monitoring and alerting
```

**Infrastructure as Code:**

```yaml
# Same infrastructure definition for all environments
# Infrastructure/main.tf
resource "aws_rds_instance" "db" {
  engine            = "postgres"
  engine_version    = "14.5"
  instance_class    = var.instance_class
  allocated_storage  = var.storage_size
  # Other parameters...
}

# Development: variables.tf
variable "instance_class" {
  default = "db.t3.small"  # Small instance
}

# Production: variables.tf
variable "instance_class" {
  default = "db.r5.xlarge"  # Large instance
}
```

**Dependency Versions:**

```
Dev:        Python 3.11, PostgreSQL 14, Redis 7
Staging:    Python 3.11, PostgreSQL 14, Redis 7
Production: Python 3.11, PostgreSQL 14, Redis 7

NOT:
Dev:        Python 3.9, SQLite, Local cache
Production: Python 3.11, PostgreSQL 14, Redis (cluster)
```

**Key Guidance:**
- Same technology across environments
- Same versions everywhere
- Automate deployments
- Frequent deploys reduce risk
- Staging matches production

### 11. Logs

**Principle:** Treat logs as event streams.

**Concept:** App writes logs to stdout; execution environment captures and routes.

**Best Practices:**

```javascript
// Good: Write to stdout
console.log('User login', { userId: '123', timestamp: new Date() });
console.error('Database connection failed', error);

// Good: Structured logging
const logger = require('winston');
logger.info('Order created', {
  orderId: '456',
  customerId: '123',
  amount: 99.99
});

// Bad: Write to files
fs.appendFileSync('/var/log/myapp.log', 'User login\n');

// Bad: Unstructured logs
console.log('stuff happened');
```

**Structured Logging:**

```javascript
// Winston example
const logger = require('winston');

logger.info('Payment processed', {
  paymentId: 'pay_123',
  amount: 100.00,
  currency: 'USD',
  status: 'success',
  processingTime: 245
});

// Output:
// {"level":"info","message":"Payment processed","paymentId":"pay_123","amount":100,...}
```

**Log Aggregation:**

```
Application → stdout
              ↓
        Log Router (Docker/Kubernetes)
              ↓
        Log Aggregation Service
              ↓
        [CloudWatch, Datadog, ELK, Splunk]
              ↓
        Analysis, Alerting, Dashboards
```

**Log Levels:**

```
DEBUG:   Detailed diagnostic information
INFO:    Confirms normal operation
WARNING: Something unexpected happened
ERROR:   Serious problem, functionality impaired
FATAL:   Critical problem, application may fail
```

**Searching & Analysis:**

```
All logs in central location:
  - Search by timestamp
  - Filter by level/service/user
  - Aggregate metrics
  - Create dashboards
  - Set alerts
  - Track trends
```

**Key Guidance:**
- Write to stdout
- Never write to files in app
- Execution environment captures logs
- Use structured logging
- Central log aggregation
- Long-term storage for compliance

### 12. Admin Processes

**Principle:** Run admin/management tasks as one-off processes.

**Concept:** One-off administrative and maintenance tasks run in identical environment to app.

**Examples:**
- Database migrations
- User account creation
- Script execution
- Data cleanup
- One-time calculations

**Best Practices:**

```bash
# Admin task: Database migration
# Same environment as production
docker run -e DATABASE_URL=... myapp:1.0.0 \
  node scripts/migrate.js

# Admin task: Create user
docker run -e DATABASE_URL=... myapp:1.0.0 \
  node scripts/create-user.js admin@example.com

# Admin task: Data cleanup
docker run -e DATABASE_URL=... myapp:1.0.0 \
  node scripts/cleanup-expired.js

# Admin task: One-off report
docker run -e DATABASE_URL=... myapp:1.0.0 \
  node scripts/generate-report.js > report.csv
```

**Implementation:**

```javascript
// scripts/migrate.js - Database migration
const db = require('../src/db');

async function migrate() {
  console.log('Starting migration...');
  await db.query('ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT false');
  await db.query('CREATE INDEX idx_users_email ON users(email)');
  console.log('Migration complete');
  process.exit(0);
}

migrate().catch(error => {
  console.error('Migration failed:', error);
  process.exit(1);
});

// scripts/create-user.js - User creation
const db = require('../src/db');

async function createUser(email) {
  const result = await db.query(
    'INSERT INTO users (email) VALUES ($1) RETURNING id, email',
    [email]
  );
  console.log('User created:', result.rows[0]);
  process.exit(0);
}

const email = process.argv[2];
if (!email) {
  console.error('Email required');
  process.exit(1);
}

createUser(email).catch(error => {
  console.error('Failed to create user:', error);
  process.exit(1);
});
```

**Kubernetes Implementation:**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  template:
    spec:
      containers:
      - name: migration
        image: myapp:1.0.0
        command: ["node", "scripts/migrate.js"]
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
      restartPolicy: Never
  backoffLimit: 1
```

**Scheduled Admin Tasks:**

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cleanup-job
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cleanup
            image: myapp:1.0.0
            command: ["node", "scripts/cleanup.js"]
            env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: database-url
          restartPolicy: OnFailure
```

**Key Guidance:**
- Same codebase as app
- Same environment/config as production
- One-off process, exits on completion
- Scriptable for automation
- Tracked in version control
- Include error handling

## Summary Table

| Factor | Principle | Key Point |
|--------|-----------|-----------|
| 1 | Codebase | One repo, many deploys |
| 2 | Dependencies | Explicit declaration |
| 3 | Config | Environment variables |
| 4 | Backing Services | Attached resources |
| 5 | Build, Release, Run | Strict separation |
| 6 | Processes | Stateless |
| 7 | Port Binding | Self-contained |
| 8 | Concurrency | Process model |
| 9 | Disposability | Fast startup, graceful shutdown |
| 10 | Dev/Prod Parity | Same everywhere |
| 11 | Logs | Stdout streams |
| 12 | Admin Processes | One-off processes |

## Applying Twelve-Factor to Microservices

Each microservice should follow all twelve factors:

```
OrderService:
  ✓ Single codebase in Git
  ✓ Dependencies in package.json
  ✓ Config via environment variables
  ✓ Connects to databases as backing services
  ✓ Build/release/run stages in CI/CD
  ✓ Stateless request handling
  ✓ Exports HTTP via port
  ✓ Scales via process count
  ✓ Fast startup and graceful shutdown
  ✓ Dev/prod parity with containers
  ✓ Logs to stdout
  ✓ Admin tasks as one-off processes
```

## Twelve-Factor in Practice

### Real-World Example: E-commerce API

```
Codebase:
  GitHub repository with main branch

Dependencies:
  package.json with all npm dependencies
  Dockerfile specifies base image

Configuration:
  DATABASE_URL, API_KEYS in environment
  .env for local, secrets manager for production

Backing Services:
  PostgreSQL (RDS)
  Redis (ElastiCache)
  S3 (file storage)

Build/Release/Run:
  GitHub Actions builds Docker image
  Image pushed to ECR
  Deploy to ECS with config

Processes:
  Web process (handles API requests)
  Worker process (background jobs)
  Scheduler (cron tasks)

Port Binding:
  Node.js Express server on port 3000

Concurrency:
  4 web processes, 2 workers

Disposability:
  Docker container starts in 3 seconds
  SIGTERM handled gracefully

Dev/Prod Parity:
  Docker Compose locally
  ECS Fargate in production
  Same images, different config

Logs:
  Winston logger outputs JSON to stdout
  CloudWatch collects logs

Admin:
  Database migration script
  Scheduled cleanup job
```

## Benefits of Twelve-Factor

✅ **Portability** - Run anywhere (local, cloud, on-premise)  
✅ **Scalability** - Easy to scale horizontally  
✅ **Resilience** - Handles failures gracefully  
✅ **Maintainability** - Clear structure and patterns  
✅ **Deployability** - Automated, safe deployments  
✅ **Testability** - Dependencies injectable, configurations flexible  

## Related Resources

- [Event-Driven Architecture](./event-driven-architecture.md)
- [Microservices Architecture](./microservices.md)
- [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md)
- [Application Playbook](../knowledge-base/playbooks/application-architecture-playbook.md)

## References

- [12factor.net](https://12factor.net/)
- [The Twelve-Factor App Methodology](https://adamwathan.me/12-factor-apps-with-docker-and-rails/)
- _12 Factor Apps with Docker and Rails_ by Adam Wathan
- [Heroku Dev Center](https://devcenter.heroku.com/)

---

**Last Updated:** November 2025  
**Related:** [Microservices](./microservices.md) | [Event-Driven](./event-driven-architecture.md) | [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md)
