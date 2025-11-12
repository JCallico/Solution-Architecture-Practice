# Architecture Modeling

## Overview

Architecture modeling is the practice of creating visual and structural representations of a system's architecture to communicate design decisions, relationships, and trade-offs to various stakeholders. Effective modeling bridges the gap between abstract architectural concepts and concrete implementation details.

## Purpose of Architecture Models

**Communication:**
- Communicate design to stakeholders
- Ensure shared understanding
- Facilitate discussions
- Document decisions

**Validation:**
- Identify gaps and inconsistencies
- Validate against requirements
- Test assumptions
- Risk identification

**Planning:**
- Guide implementation
- Identify dependencies
- Plan phasing
- Resource allocation

## Modeling Levels

### Strategic Level
Focus on business goals and organizational structure.

**Artifacts:**
- Value stream maps
- Business capability maps
- Organizational charts
- Strategic roadmaps

**Audience:**
- Business executives
- Strategy teams
- Enterprise architects

### Tactical Level
Focus on solution design and component interactions.

**Artifacts:**
- C4 diagrams
- Domain models
- Service architectures
- Data flow diagrams

**Audience:**
- Solution architects
- Technical leads
- Development teams

### Implementation Level
Focus on technical details and technology choices.

**Artifacts:**
- Deployment diagrams
- Database schemas
- API contracts
- Infrastructure as Code

**Audience:**
- Developers
- DevOps engineers
- QA teams

## Common Modeling Approaches

### C4 Model

**Level 1 - System Context**
Shows the system as a black box with external systems and users.

**Level 2 - Containers**
Shows major components and their interactions.

**Level 3 - Components**
Details the internal structure of containers.

**Level 4 - Code**
Shows classes and relationships (typically UML).

**Benefits:**
- Scalable from high to low level
- Audience-appropriate abstractions
- Clear communication
- Easy to understand

**Tools:**
- C4 PlantUML
- Structurizr
- Miro/Lucidchart
- draw.io

### UML (Unified Modeling Language)

**Structural Diagrams:**
- Class diagrams
- Component diagrams
- Deployment diagrams
- Package diagrams

**Behavioral Diagrams:**
- Sequence diagrams
- State diagrams
- Activity diagrams
- Use case diagrams

**Use Cases:**
- Detailed technical design
- Code generation
- Large enterprises
- Complex systems

**Challenges:**
- Steep learning curve
- Time-consuming
- Over-detailed for some purposes
- Maintenance burden

### ArchiMate

**Framework:**
- Business layer
- Application layer
- Technology layer
- Relationships

**Use Cases:**
- Enterprise architecture
- TOGAF implementations
- Cross-domain modeling
- Governance

**Benefits:**
- Standard notation
- Multi-layer support
- Relationship clarity
- Enterprise alignment

**Tools:**
- ArchiMate modelers (Sparx, etc.)
- Archi (open source)

### Domain-Driven Design Models

**Bounded Contexts**
Visual representation of domain boundaries.

**Event Storming**
Collaborative modeling of domain events.

**Context Maps**
Relationships between bounded contexts.

**Use Cases:**
- Microservices decomposition
- Domain understanding
- Team alignment
- Evolutionary architecture

**Tools:**
- EventStorming whiteboards
- Miro/Mural
- Event Modeling (online)

### Dataflow Diagrams (DFD)

**Elements:**
- Data sources/sinks
- Processes
- Data stores
- Data flows

**Levels:**
- Context diagram (high-level)
- Level 0 (main processes)
- Level 1+ (detailed processes)

**Use Cases:**
- Data flow understanding
- Security analysis
- System dynamics
- Integration design

**Tools:**
- Lucidchart
- Draw.io
- Visio
- yEd

## Modeling Best Practices

### Clarity and Simplicity

**Principles:**
- One idea per diagram
- Minimize unnecessary details
- Use consistent notation
- Clear labeling
- Appropriate abstraction level

**Example - Good vs Bad:**
```
BAD: Single diagram with 50+ components
GOOD: Multiple diagrams at different levels
      Each showing specific aspect
```

### Consistency

**Standard Notation:**
- Use recognized models (C4, UML, ArchiMate)
- Follow notation conventions
- Document symbols
- Train team members

**Architectural Language:**
- Consistent terminology
- Standard names for patterns
- Documented conventions
- Glossary of terms

### Audience-Appropriate

**Executive Stakeholders:**
- Business context
- Value proposition
- High-level architecture
- Risk/compliance

**Architects & Leads:**
- Component breakdown
- Interactions
- Technology choices
- Trade-offs

**Developers:**
- Detailed design
- APIs/contracts
- Implementation patterns
- Dependencies

### Evolution

**Living Documentation:**
- Update with code
- Track decisions in ADRs
- Version diagrams
- Regular reviews

**Versioning:**
```
v1.0 - Initial architecture
v1.1 - Added caching layer
v2.0 - Microservices refactoring
```

## Creating Effective Models

### 1. Define Scope
- What aspect does this model represent?
- What questions should it answer?
- Who is the audience?
- What level of detail?

### 2. Choose Appropriate Model
- Consider audience
- Evaluate tools
- Think about maintenance
- Balance detail vs clarity

### 3. Gather Information
- Document current state
- Identify assumptions
- List constraints
- Validate with stakeholders

