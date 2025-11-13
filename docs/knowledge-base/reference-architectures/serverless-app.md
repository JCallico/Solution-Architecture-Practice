# Serverless Application Reference Architecture

# Serverless Application Reference Architecture

## Overview

Modern serverless architecture for building scalable applications without managing infrastructure. Focuses on event-driven design, managed services, cost optimization, and operational excellence.

---

## Part 1: Architecture Overview

### 1.1 Serverless Components

```
External Triggers
├── HTTP Requests
├── Events (S3, SNS, SQS)
├── Scheduled Tasks
├── Database Changes
└── IoT Messages
          ↓
    API Gateway (HTTP)
          ↓
┌─────────────────────────────────────┐
│    Serverless Functions (Lambda)    │
│ ┌──────────────────────────────────┐│
│ │ Auth Function (JWT validation)   ││
│ │ Business Logic Functions         ││
│ │ Event Processors                 ││
│ │ Integrations                     ││
│ └──────────────────────────────────┘│
└─────────────────────────────────────┘
          ↓
    Managed Services
    ├─ Database (DynamoDB, Aurora)
    ├─ Storage (S3)
    ├─ Message Queue (SQS, SNS)
    ├─ Cache (ElastiCache)
    └─ Search (OpenSearch)
          ↓
    Outputs
    ├─ API Response (HTTP 200/400/500)
    ├─ Events (SNS/SQS)
    └─ Storage Updates
```

### 1.2 Serverless Characteristics

**No Infrastructure Management**:
- No servers to manage
- Auto-scaling built-in
- Patching/updates automatic
- Pay only for execution

**Event-Driven**:
- Functions triggered by events
- Asynchronous processing
- Decoupled services
- Event sources (HTTP, S3, DDB, etc)

**Limitations**:
- Cold starts (100-1000ms first invocation)
- Execution time limits (typically 15 minutes)
- Memory/CPU coupled
- Stateless (use external storage)

---

## Part 2: Function Design Patterns

### 2.1 HTTP API Handler

**REST Endpoint Pattern**:
```python
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('products')

def lambda_handler(event, context):
    """
    Handle HTTP API request
    event: API Gateway proxy event
    context: Lambda context
    """
    
    # Parse request
    http_method = event['httpMethod']
    path = event['path']
    body = json.loads(event.get('body', '{}'))
    
    # Authenticate
    token = event['headers'].get('Authorization', '')
    if not verify_token(token):
        return {
            'statusCode': 401,
            'body': json.dumps({'error': 'Unauthorized'})
        }
    
    try:
        if http_method == 'GET' and path == '/products':
            # List products
            response = table.scan(Limit=20)
            return {
                'statusCode': 200,
                'body': json.dumps(response['Items'], cls=DecimalEncoder)
            }
        
        elif http_method == 'GET':
            # Get single product
            product_id = path.split('/')[-1]
            response = table.get_item(Key={'id': product_id})
            if 'Item' not in response:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'error': 'Not found'})
                }
            return {
                'statusCode': 200,
                'body': json.dumps(response['Item'], cls=DecimalEncoder)
            }
        
        elif http_method == 'POST':
            # Create product
            product = {
                'id': str(uuid.uuid4()),
                'name': body['name'],
                'price': Decimal(body['price']),
                'created_at': datetime.utcnow().isoformat()
            }
            table.put_item(Item=product)
            
            # Publish event
            sns = boto3.client('sns')
            sns.publish(
                TopicArn=os.getenv('PRODUCT_CREATED_TOPIC'),
                Message=json.dumps(product, cls=DecimalEncoder),
                Subject='Product Created'
            )
            
            return {
                'statusCode': 201,
                'body': json.dumps(product, cls=DecimalEncoder)
            }
        
        else:
            return {
                'statusCode': 405,
                'body': json.dumps({'error': 'Method not allowed'})
            }
    
    except Exception as e:
        # Log error
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error'})
        }

class DecimalEncoder(json.JSONEncoder):
    """Helper for JSON encoding DynamoDB Decimal types"""
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super().default(o)
```

### 2.2 Asynchronous Event Processing

**Event Processing Pattern**:
```
Event Source (S3, DDB Streams, SNS)
    ↓
Lambda Function
  ├─ Parse event
  ├─ Process data
  ├─ Update state
  └─ Trigger downstream
```

