# Architecture Review Checklist

## Purpose

This checklist guides Architecture Review Board members through a systematic evaluation of proposed architectural decisions, ensuring consistency with organizational principles and minimizing risks.

---

## When to Use

- Reviewing ARB submissions
- Evaluating architectural proposals
- Conducting design reviews
- Assessing technology decisions
- Approving significant system changes
- Evaluating acquisition recommendations

---

## Pre-Review Phase

Before the review meeting, verify that the submission is complete:

```
Submission Completeness:
☐ Executive summary is clear and concise
☐ Problem statement is well-articulated
☐ Proposed solution is detailed with diagrams
☐ Resource requirements specified
☐ Timeline with milestones provided
☐ Risk assessment completed
☐ Success criteria defined
☐ Alternatives evaluated
☐ All stakeholders listed
☐ Executive sponsor identified
☐ Budget estimate provided

Documentation Quality:
☐ All sections completed (not "TBD")
☐ Diagrams are clear and labeled
☐ Metrics are quantified with units
☐ Rationale provided for decisions
☐ Related documents referenced
☐ Technical depth appropriate for audience
☐ No major gaps or missing analysis

Readiness:
☐ Submitter available for discussion
☐ Key technical experts available
☐ Required stakeholders notified
☐ Presentation prepared
☐ Supporting materials attached
```

---

## Section 1: Problem & Opportunity Assessment

Evaluate whether the problem is real and the solution is necessary:

```
Problem Validation:
☐ Problem is clearly stated
☐ Business impact quantified (revenue, efficiency, risk)
☐ Current state metrics documented
☐ Root cause analysis performed
☐ Problem validated with affected teams
☐ Stakeholder pain points documented

Questions to Ask:
- What happens if we don't solve this?
- Have we tried other approaches? Why didn't they work?
- Is this a problem for all teams or isolated?
- What would an 80% solution look like? (vs 100%)
- Can we defer this decision? What changes if we wait?
- Is the problem growing or stable?

Risk Assessment (Problem Scope):
- [ ] Low: Problem clearly defined, consensus agreement
- [ ] Medium: Problem definition debated, some disagreement
- [ ] High: Problem definition unclear, no consensus
```

---

## Section 2: Solution Architecture Quality

Evaluate the technical soundness of the proposed solution:

### 2.1 Architecture Principles Alignment

```
Organizational Principles Checklist:
For each principle, rate alignment:

[Principle Name]: ☐ Aligned ☐ Misaligned ☐ Neutral
[Questions]:
- How does this decision support/hinder this principle?
- Are we making intentional tradeoffs?
- Are tradeoffs acceptable given business context?

[Repeat for each organizational principle]

Overall Alignment: [X/10] (1=strong conflict, 10=perfect alignment)
Acceptable Tradeoffs: ☐ Yes ☐ No ☐ Requires discussion
```

### Example: Cloud-First Principle

```
Cloud-First Principle: ☐ Aligned ☐ Misaligned ☐ Neutral

Questions:
- Are we moving workloads to public cloud? (Yes/No/Partial)
- Are we using managed services? (Yes/No/How many)
- Are we reducing on-premises footprint? (How much)

Assessment:
- Proposal moves all workloads to AWS (cloud-first aligned)
- Uses managed RDS, ElastiCache, S3 (managed services aligned)
- Retains on-premises database for legacy compliance (misalignment)
- Tradeoff accepted: Legacy system keeps data on-premises for 18 months

Decision: Alignment acceptable with noted exception
```

### 2.2 Architecture Patterns

```
Architectural Patterns Used:
- Pattern 1: [Name]
  ☐ Appropriate for use case
  ☐ Correctly applied
  ☐ Team has experience
  ☐ Operational complexity acceptable

[Repeat for each pattern]

Overall Pattern Assessment: ☐ Good ☐ Acceptable ☐ Concerning
Issues: [List any concerns]
```

### 2.3 Design Quality

