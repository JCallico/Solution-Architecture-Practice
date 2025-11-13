# Service Request Process

## Overview

The Architecture Practice provides comprehensive services to business units and development teams to help them design, evaluate, and implement enterprise solutions. This document defines the service request process, intake procedures, routing logic, and delivery workflows.

**Service Request Lifecycle:**
```
Submission → Triage → Assignment → Execution → Delivery → Closure
```

## Service Request Intake

### How to Submit a Service Request

**Online Form:** Submit via [Architecture Service Request Form](../templates/service-request-form.md)

**Email Option:** architecture-practice@company.com

**Slack Option:** #architecture-requests channel for urgent items

**Walk-in Clinic:** Office hours (see [Office Hours](../team/office-hours.md))

### Required Information

All service requests must include:

1. **Request Information**
   - Requester name and contact information
   - Department/business unit
   - Urgency level (Critical, High, Medium, Low)
   - Preferred timeline for completion

2. **Problem Statement**
   - Clear description of business need or technical challenge
   - Business impact and success metrics
   - Current state (if applicable)
   - Constraints or dependencies

3. **Scope Definition**
   - Proposed deliverables
   - Known constraints
   - Related systems or services
   - Stakeholder list

4. **Attachments**
   - Existing architecture diagrams
   - Requirements documents
   - Related ADRs or decision records
   - Supporting documentation

## Service Types and Effort Estimates

### Type 1: Architecture Design (Strategic)

**Definition:** Design comprehensive solution architecture for new systems, major transformations, or critical decisions

**Scope:**
- Full architecture design from requirements to implementation plan
- Multiple design alternatives evaluated
- NFR analysis and capacity planning
- Technology selection and justification
- Security, compliance, and operational considerations

**Typical Deliverables:**
- Architecture Decision Record (ADR)
- Architecture Design Document (20-40 pages)
- C4 context, container, and component diagrams
- Technology selection matrix and evaluation
- Implementation roadmap with phases
- Risk assessment and mitigation strategies
- Team structure and skills requirements

**Effort Estimate:** 8-12 weeks
**Team Size:** 3-5 architects (principal, senior, staff)
**Cost Allocation:** 300-500 architect-hours

**SLA:**
- Initial consultation: 5 business days
- Design kickoff: 10 business days
- Design review: 4 weeks in
- Delivery: 8-12 weeks
- Post-delivery support: 2 weeks

**Example Scenarios:**
- Microservices transformation strategy
- Cloud migration architecture
- New data platform design
- Enterprise integration strategy
- Digital transformation roadmap

### Type 2: Design Review (Validation)

**Definition:** Evaluate and provide feedback on existing architecture designs, proposals, or implementation plans

**Scope:**
- Architecture review against standards and best practices
- Security and compliance assessment
- Operational readiness evaluation
- Performance and scalability analysis
- Technology stack review

**Typical Deliverables:**
- Architecture Review Board (ARB) assessment
- Findings document with severity levels
- Recommendations with justification
- Risk assessment
- Implementation guidance for remediation
- Approval decision with conditions (if applicable)

**Effort Estimate:** 2-4 weeks
**Team Size:** 2-3 architects (senior/principal)
**Cost Allocation:** 40-80 architect-hours

**SLA:**
- Initial review: 1 week
- Review meeting: 2 weeks
- Findings delivery: 3 weeks
- Follow-up review: 4 weeks

**Review Checklist:** See [Architecture Review Checklist](../templates/architecture-review-checklist.md)

**Example Scenarios:**
- Peer design review before major implementation
- Third-party architecture audit
- Post-implementation assessment
- Technology selection validation
- Compliance evaluation

### Type 3: Technology Evaluation (Decision Support)

**Definition:** Evaluate and compare technologies, platforms, or approaches to support decision-making

**Scope:**
- Technology landscape analysis
- Product/solution comparison
- Proof of concept design
- Integration assessment
- Cost-benefit analysis
- Implementation complexity evaluation

**Typical Deliverables:**
- Technology Evaluation Report
- Comparison matrix (weighted criteria scoring)
- POC requirements and success criteria
- Procurement recommendation
- Implementation approach
- Training and skills assessment
- Total cost of ownership (TCO) model

**Effort Estimate:** 4-8 weeks
**Team Size:** 2-3 architects (domain expert + generalist)
**Cost Allocation:** 80-160 architect-hours

**SLA:**
- Evaluation plan: 5 business days
- Technology briefings: 2 weeks
- Analysis completion: 4 weeks
- Recommendation delivery: 6 weeks

**Technology Evaluation Process:** See [Technology Evaluation Guide](./technology-evaluation.md)

**Example Scenarios:**
- Cloud provider selection (AWS vs Azure vs GCP)
- API gateway product evaluation
- Database platform selection
- Messaging system comparison
- Kubernetes distribution selection