**Example: S3 Image Processing**:
```python
import boto3
import json
from PIL import Image
from io import BytesIO

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

def lambda_handler(event, context):
    """
    Process S3 image upload events
    """
    # Parse S3 event
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        # Skip if not an image
        if not key.lower().endswith(('.jpg', '.png', '.jpeg')):
            continue
        
        # Download image
        obj = s3_client.get_object(Bucket=bucket, Key=key)
        image_data = obj['Body'].read()
        
        # Process image
        image = Image.open(BytesIO(image_data))
        
        # Generate thumbnail
        image.thumbnail((100, 100))
        thumb_io = BytesIO()
        image.save(thumb_io, format='JPEG')
        thumb_io.seek(0)
        
        # Upload thumbnail
        thumb_key = key.replace('.', '_thumb.')
        s3_client.put_object(
            Bucket=bucket,
            Key=thumb_key,
            Body=thumb_io.getvalue(),
            ContentType='image/jpeg'
        )
        
        # Queue for indexing
        sqs_client.send_message(
            QueueUrl=os.getenv('INDEX_QUEUE_URL'),
            MessageBody=json.dumps({
                'bucket': bucket,
                'original_key': key,
                'thumbnail_key': thumb_key
            })
        )
    
    return {
        'statusCode': 200,
        'body': 'Images processed'
    }
```

### 2.3 Scheduled Tasks

**Cron-Like Pattern**:
```python
def lambda_handler(event, context):
    """
    Scheduled task (triggered by EventBridge)
    Runs daily at 2 AM
    """
    # Check for stale data
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('sessions')
    
    # Scan for expired sessions
    response = table.scan(
        FilterExpression='expires_at < :now',
        ExpressionAttributeValues={
            ':now': int(datetime.utcnow().timestamp())
        }
    )
    
    # Delete expired items
    with table.batch_writer() as batch:
        for item in response['Items']:
            batch.delete_item(Key={'session_id': item['session_id']})
    
    # Log
    print(f"Deleted {len(response['Items'])} expired sessions")
    
    return {
        'statusCode': 200,
        'deleted_count': len(response['Items'])
    }
```

---

## Part 3: Core Serverless Services

### 3.1 API Gateway

**Configuration**:
```yaml
Resources:
  ApiGateway:
    Type: AWS::ApiGatewayV2::Api
    Properties:
      Name: ProductAPI
      ProtocolType: HTTP
  
  IntegrationRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: apigateway.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: InvokeLambda
          PolicyDocument:
            Statement:
              - Effect: Allow
                Action: lambda:InvokeFunction
                Resource: !GetAtt ProductFunction.Arn

  ProductRoute:
    Type: AWS::ApiGatewayV2::Route
    Properties:
      ApiId: !Ref ApiGateway
      RouteKey: GET /products
      Target: !Sub integrations/${ProductIntegration}
      AuthorizationType: JWT
      AuthorizerId: !Ref ApiAuthorizer

  ProductIntegration:
    Type: AWS::ApiGatewayV2::Integration
    Properties:
      ApiId: !Ref ApiGateway
      IntegrationType: AWS_PROXY
      IntegrationUri: !Sub arn:aws:apigatewayv2:${AWS::Region}:lambda:path/2015-03-31/functions/${ProductFunction.Arn}/invocations

  Authorizer:
    Type: AWS::ApiGatewayV2::Authorizer
    Properties:
      ApiId: !Ref ApiGateway
      AuthorizerType: JWT
      IdentitySource: $request.header.Authorization
      JwtConfiguration:
        Audience:
          - !Ref ApiAudience
        Issuer: !Ref TokenIssuer
```

### 3.2 DynamoDB (NoSQL Database)

**Table Design**:
```
Use DynamoDB for:
- High-scale applications
- Predictable latency
- Flexible schema
- Global distribution

Avoid:
- Complex JOINs
- Aggregations
- Ad-hoc queries

Table Design:

Products Table:
  PK: product_id (String)
  SK: (none - single partition)
  Attributes:
    - name (String)
    - price (Number)
    - inventory (Number)
    - created_at (String - ISO format)

Orders Table:
  PK: customer_id (String)
  SK: order_id (String)
  Attributes:
    - total (Number)
    - status (String)
    - items (List)
    - created_at (String)

GSI (Global Secondary Index):
  PK: status (String)
  SK: created_at (String)
  Purpose: Query orders by status and date

GSI2:
  PK: created_at (String)
  SK: (none)
  Purpose: Time-series queries
```

