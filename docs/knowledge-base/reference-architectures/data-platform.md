# Data Platform Reference Architecture

## Overview

Enterprise-grade Data Platform supporting ingestion, storage, processing, analysis, and governance of data at scale. Supports batch and real-time processing with comprehensive security and compliance.

---

## Part 1: Architecture Overview

### 1.1 High-Level Data Architecture

```
┌───────────────────────────────────────────────┐
│            Data Sources                       │
│  (APIs, Databases, Logs, Events, Files)      │
└──────────────────┬──────────────────────────┘
                   │
        ┌──────────▼──────────┐
        │ Ingestion Layer     │
        │ (ETL/ELT, Streams)  │
        └──────────┬──────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
┌───▼────┐  ┌─────▼─────┐  ┌────▼───┐
│ Batch  │  │Real-Time  │  │Streaming│
│Lake    │  │Processing │  │Processing
└───┬────┘  └─────┬─────┘  └────┬───┘
    │              │              │
    └──────────────┼──────────────┘
                   │
        ┌──────────▼──────────┐
        │Storage Layer        │
        │(Data Lake/DW/Cache) │
        └──────────┬──────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
┌───▼────┐  ┌─────▼─────┐  ┌────▼───┐
│ Data   │  │Analytics/ │  │Real-Time│
│ Lake   │  │BI Tools   │  │Dashboards
└────────┘  └───────────┘  └────────┘
```

### 1.2 Platform Capabilities

**Data Processing**:
- Batch: Daily/hourly jobs
- Real-time: Streaming data
- Hybrid: Lambda architecture

**Data Storage**:
- Data Lake (raw, unstructured)
- Data Warehouse (structured, optimized)
- Operational DB (transactional)
- Cache (fast access)

**Data Quality**:
- Validation rules
- Data profiling
- Lineage tracking
- Reconciliation

**Analytics & BI**:
- SQL querying
- OLAP cubes
- Dashboards
- Self-service BI

**Governance**:
- Data catalog
- Data lineage
- Access controls
- Compliance monitoring

---

## Part 2: Platform Components

### 2.1 Data Ingestion

**Batch Ingestion**:
```
Data Sources
  ↓
Scheduled Job (Airflow, Glue)
  ├─ Connect to source
  ├─ Extract data
  ├─ Transform (if needed)
  └─ Load to lake/warehouse
  ↓
Notification
  ├─ Success: Record count, duration
  └─ Failure: Error details, retry
```

**Example ETL Job (Airflow)**:
```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

def extract_from_api(**context):
    """Extract data from source API"""
    response = requests.get('https://api.example.com/orders')
    data = response.json()
    # Save to temporary location
    with open('/tmp/orders.json', 'w') as f:
        json.dump(data, f)

def transform_data(**context):
    """Transform extracted data"""
    with open('/tmp/orders.json', 'r') as f:
        data = json.load(f)
    
    # Transform: flatten nested JSON
    flattened = []
    for order in data['orders']:
        for item in order['items']:
            flattened.append({
                'order_id': order['id'],
                'item_id': item['id'],
                'quantity': item['quantity'],
                'price': item['price']
            })
    
    with open('/tmp/orders_transformed.csv', 'w') as f:
        writer = csv.DictWriter(f, fieldnames=flattened[0].keys())
        writer.writeheader()
        writer.writerows(flattened)

def load_to_warehouse(**context):
    """Load to data warehouse"""
    with psycopg2.connect(db_config) as conn:
        cursor = conn.cursor()
        with open('/tmp/orders_transformed.csv', 'r') as f:
            cursor.copy_from(f, 'orders_staging', sep=',')
        
        # Merge into main table
        cursor.execute('''
            MERGE INTO orders_fact o
            USING orders_staging s
            ON o.order_id = s.order_id
            WHEN MATCHED THEN UPDATE SET quantity = s.quantity
            WHEN NOT MATCHED THEN INSERT VALUES (s.*)
        ''')
        conn.commit()

# Define DAG
dag = DAG(
    'daily_orders_etl',
    default_args={
        'owner': 'data_team',
        'retries': 2,
        'retry_delay': timedelta(minutes=5),
        'start_date': datetime(2025, 1, 1)
    },
    schedule_interval='0 2 * * *'  # 2 AM daily
)

# Define tasks
extract = PythonOperator(
    task_id='extract',
    python_callable=extract_from_api,
    dag=dag
)

transform = PythonOperator(
    task_id='transform',
    python_callable=transform_data,
    dag=dag
)

load = PythonOperator(
    task_id='load',
    python_callable=load_to_warehouse,
    dag=dag
)

# Set dependencies
extract >> transform >> load
```

