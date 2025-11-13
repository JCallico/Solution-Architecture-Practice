# Technology Selection Guide

## Purpose

Technology selection is one of the most critical architectural decisions because it impacts systems for years. This guide provides a structured approach to evaluate and select technologies that balance technical fit, operational feasibility, team capability, and business constraints.

---

## When to Use This Guide

- **New project startup:** Selecting core technologies (language, frameworks, databases, etc.)
- **Technology replacement:** Evaluating alternatives to current solutions
- **Major upgrade decisions:** Assessing version changes with significant implications
- **Architectural improvement:** Evaluating technologies to fix operational issues
- **Technology spike/POC:** Understanding if a new technology is suitable before adoption

---

## Technology Selection Framework

### Phase 1: Requirements Definition

**Step 1A: Define Functional Requirements**

```
Example - E-Commerce Search System:
├─ Must support full-text search across 10M+ products
├─ Must support faceted search (brand, category, price range)
├─ Must support autocomplete with <100ms latency
├─ Must support relevance tuning by business team
├─ Must integrate with product data in PostgreSQL
└─ Must support 10,000 concurrent searches at peak
```

**Step 1B: Define Non-Functional Requirements**

```
Performance:
- Query latency: P50 <50ms, P95 <100ms, P99 <200ms
- Indexing latency: <5 minutes from database change to searchable
- Throughput: 10,000 requests/second sustained
- Uptime: 99.95% availability (4.4 hours downtime/year)

Scalability:
- Horizontal scaling: Add nodes without downtime
- Data size: Support 10M+ documents initially, 100M+ long-term
- Node count: Support 5-50 node cluster

Maintainability:
- Recovery Time Objective (RTO): <1 hour
- Recovery Point Objective (RPO): 5 minutes
- Monitoring: Full observability (metrics, logs, traces)
- Operations team size: 1-2 engineers can manage
```

**Step 1C: Define Constraints**

```
Budget:
- Software licenses: <$50k/year
- Hardware/cloud costs: <$100k/year
- Implementation: <3 months

Compliance:
- PCI-DSS: No credit card data in search index
- GDPR: Support right to deletion within 30 days
- SOC 2: Encryption in transit, audit logging

Timeline:
- Must be production-ready: 12 weeks
- Cannot delay revenue features: 4 weeks
- Team availability: 2 engineers

Team:
- Backend team expertise: Python, JavaScript, Go
- DevOps capability: Kubernetes, monitoring
- No C++ expertise available
```

---

### Phase 2: Candidate Identification

**Step 2A: Generate Candidates**

Research technologies that could meet requirements:

```
Search Technology Candidates:
1. Elasticsearch 8.0+ (distributed search engine)
2. OpenSearch 2.0+ (Elasticsearch fork)
3. Apache Solr (alternative search engine)
4. Meilisearch (modern search engine)
5. MeiliDB (Rust-based alternative)
6. PostgreSQL full-text search (existing database)
7. MongoDB Atlas Search (document database feature)
8. Algolia (SaaS search platform)
9. Vespa (Yahoo search engine)
10. Weaviate (vector search/ML search)
```

**Step 2B: Initial Screening**

Filter candidates against hard constraints:

```
Screening Criteria:
□ Meets functional requirements? (if NO → eliminate)
□ Within budget constraints? (if NO → eliminate)
□ Available team expertise or learning feasible? (if NO → eliminate)
□ Can be delivered in timeline? (if NO → eliminate)
□ Meets compliance requirements? (if NO → eliminate)

Results (Example):
✓ Elasticsearch - keep (meets all criteria)
✓ PostgreSQL FTS - keep (meets all, lowest cost)
✓ MongoDB Atlas Search - keep (meets all)
✗ Algolia - eliminate (cloud-only, price escalation concerns)
✗ Vespa - eliminate (steep learning curve, small team)
✗ MeiliDB - eliminate (less mature than alternatives)

Remaining: 5 candidates for detailed evaluation
```

---

### Phase 3: Evaluation Criteria Development

**Step 3A: Define Evaluation Criteria**

Create comprehensive criteria aligned with requirements:

```
CATEGORY 1: Technical Suitability (Weight: 35%)
  1. Functional completeness (meets requirements)       [10%]
  2. Query performance & latency                         [10%]
  3. Scalability & horizontal growth                     [8%]
  4. Data consistency & reliability                      [7%]

CATEGORY 2: Operational Characteristics (Weight: 30%)
  5. Deployment complexity & operational burden          [8%]
  6. Monitoring & observability capabilities             [8%]
  7. Recovery procedures (RTO/RPO) & resilience         [7%]
  8. Maintenance effort & ease of updates               [7%]

CATEGORY 3: Business & Strategic (Weight: 25%)
  9. Cost of ownership (software, infrastructure, FTE)  [10%]
  10. Vendor stability & community support               [8%]
  11. Strategic alignment with architecture strategy     [5%]
  12. Lock-in risk & exit strategy                      [2%]

CATEGORY 4: Team Capability (Weight: 10%)
  13. Learning curve & expertise required               [5%]
  14. Available training & documentation               [5%]

Total Criteria: 14 | Total Weight: 100%
Scoring: 1-10 scale per criterion (1=poor, 10=excellent)
```

