# Serverless Architecture

## Overview

Serverless architecture is a cloud computing model where the cloud provider manages server infrastructure, automatically scaling resources based on demand. Developers focus on code and business logic rather than infrastructure management.

## Core Concepts

### What is Serverless?

**Key Characteristics:**
- **No Server Management** - Provider handles infrastructure
- **Auto-Scaling** - Scales with demand automatically
- **Pay-per-Use** - Charged for actual consumption
- **Event-Driven** - Triggered by events
- **Stateless** - Functions don't maintain state between invocations

### Serverless vs Traditional

| Aspect | Traditional | Serverless |
|--------|------------|-----------|
| Infrastructure | Self-managed | Provider-managed |
| Scaling | Manual/auto-scaling groups | Automatic |
| Pricing | Always running | Pay per execution |
| Capacity Planning | Required | Unnecessary |
| Deployment | Server/container deployment | Function deployment |
| State | Can be stateful | Stateless by design |

### Function as a Service (FaaS)

Core serverless compute model:
- **Functions** - Small, single-purpose code units
- **Event Triggers** - HTTP, queue, schedule, storage, etc.
- **Ephemeral** - Short-lived execution (typically seconds to minutes)
- **Managed Runtime** - Provider handles execution environment

## Serverless Services

### Compute Services

**AWS:**
- **Lambda** - Event-driven functions
- **Fargate** - Serverless containers
- **Step Functions** - Workflow orchestration

**Azure:**
- **Functions** - Event-driven functions
- **Container Apps** - Serverless containers
- **Logic Apps** - Workflow automation
- **Durable Functions** - Stateful workflows

**Google Cloud:**
- **Cloud Functions** - Event-driven functions
- **Cloud Run** - Serverless containers
- **Workflows** - Service orchestration

### Storage Services

**Object Storage:**
- AWS S3
- Azure Blob Storage
- Google Cloud Storage

**Databases:**
- **AWS DynamoDB** - NoSQL database
- **Azure Cosmos DB** - Multi-model database
- **Google Firestore** - Document database
- **AWS Aurora Serverless** - Relational database

### Integration Services

**Messaging:**
- AWS SNS/SQS
- Azure Event Grid/Service Bus
- Google Cloud Pub/Sub

**API Management:**
- AWS API Gateway
- Azure API Management
- Google Cloud Endpoints

**Authentication:**
- AWS Cognito
- Azure AD B2C
- Firebase Authentication

## Architecture Patterns

### 1. API Backend

**Pattern:** Serverless functions behind API gateway.

```
Client → API Gateway → Lambda Function → Database
```

**Use Cases:**
- REST APIs
- GraphQL APIs
- Mobile backends
- Microservices

**Example (AWS):**
```javascript
// Lambda function
exports.handler = async (event) => {
  const { orderId } = JSON.parse(event.body);
  
  // Process order
  const order = await processOrder(orderId);
  
  return {
    statusCode: 200,
    body: JSON.stringify(order)
  };
};
```

**Configuration:**
```yaml
# AWS SAM template
Resources:
  OrderFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: index.handler
      Runtime: nodejs18.x
      Events:
        CreateOrder:
          Type: Api
          Properties:
            Path: /orders
            Method: post
```

### 2. Event Processing

**Pattern:** Functions triggered by events from various sources.

```
Event Source → Queue/Topic → Lambda Function → Storage
```

**Event Sources:**
- File uploads (S3, Blob Storage)
- Database changes (DynamoDB Streams, Cosmos DB Change Feed)
- Message queues (SQS, Service Bus)
- IoT events
- Custom events

**Example:**
```javascript
// Process uploaded image
exports.handler = async (event) => {
  for (const record of event.Records) {
    const bucket = record.s3.bucket.name;
    const key = record.s3.object.key;
    
    // Generate thumbnail
    const thumbnail = await createThumbnail(bucket, key);
    
    // Save to database
    await saveMetadata(key, thumbnail);
  }
};
```

### 3. Stream Processing

**Pattern:** Real-time data processing from streams.

```
Data Stream → Lambda → Aggregation → Storage/Analytics
```

**Stream Sources:**
- Kinesis Data Streams
- DynamoDB Streams
- Kafka (MSK)
- Event Hubs