**Streaming Ingestion**:
```
Event Source
  ↓
Kafka / Kinesis (message broker)
  ├─ Buffer events
  ├─ Multiple consumers
  └─ Replay support
  ↓
Stream Processor (Spark, Flink)
  ├─ Parse events
  ├─ Transform in real-time
  ├─ Aggregate by time window
  └─ Write results
  ↓
Storage
  ├─ Real-time database (fast writes)
  ├─ Data lake (for analytics)
  └─ Cache (for serving)
```

**Example Kafka Consumer**:
```python
from kafka import KafkaConsumer
import json
from datetime import datetime

consumer = KafkaConsumer(
    'user_events',
    bootstrap_servers=['kafka:9092'],
    group_id='analytics_group',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    event = message.value
    
    # Transform
    enriched_event = {
        'timestamp': datetime.utcnow().isoformat(),
        'user_id': event['user_id'],
        'event_type': event['type'],
        'properties': event.get('properties', {})
    }
    
    # Load to analytics warehouse
    insert_to_warehouse(enriched_event)
```

### 2.2 Data Storage

**Data Lake**:
```
Purpose: Store raw, unstructured data
Structure: File-based (S3, ADLS, GCS)
Format: Parquet, ORC, JSON, CSV, Avro

Organization:
/data-lake
├── /raw
│   ├── /crm
│   ├── /erp
│   └── /logs
├── /processed
│   ├── /customer
│   ├── /orders
│   └── /inventory
└── /curated
    ├── /gold
    └── /silver

Partitioning:
/raw/crm/contacts/year=2025/month=01/day=15/data.parquet

Metadata:
- Apache Hudi: Track data versioning
- Apache Iceberg: ACID transactions
- Delta Lake: Schema evolution
```

**Data Warehouse**:
```
Purpose: Store structured, optimized data
Structure: RDBMS or columnar database
Format: Fully normalized or star schema

Star Schema (common BI schema):
        Dimension: Date
             │
Customer ─ Fact Table ─ Product
             │
        Dimension: Location

Example:
Fact Table (Orders):
  order_id (PK)
  date_key (FK)
  customer_key (FK)
  product_key (FK)
  quantity
  amount

Dimension Table (Customers):
  customer_key (PK)
  customer_id
  name
  email
  segment
  created_date

Dimension Table (Dates):
  date_key (PK)
  date
  year
  month
  quarter
  day_of_week
```

**Example Data Warehouse Query**:
```sql
-- BI analyst query
SELECT 
  d.year,
  d.quarter,
  c.segment,
  p.category,
  SUM(f.amount) as total_sales,
  COUNT(DISTINCT f.order_id) as order_count,
  AVG(f.amount) as avg_order_value
FROM fact_orders f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_product p ON f.product_key = p.product_key
WHERE d.year = 2025
GROUP BY d.year, d.quarter, c.segment, p.category
ORDER BY total_sales DESC
```

### 2.3 Data Quality & Validation

**Data Quality Checks**:
```
Completeness:
- All required columns have values
- NULL rate < 5%

Accuracy:
- Email format valid
- Phone number valid
- Date ranges reasonable

Consistency:
- Customer ID in transaction exists in customer table
- Product price = 0 not allowed
- Status values in allowed list

Timeliness:
- Data loaded within SLA (e.g., 2 hours)
- No data older than 24 hours
- Real-time data latency < 1 minute
```

