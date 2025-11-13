# Documentation Standards

## Overview

Standards and guidelines for all architecture documentation. This ensures clarity, consistency, and maintainability across all documents.

---

## Document Structure

### Architecture Decision Records (ADRs)

**Format:**
```
# ADR-NNN: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context
[Problem statement and background]

## Decision
[What was decided]

## Consequences
[Positive and negative outcomes]

## Alternatives Considered
[Alternative approaches and why rejected]

## Related Decisions
[Links to related ADRs]
```

**Example:**
```
# ADR-042: Use Kubernetes for Container Orchestration

## Status
Accepted

## Context
Growing need to orchestrate 50+ microservices across multiple environments.
Manual VM management becoming unsustainable.

## Decision
Adopt Kubernetes as standard container orchestration platform.
- Use managed service (EKS/AKS/GKE) not self-hosted
- Standard Helm charts for all applications
- Istio service mesh for traffic management

## Consequences
**Positive:**
- Automatic scaling and self-healing
- Standardized deployment process
- Better resource utilization

**Negative:**
- Learning curve for team
- Operational complexity increase
- Requires infrastructure expertise

## Alternatives Considered
1. Docker Swarm - simpler but less feature-rich
2. AWS ECS - cloud-specific, fewer job opportunities
3. Manual VM orchestration - not scalable

## Related Decisions
- ADR-040: Use Docker for containerization
- ADR-041: Cloud platform selection (AWS)
```

**Guidelines:**
- ADR required for any decision affecting 3+ systems
- ADR format: ADR-NNN (padded, e.g., ADR-042)
- Location: `/docs/decisions/adr-NNN.md`
- Status tracking in master index
- Immutable once published (can be deprecated/superseded)

---

### Architecture Design Documents

**Standard Sections:**
1. **Overview** (1 page)
   - Purpose and context
   - Key stakeholders
   - Success criteria

2. **Current State** (2 pages)
   - Existing architecture
   - Known issues
   - Constraints

3. **Proposed Architecture** (3-5 pages)
   - High-level design (C4 level 1 diagram)
   - Component details (C4 level 2)
   - Data flows
   - Technology choices with rationale

4. **Non-Functional Requirements** (1 page)
   - Scalability targets
   - Reliability/SLA
   - Performance targets
   - Security requirements
   - Cost constraints

5. **Implementation Plan** (1 page)
   - Phased approach
   - Timeline and milestones
   - Resource requirements
   - Risk mitigation

6. **Testing Strategy** (1 page)
   - Test approach
   - Success criteria
   - Performance testing plan

7. **Operations & Support** (1 page)
   - Monitoring and alerting
   - Runbooks
   - On-call procedures
   - Training needs

8. **Appendices**
   - Detailed diagrams
   - Alternative designs
   - References and links

---

## Diagramming Standards

### C4 Model (Context, Containers, Components, Code)

**Level 1: System Context**
```
┌─────────────────────────────────────┐
│                                     │
│  [User] ──→ [System] ──→ [External] │
│                                     │
└─────────────────────────────────────┘
```

**Level 2: Container Diagram**
```
System
├── Web Application (Browser)
├── API Server (Node.js)
├── Database (PostgreSQL)
├── Cache (Redis)
└── Message Queue (Kafka)
```

**Level 3: Component Diagram**
```
API Server
├── Authentication Component
├── Order Service Component
├── Payment Service Component
└── Notification Component
```

**Level 4: Code**
- Class diagrams
- Sequence diagrams
- Detailed implementation

**Tool Recommendations:**
- Draw.io (free, open)
- PlantUML (text-based, version control friendly)
- Miro (collaborative)
- Lucidchart (professional)

### Diagram Naming

```
Format: [Domain]-[Type]-[Version].png
Example: 
  - ecommerce-architecture-v2.png
  - payment-sequence-v1.png
  - order-deployment-v3.png
```

**Location:** Embed in document or `/docs/diagrams/`

---

## Writing Style Guide

### Tone
- **Formal** for published architecture decisions
- **Clear** and avoid jargon when possible
- **Concise** - prefer short paragraphs
- **Active voice** - "The system validates" not "Validation is performed"

### Structure
- **Headings:** H2 for sections, H3 for subsections
- **Lists:** Bullet points for unordered, numbered for sequences
- **Tables:** Use for comparisons
- **Code blocks:** Syntax highlighting with language specified