**Example:**
```javascript
// Process click stream
exports.handler = async (event) => {
  const clickEvents = event.Records.map(record => 
    JSON.parse(Buffer.from(record.kinesis.data, 'base64').toString())
  );
  
  // Aggregate metrics
  const metrics = aggregateClicks(clickEvents);
  
  // Store in time-series database
  await storeMetrics(metrics);
};
```

### 4. Scheduled Tasks

**Pattern:** Cron-like scheduled execution.

```
CloudWatch Events/Schedule → Lambda → Task Execution
```

**Use Cases:**
- Data backups
- Report generation
- Cleanup tasks
- Monitoring checks

**Example:**
```yaml
ScheduledFunction:
  Type: AWS::Serverless::Function
  Properties:
    Handler: cleanup.handler
    Events:
      DailyCleanup:
        Type: Schedule
        Properties:
          Schedule: cron(0 2 * * ? *)  # 2 AM daily
```

### 5. Serverless Workflows

**Pattern:** Orchestrate multi-step processes.

```
Trigger → Step Functions → [Lambda1, Lambda2, Lambda3] → Result
```

**State Machine:**
```json
{
  "StartAt": "ProcessOrder",
  "States": {
    "ProcessOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:function:ProcessOrder",
      "Next": "ValidatePayment"
    },
    "ValidatePayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:function:ValidatePayment",
      "Next": "UpdateInventory"
    },
    "UpdateInventory": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:function:UpdateInventory",
      "End": true
    }
  }
}
```

### 6. Backend for Frontend (BFF)

**Pattern:** Dedicated serverless backend per client type.

```
Web App → API Gateway → Web BFF Functions → Services
Mobile App → API Gateway → Mobile BFF Functions → Services
```

**Benefits:**
- Optimized for each client
- Independent evolution
- Reduced coupling

## Design Patterns

### Function Composition

**Chain Functions:**
```javascript
// Main orchestrator
exports.handler = async (event) => {
  const validated = await lambda.invoke({
    FunctionName: 'ValidateFunction',
    Payload: JSON.stringify(event)
  }).promise();
  
  const processed = await lambda.invoke({
    FunctionName: 'ProcessFunction',
    Payload: validated.Payload
  }).promise();
  
  return processed;
};
```

### Fan-Out/Fan-In

**Pattern:** Parallel processing and aggregation.

```
Input → Fan-Out (SNS) → [Function1, Function2, Function3]
                      ↓
            Aggregator Function ← Results Queue
```

### Circuit Breaker

**Pattern:** Prevent cascade failures.

```javascript
const breaker = new CircuitBreaker(callExternalService, {
  timeout: 3000,
  errorThresholdPercentage: 50,
  resetTimeout: 30000
});

exports.handler = async (event) => {
  try {
    return await breaker.fire(event);
  } catch (error) {
    return fallbackResponse(error);
  }
};
```

### Bulkhead

**Pattern:** Isolate resources.

```javascript
// Separate functions for different workloads
- HighPriority-Function (more reserved capacity)
- LowPriority-Function (best effort)
```

## Best Practices

### Function Design

**Single Responsibility:**
```javascript
// Good: Focused function
exports.createOrder = async (event) => {
  // Only creates order
};

// Bad: Does too much
exports.processEverything = async (event) => {
  // Creates order, sends email, updates inventory...
};
```

**Keep Functions Small:**
- < 50MB deployment package (AWS Lambda)
- Minimal dependencies
- Fast cold start

**Externalize Configuration:**
```javascript
const { TABLE_NAME, API_ENDPOINT } = process.env;

exports.handler = async (event) => {
  // Use environment variables
  const table = dynamodb.Table(TABLE_NAME);
};
```

### Performance Optimization

**Minimize Cold Starts:**
- Keep functions warm (CloudWatch Events ping)
- Optimize package size
- Use provisioned concurrency
- Choose appropriate runtime

**Reuse Connections:**
```javascript
// Initialize outside handler
const dynamodb = new AWS.DynamoDB.DocumentClient();
const connection = await createDbConnection();

exports.handler = async (event) => {
  // Reuse connection across invocations
  const data = await dynamodb.get({...}).promise();
};
```

**Optimize Dependencies:**
```json
{
  "dependencies": {
    "aws-sdk": "^2.0.0"  // Use sparingly
  },
  "devDependencies": {
    "webpack": "^5.0.0"  // Bundle only needed code
  }
}
```

### Error Handling