### 2.4 Data Governance & Catalog

**Data Catalog**:
```
Tracks:
- Table/dataset metadata
- Column definitions
- Data owner
- Creation date
- Last modified date
- Quality metrics
- Sensitivity classification
- Business glossary terms

Example Entry:
Dataset: customer_orders
├── Owner: Analytics Team
├── Source: Daily ETL job
├── Update Frequency: Daily at 2 AM
├── Columns:
│   ├── order_id (PK, NOT NULL)
│   ├── customer_id (FK)
│   ├── order_date (DATE)
│   └── amount (DECIMAL)
├── Quality:
│   ├── Completeness: 99.8%
│   ├── Last Validated: 2 hours ago
│   └── Issues: 5 orders with NULL customer_id
├── Sensitivity: Medium (contains PII)
└── Lineage:
    ├── Source: Orders API
    ├── Processing: daily_orders_etl job
    └── Consumers: Revenue Dashboard, BI Reports
```

### 2.5 Analytics & Reporting

**Self-Service BI**:
```
Analysts write SQL directly
  ↓
Query runs against data warehouse
  ↓
Results visualized in tool
  ↓
Dashboard/report created
  ↓
Shared with stakeholders

Tools: Tableau, Power BI, Looker, Superset
```

**Example Dashboard**:
```
Sales Performance Dashboard
├── KPIs (top of page)
│   ├── Total Sales: $2.3M (↑12% YoY)
│   ├── Order Count: 15,432 (↑8% YoY)
│   ├── Avg Order Value: $149 (↑3% YoY)
│   └── Customer Count: 8,234 (↑5% YoY)
├── Sales by Region (bar chart)
│   ├── North: $850K
│   ├── South: $620K
│   ├── East: $540K
│   └── West: $290K
├── Sales Trend (line chart)
│   └── Last 12 months trend
├── Top Products (table)
│   ├── Product A: $450K
│   ├── Product B: $380K
│   └── ...
└── Filters
    ├── Date range
    ├── Region
    ├── Product category
    └── Customer segment
```

---

## Part 3: Data Processing Patterns

### 3.1 Lambda Architecture (Batch + Real-time)

**Structure**:
```
Data Source
  ├─ Speed Layer (real-time)
  │   └─ Streaming processor → In-memory store → Serve layer
  │
  └─ Batch Layer (historical)
      └─ Batch processor → Data warehouse → Serve layer
              ↓
          Serving Layer (merge speed + batch)
              ↓
          Queries/Dashboards
```

**Example: Orders Analytics**:
```
Orders Stream
├─ Speed Layer:
│   ├─ Kafka consumer
│   ├─ 5-minute windows
│   ├─ Aggregate: count, sum, avg
│   └─ Store in Redis (latest 1 hour)
│
└─ Batch Layer:
    ├─ Daily ETL job
    ├─ Aggregate all historical data
    ├─ Upsert to data warehouse
    └─ Update dimension tables

Serving Layer:
├─ For last 1 hour: Query Redis (speed layer)
├─ For historical: Query data warehouse (batch)
├─ Merge results
└─ Serve to dashboard
```

### 3.2 Kappa Architecture (Real-time only)

**Structure**:
```
Data Source
  ↓
Streaming Processor
  ├─ Process event
  ├─ Enrich
  ├─ Aggregate
  └─ Store
  ↓
Storage (handles both real-time and historical)
  ↓
Serving layer
  ↓
Queries/Dashboards
```

**Advantages**:
- Simpler than Lambda (no dual code paths)
- Always consistent
- Easier to debug

**Disadvantages**:
- Requires stateful streaming (Kafka or Pulsar)
- More complex stream processor setup
- Harder to backfill historical data

---

## Part 4: Scalability Patterns

### 4.1 Horizontal Scaling