**DynamoDB Query Example**:
```python
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
orders_table = dynamodb.Table('orders')

# Query customer's orders
response = orders_table.query(
    KeyConditionExpression=Key('customer_id').eq('cust123')
)
customer_orders = response['Items']

# Query by GSI (status index)
response = orders_table.query(
    IndexName='status-created_at-index',
    KeyConditionExpression=Key('status').eq('PENDING')
)
pending_orders = response['Items']

# Scan with filter (expensive, avoid)
response = orders_table.scan(
    FilterExpression=Attr('total').gt(100)
)
large_orders = response['Items']
```

### 3.3 SQS (Message Queue)

**Asynchronous Processing**:
```
Event Source
    ↓
Lambda sends message to SQS
    ↓ Returns immediately
Consumer Lambda polls SQS
    ↓
Processes message
    ├─ Success: Deletes message
    └─ Failure: Message returns to queue (retry)
```

**Example**:
```python
# Producer: Send message
sqs = boto3.client('sqs')
sqs.send_message(
    QueueUrl='https://sqs.us-east-1.amazonaws.com/123456/ProcessQueue',
    MessageBody=json.dumps({
        'order_id': 'order123',
        'items': [...],
        'customer_id': 'cust456'
    }),
    MessageAttributes={
        'Priority': {
            'StringValue': 'high',
            'DataType': 'String'
        }
    }
)

# Consumer: Poll and process
def lambda_handler(event, context):
    for record in event['Records']:
        body = json.loads(record['body'])
        message_id = record['messageId']
        
        try:
            # Process message
            process_order(body)
            
            # Delete message (important!)
            sqs.delete_message(
                QueueUrl='...',
                ReceiptHandle=record['receiptHandle']
            )
        except Exception as e:
            # Failure: message stays in queue, retry
            print(f"Failed to process {message_id}: {e}")
            # Message will be re-delivered
```

### 3.4 S3 (Object Storage)

**Use Cases**:
- File uploads (documents, images)
- Static website hosting
- Data lake
- Log storage
- Backups

**Configuration**:
```yaml
Bucket:
  Type: AWS::S3::Bucket
  Properties:
    BucketName: myapp-uploads
    VersioningConfiguration:
      Status: Enabled  # Track versions
    PublicAccessBlockConfiguration:
      BlockPublicAcls: true
      BlockPublicPolicy: true
      IgnorePublicAcls: true
      RestrictPublicBuckets: true
    ServerSideEncryptionConfiguration:
      - ServerSideEncryptionByDefault:
          SSEAlgorithm: AES256  # Encryption at rest
    LifecycleConfiguration:
      Rules:
        - Id: ArchiveOldFiles
          Status: Enabled
          Transitions:
            - StorageClass: GLACIER
              TransitionInDays: 90  # Move to cheaper storage
        - Id: DeleteOldVersions
          Status: Enabled
          NoncurrentVersionExpirationInDays: 30

EventNotification:
  Type: AWS::S3::Bucket
  Properties:
    NotificationConfiguration:
      LambdaFunctionConfigurations:
        - Event: s3:ObjectCreated:*
          Function: !GetAtt ProcessImageFunction.Arn
          Filter:
            Key:
              FilterRules:
                - Name: prefix
                  Value: uploads/images/
                - Name: suffix
                  Value: .jpg
```

---

## Part 4: Cold Starts & Performance

### 4.1 Cold Start Causes & Solutions

**Cold Start**: First invocation after deployment or inactivity
- Language: Node.js (fastest), Python (medium), Java (slowest)
- Package size: Smaller = faster
- Dependencies: Fewer = faster
- Memory: Higher memory = faster CPU

**Optimization Techniques**:

1. **Reduce Package Size**:
```
Bad: 50MB package with unused dependencies
Good: 5MB package with only needed dependencies

- Remove dev dependencies
- Use tree-shaking (webpack)
- Use Lambda Layers for shared code
```

