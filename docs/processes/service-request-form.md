# Service Request Form

## Overview

The Service Request Form standardizes how teams request architecture services from the Enterprise Architecture team. It ensures all necessary information is captured upfront, enabling faster turnaround and better outcomes.

**Benefits of Standardized Requests:**
- Clear expectations for both requestor and architect
- Complete information at submission
- Proper prioritization and resource allocation
- Faster turnaround times
- Better alignment with business goals

## Request Types

### Architecture Consultation
**When to use:** Need guidance on architectural approach

For questions about:
- Technology selection
- Architecture patterns and best practices
- Design validation
- Performance optimization
- Migration planning
- System integration approaches

**Typical timeline:** 1-2 weeks
**Effort:** 8-16 hours

### Architecture Review
**When to use:** Want feedback on existing or proposed architecture

For reviews of:
- System design documents
- Technology proposals
- Implementation plans
- Code architecture
- Infrastructure design
- Security architecture

**Typical timeline:** 2-4 weeks
**Effort:** 16-40 hours

### Architecture Design
**When to use:** Need comprehensive architecture for new initiative

For designing:
- New systems from scratch
- Major system overhauls
- Platform migrations
- Microservices architectures
- Integration solutions
- Data pipelines

**Typical timeline:** 4-12 weeks
**Effort:** 40-160 hours

### Due Diligence/Assessment
**When to use:** Need evaluation of vendor, technology, or system

For assessing:
- Vendor solutions
- Technology fitness for purpose
- System health and modernization needs
- Risk assessment
- Compliance evaluation
- Cloud migration readiness

**Typical timeline:** 2-6 weeks
**Effort:** 20-80 hours

### Training & Workshop
**When to use:** Need capability building or team alignment

For:
- Architecture fundamentals training
- Technology deep dives
- Design workshops
- Migration planning sessions
- Decision-making workshops
- Best practices workshops

**Typical timeline:** 1-4 weeks
**Effort:** 16-40 hours

## Service Request Form

### Section 1: Requestor Information

**Name** (Required)
- Your full name
- *Example: John Smith*

**Email** (Required)
- Your email address
- *Example: john.smith@company.com*

**Phone** (Optional)
- Best phone number to reach you
- *Example: (555) 123-4567*

**Department/Team** (Required)
- Your team or department
- *Example: Product Engineering, Platform Team*

**Manager/Sponsor** (Required)
- Name of your direct manager or executive sponsor
- Important for prioritization
- *Example: Jane Doe, VP Engineering*

---

### Section 2: Request Details

**Request Title** (Required)
- Brief title of your request
- *Example: "Cloud Migration Architecture Review" or "Microservices Design for Payment System"*

**Request Type** (Required)
- Select one:
  - ☐ Architecture Consultation
  - ☐ Architecture Review
  - ☐ Architecture Design
  - ☐ Due Diligence/Assessment
  - ☐ Training & Workshop
  - ☐ Other (please specify)

**Description** (Required - 200-500 words)
- Clearly describe what you need
- Explain the business context
- Describe current state (if applicable)

**Example:**
> We're planning to migrate our monolithic order processing system to microservices. We need an architecture review of our proposed design covering:
> - Service decomposition strategy
> - Data consistency approach
> - Inter-service communication
> - Deployment strategy
> - Monitoring and observability
> 
> The system currently handles 100K orders/day with 99.9% uptime SLA. We expect 2x growth in next year.

---

### Section 3: Business Context

**Business Objective** (Required)
- What business goal drives this request?
- How does it align with strategy?
- What's the business value?

**Example:**
> Reduce operational complexity and enable faster feature delivery. Monolithic architecture slowing our deployment velocity. Target: Reduce release cycles from 2 weeks to 1 week.

**Success Criteria** (Required - at least 2)
- How will we know if this is successful?
- What measurable outcomes matter?
- What are acceptable trade-offs?

**Examples:**
- System can handle 200K orders/day (vs 100K today)
- Deployment cycle reduced from 2 weeks to 1 week
- Team autonomy increased (services owned by individual teams)
- Cost within $X per month
- Migration completed within 6 months

**Key Stakeholders** (Required)
- Who is involved in this initiative?
- Who needs to be consulted?
- Who has final authority?

**Format:**
```
Name                Role                        Involvement
Jane Doe           VP Engineering               Sponsor/Approver
John Smith         Engineering Manager         Project Lead
Sarah Johnson      Database Admin              Technical SME
Michael Brown      Security Officer            Risk Review
```

---

### Section 4: Scope & Constraints

**Scope** (Required)
- What's included in this request?
- What's out of scope?
- What systems are affected?

**Example:**
```
IN SCOPE:
- Order processing service
- Inventory service
- Payment integration
- Current data schema design

OUT OF SCOPE:
- Customer portal (separate initiative)
- Reporting system (will address later)
- Legacy billing system (will sunset)
```

