# Contributing to the Solution Architecture Practice Documentation

## Welcome Contributors!

We welcome and encourage contributions from all architects and team members. This documentation is a living resource that improves through community participation.

## Ways to Contribute

### 1. Content Contributions
- **New Patterns**: Document architecture patterns you've successfully applied
- **Reference Architectures**: Share complete solution architectures
- **Best Practices**: Document lessons learned and best practices
- **Case Studies**: Write about interesting projects (anonymized)
- **Playbooks**: Create guides for common scenarios
- **Templates**: Improve or create new templates

### 2. Updates & Improvements
- Fix typos and grammatical errors
- Clarify unclear explanations
- Add examples and diagrams
- Update outdated information
- Improve organization and structure

### 3. Reviews & Feedback
- Review pull requests from others
- Provide feedback on content
- Suggest improvements
- Report issues

## Contribution Process

### Step 1: Identify What to Contribute

**Check First**:
- Does similar content already exist?
- Is this aligned with practice standards?
- Is this something others would benefit from?

**Get Input** (for large contributions):
- Discuss in #architecture Slack channel
- Bring up in Architecture Council
- Check with Principal Architects

### Step 2: Create Your Content

**Use Templates**:
- [Pattern Template](./templates/pattern-template.md)
- [Reference Architecture Template](./templates/reference-architecture-template.md)
- [Playbook Template](./templates/playbook-template.md)

**Follow Standards**:
- Use Markdown format
- Follow style guide (below)
- Include diagrams where helpful
- Add examples
- Link to related content

### Step 3: Submit for Review

**Via Git**:
1. Fork or branch the repository
2. Add/update content
3. Create pull request
4. Request review from 1-2 architects

**Via Other Means**:
- Share draft in #architecture
- Email to solution-architecture@company.com
- Discuss in office hours

### Step 4: Incorporate Feedback

- Respond to review comments
- Make requested changes
- Discuss any disagreements
- Update based on consensus

### Step 5: Publication

- Once approved, content is merged
- Announced in #architecture channel
- Added to monthly newsletter
- Recognized in Architecture Council

## Content Guidelines

### Writing Style

**Be Clear and Concise**:
- Use simple, direct language
- Avoid jargon when possible
- Define acronyms on first use
- Write for your audience

**Be Practical**:
- Include real examples
- Provide code snippets where helpful
- Link to working implementations
- Share lessons learned

**Be Objective**:
- Present trade-offs honestly
- Avoid absolute statements
- Consider different contexts
- Acknowledge alternatives

### Structure

**Use Consistent Headings**:
- H1 for document title
- H2 for major sections
- H3 for subsections
- H4 and below sparingly

**Include Navigation**:
- Link back to parent pages
- Link to related content
- Include table of contents for long docs

**Use Lists**:
- Bullet points for unordered items
- Numbered lists for sequential steps
- Tables for structured data

### Diagrams

**When to Include**:
- Architecture diagrams (use C4)
- Sequence diagrams for workflows
- Data flow diagrams
- Infrastructure diagrams

**Diagram Standards**:
- Use PlantUML or Draw.io
- Follow C4 notation for architecture diagrams
- Include legend when needed
- Save both source and rendered versions

**Example C4 Context Diagram**:
```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

Person(user, "User")
System(system, "Your System")
System_Ext(external, "External System")

Rel(user, system, "Uses")
Rel(system, external, "Calls")
@enduml
```

### Code Examples

**Include When**:
- Demonstrating implementation
- Showing configuration
- Providing templates

**Best Practices**:
- Use proper syntax highlighting
- Include comments
- Show complete, runnable examples
- Indicate language/framework

**Example**:
```python
# Circuit breaker example using tenacity library
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
def call_external_service():
    """Call external service with retry logic."""
    response = requests.get("https://api.example.com/data")
    response.raise_for_status()
    return response.json()
```

## Content Types

### Architecture Patterns

**Structure**:
- Pattern name
- Problem statement
- Context and when to use
- Solution description
- Benefits and trade-offs
- Implementation guidance
- Examples
- Related patterns

**Use**: [Pattern Template](./templates/pattern-template.md)

### Reference Architectures

**Structure**:
- Business context
- Architecture overview
- Component descriptions
- Technology stack
- Data architecture
- Security considerations
- Deployment model
- Alternatives considered

**Use**: [Reference Architecture Template](./templates/reference-architecture-template.md)

### Playbooks

**Structure**:
- Overview and purpose
- When to use this playbook
- Prerequisites
- Step-by-step guide
- Common pitfalls
- Examples
- Resources and references

**Use**: [Playbook Template](./templates/playbook-template.md)

### Case Studies

**Structure**:
- Project background (anonymized)
- Challenges and requirements
- Solution approach
- Results and outcomes
- Lessons learned
- What we'd do differently

## Style Guide

### Formatting

**Headings**:
- Use sentence case (not title case)
- Be descriptive
- Keep concise

**Lists**:
- Use bullets for unordered items
- Use numbers for sequences
- Parallel structure in list items

**Emphasis**:
- **Bold** for important concepts
- *Italic* for emphasis
- `Code formatting` for technical terms, filenames, commands

**Links**:
- Use descriptive link text (not "click here")
- Link to authoritative sources
- Keep internal links relative

### Terminology

**Consistent Terms**:
- Use "microservices" not "micro-services"
- Use "API" not "Api" or "api"
- Use "Kubernetes" not "K8s" in formal docs (K8s ok in casual context)

**Abbreviations**:
- Define on first use: "Architecture Decision Record (ADR)"
- Use common abbreviations after definition
- Avoid obscure abbreviations

### Voice and Tone

**Active Voice**:
- ✅ "The architect creates the diagram"
- ❌ "The diagram is created by the architect"

**Direct and Helpful**:
- ✅ "Use the C4 model to document your architecture"
- ❌ "It might be beneficial to potentially consider using C4"

**Inclusive**:
- Use "we" and "you" appropriately
- Avoid assumptions about reader knowledge
- Provide context and explanations

## Technical Standards

### Markdown

**Use CommonMark**:
- Standard Markdown syntax
- GitHub Flavored Markdown extensions
- Tables, task lists, code blocks

**Front Matter** (optional):
```yaml
---
title: Document Title
description: Brief description
tags: [tag1, tag2]
author: Your Name
date: 2025-11-11
---
```

### File Organization

**Naming**:
- Use lowercase
- Use hyphens for spaces
- Be descriptive
- Example: `microservices-patterns.md`

**Location**:
- Place in appropriate section
- Create subsections as needed
- Update parent README with links

### Version Control

**Commits**:
- Clear commit messages
- Logical groupings
- Reference issues if applicable

**Branches**:
- Use feature branches
- Name descriptively: `add-kafka-pattern`

**Pull Requests**:
- Descriptive title
- Explain what and why
- Link to related issues/discussions
- Request specific reviewers

## Recognition

### Contributors

**We recognize contributions**:
- Author attribution on content
- Shout-outs in #architecture channel
- Monthly contributor highlights
- Annual contributor awards

### Building Your Portfolio

Contributions help:
- Build your architecture portfolio
- Demonstrate thought leadership
- Support career growth
- Help the community

## Questions?

**Slack**: #architecture-contributions  
**Email**: solution-architecture@company.com  
**Office Hours**: Daily architecture office hours

## Thank You!

Your contributions make our practice better. Every improvement, no matter how small, helps the entire team.

---

[Back to Home](../README.md)
