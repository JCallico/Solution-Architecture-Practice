# Training Catalog

## Overview

Comprehensive catalog of available training resources for architecture team members. This catalog provides learning paths for different roles and specializations, with recommended courses, books, certifications, and conferences.

---

## Architecture Fundamentals Track

### 1. Software Architecture Fundamentals

**Objective:** Master core architecture principles and practices

**Recommended Courses:**
- **"Software Architecture Fundamentals" (O'Reilly)** - 20 hours
  - Architecture styles (microservices, monolithic, serverless)
  - Architecture patterns and anti-patterns
  - Quality attributes (scalability, reliability, security)
  - Cost and performance analysis
  - Hands-on exercises

- **"Software Architecture in Practice" (CMU)** - 40 hours
  - Real-world case studies
  - Architecture documentation
  - Architecture evaluation
  - Stakeholder management
  
**Related Books:**
- "Fundamentals of Software Architecture" (Richards & Ford)
- "Building Software Systems at Google" (Google SRE book)

**Time Investment:** 40-60 hours  
**Prerequisites:** 3+ years software development experience  
**Assessment:** Quiz (passing score 80%)

---

### 2. Design Patterns Mastery

**Objective:** Understand and apply Gang of Four patterns and architectural patterns

**Courses:**
- **"Design Patterns" (Pluralsight)** - 10 hours
  - Creational patterns (Factory, Builder, Singleton)
  - Structural patterns (Adapter, Decorator, Facade)
  - Behavioral patterns (Strategy, Observer, Command)
  - Pattern selection criteria
  - Code examples (Java, Python, C#)

- **"Enterprise Integration Patterns" (O'Reilly)** - 15 hours
  - Message-based integration
  - Routing and transformation patterns
  - Messaging constructs
  - Real-world examples

**Books:**
- "Design Patterns" (Gang of Four)
- "Enterprise Integration Patterns" (Hohpe & Woolf)

**Practical Exercise:**
- Identify 10 patterns in existing codebase
- Refactor code using appropriate patterns
- Document design decisions

**Time Investment:** 30-40 hours  
**Prerequisite:** Fundamentals track

---

### 3. Domain-Driven Design (DDD)

**Objective:** Design systems around business domains

**Courses:**
- **"Domain-Driven Design" (Udacity)** - 25 hours
  - Bounded contexts and ubiquitous language
  - Aggregate design
  - Value objects and entities
  - Event sourcing
  - Tactical and strategic design

**Books:**
- "Domain-Driven Design" (Eric Evans)
- "Implementing Domain-Driven Design" (Vaughn Vernon)

**Workshop:**
- 2-day hands-on DDD workshop
- Event storming exercise
- Design a real domain using DDD principles

**Time Investment:** 40-50 hours  
**Prerequisites:** Design Patterns course completed

---

### 4. System Design

**Objective:** Design large-scale systems

**Courses:**
- **"Grokking the System Design Interview" (Educative)** - 30 hours
  - Scalability fundamentals
  - Load balancing
  - Caching strategies
  - Database design
  - Case studies (Twitter, Instagram, Uber)

- **"System Design Primer" (GitHub)** - Self-paced
  - Distributed systems concepts
  - Databases and caching
  - Message queues
  - System design patterns

**Practice:**
- Design Twitter-like system
- Design Netflix video streaming platform
- Design WhatsApp real-time messaging
- Design Uber ride-sharing system

**Time Investment:** 50-70 hours  
**Prerequisites:** Design Patterns + DDD courses

---

## Cloud Platform Specialization

### AWS Solutions Architect Track

**Prerequisites:** Cloud Fundamentals (20 hours)

**Level 1: AWS Fundamentals (40 hours)**
- Course: "AWS Solutions Architect Associate" (A Cloud Guru)
- Key topics: EC2, RDS, S3, VPC, Lambda, IAM
- Hands-on labs: 10+ exercises
- Exam: AWS Solutions Architect Associate

**Level 2: Advanced AWS (50 hours)**
- Course: "AWS Solutions Architect Professional" (A Cloud Guru)
- Topics: Migration strategies, multi-region, DR, HA
- Case studies: Real-world scenarios
- Exam: AWS Solutions Architect Professional

**Level 3: AWS Specialty (40 hours)**
- Choose one specialization:
  - **Security:** "Security Engineering on AWS" (40 hours)
  - **DevOps:** "DevOps Engineering on AWS" (40 hours)
  - **Data Analytics:** "Data Analytics on AWS" (40 hours)
  - **Database:** "Databases on AWS" (40 hours)

**Level 4: Mastery (Ongoing)**
- AWS re:Invent conference (3 days)
- Deep dive on advanced topics
- Hands-on labs with infrastructure as code
- Architecture design reviews

**Certification Path:** Associate → Professional → Specialty  
**Total Time Investment:** 150-200 hours + exam prep  
**Cost:** $100 per exam, courses $300-500

---

### Azure Architecture Track

**Prerequisites:** Cloud Fundamentals (20 hours)

**Level 1: Azure Fundamentals (40 hours)**
- Course: "AZ-900 Microsoft Azure Fundamentals" (Microsoft Learn)
- Key topics: Compute, Storage, Networking, Identity
- Hands-on labs: Free Azure sandbox environment
- Exam: AZ-900

**Level 2: Azure Solutions Architect (60 hours)**
- Course: "AZ-104 Azure Administrator" (Microsoft Learn)
- Course: "AZ-305 Azure Solutions Architect Expert"
- Design secure, scalable, reliable Azure solutions
- Exam: AZ-305

**Level 3: Azure Specialty (40 hours)**
- Choose specialization:
  - **Security:** "AZ-500 Azure Security Engineer"
  - **DevOps:** "AZ-400 Azure DevOps Engineer"
  - **Data Engineering:** "DP-203 Data Engineer"

**Certification Path:** Fundamentals → Administrator → Architect → Specialty  
**Total Time Investment:** 150-200 hours  
**Cost:** Microsoft Learn (free) + exams $99-165

---

### GCP Professional Track

**Prerequisites:** Cloud Fundamentals (20 hours)

**Level 1: GCP Fundamentals (40 hours)**
- Course: "Google Cloud Fundamentals" (Coursera)
- Key topics: Compute Engine, Cloud Storage, Networking
- Hands-on labs: Free GCP credits
- Assessment: Quiz

**Level 2: Cloud Architect (60 hours)**
- Course: "Preparing for Google Cloud Architect" (Coursera)
- Design production GCP systems
- Case studies and labs
- Exam: Professional Cloud Architect

**Level 3: Specialty (40 hours)**
- Choose specialization:
  - **Data Engineering:** "Professional Data Engineer"
  - **Cloud Developer:** "Associate Cloud Engineer"
  - **ML Engineer:** "Professional Machine Learning Engineer"

**Certification Path:** Fundamentals → Architect → Specialty  
**Total Time Investment:** 140-180 hours  
**Cost:** Coursera subscription $39/month + $200 exam

---

## Microservices & Distributed Systems Track

### Microservices Architecture (60 hours)

**Courses:**
- **"Building Microservices" (O'Reilly)** - 20 hours
  - Design principles and patterns
  - Communication patterns (sync, async)
  - Data consistency and transactions
  - Scaling and deployment

- **"Microservices Architecture" (Linux Academy)** - 30 hours
  - Service decomposition strategies
  - API design for microservices
  - Handling distributed transactions
  - Monitoring and observability

**Books:**
- "Building Microservices" (Sam Newman)
- "Microservices Patterns" (Chris Richardson)

**Hands-On Project:**
- Refactor monolith to microservices
- Implement event-driven communication
- Deploy to Kubernetes cluster
- Setup observability stack

**Time Investment:** 60-80 hours  
**Prerequisites:** Software Architecture Fundamentals, DDD

---

### Event-Driven Architecture (40 hours)

**Courses:**
- **"Event-Driven Architecture" (O'Reilly)** - 20 hours
  - Event sourcing and CQRS
  - Event notification patterns
  - Temporal data and event stores
  - Choreography vs orchestration

- **"Apache Kafka Fundamentals"** - 15 hours
  - Kafka architecture
  - Producers and consumers
  - Stream processing (Kafka Streams)
  - Real-world patterns

**Books:**
- "Event-Driven Architecture" (O'Reilly)
- "Designing Event-Driven Systems" (Confluent)

**Project:**
- Build event-sourced order system
- Implement CQRS pattern
- Design event schema and versioning
- Setup Kafka cluster

**Time Investment:** 40-60 hours  
**Prerequisites:** Microservices Architecture course

---

### API Design & Management (40 hours)

**Courses:**
- **"RESTful API Design" (Pluralsight)** - 15 hours
  - REST principles and constraints
  - Resource design
  - Versioning strategies
  - Error handling and security

- **"API Management" (Linux Academy)** - 15 hours
  - API gateways (Kong, AWS API Gateway)
  - Rate limiting and throttling
  - API analytics and monitoring
  - API security (OAuth, API keys)

**Books:**
- "Web API Design Practices" (Apigee)
- "REST API Best Practices"

**Project:**
- Design RESTful API specification (OpenAPI)
- Implement API using API gateway
- Setup API versioning and backwards compatibility
- Monitor API usage and performance

**Time Investment:** 40-50 hours  
**Prerequisites:** Microservices Architecture

---

## Data & Analytics Specialization

### Data Architecture Fundamentals (50 hours)

**Courses:**
- **"Data Fundamentals" (Coursera)** - 20 hours
  - Data modeling (relational, dimensional)
  - Normalization and denormalization
  - Star schema and fact tables
  - Data warehouse concepts

- **"Big Data Fundamentals" (Coursera)** - 20 hours
  - Distributed processing concepts
  - Apache Hadoop and Spark
  - Data lake architecture
  - Real-time vs batch processing

**Books:**
- "The Data Warehouse Toolkit" (Ralph Kimball)
- "Fundamentals of Data Engineering" (Joe Reis)

**Project:**
- Design dimensional model for retail business
- Implement star schema in PostgreSQL
- Design data lake architecture
- Performance optimization

**Time Investment:** 50-70 hours  
**Prerequisites:** Database fundamentals

---

### Cloud Data Warehouses (60 hours)

**Choose One:**

**Snowflake Track:**
- Course: "Snowflake University" (official)
- Topics: Warehouse design, scaling, cost optimization
- Labs: 10+ hands-on exercises
- Certification: Snowflake Associate Architect
- Time: 60 hours

**Google BigQuery Track:**
- Course: "BigQuery Fundamentals" (Coursera)
- Topics: Querying, optimization, ML integration
- Labs: Real datasets, performance tuning
- Time: 50 hours

**Amazon Redshift Track:**
- Course: "Data Warehouse Design on AWS" (A Cloud Guru)
- Topics: Cluster design, distribution keys, optimization
- Labs: Loading data, query optimization
- Time: 60 hours

**Project:**
- Migrate data to chosen warehouse
- Optimize queries for performance
- Design cost-effective partitioning
- Implement data governance

**Time Investment:** 60-80 hours  
**Prerequisites:** Data Architecture Fundamentals

---

### Modern Data Stack (40 hours)

**Topics:**
- dbt (data build tool) - 15 hours
- Orchestration (Airflow, Dagster) - 10 hours
- Data quality and testing - 10 hours
- Modern ELT patterns - 5 hours

**Courses:**
- "dbt Fundamentals" (dbt Learn)
- "Apache Airflow" (Udemy)
- "Data Testing with dbt" (dbt Learn)

**Project:**
- Build dbt project for data transformation
- Orchestrate pipelines with Airflow
- Implement data quality checks
- Version control ELT pipelines

**Time Investment:** 40-60 hours  
**Prerequisites:** Data Architecture Fundamentals

---

## Security Architecture Track

### Security Fundamentals (40 hours)

**Courses:**
- **"Security Architecture" (Pluralsight)** - 20 hours
  - Authentication and authorization
  - Encryption basics
  - Threat modeling
  - Security patterns

- **"OWASP Top 10" (PortSwigger)** - 15 hours
  - Injection attacks
  - Broken authentication
  - XSS and CSRF
  - Insecure deserialization
  - Security misconfiguration

**Books:**
- "Security Architecture" (Roman Zeyik)
- "The Web Application Hacker's Handbook"

**Project:**
- Threat modeling exercise
- OWASP assessment of sample application
- Security architecture design document
- Vulnerability remediation plan

**Time Investment:** 40-50 hours  
**Prerequisites:** Software Architecture Fundamentals

---

### Cloud Security (60 hours)

**AWS Security Track:**
- Course: "AWS Security Fundamentals" (A Cloud Guru)
- Topics: IAM, KMS, WAF, VPC security, logging
- Labs: 15+ hands-on exercises
- Certification: AWS Security Specialty
- Time: 60 hours

**Azure Security Track:**
- Course: "AZ-500 Azure Security Engineer"
- Topics: Azure security, compliance, data protection
- Labs: Azure sandbox environment
- Certification: Azure Security Engineer Associate
- Time: 60 hours

**Project:**
- Design zero-trust security architecture
- Implement secrets management
- Setup encryption and TLS
- Configure WAF and DDoS protection
- Audit logging and monitoring

**Time Investment:** 60-80 hours  
**Prerequisites:** Security Fundamentals, Cloud Architecture

---

### Compliance & Governance (40 hours)

**Topics:**
- PCI-DSS compliance - 10 hours
- GDPR and CCPA - 10 hours
- HIPAA and FedRAMP - 10 hours
- SOC 2 and audit readiness - 10 hours

**Courses:**
- "PCI-DSS Compliance" (LinkedIn Learning)
- "GDPR Compliance" (Coursera)
- "Compliance and Security for AWS" (A Cloud Guru)

**Project:**
- Compliance assessment for organization
- Remediation roadmap creation
- Control mapping (PCI-DSS controls)
- Audit preparation documentation

**Time Investment:** 40-60 hours  
**Prerequisites:** Security Fundamentals

---

## Kubernetes & Infrastructure Track

### Kubernetes Fundamentals (50 hours)

**Courses:**
- **"Kubernetes for Developers" (Linux Academy)** - 25 hours
  - Kubernetes architecture (pods, services, deployments)
  - Storage and networking
  - ConfigMaps and Secrets
  - StatefulSets and DaemonSets
  - Helm package management

- **"Certified Kubernetes Administrator" (Linux Academy)** - 30 hours
  - Cluster setup and management
  - RBAC and security
  - Troubleshooting and debugging
  - Upgrade and backup strategies

**Books:**
- "The Kubernetes Book" (Nigel Poulton)
- "Kubernetes in Action" (Marko Luksa)

**Hands-On Labs:**
- Deploy applications to Kubernetes
- Configure services and networking
- Setup persistent storage
- Implement RBAC policies
- Troubleshoot cluster issues

**Certification:** Certified Kubernetes Application Developer (CKAD)  
**Time Investment:** 50-70 hours  
**Prerequisites:** Container fundamentals (Docker)

---

### Advanced Kubernetes (60 hours)

**Topics:**
- Advanced networking and service mesh - 20 hours
- Operators and custom resources - 15 hours
- Performance optimization - 15 hours
- Multi-cluster management - 10 hours

**Courses:**
- "Kubernetes Advanced" (Linux Academy)
- "Istio Service Mesh" (Nginx)
- "Kubernetes Operators" (CloudNative.tv)

**Projects:**
- Deploy service mesh (Istio)
- Build custom Kubernetes operator
- Optimize cluster performance
- Setup multi-cluster federation

**Certification:** Certified Kubernetes Administrator (CKA)  
**Time Investment:** 60-80 hours  
**Prerequisites:** Kubernetes Fundamentals + CKA exam

---

## Practical Learning

### Architecture Katas (Monthly, 4 hours each)

**Format:**
- Monthly hands-on architecture workshop
- Real-world problem statement
- 2-hour design session (teams of 3-4)
- 1-hour peer review and feedback
- 1-hour discussion of patterns and trade-offs

**Examples:**
- "Design a financial trading platform"
- "Architect a real-time recommendation engine"
- "Design a multi-tenant SaaS platform"
- "Plan migration of legacy monolith"

**Benefits:**
- Hands-on practice with peers
- Rapid iteration on designs
- Learn from others' approaches
- Keep current with industry patterns

---

### Internal Workshops

**Monthly Offerings:**
1. **Technology Deep Dive** (3 hours)
   - Latest tools and frameworks
   - Vendor presentations
   - Demo and Q&A

2. **Case Study Analysis** (2 hours)
   - Real project retrospectives
   - Lessons learned discussion
   - Pattern identification

3. **Design Review Workshop** (2 hours)
   - Review actual architecture proposals
   - Practice design feedback
   - Consensus building

4. **Pattern Workshop** (2 hours)
   - Deep dive on architecture patterns
   - When to use and when not to use
   - Real-world examples

---

## Conferences (Must-Attend)

### Flagship Conferences

**AWS re:Invent** (Las Vegas, Nov/Dec) - 3-5 days
- 2,000+ sessions
- Customer keynotes
- Hands-on labs
- Networking
- Cost: $1,500-2,500 + travel

**Microsoft Build** (Seattle/Virtual, May) - 3 days
- Azure announcements
- Developer sessions
- Technical workshops
- Cost: $500-2,000

**Google Cloud Next** (Las Vegas, Sept) - 2-3 days
- Google Cloud product announcements
- Technical sessions
- Hands-on labs
- Cost: $500-1,500

**O'Reilly Software Architecture Conference** (Virtual/In-person) - 2 days
- Architecture trends and best practices
- Expert speakers
- Case studies
- Cost: $800-1,200

---

### Regional & Specialized Conferences

- **QCon** (San Francisco, New York, London) - Architecture and microservices
- **KubeCon** (Various locations) - Kubernetes and cloud-native
- **Gartner Symposium** - Enterprise architecture and strategy
- **Tech conferences** - Local/regional, lower cost alternative

---

## Recommended Books by Track

### Architecture Fundamentals
1. "Fundamentals of Software Architecture" (Richards & Ford)
2. "A Philosophy of Software Design" (John Ousterhout)
3. "Design Patterns" (Gang of Four)

### Microservices
1. "Building Microservices" (Sam Newman)
2. "Microservices Patterns" (Chris Richardson)
3. "Designing Event-Driven Systems" (Confluent)

### Cloud Platforms
1. "Well-Architected: Cloud architecture best practices" (various authors)
2. "Migrating Applications to the Cloud" (Nginx)

### Data Engineering
1. "The Data Warehouse Toolkit" (Ralph Kimball)
2. "Fundamentals of Data Engineering" (Joe Reis & Matt Housley)
3. "Designing Data-Intensive Applications" (Martin Kleppmann)

### Security
1. "Security Architecture" (Roman Zeyik)
2. "The Web Application Hacker's Handbook"
3. "Zero Trust Networks" (Gilman & Barth)

---

## Training Budget & Approval

### Annual Budget per Architect

| Role | Annual Budget | Conference | Certification |
|------|---------------|-----------|----------------|
| Associate Architect | $2,000 | 1 | 1-2 |
| Architect | $3,000 | 2 | 1-2 |
| Senior Architect | $4,000 | 2 | 1 |
| Principal Architect | $5,000 | 2-3 | As needed |

### Budget Allocation Example

For Senior Architect ($4,000/year):
- Online courses: $500
- Certification exams: $400
- Books and materials: $300
- Conference attendance: $2,000
- Local workshops/meetups: $800

### Approval Process

1. **Proposal Submission** (Via email/form)
   - Course/conference name
   - Expected duration
   - Cost breakdown
   - Business justification
   - Expected outcomes

2. **Manager Approval** (1-2 days)
   - Fits role requirements
   - Reasonable timeline
   - Budget availability

3. **Team Lead Review** (Optional, for major trainings)
   - Impacts to project schedules
   - Team coverage

4. **Reimbursement** (Upon completion)
   - Submit receipts
   - Share key learnings with team
   - 30-day turnaround

---

## How to Access & Register

### Step 1: Identify Learning Goal
- Career development discussion with manager
- Review recommended learning paths
- Check training catalog

### Step 2: Submit Request
- Use training request form
- Include justification and expected outcomes
- Get manager approval

### Step 3: Enroll & Complete
- Create account on learning platform
- Schedule time for learning
- Complete coursework

### Step 4: Share Learnings
- Lunch & learn presentation (20 min)
- Brown bag session with team
- Internal wiki documentation
- Mentoring junior architects

### Step 5: Reflection & Assessment
- Complete learning reflection
- Identify application to current projects
- Discuss with manager in 1:1

---

## Continuous Learning Culture

**Expectations:**
- 5-10% of time dedicated to learning (4-8 hours/week)
- At least 1 course or conference per year
- Mentoring and knowledge sharing
- Participation in communities of practice

**Support:**
- Budget allocated annually
- Time protected for learning
- Peer learning opportunities
- Internal subject matter experts

---

## Related Resources

- [Learning Paths by Role](./learning-paths/)
- [Certifications Guide](./certifications/)
- [Mentorship Program](./mentorship/)
- [Communities of Practice](./communities/)