### Technical Content
```markdown
# Bad Example
Services perform asynchronous messaging via Kafka with 
topics that are partitioned by entity ID to ensure ordered 
processing while enabling horizontal scaling.

# Good Example  
Services communicate asynchronously using Kafka:
- Partition by entity ID → ensures ordered processing
- Multiple partitions → enables horizontal scaling
- Retention policy → 7 days → cost management
```

### Links
- **Internal:** `[Pattern](../patterns/microservices.md)` 
- **Relative paths** preserve portability
- **Avoid:** Hardcoded URLs

---

## Code Examples & Snippets

**Requirements:**
- Compilable/runnable when possible
- Clear variable names
- Comments for non-obvious logic
- Language specified in code fence

**Example:**
```python
# Good: Clear, documented, production-ready
class OrderService:
    """Process customer orders with idempotency."""
    
    def create_order(self, customer_id: int, items: List[Item]) -> Order:
        """
        Create order with idempotency key to prevent duplicates.
        
        Args:
            customer_id: Customer placing order
            items: List of items to order
            
        Returns:
            Order object with unique order_id
        """
        # Use customer_id + timestamp as idempotency key
        idempotency_key = f"{customer_id}:{time.time()}"
        
        # Check if order already exists with this key
        existing = self.db.query(Order).filter(
            Order.idempotency_key == idempotency_key
        ).first()
        
        if existing:
            return existing  # Idempotent: return same order
        
        # Create new order
        order = Order(customer_id=customer_id, items=items)
        self.db.save(order)
        return order
```

---

## Markdown Formatting

**Standard Markdown:**
```markdown
# Heading 1 (Document title)
## Heading 2 (Section)
### Heading 3 (Subsection)

**Bold** for emphasis
*Italic* for terms

- Bullet points
- For lists

1. Numbered
2. For sequences

| Column | Header |
|--------|--------|
| Cell   | Data   |

> Blockquote for callouts
```

**Callouts:**
```markdown
> **Note:** This is important context

> **Warning:** This could break things

> **Tip:** Best practice recommendation
```

---

## Document Templates

### Design Document Template
- Location: `/templates/design-document-template.md`
- Use as starting point for all architecture designs
- Modify sections as needed but keep core structure

### Decision Record Template
- Location: `/templates/adr-template.md`
- One-page format (aim for <2 pages)
- Status field is machine-readable for indexing

### RFC (Request for Comments) Template
- Location: `/templates/rfc-template.md`
- For major proposals requiring community feedback
- 5-7 day feedback window before decision

---

## Documentation Maintenance

### Version Control
- All documents in Git
- Changes require pull request
- Review before merge
- Commit messages: "docs: brief description"

### Archiving Deprecated Documentation
- Mark as "Deprecated" at top
- Keep in repository for historical reference
- Link to replacement document
- Never delete

### Review Cycles
- **Monthly:** Technical content accuracy review
- **Quarterly:** Update examples and links
- **Annually:** Full document assessment
- Archive outdated documents

### Metadata
```markdown
---
title: Document Title
author: Author Name
date: YYYY-MM-DD
status: Draft | In Review | Published | Deprecated
version: 1.0
category: Architecture | Process | Guide
---
```

---

## Accessibility Standards

**Requirements:**
- Readable font (sans-serif, 12pt minimum)
- Sufficient color contrast (WCAG AA minimum)
- Alt text for all images/diagrams
- Plain language (grade 8 reading level)
- Short sentences (< 20 words)

**Example:**

```markdown
![Order Processing Architecture Diagram showing order 
flow from customer through multiple services. See 
architecture-order-v2.png for detailed components.]
(diagrams/architecture-order-v2.png)
```

---

## Documentation Process

### Approval Workflow

```
Author creates document
    ↓
Peer review (team members)
    ↓
Technical review (domain expert)
    ↓
Architecture Review Board sign-off (if major)
    ↓
Published to wiki
    ↓
Share with stakeholders
```

### Publication Checklist
- [ ] Grammar and spelling verified
- [ ] Links tested (internal and external)
- [ ] Diagrams clear and labeled
- [ ] Code examples compile/run
- [ ] Metadata complete
- [ ] Relative paths used (not absolute)
- [ ] Table of contents updated
- [ ] Related documents cross-linked

---

## Related Resources

- [ADR Template](../../templates/adr-template.md)
- [Design Document Template](../../templates/design-document-template.md)
- [Architecture Decision Records](../decisions/)