2. **Optimize Runtime**:
```
Cold start times (typical):
- Node.js: 100-300ms
- Python: 200-400ms
- Java: 1000-2000ms
- .NET: 500-1000ms

Choice: Node.js or Python for low latency
```

3. **Connection Pooling**:
```python
# Bad: Create connection per invocation
def lambda_handler(event, context):
    conn = create_db_connection()
    # Use conn
    # Connection closed, created fresh next time

# Good: Reuse connection across invocations
connection = None

def get_connection():
    global connection
    if connection is None:
        connection = create_db_connection()
    return connection

def lambda_handler(event, context):
    conn = get_connection()
    # Use conn
    # Connection stays open, reused next invocation
```

4. **Lambda Layers**:
```
/opt/python/  (Lambda sets PYTHONPATH)
├── numpy/
├── pandas/
├── requests/
└── ...

Function code: Just business logic (small)
Layers: Shared dependencies

Benefits:
- Smaller function package
- Faster deployment
- Code reuse across functions
```

### 4.2 Warm Starts

**Keep Functions Warm**:
```
CloudWatch Events rule: Every 5 minutes
  ↓
Invoke Lambda with test event
  ↓
Lambda keeps connection open, memory allocated
  ↓
Real invocations: Faster (warm)

Cost: Minimal (a few cents/month for test invocations)
```

---

## Part 5: Security in Serverless

### 5.1 IAM Permissions

**Least Privilege Principle**:
```yaml
LambdaRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: '2012-10-17'
      Statement:
        - Effect: Allow
          Principal:
            Service: lambda.amazonaws.com
          Action: sts:AssumeRole
    Policies:
      - PolicyName: DynamoDBAccess
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
            # Only allow reading from specific table
            - Effect: Allow
              Action:
                - dynamodb:GetItem
                - dynamodb:Query
              Resource: !GetAtt OrdersTable.Arn
            
            # Only allow putting to specific table
            - Effect: Allow
              Action:
                - dynamodb:PutItem
              Resource: !GetAtt AuditTable.Arn
            
            # Never allow: Scan, Delete, Update
            # Never allow: All actions on all tables
```

### 5.2 Secrets Management

**Using AWS Secrets Manager**:
```python
import boto3
import json
import os
from aws_lambda_powertools import Logger, Tracer

logger = Logger()
tracer = Tracer()

secrets_client = boto3.client('secretsmanager')
cache = {}

@tracer.capture_lambda_handler
def lambda_handler(event, context):
    secret = get_secret('prod/database-password')
    
    # Use secret
    conn = connect_to_database(
        host=secret['host'],
        user=secret['user'],
        password=secret['password']
    )

def get_secret(secret_id):
    """Get secret with caching"""
    if secret_id in cache:
        return cache[secret_id]
    
    try:
        response = secrets_client.get_secret_value(
            SecretId=secret_id
        )
        secret = json.loads(response['SecretString'])
        cache[secret_id] = secret
        return secret
    except Exception as e:
        logger.exception(f"Error retrieving secret {secret_id}")
        raise
```

### 5.3 Environment-Specific Secrets

**Development**:
```
No real secrets in code
Use AWS Secrets Manager
Rotate annually
```

**Production**:
```
Encrypted in Secrets Manager
Rotation every 30-90 days
Access logged and monitored
```

---

## Part 6: Monitoring & Observability

### 6.1 CloudWatch Logging

**Structured Logging**:
```python
import json
from aws_lambda_powertools import Logger

logger = Logger()

def lambda_handler(event, context):
    # Structured logging (JSON format)
    logger.info(
        "Processing order",
        extra={
            "order_id": "order123",
            "customer_id": "cust456",
            "amount": 99.99
        }
    )
    
    # CloudWatch can parse and filter
    # Query: fields @timestamp, @message | filter order_id = "order123"
```

### 6.2 X-Ray Tracing

**Distributed Tracing**:
```python
from aws_lambda_powertools import Tracer
from aws_xray_sdk.core import xray_recorder

tracer = Tracer()

@tracer.capture_lambda_handler
def lambda_handler(event, context):
    # Automatic tracing of Lambda execution
    
    @tracer.capture_method
    def process_order(order_id):
        # This method execution is traced
        db.query(order_id)
        return result
    
    return process_order("order123")

# Result: Complete request flow visible
# - Lambda execution time
- Database query time
# - Network latency
# - Bottlenecks identified
```

