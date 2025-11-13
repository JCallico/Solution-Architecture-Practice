# Contributing to Architecture Knowledge Base

## Purpose

This knowledge base is a living document maintained by the architecture practice team and community. These guidelines help maintain consistency, quality, and usability of contributed content.

---

## How to Contribute

### 1. Identify Content Gap

**Review existing content:**
- Check [Table of Contents](README.md)
- Review related documentation
- Check [Decisions](./decisions.md) for already-addressed topics

**Propose new content:**
- Open an issue with `[CONTENT PROPOSAL]` title
- Include: topic, audience, estimated scope (500/1000/2000 lines)
- Allow 1 week for community feedback

### 2. Content Preparation

**Create pull request with:**
- New file in appropriate directory
- Content following templates below
- Self-review (see checklist)
- Link to motivating issue

### 3. Review & Feedback

**Review process:**
1. Peer review by 1-2 architects (1 week)
2. Grammar/style review (1-2 days)
3. Feedback iterations (as needed)
4. Final approval and merge

**Timeline:**
- Minor updates: 3-5 days
- New major content: 2 weeks
- Complex/sensitive topics: 3+ weeks

---

## Content Templates

### Pattern Documentation Template

```markdown
# [Pattern Name]

## Intent & Problem

Brief description of what problem this pattern solves.

## Solution

How the pattern solves the problem.

## Structure

Diagram or component structure.

## Participants

Components involved and their roles.

## Implementation

Step-by-step implementation details.

## Consequences

Benefits:
- Benefit 1
- Benefit 2

Drawbacks:
- Drawback 1
- Drawback 2

Trade-offs:
- Trade-off 1

## Example Implementation

Real-world code example.

## Related Patterns

- Pattern A (when to use instead)
- Pattern B (complements this pattern)

## References

- Book/Article 1
- Book/Article 2

---

**Status:** Complete
**Author:** [Name]
**Last Updated:** [Date]
```

### Playbook Documentation Template

```markdown
# [Playbook Title]

## Purpose

Why this playbook exists.

## When to Use This

Specific situations and scenarios.

## Prerequisites

What needs to be in place first.

## Key Concepts

Theory and background.

## Step-by-Step Guide

Numbered procedures.

## Worked Example

Detailed scenario with real-world data.

## Common Pitfalls

Things to avoid.

## Troubleshooting

Problems and solutions.

## Success Criteria

How to verify it worked.

## Related Playbooks

- Other guides

---

**Status:** Complete
**Author:** [Name]
**Last Updated:** [Date]
```

### Architecture Decision Record (ADR)

```markdown
# ADR-YYYY-NNN: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded]

## Context

What forces led to this decision?

## Decision

What was decided?

## Rationale

Why this decision?

## Consequences

What are the resulting outcomes?

## Alternatives Considered

1. Alternative A (why not chosen)
2. Alternative B (why not chosen)

## Approval

- Decision maker: [Name]
- Date: [Date]
- Approvals: [Names]

## Related ADRs

- ADR-YYYY-NNN (predecessor)
- ADR-YYYY-NNN (related)

---

**Status:** Accepted
**Date:** [Date]
```

---

## Writing Guidelines

### Style & Tone

```
Recommendations:
✓ Clear and concise (write for busy architects)
✓ Active voice ("we recommend" not "it is recommended")
✓ Practical examples (show, don't just tell)
✓ Second person ("you should", not "developers should")
✓ Positive framing ("do this" not "don't do that")
✓ Inclusive language (avoid gender-specific pronouns)

Structure:
1. Purpose (first paragraph - why this exists)
2. When to use (situations it applies)
3. Main content (theory + practice)
4. Example (worked example with real data)
5. Related resources (links)
```

### Content Structure

**Every document should have:**

```markdown
# [Title]

## Purpose
One paragraph explaining why this exists.

## When to Use This
Specific scenarios for which this applies.

[Main content sections]

## [Practical Examples]
Real-world worked examples.

## Related Resources
Links to related documentation.

---

**Status:** Complete
**Last Updated:** [Date]
**Version:** [Number]
**Contributors:** [Names]
```

### Code Examples

**Guidelines:**
- Use real, working code
- Include imports and setup
- Comment non-obvious logic
- Show both ❌ (anti-pattern) and ✅ (good practice)
- Use multiple languages if helpful (Python, JavaScript, Go, SQL)

**Example format:**
```python
# ❌ Anti-pattern (what to avoid)
def bad_approach():
    # Problematic code
    pass

# ✅ Better approach (recommended)
def good_approach():
    # Improved code
    pass
```

### Diagrams

**Requirements:**
- Text-based when possible (Mermaid, ASCII art)
- Include in Markdown (version control friendly)
- Alternative text descriptions for clarity
- Tool recommendation: Mermaid for diagrams, draw.io for complex designs

**Example:**
```markdown
\`\`\`mermaid
graph TB
    A[Component A] --> B[Component B]
    B --> C[Component C]
\`\`\`

**Description:** This diagram shows how Component A communicates...
```

### Tables & Lists

**Tables for comparisons:**
```markdown
| Criterion | Option A | Option B | Option C |
|-----------|----------|----------|----------|
| Performance | High | Medium | Low |
| Cost | $100k | $50k | $10k |
| Learning Curve | Steep | Moderate | Easy |
```

**Lists for procedures:**
```markdown
1. First step
2. Second step
3. Third step

Nested steps:
1. Parent step
   a. Sub-step
   b. Sub-step
2. Next parent
```

---

## Documentation Quality Checklist

### Before Submitting Your PR