```
Design Completeness:
☐ Component design detailed
☐ Data model designed
☐ API/interface contracts defined
☐ Integration points identified
☐ Deployment architecture designed
☐ Operational considerations addressed
☐ Disaster recovery planned
☐ Security architecture included

Design Clarity:
☐ Architecture diagrams clear and complete
☐ Component responsibilities well-defined
☐ Data flows documented
☐ Dependency map provided
☐ Interaction patterns explained

Questions to Ask:
- What are the critical components? Why?
- Where are potential single points of failure?
- What happens when component X fails?
- How many hops between critical services?
- What is the blast radius of a deployment?
- Can this design scale to [2x/10x/100x] current size?
```

---

## Section 3: Technology Assessment

Evaluate technology choices:

```
Technology Choices Evaluation:

For Each Technology:
- Name: [Technology]
- Version: [Version]
- Rationale: ☐ Clear ☐ Unclear
- Justification: ☐ Strong ☐ Acceptable ☐ Weak

☐ Solves stated problem
☐ Aligns with architecture principles
☐ Team has experience
☐ Vendor/community support strong
☐ License acceptable
☐ Total cost of ownership reasonable
☐ Alternatives evaluated
☐ Switching costs understood

Red Flags:
☐ Immature technology (< 1 year stable)
☐ Weak community/vendor support
☐ High switching costs
☐ No team expertise
☐ License restrictions
☐ Proprietary/vendor lock-in concerns
☐ Significant performance unknowns

Overall Technology Assessment:
- [ ] Low Risk: Proven, well-supported, team experienced
- [ ] Medium Risk: Some unknowns, but acceptable
- [ ] High Risk: Significant concerns, requires mitigation
```

---

## Section 4: Risk Assessment

Evaluate risk identification and mitigation:

```
Risk Evaluation Framework:

For Each Identified Risk:

Risk: [Risk Name]
Likelihood: [Low/Med/High] - Rate 1-10
Impact: [Low/Med/High] - Quantify ($, hours, users)
Mitigation: ☐ Clear ☐ Vague ☐ Missing

Questions:
- Is mitigation realistic and affordable?
- What is the residual risk after mitigation?
- Who owns the mitigation?
- When is mitigation complete?
- How will we know if mitigation failed?

Risk Gaps Identified:
☐ None - all risks identified
☐ Some - gaps in risk identification
☐ Significant - major risks missing

Potential Risks Not Mentioned:
1. [Risk]: Likelihood [L/M/H], Impact [L/M/H]
   Mitigation recommendation: [Strategy]

Overall Risk Profile:
- [ ] Low: Risks identified, mitigations solid
- [ ] Medium: Acceptable risk with documented mitigations
- [ ] High: Significant risks; mitigation plan insufficient
```

---

## Section 5: Resource & Timeline Review

Evaluate resource requirements and feasibility:

```
Resource Assessment:

Team Composition:
☐ Sufficient senior engineers
☐ Adequate DevOps/platform support
☐ Product/business representation
☐ Security expertise included
☐ Realistic team availability
☐ No critical person dependencies

Budget:
☐ Estimate is reasonable (±25%)
☐ Covers all phases
☐ Includes contingency (10-20%)
☐ Within budget constraints

Timeline Evaluation:
☐ Milestones are specific and measurable
☐ Dependencies identified
☐ Critical path clear
☐ Buffer included for risks
☐ Realistic estimates (not optimistic)

Questions to Ask:
- What could delay this timeline?
- What are the hard deadlines?
- What could we reduce scope on to accelerate?
- Is the team over-allocated?
- What external dependencies exist?
- What could be parallelized?

Timeline Risk:
- [ ] Low: Solid estimates, clear path
- [ ] Medium: Some timeline risk, acceptable
- [ ] High: Timeline appears optimistic
```

---

## Section 6: Success Criteria Evaluation

Assess whether success criteria are measurable and achievable:

