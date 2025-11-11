# C4 Model for Architecture Documentation

## Overview

The C4 model provides a hierarchical approach to architecture diagrams, enabling communication with different audiences through different levels of abstraction. Created by Simon Brown, it stands for Context, Containers, Components, and Code.

## The Four Levels

### Level 1: System Context Diagram
**Purpose**: Show how your system fits into the world around it.

**Audience**: Everyone - technical and non-technical stakeholders

**Elements**:
- Your system (center)
- Users and personas
- External systems and dependencies

**Example**:
```
[Customer] --uses--> [E-Commerce System] --uses--> [Payment Gateway]
                            |
                            v
                    [Email Service]
```

**When to Create**:
- Every solution architecture
- Project kickoff
- Executive presentations

**Key Questions Answered**:
- Who uses the system?
- What external systems does it integrate with?
- What is the system boundary?

### Level 2: Container Diagram
**Purpose**: Show the high-level technology choices and how containers communicate.

**Audience**: Technical stakeholders, architects, developers

**Elements**:
- Applications (web apps, mobile apps, etc.)
- Databases
- File systems
- Message brokers
- Microservices

**Note**: "Container" = deployable/executable unit (not Docker containers specifically)

**Example**:
```
[Web Application] --reads/writes--> [Database]
       |
       v
[API Application] --publishes--> [Message Queue]
       |
       v
[Background Worker]
```

**When to Create**:
- All solution designs
- Technology selection
- Deployment planning

**Key Questions Answered**:
- What are the deployable components?
- What technology stack is used?
- How do components communicate?
- Where is data stored?

### Level 3: Component Diagram
**Purpose**: Decompose containers into components and show their relationships.

**Audience**: Architects, senior developers, tech leads

**Elements**:
- Components within a container
- Interfaces
- Dependencies between components

**Example** (for an API Application container):
```
[Controllers] --> [Services] --> [Repositories] --> [Database]
                      |
                      v
                [External API Client]
```

**When to Create**:
- Complex containers needing internal structure
- When defining component responsibilities
- For new teams or complex codebases

**Key Questions Answered**:
- What are the main components?
- What are their responsibilities?
- How do they interact?

### Level 4: Code Diagrams
**Purpose**: Show implementation details (classes, interfaces, etc.)

**Audience**: Developers

**Note**: Usually auto-generated from code or created as UML diagrams. Optional in C4 - focus on levels 1-3.

**When to Create**:
- Complex algorithms or patterns
- When code cannot be self-documenting
- For critical, complex components

## Best Practices

### General Guidelines

1. **Keep Diagrams Simple**
   - One diagram, one purpose
   - Avoid cluttering with too many elements
   - Use consistent notation

2. **Use Consistent Notation**
   - Boxes for containers/components
   - Lines for relationships
   - Labels on all relationships
   - Color coding for types (optional)

3. **Make Diagrams Self-Contained**
   - Include titles and legends
   - Add keys for symbols
   - Include diagram metadata (author, date, version)

4. **Focus on Intent**
   - Show what's important for the diagram's purpose
   - Leave out irrelevant details
   - Create multiple diagrams if needed

### Notation Standards

#### Boxes
- **System**: Solid box with name
- **Container**: Solid box with name and technology
- **Component**: Solid box with name and type
- **Person**: Stick figure or box labeled "Person"
- **External System**: Dashed box or different color

#### Lines
- **Synchronous**: Solid line with arrow
- **Asynchronous**: Dashed line with arrow
- **Label**: Always label relationships (e.g., "reads from", "calls", "publishes to")

#### Colors
- **Internal**: Blue/Green
- **External**: Gray
- **Databases**: Different shade
- **Key Components**: Highlighted color

### Tooling

#### Recommended Tools
1. **Structurizr** (structurizr.com)
   - Purpose-built for C4
   - Diagrams as code
   - Automatic layout
   
2. **PlantUML with C4 extension**
   - Text-based diagrams
   - Version control friendly
   - CI/CD integration

3. **Draw.io / Diagrams.net**
   - Free and accessible
   - C4 templates available
   - Easy collaboration

4. **Miro / Mural**
   - Collaborative workshops
   - Sticky note exercises
   - Export to other formats

#### Not Recommended
- Visio (expensive, not cloud-friendly)
- PowerPoint (limited layout capabilities)
- Generic drawing tools without templates

## Template Examples

### System Context Template

```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

LAYOUT_WITH_LEGEND()

title System Context Diagram for [System Name]

Person(user, "User", "A user of the system")
System(systemA, "System Name", "Description of what the system does")
System_Ext(systemB, "External System", "Description")

Rel(user, systemA, "Uses", "HTTPS")
Rel(systemA, systemB, "Sends data to", "HTTPS/JSON")

@enduml
```

### Container Diagram Template

```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Container.puml

LAYOUT_WITH_LEGEND()

title Container Diagram for [System Name]

Person(user, "User")

Container(web, "Web Application", "React", "Provides UI")
Container(api, "API Application", "Node.js", "Provides business logic")
ContainerDb(db, "Database", "PostgreSQL", "Stores data")
Container(worker, "Background Worker", "Python", "Processes jobs")
Container_Ext(queue, "Message Queue", "RabbitMQ", "Queues messages")

Rel(user, web, "Uses", "HTTPS")
Rel(web, api, "Makes API calls", "HTTPS/JSON")
Rel(api, db, "Reads/writes", "SQL/TLS")
Rel(api, queue, "Publishes messages", "AMQP")
Rel(queue, worker, "Consumes messages", "AMQP")

@enduml
```

## Integration with Architecture Process

### During Design
- Create System Context during requirements phase
- Create Container diagram during solution design
- Create Component diagrams for complex containers
- Review and iterate with stakeholders

### During Reviews
- Include in Architecture Review Board submissions
- Use for design discussions
- Update based on feedback

### During Implementation
- Keep diagrams updated as design evolves
- Use as reference for developers
- Include in technical documentation

### During Maintenance
- Review and update during major changes
- Keep as part of system documentation
- Use for onboarding new team members

## Common Pitfalls

### ❌ Too Much Detail
Don't try to show everything in one diagram. Create multiple focused diagrams.

### ❌ Inconsistent Notation
Use the same notation across all diagrams. Don't mix different styles.

### ❌ Outdated Diagrams
Diagrams that don't reflect reality are worse than no diagrams. Keep them updated.

### ❌ Wrong Level of Detail
Don't show code-level details in a Container diagram. Use the right level.

### ❌ No Context
Always provide context: title, legend, date, author, purpose.

## Examples from Our Practice

See the [Reference Architectures](../knowledge-base/reference-architectures/) section for complete C4 examples:
- [E-Commerce Platform](../knowledge-base/reference-architectures/ecommerce-platform.md)
- [Data Analytics Platform](../knowledge-base/reference-architectures/data-platform.md)
- [Microservices Platform](../knowledge-base/reference-architectures/microservices-platform.md)

## Resources

### Official Resources
- [C4 Model Website](https://c4model.com)
- [C4 PlantUML](https://github.com/plantuml-stdlib/C4-PlantUML)
- [Structurizr](https://structurizr.com)

### Training
- Internal C4 workshop (quarterly)
- Simon Brown's workshops (external)
- Self-paced tutorials on c4model.com

### Templates
- [PlantUML Templates](../../templates/diagrams/c4-plantuml/)
- [Draw.io Templates](../../templates/diagrams/c4-drawio/)
- [Structurizr Examples](../../templates/diagrams/c4-structurizr/)

---

[Back to Frameworks](./README.md) | [Home](../../README.md)