**Graceful Degradation:**
```javascript
exports.handler = async (event) => {
  try {
    return await primaryService(event);
  } catch (error) {
    console.error('Primary service failed:', error);
    return await fallbackService(event);
  }
};
```

**Dead Letter Queues:**
```yaml
OrderFunction:
  Type: AWS::Serverless::Function
  Properties:
    DeadLetterQueue:
      Type: SQS
      TargetArn: !GetAtt FailedOrdersQueue.Arn
    ReservedConcurrentExecutions: 100
```

**Retry Strategy:**
```javascript
const retry = require('async-retry');

exports.handler = async (event) => {
  return await retry(async (bail) => {
    try {
      return await unreliableService();
    } catch (error) {
      if (error.statusCode === 400) {
        bail(error);  // Don't retry 4xx
      }
      throw error;  // Retry 5xx
    }
  }, {
    retries: 3,
    minTimeout: 1000,
    maxTimeout: 5000
  });
};
```

### Security

**Least Privilege IAM:**
```yaml
OrderFunctionRole:
  Type: AWS::IAM::Role
  Properties:
    Policies:
      - PolicyName: DynamoDBAccess
        PolicyDocument:
          Statement:
            - Effect: Allow
              Action:
                - dynamodb:GetItem
                - dynamodb:PutItem
              Resource: !GetAtt OrdersTable.Arn
```

**Environment Variables Encryption:**
```yaml
OrderFunction:
  Type: AWS::Serverless::Function
  Properties:
    Environment:
      Variables:
        API_KEY: !Ref EncryptedApiKey
    KmsKeyArn: !GetAtt KmsKey.Arn
```

**Input Validation:**
```javascript
const Joi = require('joi');

const orderSchema = Joi.object({
  customerId: Joi.string().required(),
  items: Joi.array().items(Joi.object({
    productId: Joi.string().required(),
    quantity: Joi.number().positive().required()
  })).required()
});

exports.handler = async (event) => {
  const { error, value } = orderSchema.validate(JSON.parse(event.body));
  
  if (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: error.details })
    };
  }
  
  // Process valid order
};
```

### Monitoring & Observability

**Structured Logging:**
```javascript
const logger = require('pino')();

exports.handler = async (event, context) => {
  logger.info({
    requestId: context.requestId,
    event: 'order.created',
    customerId: event.customerId
  });
  
  // Process order
};
```

**Custom Metrics:**
```javascript
const cloudwatch = new AWS.CloudWatch();

await cloudwatch.putMetricData({
  Namespace: 'OrderService',
  MetricData: [{
    MetricName: 'OrdersProcessed',
    Value: 1,
    Unit: 'Count',
    Timestamp: new Date(),
    Dimensions: [{ Name: 'Environment', Value: 'Production' }]
  }]
}).promise();
```

**Distributed Tracing:**
```javascript
const AWSXRay = require('aws-xray-sdk-core');
const AWS = AWSXRay.captureAWS(require('aws-sdk'));

exports.handler = async (event) => {
  const segment = AWSXRay.getSegment();
  const subsegment = segment.addNewSubsegment('ProcessOrder');
  
  try {
    // Process order
    subsegment.addAnnotation('orderId', orderId);
  } finally {
    subsegment.close();
  }
};
```

## Cost Optimization

### Right-Sizing Functions

**Memory Configuration:**
- Test different memory settings (128MB - 10GB)
- More memory = faster CPU + potentially faster execution
- Find sweet spot (cost vs performance)