```
Technical Metrics:
For each metric:
☐ Clearly defined
☐ Measurable with available tools
☐ Baseline established
☐ Target is achievable
☐ Timeline is realistic
☐ Owner identified

Example validation:
Metric: API latency (P95) < 200ms
- Baseline: 800ms (current state documented)
- Target: 200ms (40% improvement, aggressive but achievable)
- Timeline: 6 months (achievable given design)
- Owner: Platform team
- Measurement: APM tool (DataDog)
✓ This metric is well-defined

Business Metrics:
☐ Business impact quantified
☐ Metrics align with strategy
☐ Attribution methodology clear (what changed?)
☐ Baseline vs target specified
☐ Timeline realistic for business change

Operational Metrics:
☐ Operational impact assessed
☐ On-call impact understood
☐ Runbook completeness evaluated
☐ Support team trained

Questions:
- What if we hit 80% of targets? Is that success?
- How will we measure business impact?
- What leading indicators suggest success?
- Are metrics aligned with risk profile?

Success Criteria Overall Assessment:
- [ ] Excellent: Clear, measurable, achievable
- [ ] Good: Mostly clear with minor gaps
- [ ] Concerning: Vague, difficult to measure
```

---

## Section 7: Operational Readiness

Assess operational preparedness:

```
Operational Planning:
☐ Deployment strategy documented
☐ Runbooks prepared
☐ Monitoring/alerting configured
☐ Incident response plan ready
☐ Rollback procedure defined
☐ On-call rotation planned
☐ Training plan for ops team
☐ Documentation complete

Specific Questions:
- What happens at 2 AM when this fails?
- How do we find the root cause?
- What is the MTTR target and is it achievable?
- Do we have sufficient observability?
- Is the on-call team trained?
- What is the escalation path?

Deployment Approach:
☐ Canary/staged rollout planned
☐ Feature flags for rollback
☐ A/B testing capability
☐ Rollback timeline defined
☐ Communication plan for outage

Observability:
☐ Metrics defined (what to measure)
☐ Dashboards designed
☐ Alerting thresholds set
☐ Log aggregation configured
☐ Distributed tracing capability
☐ SLI/SLO defined

Operational Risk:
- [ ] Low: Well-prepared, team confident
- [ ] Medium: Acceptable with training/preparation
- [ ] High: Operational risks significant, mitigation needed
```

---

## Section 8: Stakeholder & Governance

Evaluate stakeholder alignment and governance:

```
Stakeholder Alignment:
For each stakeholder group:
- Name/Team: [Group]
- Impact: ☐ High ☐ Medium ☐ Low
- Consulted: ☐ Yes ☐ No ☐ Partially
- Aligned: ☐ Yes ☐ No ☐ Neutral

Critical stakeholders:
☐ Executive sponsor identified and committed
☐ Affected teams consulted
☐ Security/compliance reviewed
☐ Finance approved budget
☐ Operations prepared

Governance & Oversight:
☐ Clear decision authority identified
☐ Approval gates defined
☐ Escalation path clear
☐ Regular review cadence planned
☐ Go/no-go decision criteria defined

Cross-functional Risks:
- Are there team dynamics concerns?
- Are there org structure impacts?
- Is there resistance from stakeholders?
- Are there political considerations?

Governance Assessment:
- [ ] Strong: Clear sponsorship, alignment, oversight
- [ ] Adequate: Acceptable governance, minor concerns
- [ ] Weak: Governance gaps, accountability unclear
```

---

## Section 9: Strategic Alignment

Evaluate alignment with organizational strategy:

```
Strategic Alignment:
☐ Supports organizational strategy
☐ Aligned with product roadmap
☐ Fits in architectural evolution
☐ Enables competitive advantage
☐ Supports team scaling
☐ Enables organizational goals

Questions:
- Does this solve a strategic problem?
- Does this enable our 5-year vision?
- Would we regret not doing this?
- Is timing right, or should we defer?
- Does this enable other initiatives?

Strategic Value Assessment:
- [ ] High: Strategic importance, enables capabilities
- [ ] Medium: Useful, supports strategy
- [ ] Low: Incremental improvement, nice-to-have
```

---

## Section 10: Alternatives Analysis

Evaluate thoroughness of alternatives analysis:

```
Alternatives Evaluated:

For each alternative:
☐ Properly described
☐ Pros honestly assessed
☐ Cons honestly assessed
☐ Cost/benefit compared
☐ Timeline compared
☐ Risk profile compared
☐ Rationale for rejection clear

Evaluation Quality:
☐ At least 2-3 alternatives considered
☐ "Do nothing" alternative evaluated
☐ "Incremental improvement" alternative evaluated
☐ More aggressive alternative evaluated
☐ Make vs buy alternatives considered

Questions:
- Why wasn't [obvious alternative] considered?
- Is the comparison fair and honest?
- Would a different team choose differently?
- Are we anchoring on the first solution?

Alternatives Assessment:
- [ ] Thorough: Good analysis of multiple options
- [ ] Adequate: Considered main alternatives
- [ ] Weak: Limited alternatives explored
```