### Type 4: Architecture Guidance (Advisory)

**Definition:** Provide architectural guidance and mentoring to teams on specific topics or challenges

**Scope:**
- Ad-hoc architectural advice
- Technical mentoring and coaching
- Pattern and best practice recommendations
- Design review and feedback
- Problem-solving assistance
- Upskilling and knowledge transfer

**Typical Deliverables:**
- Technical guidance document (5-15 pages)
- Implementation recommendations
- Code examples or templates
- Training materials or sessions
- References and learning resources
- Follow-up mentoring sessions

**Effort Estimate:** 2-6 weeks
**Team Size:** 1-2 architects
**Cost Allocation:** 20-60 architect-hours

**SLA:**
- Initial discussion: 3 business days
- Guidance document: 2 weeks
- Follow-up sessions: 4 weeks

**Example Scenarios:**
- Microservices decomposition guidance
- API design review and mentoring
- Observability strategy development
- Kubernetes adoption roadmap
- Security architecture guidance

### Type 5: Training and Workshops

**Definition:** Deliver technical training, architecture katas, and workshops on specific topics

**Scope:**
- Custom training development
- Workshop facilitation
- Architecture kata design
- Hands-on labs
- Knowledge transfer sessions
- Team readiness assessments

**Typical Deliverables:**
- Training curriculum
- Participant materials and workbooks
- Lab exercises with solutions
- Video recordings (if applicable)
- Knowledge base articles
- Assessment materials

**Effort Estimate:** 1-3 weeks (execution), plus prep time
**Team Size:** 1-3 architects (domain expert)
**Cost Allocation:** 30-80 architect-hours

**SLA:**
- Initial planning: 1 week
- Materials development: 2 weeks
- Training delivery: flexible based on schedule
- Follow-up assessment: 2 weeks

**Example Scenarios:**
- Microservices architecture workshop
- Kubernetes fundamentals training
- Cloud migration patterns workshop
- Security architecture training
- Architecture design thinking sessions

## Service Request Triage

### Initial Assessment

All service requests are assessed within 2 business days:

| Criteria | Assessment |
|----------|------------|
| **Completeness** | Are all required fields provided? |
| **Business Alignment** | Does request align with business strategy? |
| **Scope Clarity** | Is scope well-defined and reasonable? |
| **Resource Feasibility** | Do we have capacity and expertise? |
| **Urgency** | What is the actual priority level? |

### Triage Decision Matrix

```
Urgency × Complexity × Scope = Priority & Timeline

Critical + High Complexity + Large Scope = Expedited (2-4 week timeline)
High + Medium Complexity + Medium Scope = Standard (4-8 week timeline)
Medium + Low Complexity + Small Scope = Deferred (8-12 week timeline)
Low + Any = Backlog or Self-service resources
```

### Incomplete Requests

If a request is incomplete:

1. **Day 1:** Requester is contacted with missing information list
2. **Day 3:** Reminder sent if information not provided
3. **Day 5:** Request marked as "On Hold" pending information
4. **Day 15:** On-hold request archived if information not received

## Service Request Routing

### Routing Algorithm

Service requests are routed based on:

1. **Primary Factor: Domain Expertise Required**
   - E-Commerce Architecture → E-Commerce Domain Champion
   - Data/Analytics → Data Domain Champion
   - Cloud Infrastructure → Cloud Domain Champion
   - Integration/APIs → Integration Domain Champion
   - Security Architecture → Security Domain Champion

2. **Secondary Factor: Current Workload**
   - Request assigned to principal or senior architect with capacity
   - Team load balanced across domain

3. **Tertiary Factor: Development Opportunity**
   - Opportunity for staff/associate architect growth considered
   - Mentoring assignments distributed

### Assignment Procedure

1. **Intake Owner** reviews request and determines primary domain
2. **Domain Champion** contacted with request details
3. **Assignment** made to available architect (primary + backup)
4. **Confirmation** sent to requester with architect assignment
5. **Kickoff Meeting** scheduled within 5 business days

### Escalation Path

```
Request Submitter
    ↓
Practice Manager (if urgent/critical)
    ↓
VP Architecture (if policy/governance issue)
    ↓
CTO (if strategic/cross-organization)
```

## Execution Phase

### Kickoff Meeting

**Attendees:**
- Assigned architect(s)
- Request submitter and sponsor
- Key technical stakeholders
- Domain expert (if not primary architect)

**Agenda (1-2 hours):**
1. Business context and success criteria review (15 min)
2. Current state assessment (15 min)
3. Scope clarification and constraints (15 min)
4. Deliverables and timeline confirmation (15 min)
5. Stakeholder identification and communication plan (15 min)
6. Next steps and checkpoints (5 min)