**Key Requirements** (Required - at least 3)
- Functional requirements
- Non-functional requirements
- Regulatory/compliance requirements

**Example:**
```
Functional:
- Process 100K+ orders/day
- Support 3 payment methods
- Integrate with ERP system
- Real-time inventory updates

Non-Functional:
- 99.9% uptime SLA
- <100ms response time for order placement
- Support for 1000 concurrent users
- Horizontal scalability

Compliance:
- PCI DSS compliance for payments
- GDPR compliance for customer data
- SOC 2 Type II certification
```

**Constraints** (Optional)
- Budget limitations
- Timeline restrictions
- Technology restrictions
- Team skills/availability
- Regulatory constraints

**Example:**
```
- Budget: $500K capital, $50K/month operational
- Timeline: Production by Q2 2026
- Technology: Cloud-native preferred (AWS)
- Team: 4 engineers available full-time
- Constraint: Cannot replace existing reporting until replacement ready
```

**Known Risks** (Optional)
- What concerns do you have?
- What could go wrong?
- Any deal-breakers?

**Example:**
```
- Risk: Data migration from legacy database (large volume)
  Concern: Potential downtime during cutover
  
- Risk: Team unfamiliar with microservices
  Concern: May require significant training
  
- Risk: Tight timeline
  Concern: May need to compromise on completeness
```

---

### Section 5: Technical Context

**Current Architecture** (Required for reviews/designs)
- Describe existing system
- What's working well?
- What are pain points?
- Technology stack

**Example:**
> Monolithic Java application running on-premises with Oracle database. Uses synchronous HTTP communication. Deployed via manual processes. Single release every 2 weeks. Scaling by adding more powerful hardware becoming expensive.

**Proposed Approach** (Optional)
- If you have ideas, share them
- Proposed technologies
- High-level design concepts
- Reference architectures you're considering

**Example:**
> Considering moving to microservices on AWS. Evaluating:
> - Containers (Docker/Kubernetes) vs Lambda/Fargate
> - Event-driven via SNS/SQS vs synchronous REST
> - RDS for databases vs DynamoDB for specific services

**Similar Projects/References** (Optional)
- Have you seen similar solutions?
- Any reference implementations?
- Lessons learned from others?

**Example:**
> Reviewed AWS Well-Architected Framework, looked at competitor implementations, found similar migration at partner company.

---

### Section 6: Timeline & Availability

**Desired Timeline** (Required)
- Select priority:
  - ☐ Urgent (needed within 1 week)
  - ☐ High (needed within 2-4 weeks)
  - ☐ Medium (needed within 4-8 weeks)
  - ☐ Low (flexible, can wait)

**Project Timeline** (Required)
- When does this initiative start?
- When must decisions be made?
- When is production target?

**Example:**
```
Project kickoff: December 1, 2025
Architecture decisions needed by: December 15, 2025
Design phase: December-February
Implementation: February-June
Production target: June 30, 2026
```

**Team Availability** (Required)
- How much time can key team members dedicate?
- Are they fully available?
- Any vacation/leave planned?

**Example:**
```
Engineering Manager: 20% (meetings, coordination)
Tech Lead: 50% (detailed design, coordination)
Engineers: 100% (4 engineers full-time on project)
Database Admin: 25% (database design, migration)
```

---

### Section 7: Additional Information

**Budget** (Optional)
- Capital budget available
- Operational budget
- ROI expectations

**External Dependencies** (Optional)
- Vendor evaluations in progress
- Third-party tools or platforms
- External vendor relationships

**Documentation Provided** (Optional)
- Attach relevant documents:
  - [ ] Current architecture diagrams
  - [ ] Requirements documents
  - [ ] Technical specifications
  - [ ] Business case/ROI analysis
  - [ ] Vendor proposals
  - [ ] Code samples

**Next Steps After Approval** (Optional)
- Expected outcomes from engagement
- How will recommendations be implemented?
- Timeline for next phase?

**Additional Notes** (Optional)
- Anything else we should know?
- Context or background information
- Previous attempts or alternatives tried

---

## Sample Completed Form

### Request: Cloud Migration Architecture Review

**Requestor Information:**
- Name: John Smith
- Email: john.smith@company.com
- Department: Product Engineering
- Manager: Jane Doe, VP Engineering

**Request Details:**
- Title: Cloud Migration Architecture Review
- Type: Architecture Review
- Description: Our order processing system runs on-premises. We need comprehensive architecture review of our proposed AWS migration including service decomposition, data strategy, deployment approach, and operational model.

**Business Context:**
- Objective: Reduce infrastructure costs by 40%, improve reliability, and enable faster deployments
- Success Criteria: 
  1. Architecture handles 200K orders/day (2x current)
  2. Deployment frequency increased to weekly
  3. Infrastructure costs <$X/month
  4. Team autonomy with clear service ownership
