# Engagement Model

## Overview

This document describes how project teams, product managers, and other stakeholders engage with the Solution Architecture Practice to get architecture support.

## When to Engage Architecture

### Required Engagement

Architecture involvement is **required** for:

- ✅ New product or platform development
- ✅ Major feature releases affecting multiple systems
- ✅ New technology adoption
- ✅ Significant architecture changes
- ✅ System integration with external parties
- ✅ Cloud migration initiatives
- ✅ Security-critical systems
- ✅ Projects with budget > $500K
- ✅ Data platform or pipeline development
- ✅ API platform initiatives

### Recommended Engagement

Architecture involvement is **recommended** for:

- ⚠️ Moderate feature releases
- ⚠️ Performance optimization initiatives
- ⚠️ Technical debt reduction programs
- ⚠️ Infrastructure changes
- ⚠️ Vendor selection
- ⚠️ Proof of concepts
- ⚠️ Architecture modernization

### Optional Engagement

Architecture can **optionally help** with:

- 💡 Design consultations
- 💡 Code reviews for architecture concerns
- 💡 Technical spike guidance
- 💡 Architecture learning and training
- 💡 Tool and framework questions

## Engagement Models

### Model 1: Embedded Architect

**Description**: Dedicated architect assigned to your team/project

**When to Use**:
- Strategic initiatives
- Long-running programs (6+ months)
- Complex, high-risk projects
- New product development
- Major platform initiatives

**How It Works**:
1. Submit architecture service request
2. Practice leadership assigns dedicated architect
3. Architect joins your team rituals (standups, planning, etc.)
4. Architect provides ongoing guidance throughout project
5. Architect coordinates ARB reviews as needed

**Timeline**: Ongoing throughout project

**Commitment**:
- Architect typically 25-100% allocated
- Part of your team's ceremonies
- Available for day-to-day questions

**Example Projects**:
- New customer portal development
- Payment platform rebuild
- Multi-year cloud migration

### Model 2: Consulting Engagement

**Description**: Architect provides specific deliverables or time-boxed consultation

**When to Use**:
- Specific architecture needs
- Technology evaluations
- Architecture assessments
- Design reviews
- Short to medium-term projects (< 6 months)

**How It Works**:
1. Submit architecture service request
2. Initial consultation to scope engagement
3. Define deliverables and timeline
4. Architect works on defined scope
5. Deliver artifacts and knowledge transfer

**Timeline**: 2-12 weeks typical

**Commitment**:
- Architect allocated part-time
- Focused on specific deliverables
- Scheduled working sessions

**Example Projects**:
- Database technology selection
- Microservices decomposition
- Security architecture design
- Integration architecture

### Model 3: Review & Advisory

**Description**: Periodic reviews and ad-hoc guidance

**When to Use**:
- Ongoing maintenance projects
- Small to medium features
- Teams with in-house architecture capability
- When you need validation more than design

**How It Works**:
1. Team develops design
2. Submit for architecture review
3. Review session with architect(s)
4. Feedback and recommendations
5. Iterate if needed

**Timeline**: 1-2 week review cycle

**Commitment**:
- Architect reviews submissions
- 1-2 hour review meetings
- Follow-up Q&A as needed

**Example Projects**:
- Feature releases
- Component refactoring
- Design pattern adoption

### Model 4: Office Hours & Ad-Hoc

**Description**: Quick consultations and guidance

**When to Use**:
- Quick questions
- Design discussions
- Pattern recommendations
- Tool selection
- Exploratory discussions

**How It Works**:
1. Drop into architecture office hours, OR
2. Post question in #architecture Slack channel, OR
3. Schedule 30-min consultation

**Timeline**: Same day to 3 days

**Commitment**:
- 15 minutes to 2 hours
- No formal deliverables
- Guidance and pointers

**Example Scenarios**:
- "Which database should we use for this use case?"
- "How should we implement caching?"
- "What's the pattern for handling distributed transactions?"
- "Can you review this design diagram?"

## How to Request Architecture Support

### Step 1: Determine Your Need