**Step 3B: Define Scoring Guidance**

```
Technical Suitability - Query Performance (0-10 scale):

10 - Exceeds requirements significantly
     P50 <20ms, P95 <50ms, P99 <100ms (vs 50/100/200 requirement)
     10k req/sec sustained + 50% spike capability

8-9 - Meets or slightly exceeds requirements
     P50 <50ms, P95 <100ms, P99 <200ms
     10k req/sec sustained capability
     
6-7 - Meets requirements with minor limitations
     P50 <100ms, P95 <200ms, P99 <400ms
     Meets 10k req/sec but limited spike capability
     
4-5 - Meets minimum requirements with concerns
     P50 <150ms, P95 <300ms, P99 <600ms
     Requires optimization/caching to meet requirements
     
2-3 - Significant gaps vs requirements
     Would require substantial workarounds
     
0-1 - Does not meet requirements
     Unsuitable for use case
```

---

### Phase 4: Candidate Evaluation

**Step 4A: Research & Documentation**

For each candidate, document:

```
CANDIDATE EVALUATION SHEET

Technology: Elasticsearch 8.0
URL: https://www.elastic.co
Category: Search Engine
License: SSPL (proprietary)

Functional Suitability Score: 9/10
├─ Full-text search: Excellent (9/10)
├─ Faceted search: Excellent (9/10)
├─ Autocomplete: Excellent (9/10) - built-in completion suggester
├─ Relevance tuning: Excellent (10/10) - sophisticated scoring
└─ PostgreSQL integration: Good (8/10) - logstash beats plugin

Technical Suitability Score: 8/10
├─ Query performance: 8/10 - consistent <50ms for 10M docs
├─ Scalability: 9/10 - proven to 100M+ docs easily
├─ Consistency: 7/10 - eventually consistent (eventual consistency concern)
└─ Reliability: 8/10 - replication, failover

Operational Score: 7/10
├─ Deployment: 7/10 - Docker/K8s straightforward
├─ Monitoring: 8/10 - built-in monitoring
├─ Recovery: 7/10 - RTO/RPO straightforward
└─ Maintenance: 7/10 - regular updates, cluster management needed

Cost Score: 7/10
├─ Software: 6/10 - SSPL license ($5k+/year if enterprise)
├─ Infrastructure: 8/10 - modest hardware requirements
└─ Operations: 7/10 - 1 engineer can manage 1-3 clusters

Team Capability Score: 8/10
├─ Learning curve: 8/10 - 1-2 weeks for team
├─ Documentation: 9/10 - excellent docs and community
└─ Training: 8/10 - courses available

Total Weighted Score: 7.8/10
├─ Technical (35%): 8.2
├─ Operational (30%): 7.0
├─ Business (25%): 7.0
└─ Team (10%): 8.0
```

**Step 4B: Create Comparison Matrix**

```
TECHNOLOGY EVALUATION COMPARISON

                    Elasticsearch  PostgreSQL  MongoDB    Score
                                   FTS         Atlas      Ranking
────────────────────────────────────────────────────────────────
Technical (35%)           8.2          5.8        7.5      1st
  Query Performance       8/10         5/10       8/10
  Scalability             9/10         4/10       9/10
  Consistency             7/10         9/10       7/10
  Reliability             8/10         8/10       7/10

Operational (30%)         7.0          8.5        6.8      2nd
  Deployment              7/10         9/10       6/10
  Monitoring              8/10         9/10       7/10
  Recovery                7/10         8/10       7/10
  Maintenance             7/10         8/10       6/10

Business (25%)            7.0          8.0        6.5      3rd
  Cost                    7/10         9/10       5/10
  Vendor                  8/10         10/10      9/10
  Strategic Fit           7/10         8/10       7/10
  Lock-in Risk            5/10         8/10       5/10

Team (10%)                8.0          7.0        7.5      2nd
  Learning Curve          8/10         7/10       7/10
  Documentation           9/10         8/10       8/10

────────────────────────────────────────────────────────────────
WEIGHTED TOTAL           7.8/10       7.7/10     7.3/10

RECOMMENDATION RANK      1st          2nd        3rd
────────────────────────────────────────────────────────────────
```

**Step 4C: Strengths & Weaknesses Summary**