---

## Section 11: Architecture Review Discussion

Document the actual review discussion:

```
Discussion Points:
1. [Topic]: [Summary of discussion]
   - Perspective A: [Position]
   - Perspective B: [Position]
   - Resolution: [Outcome]

2. [Topic]: [Summary]
   - [Discussion]
   - [Resolution]

[Continue for each discussion item]

Key Decisions Made:
1. [Decision]: [Rationale]
2. [Decision]: [Rationale]

Conditions for Approval:
1. [Condition]: [Why required, success criteria]
2. [Condition]: [Why required, success criteria]
3. [Condition]: [Why required, success criteria]

Required Modifications:
1. [Modification]: [What needs to change, why]
2. [Modification]: [What needs to change, why]

Questions for Submitter:
1. [Question]: [Context]
   Answer: ___________
2. [Question]: [Context]
   Answer: ___________
```

---

## Final Review Decision

```
Overall Assessment Summary:

Problem Quality:        [1] [2] [3] [4] [5]
Solution Quality:       [1] [2] [3] [4] [5]
Technical Soundness:    [1] [2] [3] [4] [5]
Operational Readiness:  [1] [2] [3] [4] [5]
Risk Management:        [1] [2] [3] [4] [5]
Strategic Alignment:    [1] [2] [3] [4] [5]
Governance:             [1] [2] [3] [4] [5]

Average Score: ____ (4.0+ recommended for approval)

Final Decision:
☐ APPROVED - Proceed as proposed
☐ APPROVED WITH CONDITIONS - See conditions below
☐ APPROVED WITH MODIFICATIONS - See required changes below
☐ DEFERRED - Resubmit after addressing concerns
☐ REJECTED - Significant concerns, recommend alternative approach

Approval Conditions (if applicable):
1. [Condition]: Due by [Date]
   Verification: [How we'll verify this was met]

2. [Condition]: Due by [Date]
   Verification: [How we'll verify this was met]

Required Modifications (if applicable):
1. [Modification]: [What to change]
   Reason: [Why required]
   Resubmit by: [Date]

2. [Modification]: [What to change]
   Reason: [Why required]
   Resubmit by: [Date]

Rejection Rationale (if applicable):
[Clear explanation of why this proposal is rejected]
[Path forward - what would need to change]
[Alternative recommendations]

Approval Authority: ___________
Review Date: ___________
Next Review: ___________
```

---

## Post-Review Actions

```
Items Assigned:
- [ ] Item 1: Owner, Due Date
- [ ] Item 2: Owner, Due Date
- [ ] Item 3: Owner, Due Date

Communication:
- [ ] Decision communicated to submitter
- [ ] Decision documented in system
- [ ] Relevant stakeholders notified
- [ ] Conditions/modifications communicated clearly

Follow-up:
- [ ] Review meeting scheduled (if modifications needed)
- [ ] Implementation tracking initiated
- [ ] Success metrics monitoring enabled
- [ ] Quarterly progress review scheduled
```

---

## Architecture Review Board Checklist Summary

Quick reference for reviewers:

```
☐ Submission is complete before meeting
☐ Problem is real and well-articulated
☐ Solution is sound and well-designed
☐ Technology choices are justified
☐ Risks are identified and mitigated
☐ Resources and timeline are realistic
☐ Success criteria are measurable
☐ Team is prepared operationally
☐ Stakeholders are aligned
☐ Strategy alignment is clear
☐ Alternatives were properly evaluated
☐ Discussion issues are resolved
☐ Final decision is documented
☐ Conditions/modifications are clear
☐ Follow-up actions are assigned
```

---

## Related Resources

- [ARB Submission Template](./arb-submission-template.md)
- [Architecture Principles](../../knowledge-base/principles/README.md)
- [Architecture Review Process](../../processes/architecture-review-process.md)
- [Decision Template](./decisions.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