Review the [When to Engage](#when-to-engage-architecture) section to understand if architecture involvement is required, recommended, or optional.

### Step 2: Choose Engagement Model

Based on your project scope, duration, and complexity, select the appropriate [engagement model](#engagement-models).

### Step 3: Submit Request

Choose your submission method:

#### Option A: Service Request Form (Recommended)
- Fill out the [Architecture Service Request Form](./service-request-form.md)
- Email to solution-architecture@company.com
- Or submit via ServiceNow (Architecture Services catalog)

#### Option B: Slack (For Quick Questions)
- Post in #architecture-requests channel
- Include: project name, what you need, urgency

#### Option C: Office Hours (For Consultations)
- Check office hours schedule in #architecture channel
- Drop in during posted hours
- Or schedule a specific time slot

### Step 4: Initial Consultation

Within **3 business days**, an architect will:
- Review your request
- Schedule initial consultation (30-60 min)
- Understand your requirements
- Recommend engagement model if not already clear
- Estimate timeline and commitment

### Step 5: Engagement Begins

Depending on model:
- **Embedded**: Architect joins your team
- **Consulting**: Scope defined, work begins
- **Review**: You submit design, review scheduled
- **Ad-Hoc**: Immediate guidance provided

### Step 6: Ongoing Collaboration

- Regular check-ins and sync meetings
- Architecture reviews at key milestones
- ARB submission if required
- Documentation and knowledge transfer

### Step 7: Engagement Closure

- Final deliverables provided
- Knowledge transfer completed
- Post-engagement survey
- Ongoing support channel established

## Engagement Lifecycle

```
Request → Consultation → Engagement → Collaboration → Delivery → Closure
   ↓           ↓             ↓             ↓             ↓          ↓
 3 days    30-60 min    Varies       Ongoing       Per scope   Survey
```

## Service Level Commitments

| Engagement Type | Initial Response | Engagement Start | Typical Duration |
|----------------|------------------|------------------|------------------|
| Embedded | 3 business days | 1-2 weeks | Project duration |
| Consulting | 3 business days | 1-2 weeks | 2-12 weeks |
| Review & Advisory | 3 business days | < 1 week | Per review cycle |
| Office Hours | Same day | Immediate | 15 min - 2 hours |

## What to Prepare

To make the most of architecture engagement, prepare:

### For Initial Consultation
- Project overview and business objectives
- High-level requirements
- Key stakeholders and team structure
- Timeline and constraints
- Budget (if relevant)
- Any existing documentation or designs

### For Embedded Engagement
- Access to project repositories and tools
- Team calendar and meeting invites
- Product roadmap
- Technical constraints and dependencies

### For Review Engagement
- Design documents
- Architecture diagrams (C4 model preferred)
- API specifications
- ADRs for key decisions
- Non-functional requirements

### For Technology Evaluation
- Use cases and requirements
- Current state and pain points
- Options being considered
- Evaluation criteria
- POC scope (if applicable)

## Roles & Responsibilities

### Your Team's Responsibilities
- Clearly articulate requirements and constraints
- Provide access to necessary resources
- Participate in architecture sessions
- Implement architecture guidance
- Provide feedback on architecture engagement

### Architecture Team's Responsibilities
- Respond to requests in a timely manner
- Provide clear, actionable guidance
- Document decisions and designs
- Coordinate ARB reviews
- Support implementation
- Knowledge transfer

## Escalation

If you're not getting the support you need:

1. **First**: Speak with your assigned architect
2. **Second**: Contact Principal Architect for your domain
3. **Third**: Escalate to Director of Solution Architecture

Contact: solution-architecture-escalations@company.com

## Success Criteria

A successful architecture engagement delivers:

✅ **Clear Guidance**: Actionable architecture direction  
✅ **Quality Design**: Well-architected solution  
✅ **Documentation**: Comprehensive architecture artifacts  
✅ **Knowledge Transfer**: Team understands the architecture  
✅ **On-Time Delivery**: Architecture doesn't delay project  
✅ **Satisfied Stakeholders**: Teams satisfied with support  

## Feedback

We continuously improve based on feedback:

### During Engagement
- Regular check-ins to ensure we're meeting your needs
- Open communication channels
- Adapt approach based on feedback

### After Engagement
- Post-engagement survey (anonymous option available)
- Retrospective with your team
- Lessons learned captured

### Share Feedback
- Email: solution-architecture@company.com
- Slack: #architecture-feedback
- Direct conversation with your architect
- Quarterly practice reviews

## Examples

### Example 1: New Product Launch

**Scenario**: Launching a new customer-facing mobile app

**Engagement Model**: Embedded Architect

**Process**:
1. Product Manager submits architecture service request
2. Initial consultation to understand vision and requirements
3. Senior Solution Architect assigned 50% to project
4. Architect participates in inception and design sprints
5. Solution architecture document created
6. ARB review conducted
7. Architect guides implementation through launch
8. Knowledge transfer to maintenance team

**Duration**: 6 months

### Example 2: Technology Evaluation

**Scenario**: Evaluate message queue technologies

**Engagement Model**: Consulting Engagement

**Process**:
1. Engineering Lead submits request
2. Integration Architect assigned
3. Evaluation criteria defined together
4. Architect conducts research and POCs
5. Technology comparison document created
6. Recommendation presented to stakeholders
7. ADR documenting decision

**Duration**: 4 weeks

### Example 3: Feature Design Review

**Scenario**: New payment processing feature

**Engagement Model**: Review & Advisory

**Process**:
1. Team develops initial design
2. Submit design docs for review
3. 90-minute review session with architect
4. Feedback on security, scalability, and integration
5. Team refines design
6. Quick follow-up review (30 min)
7. Approval to proceed

**Duration**: 2 weeks

### Example 4: Quick Consultation

**Scenario**: Database choice for new microservice

**Engagement Model**: Office Hours

**Process**:
1. Developer posts question in #architecture
2. Data Architect responds within 2 hours
3. 30-minute call to discuss requirements
4. Recommendation provided with rationale
5. Pointer to database selection decision tree

**Duration**: Same day

## FAQs

**Q: Do I need architecture approval to start development?**  
A: For [required engagement](#required-engagement) projects, yes. For others, it's recommended but not blocking.

**Q: How much does architecture support cost?**  
A: Architecture is a shared service. There's no direct cost to your project.

**Q: Can I request a specific architect?**  
A: You can express preference, but assignment considers workload, expertise, and availability.

**Q: What if I disagree with architecture guidance?**  
A: Architecture provides recommendations, not mandates (except for governance items). Discuss concerns with your architect. Escalation path is available.

**Q: How do I know if my project needs ARB review?**  
A: Your architect will guide you. Generally, major projects and significant decisions require ARB.

**Q: Can I get architecture help for a spike or POC?**  
A: Yes! Use Office Hours model for quick POC guidance or Consulting model for more involved POCs.

**Q: What if our timelines are very aggressive?**  
A: Let us know upfront. We can adjust engagement model and prioritize critical architecture aspects.

---

[Back to Processes](./README.md) | [Home](../../README.md)