```
ELASTICSEARCH
Strengths:
✓ Best-in-class search capabilities
✓ Proven at massive scale (billions of documents)
✓ Excellent full-text search and relevance tuning
✓ Strong community and training available
✓ Fast indexing and sub-100ms queries achievable

Weaknesses:
✗ License model recently changed (SSPL)
✗ Eventual consistency (not immediate)
✗ Operational complexity higher than PostgreSQL
✗ Requires dedicated cluster management
✗ Memory footprint significant (node sizing important)

PostgreSQL FTS
Strengths:
✓ Leverage existing PostgreSQL infrastructure
✓ Zero additional operational overhead
✓ Lower cost (no additional licenses)
✓ Strong consistency (ACID)
✓ Team expertise already available

Weaknesses:
✗ Query performance (200+ ms typical)
✗ Relevance tuning limited
✗ Faceted search requires workarounds
✗ Autocomplete limited
✗ Cannot scale to very large result sets efficiently

MONGODB ATLAS SEARCH
Strengths:
✓ Integrated with existing MongoDB
✓ Good performance (acceptable for requirements)
✓ Cloud-managed (no operational overhead)
✓ Faceted search built-in
✓ Simpler than Elasticsearch

Weaknesses:
✗ Higher cloud costs (escalates with usage)
✗ Vendor lock-in (cloud-only)
✗ Limited relevance tuning options
✗ Less flexible than Elasticsearch
✗ Query performance variability with cloud load
```

---

### Phase 5: Proof of Concept (POC)

**Step 5A: Determine POC Necessity**

```
POC Required When:
✓ High uncertainty in any critical area
✓ Top 2-3 candidates are very close in scoring
✓ Novel use case with technology
✓ Significant operational concerns
✓ Team concerns about feasibility

POC Not Required When:
✗ Clear winner with >1 point difference
✗ Technology used extensively elsewhere
✗ Low risk of selection mistake
✗ Tight timeline prevents POC
```

**Step 5B: POC Scope (Example)**

```
Search Engine POC: 2-3 weeks

Goals:
1. Validate Elasticsearch can meet performance requirements
2. Evaluate indexing latency from PostgreSQL
3. Assess operational complexity for team
4. Determine cost more accurately
5. Compare search quality vs PostgreSQL

Scope:
- Index 100,000 sample products (from 10M dataset)
- Load test with 1,000 concurrent search requests
- Measure latency and throughput
- Test failover and recovery
- Document operational procedures

Success Criteria:
□ P95 query latency <100ms with 1,000 concurrent users
□ Indexing latency <5 minutes from database change
□ Recovery from node failure <5 minutes
□ 1 engineer can troubleshoot and manage

Timeline: 2 weeks for core team, 1 week for decision
```

---

### Phase 6: Final Decision & Documentation

**Step 6A: Decision Checklist**

```
Before Making Final Decision, Verify:

□ All candidates have been fairly evaluated
□ Weighting criteria approved by stakeholders
□ Scoring is justified with evidence
□ POC (if applicable) has been completed
□ Risks have been identified and mitigations planned
□ Cost estimates are realistic (+/- 25%)
□ Implementation timeline is achievable
□ Team is comfortable with selection
□ Regulatory/compliance team approval obtained
□ Vendor relationship established (if needed)
□ Exit strategy defined for future migration
□ ARB approval obtained (if required)
```

**Step 6B: Architecture Decision Record (ADR)**

Document decision for future reference:

```
ADR-2024-008: Select Elasticsearch for Product Search

Status: Accepted

Context:
E-commerce platform requires full-text search across 10M+ product catalog
with <100ms latency and ability to support sophisticated faceted search
and business team relevance tuning.

Decision:
We will use Elasticsearch 8.0 for product search functionality.

Rationale:
1. Elasticsearch scores highest in technical suitability (8.2/10)
2. Exceeds performance requirements (P95 <50ms vs requirement <100ms)
3. Proven at required scale (10M+ documents) in production
4. Excellent relevance tuning capabilities meet business needs
5. Team can learn in 1-2 weeks with available training

Alternatives Considered:
1. PostgreSQL full-text search - acceptable but doesn't meet performance
2. MongoDB Atlas Search - good alternative but higher cost at scale

Risks & Mitigations:
- Operational complexity: Mitigate with training and automated runbooks
- License model changes: Monitor Elastic licensing, maintain exit option
- Cost escalation: Cap cluster size, estimate growth costs explicitly

Consequences:
- 3-4 week implementation effort
- $30k/year software + infrastructure costs
- 1 engineer can manage operations
- Committed to Elasticsearch-compatible tooling

Approval:
├─ Architecture Team: [Signature] [Date]
├─ Product Manager: [Signature] [Date]
├─ DevOps Lead: [Signature] [Date]
└─ Finance: [Signature] [Date]

Related Decisions:
- ADR-2023-015: Use Kafka for event streaming
- ADR-2024-009: PostgreSQL as primary database
```

**Step 6C: Implementation Planning**