### 4. Create Drafts
- Sketch initial ideas
- Iterate quickly
- Get feedback early
- Refine design

### 5. Validate
- Check completeness
- Verify accuracy
- Validate assumptions
- Get stakeholder sign-off

### 6. Maintain
- Keep updated
- Link to code/documentation
- Version control
- Regular reviews

## Model Types by Purpose

### Conceptual Models
Focus on understanding and communication.

**Examples:**
- Business capability maps
- Process models
- Data flow (high-level)

**Tools:**
- Miro/Mural (collaborative)
- Lucidchart
- Draw.io

### Logical Models
Focus on system design without technology.

**Examples:**
- C4 System/Container diagrams
- Data models (logical)
- Service interactions

**Tools:**
- C4 modelers
- UML tools
- Archi

### Physical Models
Focus on implementation and technology.

**Examples:**
- Deployment diagrams
- Infrastructure diagrams
- Database schemas

**Tools:**
- Infrastructure as Code visualizers
- Database modelers
- Diagram tools with tech icons

## Anti-Patterns

❌ **Overly Complex**
Too many elements, difficult to understand.

✅ **Solution:** Multiple focused diagrams

❌ **Outdated**
Doesn't match actual implementation.

✅ **Solution:** Keep in version control, update with code

❌ **Unclear Notation**
Uses non-standard or poorly explained symbols.

✅ **Solution:** Use recognized models, document conventions

❌ **Wrong Level**
Too detailed for strategic, too vague for implementation.

✅ **Solution:** Match model level to audience

❌ **Isolated**
Not connected to requirements or decisions.

✅ **Solution:** Link to ADRs, requirements, code

## Tools Comparison

| Tool | Type | Strength | Best For |
|------|------|----------|----------|
| Structurizr | C4 Modeling | DSL + visualization | Architecture documentation |
| Draw.io | General | Free, flexible | Quick diagrams |
| Lucidchart | General | Professional, polished | Presentations |
| PlantUML | Code-based | Version control friendly | Automated documentation |
| Archi | ArchiMate | Enterprise focus | TOGAF/enterprise architecture |
| Miro/Mural | Collaborative | Real-time collaboration | EventStorming, workshops |
| Sparx EA | Comprehensive | UML, ArchiMate | Enterprise modeling |
| Visio | General | Microsoft ecosystem | Corporate environments |

## Modeling Workflow

```
1. Requirements Definition
   ↓
2. Stakeholder Identification
   ↓
3. Model Selection
   ↓
4. Information Gathering
   ↓
5. Draft Creation
   ↓
6. Review & Feedback
   ↓
7. Refinement
   ↓
8. Approval & Sign-off
   ↓
9. Documentation
   ↓
10. Version Control & Maintenance
```

## Integration with Development

### Documentation as Code

**Benefits:**
- Version controlled
- Reviewable in pull requests
- Automated validation
- Easy to maintain

**Tools:**
- PlantUML
- Mermaid
- Asciidoc with diagrams
- C4-PlantUML

**Example:**
```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

Person(user, "User", "")
System(system, "Order System", "")
System_Ext(payment, "Payment Gateway", "")

Rel(user, system, "Places orders")
Rel(system, payment, "Processes payments")

@enduml
```

### Linking to Implementation

- Architecture diagrams reference code files
- Code includes architecture context links
- ADRs reference diagrams
- Deployment diagrams match infrastructure code

## Common Modeling Mistakes

❌ **Creating diagram then ignoring it**
Keep models current with implementation.

❌ **Too detailed too soon**
Start high-level, add detail as needed.

❌ **Wrong tools**
Tool should support your modeling approach.

❌ **Insufficient stakeholder input**
Model should reflect shared understanding.

❌ **No version history**
Track changes to understand evolution.

## Governance

### Model Standards
- Approved modeling approaches
- Notation conventions
- Quality standards
- Review process

### Approval Process
- Architectural review
- Stakeholder sign-off
- Risk assessment
- Documentation requirements

### Maintenance
- Regular model reviews
- Update frequency
- Change request process
- Stakeholder notification

## Training & Competencies

**Essential Skills:**
- Visual communication
- Systems thinking
- Notation knowledge
- Stakeholder management

**Model-Specific Training:**
- C4 Model (1-2 hours)
- UML (course)
- ArchiMate (certification available)
- Domain-Driven Design (workshop)

**Tools Training:**
- Tool-specific workshops
- Online tutorials
- Practice sessions
- Peer learning

## Related Resources

- [C4 Model](./c4-model.md)
- [Domain-Driven Design](./domain-driven-design.md)
- [Architecture Decision Records](./adr-framework.md)
- [TOGAF Framework](./togaf.md)

## References

- [C4 Model - Context, Containers, Components, Code](https://c4model.com/)
- [UML Documentation](https://www.omg.org/spec/UML/)
- [ArchiMate Standard](https://pubs.opengroup.org/architecture/archimate30-doc/)
- _Documenting Software Architectures_ (Clements, Bachmann, Bass, Garlan, Ivers, Merson, Nord, Stafford)
- [PlantUML](https://plantuml.com/)
- [Miro Whiteboarding](https://miro.com/)

---

**Last Updated:** November 2025  
**Related:** [C4 Model](./c4-model.md) | [Architecture Decision Records](./adr-framework.md) | [TOGAF Framework](./togaf.md)