**Kickoff Deliverable:** Engagement Charter
```
- Business objectives
- Scope boundaries
- Key assumptions
- Risks and mitigation strategies
- Communication cadence
- Decision authority and approval process
```

### Ongoing Execution

**Weekly Status Updates:**
- Progress against deliverables
- Issues and risks encountered
- Upcoming milestones
- Resource needs and constraints

**Checkpoint Meetings:**
- Midpoint checkpoint (50% complete)
- Technical review checkpoint (design validation)
- Pre-delivery checkpoint (final review)

**Issue Escalation:**
- Minor issues: Addressed in next status update
- Major issues: Escalated to domain champion immediately
- Blocking issues: Escalated to practice manager

### Stakeholder Engagement

**Throughout Engagement:**
- Weekly or bi-weekly status updates to sponsor
- Regular feedback from technical team
- Executive review at key milestones
- Stakeholder sign-off on major decisions

**Decision Authority:**
- Architectural decisions: Lead architect + domain champion approval
- Technical trade-offs: Lead architect + team technical lead consensus
- Scope changes: Sponsor approval + practice manager notification

## Delivery Phase

### Deliverable Quality Standards

All deliverables must meet these standards:

**Documentation Quality:**
- ✓ Clear, concise writing (grade 8 reading level)
- ✓ Proper grammar and spelling
- ✓ Consistent formatting and style
- ✓ All figures labeled with captions
- ✓ Tables with headers and legends
- ✓ Code examples tested and compilable

**Technical Accuracy:**
- ✓ Peer reviewed by at least one other architect
- ✓ Validated against current technology versions
- ✓ Aligned with organizational standards
- ✓ Cross-references correct and up-to-date
- ✓ No placeholder or TBD content

**Completeness:**
- ✓ All promised sections included
- ✓ All questions answered
- ✓ All alternatives considered
- ✓ Implementation guidance included
- ✓ Next steps clearly defined

### Delivery Process

1. **Pre-Delivery Review**
   - Lead architect conducts final quality check
   - Domain champion reviews for alignment
   - Sponsor reviews for business relevance

2. **Delivery Meeting**
   - Presentation of findings and recommendations
   - Q&A and discussion
   - Sign-off on deliverables
   - Next steps discussion

3. **Documentation**
   - Store deliverables in shared repository
   - Update practice knowledge base
   - Create ADRs or reference records as needed
   - Archive engagement metadata

### Post-Delivery Support

**Included in Service:**
- 2 weeks of follow-up questions answered
- Clarification on recommendations
- Guidance on implementation approach

**Not Included:**
- Implementation execution (separate engagement)
- Ongoing operational support
- Technology support (vendor/platform responsibility)

## Closure and Follow-up

### Closure Checklist

- [ ] All deliverables provided and accepted
- [ ] Questions and action items resolved
- [ ] Engagement documentation complete
- [ ] Knowledge transfer completed (if applicable)
- [ ] Lessons learned captured
- [ ] Feedback survey sent and reviewed

### Engagement Metrics

Tracked for each service request:

| Metric | Target |
|--------|--------|
| **Customer Satisfaction** | 4.0+ / 5.0 |
| **On-time Delivery** | 95% |
| **Deliverable Quality Score** | 4.2+ / 5.0 |
| **Implementation Adoption** | 70%+ of recommendations adopted |
| **Business Impact Realization** | Tracked after 6 months |

### Feedback Survey

All requesters receive post-delivery survey:

```
1. Were deliverables complete and helpful? (1-5)
2. Did the architect understand your business need? (1-5)
3. Was the process easy and responsive? (1-5)
4. Would you request architecture services again? (Yes/No)
5. What could we improve? (Open-ended)
```

### Knowledge Sharing

After every service engagement:
- Key insights documented in knowledge base
- Patterns and learnings added to pattern catalog
- Case study template filled for significant engagements
- Relevant ADRs shared with broader organization
- Lessons learned shared in architecture forums

## Service Request Portal (Future)

Planned enhancements:

- **Automated Status Tracking:** Real-time view of request status
- **Request Templates:** Pre-filled forms for common request types
- **Skill Matrix Integration:** Automatic architect recommendation
- **Calendar Integration:** Automated schedule coordination
- **Document Generation:** Auto-population of standard templates
- **Metrics Dashboard:** Capacity and utilization tracking

## Related Resources

- [Service Request Form](../templates/service-request-form.md)
- [Architecture Review Checklist](../templates/architecture-review-checklist.md)
- [Technology Evaluation Guide](./technology-evaluation.md)
- [Decision Process](./decision-process.md)
- [Stakeholder Management](./stakeholder-management.md)
- [Communication Plan](./communication-plan.md)
- [Office Hours](../team/office-hours.md)
- [Domain Expertise](../team/domain-expertise.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Owner:** VP Architecture