**Timeout Configuration:**
- Set appropriate timeout (don't use max by default)
- Shorter timeout = lower cost on failures

### Reduce Invocations

**Batch Processing:**
```javascript
exports.handler = async (event) => {
  // Process records in batch
  const records = event.Records;
  const batchSize = 25;
  
  for (let i = 0; i < records.length; i += batchSize) {
    const batch = records.slice(i, i + batchSize);
    await processBatch(batch);
  }
};
```

**Caching:**
```javascript
const cache = new Map();

exports.handler = async (event) => {
  const cacheKey = event.productId;
  
  if (cache.has(cacheKey)) {
    return cache.get(cacheKey);
  }
  
  const product = await getProduct(event.productId);
  cache.set(cacheKey, product);
  
  return product;
};
```

### Use Reserved Capacity

For predictable workloads:
- AWS Lambda Provisioned Concurrency
- Azure Premium Functions
- Savings vs on-demand pricing

## Testing Strategies

### Unit Testing

```javascript
const { handler } = require('./index');

test('creates order successfully', async () => {
  const event = {
    body: JSON.stringify({
      customerId: '123',
      items: [{ productId: 'P1', quantity: 2 }]
    })
  };
  
  const result = await handler(event);
  
  expect(result.statusCode).toBe(201);
  expect(JSON.parse(result.body)).toHaveProperty('orderId');
});
```

### Integration Testing

```javascript
const AWS = require('aws-sdk');
const lambda = new AWS.Lambda({ region: 'us-east-1' });

test('order flow end-to-end', async () => {
  const result = await lambda.invoke({
    FunctionName: 'CreateOrderFunction',
    Payload: JSON.stringify({ customerId: '123' })
  }).promise();
  
  const order = JSON.parse(result.Payload);
  expect(order).toHaveProperty('orderId');
});
```

### Local Testing

**AWS SAM:**
```bash
# Start local API
sam local start-api

# Invoke function locally
sam local invoke OrderFunction -e events/order.json
```

**Azure Functions:**
```bash
# Start local runtime
func start

# Test function
curl http://localhost:7071/api/orders
```

**Serverless Framework:**
```bash
# Invoke function locally
serverless invoke local -f createOrder -d '{"customerId":"123"}'
```

## Deployment

### Infrastructure as Code

**AWS SAM:**
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  OrderFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: index.handler
      Runtime: nodejs18.x
      CodeUri: ./src
      Environment:
        Variables:
          TABLE_NAME: !Ref OrdersTable
      Policies:
        - DynamoDBCrudPolicy:
            TableName: !Ref OrdersTable
  
  OrdersTable:
    Type: AWS::DynamoDB::Table
    Properties:
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: orderId
          AttributeType: S
      KeySchema:
        - AttributeName: orderId
          KeyType: HASH
```

**Serverless Framework:**
```yaml
service: order-service

provider:
  name: aws
  runtime: nodejs18.x
  environment:
    TABLE_NAME: ${self:service}-${self:provider.stage}-orders

functions:
  createOrder:
    handler: handler.createOrder
    events:
      - http:
          path: orders
          method: post
    environment:
      TABLE_NAME: ${self:custom.tableName}

resources:
  Resources:
    OrdersTable:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: ${self:custom.tableName}
        BillingMode: PAY_PER_REQUEST
```

### CI/CD Pipeline

```yaml
# GitHub Actions
name: Deploy Serverless

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Deploy to AWS
        run: |
          npm install -g serverless
          serverless deploy --stage prod
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## Common Challenges & Solutions

### Cold Starts

**Problem:** First invocation slow due to initialization.

**Solutions:**
- Provisioned concurrency
- Keep functions warm
- Optimize package size
- Choose faster runtimes (Node.js, Python vs Java, .NET)

### Timeouts

**Problem:** Function exceeds maximum execution time.

**Solutions:**
- Break into smaller functions
- Use Step Functions for orchestration
- Async processing with queues

### Debugging

**Problem:** Hard to debug distributed systems.

**Solutions:**
- Comprehensive logging
- Distributed tracing (X-Ray, App Insights)
- Local testing tools
- Correlation IDs

### Vendor Lock-in

**Problem:** Hard to migrate between cloud providers.

**Solutions:**
- Abstract cloud-specific code
- Use multi-cloud frameworks
- Containerized functions (Cloud Run, Container Apps)

## Use Cases

### Web Applications
- API backends
- Static site generation
- Server-side rendering

### Data Processing
- ETL pipelines
- Real-time analytics
- Image/video processing

### IoT
- Device telemetry processing
- Real-time alerting
- Data aggregation

### Automation
- CI/CD pipelines
- Infrastructure automation
- Chatbots

### Integration
- Webhook handling
- Third-party API integration
- Event routing

## Related Resources

- [Event-Driven Architecture](./event-driven-architecture.md)
- [Microservices Architecture](./microservices.md)
- [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md)
- [API Design Playbook](../knowledge-base/playbooks/api-design-playbook.md)

## References

- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Google Cloud Functions](https://cloud.google.com/functions/docs)
- _Serverless Architectures on AWS_ by Peter Sbarski
- [Serverless Framework](https://www.serverless.com/)
- [AWS SAM](https://aws.amazon.com/serverless/sam/)

---

**Last Updated:** November 2025  
**Related:** [Event-Driven](./event-driven-architecture.md) | [Microservices](./microservices.md) | [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md)