### 6.3 Metrics & Alarms

**CloudWatch Metrics**:
```yaml
AlarmHighErrorRate:
  Type: AWS::CloudWatch::Alarm
  Properties:
    MetricName: Errors
    Namespace: AWS/Lambda
    Statistic: Sum
    Period: 300  # 5 minutes
    EvaluationPeriods: 1
    Threshold: 10  # Alert if > 10 errors in 5 min
    ComparisonOperator: GreaterThanThreshold
    Dimensions:
      - Name: FunctionName
        Value: !Ref ProductFunction
    AlarmActions:
      - !Ref AlertTopic

AlarmHighDuration:
  Type: AWS::CloudWatch::Alarm
  Properties:
    MetricName: Duration
    Namespace: AWS/Lambda
    Statistic: Average
    Period: 300
    EvaluationPeriods: 2
    Threshold: 5000  # Alert if avg > 5 seconds
    ComparisonOperator: GreaterThanThreshold
```

---

## Part 7: Cost Optimization

**Pricing Model**:
```
Requests: $0.20 per million requests
Duration: $0.0000166667 per GB-second

Example:
100,000 requests/month
Average 512MB, 100ms duration

Cost:
- Requests: (100,000 / 1,000,000) * $0.20 = $0.02
- Duration: 100,000 * 0.1s * (512/1024) GB = 5,000 GB-s
  5,000 * $0.0000166667 = $0.083
- Free tier: 1M requests + 400,000 GB-s (covers most small apps)
- Total: ~$0 - $1/month
```

**Cost Reduction**:
```
1. Right-size memory: Higher memory = more CPU = faster = cheaper
   Test different memory levels

2. Optimize code: Reduce execution time
   - Cache external calls
   - Use efficient algorithms
   - Async processing

3. Use managed services: Less custom code needed
   - DynamoDB autoscaling
   - S3 lifecycle policies
   - SQS batch processing

4. Monitor usage: Set alarms for unexpected spikes
```

---

## Example Serverless Application

**E-Commerce Order Service**:
```
Endpoints:
- POST /orders: Create order
- GET /orders/{id}: Get order
- PUT /orders/{id}: Update order status
- GET /orders: List user's orders

Functions:
1. OrderAPI: HTTP handler, validates request, calls OrderService
2. OrderService: Business logic, reads/writes DynamoDB
3. OrderProcessor: Async processor, handles async workflows
4. PaymentService: Integrated payment processing
5. NotificationService: Send emails/SMS
6. ReportGenerator: Generate daily reports (scheduled)

Data:
- DynamoDB: Orders, Customers, Inventory
- S3: Receipts, Invoices
- SQS: Order processing queue, Email queue

Monitoring:
- CloudWatch Logs: Structured JSON logs
- X-Ray: Distributed tracing
- CloudWatch Alarms: Errors, latency, cost
```

---

## Related Resources

- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [AWS Serverless Application Lens](https://docs.aws.amazon.com/wellarchitected/latest/serverless-applications-lens/)
- [Cloud Patterns](../patterns/cloud-patterns.md)
- [Resilience Patterns](../patterns/resilience-patterns.md)
- [Security Guide](../playbooks/security-guide.md)
- [Performance Guide](../playbooks/performance-guide.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team

## Overview

Modern serverless application architecture leveraging cloud-native services.

## Coming Soon

### Serverless Components
- Function as a Service (FaaS)
- API Gateway
- Event-driven architecture
- Managed databases
- Object storage
- Message queues

### Architecture Patterns
- Event sourcing
- CQRS
- Choreography vs Orchestration
- Backend for Frontend (BFF)
- Fan-out/Fan-in
- Circuit breaker

### Implementation
- Cold start optimization
- Function composition
- State management
- Error handling
- Retry patterns
- Idempotency

### Operational Concerns
- Distributed tracing
- Centralized logging
- Metrics and alerting
- Cost optimization
- Performance tuning
- Security best practices

## Related Resources

- [Cloud Patterns](../patterns/cloud-patterns.md)
- [Integration Patterns](../patterns/integration-patterns.md)
- [Well-Architected Framework](../../frameworks/well-architected.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