- Stakeholders: VP Eng (sponsor), Tech Lead (project lead), DBA (technical), Security (risk review)

**Scope:**
- In Scope: Order system, inventory integration, payment processing
- Out of Scope: Customer portal, reporting, legacy billing
- Requirements: 99.9% uptime, <100ms response, PCI DSS, GDPR, SOC 2

**Technical Context:**
- Current: On-prem Java monolith, Oracle DB, manual deployment
- Proposed: AWS microservices, containers, CI/CD pipeline
- References: AWS Well-Architected Framework

**Timeline:**
- Priority: High (4 weeks)
- Project kickoff: Dec 1, Decisions needed: Dec 15, Production: Jun 30
- Team: Manager 20%, Tech Lead 50%, Engineers 100%

---

## Submission Process

### How to Submit

**Digital Submission (Preferred):**
1. Fill out this form completely
2. Include all supporting documents
3. Email to: architecture@company.com
4. Subject: "Architecture Service Request: [Your Title]"

**Paper Submission:**
1. Print this form
2. Complete all sections
3. Attach supporting documents
4. Submit to: Enterprise Architecture Office, Building A, Room 301

### What Happens Next

**1. Initial Review** (1-2 business days)
- Confirmation receipt email
- Form completeness check
- Request routing to appropriate architect

**2. Planning Meeting** (3-5 business days)
- Architect contacts you
- Clarify any details
- Confirm timeline and scope
- Establish communication plan

**3. Engagement** (As scheduled)
- Architecture work per timeline
- Regular check-ins
- Deliverables and recommendations

**4. Closeout**
- Final deliverables provided
- Feedback collected
- Document for future reference

### Estimated Response Times

| Priority | Response Time | Delivery Time | Duration |
|----------|---------------|---------------|----------|
| Urgent | 1 business day | 1 week | 8-16 hrs |
| High | 3 business days | 2-4 weeks | 16-40 hrs |
| Medium | 1 week | 4-8 weeks | 40-80 hrs |
| Low | 2 weeks | 8-12 weeks | 80-160 hrs |

*Times are estimates and depend on complexity and team availability*

---

## Form Sections Quick Reference

| Section | Required Fields | Purpose |
|---------|-----------------|---------|
| 1 | Name, Email, Dept, Sponsor | Identify requestor and routing |
| 2 | Title, Type, Description | Define what's needed |
| 3 | Business Objective, Success Criteria, Stakeholders | Align with business goals |
| 4 | Scope, Requirements, Constraints, Risks | Define boundaries |
| 5 | Current Architecture, Proposed Approach | Provide technical context |
| 6 | Timeline, Availability | Plan engagement |
| 7 | Additional Info, Budget, Dependencies | Complete picture |

---

## Tips for Completing the Form

✅ **Be specific**
- Vague requests delay processing
- Use concrete examples
- Attach diagrams and documents

✅ **Provide context**
- Why is this important to the business?
- What's driving urgency?
- What success looks like

✅ **Identify stakeholders**
- Who needs to be involved?
- Who makes final decisions?
- Who manages implementation?

✅ **Be realistic about timeline**
- Don't rush complex decisions
- Plan buffer for unexpected issues
- Coordinate with other initiatives

✅ **Attach supporting materials**
- Current architecture diagrams
- Technical specifications
- Business case
- Vendor proposals
- Requirements documents

❌ **Don't be vague**
- "We need architecture help" isn't specific
- Include actual numbers and goals
- Explain the business problem

❌ **Don't skip sections**
- Each section provides important information
- Incomplete forms delay processing
- Helps route to right architect

❌ **Don't underestimate timeline**
- Good architecture takes time
- Don't expect decisions in days
- Complex decisions need proper evaluation

❌ **Don't submit without sponsor**
- Manager/sponsor approval required
- Helps with prioritization
- Ensures organizational alignment

---

## Related Processes

- **[Service Request Process](./service-request-process.md)** - How requests are processed
- **[Engagement Model](./engagement-model.md)** - How architects work with you
- **[Architecture Review Board](./arb/README.md)** - Governance and approvals
- **[Communication Plan Template](./communication-plan.md)** - Team coordination

## Contact Information

**Enterprise Architecture Team**
- Email: architecture@company.com
- Slack Channel: #enterprise-architecture
- Office Hours: Tuesdays 10-11 AM, Thursdays 2-3 PM
- Physical Location: Building A, Room 301

**Quick Help:**
- Form questions: Email architecture@company.com
- Need urgent guidance: Contact your manager or VP Engineering
- General architecture questions: Post in #enterprise-architecture Slack channel

---

**Last Updated:** November 2025
**Maintained By:** Enterprise Architecture Team
**Version:** 1.0
**Related Form:** [Service Request Form Template](./service-request-form-template.md)