```
Post-Decision Actions:

Week 1:
├─ Establish vendor relationship (if applicable)
├─ License procurement and approval
├─ Schedule team training (online courses)
└─ Create implementation plan with milestones

Week 2-3:
├─ Team training completion
├─ Setup development environment
├─ Begin proof-of-concept implementation
└─ Document operational procedures

Week 4+:
├─ Production setup and hardening
├─ Performance testing and tuning
├─ Monitoring and alerting setup
├─ Team readiness validation
└─ Production launch
```

---

## Common Technology Selection Scenarios

### Scenario 1: Database Technology Selection

```
Example: Selecting database for new analytics system

Requirements:
- Analytical queries on 50TB+ historical data
- Sub-10 second response time for weekly aggregations
- Cost-effective for infrequent queries (not OLTP)
- SQL-based query interface
- Long-term data retention (7+ years)

Candidates Evaluated:
1. BigQuery (Google Cloud)
2. Snowflake
3. AWS Redshift
4. Databricks
5. DuckDB (local analytics)

Typical Winner: Snowflake or BigQuery
Rationale:
- Cost scales with usage (good for variable load)
- Zero operational overhead (managed services)
- Performance meets requirement (10s queries achievable)
- SQL compatibility (team expertise)
```

### Scenario 2: Infrastructure Platform Selection

```
Example: Selecting container orchestration platform

Requirements:
- Scale to 100+ microservices
- Auto-scaling based on load
- Zero-downtime deployment
- Monitoring/observability built-in
- Team can learn and operate

Candidates Evaluated:
1. AWS ECS
2. AWS EKS (Kubernetes)
3. Fargate (AWS serverless containers)
4. Google GKE (Kubernetes)
5. HashiCorp Nomad

Typical Winner: AWS EKS (Kubernetes)
Rationale:
- Industry standard (team skill portable)
- Excellent ecosystem and tooling
- Scales to required size
- Cost-competitive with managed service
```

### Scenario 3: API Communication Pattern

```
Example: Selecting API protocol for microservices

Requirements:
- Service-to-service communication
- High throughput (10,000 req/sec)
- Streaming responses
- Type safety and contract validation
- Team familiarity important

Candidates Evaluated:
1. REST (HTTP/1.1) with JSON
2. REST (HTTP/2) with gRPC
3. GraphQL
4. Apache Avro + Kafka
5. Apache Thrift

Typical Winner: gRPC
Rationale:
- HTTP/2 multiplexing enables high throughput
- Protobuf provides type safety and compatibility
- Streaming responses built-in
- Performance critical, gRPC 10x faster than REST
- Learning curve acceptable (1-2 weeks)
```

---

## Technology Selection Best Practices

```
DO:
✓ Define requirements clearly before evaluation
✓ Use weighted scoring to avoid bias
✓ Involve stakeholders in criteria and scoring
✓ Test top candidates with POC if uncertain
✓ Document decision rationale for future reference
✓ Plan migration path at time of selection
✓ Consider team skill and learning curve
✓ Reevaluate every 2-3 years for major technologies

DON'T:
✗ Choose based on personal preference
✗ Select newest/trendiest technology
✗ Ignore operational complexity
✗ Forget about team capability gaps
✗ Choose without clear business justification
✗ Skip proof of concept for critical systems
✗ Assume team can learn everything quickly
✗ Ignore vendor stability and community support
✗ Choose single-vendor lock-in without justification
```

---

## Technology Selection Timeline

```
Typical Technology Selection Lifecycle:

Fast-Track (2 weeks):
├─ Requirements definition: 2 days
├─ Candidate identification: 1 day
├─ Evaluation criteria: 1 day
├─ Candidate evaluation: 3 days
├─ Decision & approval: 2 days
└─ Implementation: Week 2+

Standard (4 weeks):
├─ Requirements definition: 3 days
├─ Candidate identification: 2 days
├─ Evaluation criteria: 2 days
├─ Candidate evaluation: 5 days
├─ POC (if needed): 1-2 weeks
├─ Decision & approval: 2 days
└─ Implementation: Parallel with POC

Complex Selection (6-8 weeks):
├─ Requirements definition: 1 week
├─ Market research: 1 week
├─ Candidate identification: 1 week
├─ Evaluation criteria development: 1 week
├─ Candidate evaluation: 1 week
├─ POC (2-3 candidates): 2 weeks
├─ Decision & approval: 1 week
└─ Implementation: Parallel start
```

---

## Related Resources

- [Technology Radar](./technology-radar.md)
- [Tool Recommendations](./tool-recommendations.md)
- [Technology Evaluation Template](../templates/technology-evaluation-template.md)
- [POC Template](../templates/poc-template.md)
- [ADR - Architecture Decision Record](./decisions.md)
- [Architecture Review Process](../processes/arb/README.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