```
Content Quality:
□ Purpose is clear (stated in first paragraph)
□ When to use is explicit
□ Practical examples are included
□ Code examples are tested and working
□ Diagrams are clear and helpful
□ Trade-offs are discussed honestly

Structure:
□ Follows appropriate template
□ Clear section hierarchy
□ Table of contents if >2000 words
□ Consistent formatting

Style:
□ Grammar/spelling checked
□ Technical terminology explained
□ Tone is professional but friendly
□ Active voice used predominantly
□ Clear, short sentences

Completeness:
□ Links to related resources included
□ No broken internal links
□ References cited
□ Author and date included
□ Status field present

Diagrams & Code:
□ Code examples tested
□ Syntax highlighting applied
□ Alternative text for images
□ Source cited if not original

Accessibility:
□ Heading hierarchy correct
□ Accessible color choices (if diagrams)
□ Descriptive alt text
□ No content only in images
```

### Peer Review Checklist

**Reviewers should verify:**

```
Accuracy:
□ Technical content is correct
□ Examples work as shown
□ References are current
□ Recommendations align with organization standards

Completeness:
□ Sufficient detail for intended audience
□ Examples cover main use cases
□ Edge cases addressed

Clarity:
□ Writing is easy to follow
□ Technical terms explained
□ Examples illuminate the concept

Value:
□ Adds useful knowledge
□ Addresses identified need
□ Doesn't duplicate existing content

Consistency:
□ Follows style guide
□ Matches template structure
□ Consistent with other documentation
```

---

## Content Categories & Requirements

### Patterns

**Length:** 500-1,500 lines  
**Audience:** Architects, experienced developers  
**Review time:** 2 weeks  

**Must include:**
- Problem statement
- Solution design
- Structure diagram
- Implementation example
- Consequences (benefits & drawbacks)
- Related patterns

### Playbooks

**Length:** 1,000-2,500 lines  
**Audience:** Teams implementing the practice  
**Review time:** 2-3 weeks  

**Must include:**
- Clear purpose
- Prerequisites
- Step-by-step procedures
- Worked example with real data
- Common pitfalls
- Success criteria
- Troubleshooting guide

### Architecture Decision Records (ADRs)

**Length:** 300-1,000 lines  
**Audience:** Decision stakeholders, future maintainers  
**Review time:** 1-2 weeks  

**Must include:**
- Status
- Context and forces
- Clear decision statement
- Rationale
- Consequences
- Alternatives considered
- Approvals

### Case Studies

**Length:** 2,000-5,000 lines  
**Audience:** Team learning from experience  
**Review time:** 3 weeks  

**Must include:**
- Project context
- Problem statement
- Solution design
- Implementation approach
- Metrics (before/after)
- Lessons learned
- Do's and Don'ts

### Reference Architectures

**Length:** 2,000-5,000 lines  
**Audience:** Teams building similar systems  
**Review time:** 3+ weeks  

**Must include:**
- System overview
- Architecture diagram (C4 Model)
- Component descriptions
- Technology choices with rationale
- Data architecture
- Security architecture
- Deployment architecture
- Operational procedures
- Runbooks for common scenarios

---

## Maintenance & Updates

### Content Lifecycle

```
Creation
  ↓
Published & Version 1.0
  ↓ (6-12 months)
Review & Feedback
  ↓
Updated → Version 1.1 (minor) or 2.0 (major)
  ↓ (12-18 months)
Deprecation Review
  ↓
Decision: Keep (renewed), Update, or Deprecate
```

### Deprecation Process

When content becomes outdated:

```
1. Mark as "Deprecated" in status
2. Add notice: "This document is deprecated as of [date]. Use [new reference] instead."
3. Redirect links to replacement content
4. Archive to docs/archive/
5. Update related documents with new references
```

### Suggesting Updates

Open issue with:
- Document title
- Specific outdated sections
- Suggested improvements
- Evidence of changes (links, examples)

---

## Contribution Recognition

**Contributors are recognized by:**

1. **Git history:** Commit attribution
2. **Document footer:** Author/contributor names
3. **Annual contributors list:** Top contributors featured
4. **Acknowledgments:** Open source style

**Example:**
```markdown
---

**Status:** Complete  
**Version:** 1.2  
**Last Updated:** November 2025  
**Authors:** [Name], [Name]  
**Contributors:** [Name], [Name]
**Reviewed by:** [Name] (Architecture)
```

---

## Content Licensing

All contributed content is licensed under the project license:
- Code examples: Apache 2.0
- Documentation: Creative Commons Attribution 4.0

By contributing, you agree to these licenses.

---

## Common Questions

**Q: How detailed should examples be?**  
A: Include enough detail that someone unfamiliar with the topic could implement it from your example.

**Q: Can I reference external resources?**  
A: Yes, but provide summary content. External links may disappear over time.

**Q: How long does approval take?**  
A: 1-3 weeks depending on complexity. Smaller updates faster.

**Q: Can I update someone else's document?**  
A: Yes, through pull request review process. Significant changes should discuss with original author.

---

## Getting Help

**Questions about contributing?**
- Open discussion in issues labeled `[DISCUSSION]`
- Contact architecture team in Slack
- Check existing ADRs for decision context

**Need feedback on draft?**
- Open PR with `[DRAFT]` label
- Request reviewers
- Iterate based on feedback
- Move to regular PR when ready

---

## Related Resources

- [Architecture Review Board](../processes/arb/README.md)
- [Documentation Standards](../processes/documentation-standards.md)
- [Main Contributing Guide](../../CONTRIBUTING.md)
- [Markdown Guide](https://www.markdownguide.org/)
- [Mermaid Diagram Guide](https://mermaid.js.org/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