**Partitioning Strategy**:
```
Partition by date:
/data-lake/orders/year=2025/month=01/day=15/

Partition by customer_id:
/data-lake/orders/customer_id=123/data.parquet

Partition by region:
/data-lake/orders/region=US/year=2025/month=01/data.parquet

Benefits:
- Query only relevant partitions
- Parallel read/write
- Faster queries on large datasets
```

**Example Partitioned Query**:
```sql
-- Only scans Jan 2025 data
SELECT * FROM orders
WHERE year = 2025 AND month = 1 AND region = 'US'
-- Pushdown: Partitions filtered before reading
```

### 4.2 Caching Strategy

**Query Result Caching**:
```
Same query multiple times
  ├─ Check cache
  ├─ If hit: Return cached result
  └─ If miss: Run query → Cache result → Return

Invalidation:
- Time-based: Expire after 1 hour
- Event-based: Invalidate when data changes
- Manual: Admin invalidates when needed

Tools: Redis, Memcached, Varnish
```

---

## Part 5: Security & Compliance

### 5.1 Data Access Control

**Row-Level Security**:
```
Analyst can only see their region's data
  ↓
Query: SELECT * FROM orders
  ↓
Database applies filter: WHERE region = 'US'
  ↓
Results only contain US orders

Implementation:
- Row-level policies in database
- Security context passed with query
- Enforced at query execution
```

**Column-Level Security**:
```
Finance can see salary data
Operations cannot

Query: SELECT employee_id, name, salary FROM employees
  ├─ If Finance: Returns all columns
  └─ If Operations: Returns only employee_id, name (salary hidden)
```

### 5.2 Data Classification & Encryption

**Classification**:
```
Public: No restrictions (product catalog)
Internal: Within company (sales reports)
Confidential: Restricted access (customer data)
Secret: Highly restricted (payment info)
```

**Encryption**:
```
At Rest:
- Encrypted disk storage
- Key in separate key vault
- Rotation policy

In Transit:
- HTTPS/TLS for API access
- VPN for internal traffic
- Encrypted database connections
```

### 5.3 Audit Logging

**What to Log**:
```
Access:
- Who accessed what data
- When
- From where
- What they did

Changes:
- Schema modifications
- Data updates (sensitive data)
- Access control changes

Administrative:
- User/role management
- Configuration changes
- Backups and restores
```

---

## Part 6: Cost Optimization

**Typical Data Platform Costs** (AWS):
```
Data Lake (S3):
- Storage: $0.023/GB/month
- 100TB = ~$2,300/month

Data Warehouse (Redshift):
- dc2.large: ~$0.25/hour
- 10 nodes: ~$1,800/month

ETL (Glue):
- $0.44/job hour
- 4 hours/day: ~$53/month

Analytics (Athena):
- $5/TB scanned
- 10TB/month: ~$50/month

Total (Typical): $4,200-6,000/month

Optimization:
- Partition data by date/region
- Archive old data to Glacier ($0.004/GB)
- Use Athena for ad-hoc queries (cheaper than warehouse)
- Schedule batch jobs during off-peak
```

---

## Example Implementation

**Minimal Data Platform**:
```
1. Data Lake
   - AWS S3 / Azure ADLS
   - Partitioned by date

2. ETL Tool
   - Apache Airflow
   - Daily batch jobs

3. Data Warehouse
   - PostgreSQL or Snowflake
   - Star schema

4. Real-time Stream
   - Kafka for event ingestion
   - Spark streaming for processing

5. Analytics & BI
   - Superset/Metabase for free option
   - Tableau for enterprise

6. Data Governance
   - Data catalog (custom or Collibra)
   - Access logs

7. Monitoring
   - Data quality checks
   - ETL job monitoring
```

---

## Related Resources

- [Data Patterns](../patterns/data-patterns.md)
- [Cloud Patterns](../patterns/cloud-patterns.md)
- [Architecture Playbook](../playbooks/architecture-playbook.md)
- [Performance Guide](../playbooks/performance-guide.md)
- [AWS Analytics](https://aws.amazon.com/big-data/datalakes-and-analytics/)
- [Snowflake Documentation](https://docs.snowflake.com/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
