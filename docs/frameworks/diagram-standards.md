# Diagram Standards

## Overview

Diagram Standards define how to create, organize, and maintain architecture, system, and process diagrams. Clear standards ensure consistency, readability, and professional appearance of visual communications.

## Purpose of Diagrams

**Communication:**
- Visualize complex systems
- Communicate to diverse audiences
- Show relationships and flows
- Make abstract concepts concrete

**Documentation:**
- Record architectural decisions
- Preserve institutional knowledge
- Support onboarding
- Track changes over time

**Analysis:**
- Identify bottlenecks
- Spot missing pieces
- Evaluate alternatives
- Risk assessment

**Planning:**
- Guide implementation
- Identify dependencies
- Resource planning
- Phasing and sequencing

## Diagram Types & When to Use

### Context Diagram
**Purpose:** Show system boundaries and external dependencies.

**Audience:** All levels (executive to developer)

**Contents:**
- The system as single box
- External systems/actors
- Interactions/data flows

**When to Use:**
- First diagram to create
- Onboarding new people
- Explaining system scope
- Stakeholder presentations

**Example:**
```
[User] → [Order System] → [Payment Gateway]
         → [Email Service]
         → [Inventory System]
```

### Container Diagram
**Purpose:** Show major components and their interactions.

**Audience:** Technical staff

**Contents:**
- Major components (databases, services, applications)
- Technology choices
- Interactions between containers
- Protocols/APIs

**When to Use:**
- Detailed architecture
- Technology decisions
- Development guidance
- Integration design

### Component Diagram
**Purpose:** Show internal structure of containers.

**Audience:** Developers, architects

**Contents:**
- Components within container
- Component responsibilities
- Dependencies
- APIs/interfaces

**When to Use:**
- Detailed design
- Code structure guidance
- Interface design
- Refactoring planning

### Deployment Diagram
**Purpose:** Show how system is deployed to infrastructure.

**Audience:** DevOps, operations

**Contents:**
- Servers, containers, nodes
- Deployment relationships
- Network topology
- Redundancy/clustering

**When to Use:**
- Infrastructure planning
- Operational procedures
- High availability design
- Capacity planning

**Example:**
```
[Load Balancer]
    ↓
[Web Server 1] [Web Server 2] [Web Server 3]
    ↓           ↓              ↓
[Database Cluster with Replication]
```

### Data Flow Diagram (DFD)
**Purpose:** Show how data moves through system.

**Audience:** Analysts, architects, developers

**Contents:**
- Data sources/sinks
- Processes
- Data stores
- Data flows

**When to Use:**
- Understanding system dynamics
- Security analysis
- Integration design
- Process mapping

### Sequence Diagram
**Purpose:** Show interactions over time.

**Audience:** Developers, architects

**Contents:**
- Actors/objects
- Messages between them
- Timing/order
- Interactions

**When to Use:**
- API interactions
- Workflow design
- Error handling flows
- Integration patterns

### Activity Diagram
**Purpose:** Show process flows and workflows.

**Audience:** Business analysts, architects

**Contents:**
- Activities/steps
- Decision points
- Parallel activities
- Start/end

**When to Use:**
- Business process design
- Workflow management
- Decision logic
- User journeys

### Class/Entity Relationship Diagram
**Purpose:** Show object models or database schemas.

**Audience:** Developers

**Contents:**
- Classes/entities
- Attributes
- Relationships
- Cardinality

**When to Use:**
- Database design
- Object model design
- API contract design
- Data structure documentation

## Diagram Design Standards

### Visual Consistency

**Color Scheme:**
- Use consistent colors for similar elements
- External systems: different color from internal
- Databases: standard database icon color
- Services: consistent service color
- User/actors: distinct color

**Recommended Palette:**
```
Primary: #0366D6 (Blue) - Internal systems
Secondary: #28A745 (Green) - Databases
Accent: #FFC107 (Amber) - External systems
Danger: #DC3545 (Red) - Failures/issues
Neutral: #6C757D (Gray) - Infrastructure
```

**Typography:**
- Use single sans-serif font family
- Consistent font sizes
- Clear hierarchy
- Readable at print size

**Line Styles:**
```
Solid lines: Synchronous communication
Dashed lines: Asynchronous communication
Arrow styles: Direction of flow
```

### Layout Principles

**Clarity:**
- One concept per diagram
- Minimize crossing lines
- Logical grouping
- White space

**Hierarchy:**
- Most important elements prominent
- Top-to-bottom or left-to-right flow
- Group related elements
- Use containers/swimlanes

**Balance:**
- Distribute elements evenly
- Avoid crowding
- Use consistent spacing
- Professional appearance

### Element Standards

**Boxes/Containers:**
- Clear labeling
- Consistent sizing
- Technology labels where appropriate
- Description if needed

**Lines/Arrows:**
- Clear direction
- Label interactions
- Consistent line width
- Avoid line crossing

**Text:**
- Descriptive labels
- Avoid acronyms or define them
- Readable font size (minimum 10pt)
- Proper grammar and spelling

## Specific Diagram Standards

### C4 Model Diagrams

**Notation:**
- Rectangle = Container/Component
- Arrow = Interaction/Relationship
- Text labels = Technology, description

**Style:**
- Consistent rectangle size
- Color by system boundary
- Technology label below element name
- Clear description of interactions

**Examples:**

```
Context Diagram:
┌─────────────────────────┐
│     Order System        │ ← One box for system
└──────────┬──────────────┘
     ↓  ↓  ↓
   [External Systems]


Container Diagram:
┌─────────────────────────────────────┐
│ Application Container               │
│  ┌────────┐  ┌────────┐            │
│  │ Web UI │→ │ API    │           │
│  └────────┘  └───┬────┘            │
└──────────────────┼────────────────┘
                   ↓
              ┌─────────┐
              │Database │
              └─────────┘
```

### UML Diagram Standards

**Class Diagram:**
```
┌─────────────────┐
│  ClassName      │
├─────────────────┤
│ - field: Type   │
├─────────────────┤
│ + method(): Ret │
└─────────────────┘
```

**Sequence Diagram:**
```
Actor    System    Database
  │        │          │
  │        │ Query    │
  ├───────→│────────→│
  │        │← Result │
  │←───────┤← Result │
```

### ArchiMate Diagram Standards

**Notation:**
- Standard ArchiMate shapes
- Color-coded by layer
- Clear relationships
- Legend included

**Layers:**
- Business (yellow)
- Application (green)
- Technology (grey)

## Creating High-Quality Diagrams

### Process

**1. Planning**
- Define purpose
- Identify audience
- Choose type
- Outline scope

**2. Drafting**
- Rough sketch
- Get feedback
- Iterate quickly
- Don't over-polish yet

**3. Creating**
- Use standard tools
- Follow style guidelines
- Apply consistent styling
- Add labels and descriptions

**4. Reviewing**
- Technical accuracy
- Clarity check
- Completeness
- Compliance with standards

**5. Publishing**
- Export to standard formats
- Create supporting text
- Link to related docs
- Version control

### Tools Selection

**Simple Diagrams:**
- Draw.io (free, flexible)
- Lucidchart (professional, cloud)
- Visio (enterprise)

**C4 Modeling:**
- Structurizr (dedicated)
- C4 PlantUML (code-based)
- Draw.io with C4 shapes

**Code-Based:**
- PlantUML (UML, architecture)
- Mermaid (flowcharts, sequences)
- Graphviz (technical graphs)

**Collaborative:**
- Miro (real-time, workshops)
- Mural (team whiteboarding)
- Figma (design-focused)

## Annotation Standards

### Labels

**Element Labels:**
```
[Component Name]
Technology: Node.js + Express
Purpose: API gateway
```

**Relationship Labels:**
```
Synchronous: "REST API (JSON)"
Asynchronous: "Message Queue (JSON)"
Direction: Arrow with label
```

### Legends

**Always Include:**
- Color meanings
- Line style meanings
- Symbol meanings
- Technology stack references

**Example:**
```
Colors:
  Blue - Internal System
  Green - Database
  Red - External Service

Lines:
  Solid - Synchronous
  Dashed - Asynchronous
```

### Notes & Callouts

**Use For:**
- Design rationale
- Important constraints
- Temporary limitations
- Performance considerations

**Placement:**
- Adjacent to relevant elements
- Numbered references
- Clear connection to element

## Export & Sharing Standards

### File Formats

**For Documentation:**
- PNG (raster, easy sharing)
- SVG (vector, scalable)
- PDF (printable)

**For Version Control:**
- Source format (draw.io XML, PlantUML text)
- Include exported PNG/SVG

**For Presentations:**
- PNG (consistent sizing)
- PDF (professional)
- Native format if editable

### File Naming

**Convention:**
```
[diagram-type]-[subject]-[version].png

Examples:
- c4-context-order-system-v1.png
- deployment-production-v2.png
- sequence-payment-flow-v1.png
```

### Resolution & Sizing

**Quality Standards:**
- Minimum 150 DPI for print
- 300 DPI for high-quality print
- Screen: 72-96 DPI typical

**Sizing:**
- Width: 800-1200 pixels (screen)
- Aspect ratio: 16:9 or 4:3
- Readable at 50% zoom

## Diagram Maintenance

### Versioning

**Track Changes:**
- Include version number in filename
- Document what changed
- Link in ADRs or documentation
- Date for reference

**Version Naming:**
```
v1.0 - Initial design
v1.1 - Add caching layer
v2.0 - Major refactoring
v2.1 - Add monitoring
```

### Review & Updates

**Triggers for Update:**
- Architecture changes
- Technology stack changes
- New components added
- Significant refactoring

**Review Schedule:**
- Annual architecture review
- With each major release
- After significant incidents
- With technology decisions

### Documentation

**Each Diagram Should Include:**
- Title clearly identifying content
- Date created/updated
- Owner/maintainer
- Version number
- Legend/key
- Brief description
- Link to detailed documentation

## Anti-Patterns

❌ **Too Complex**
Too many elements, impossible to parse.

✅ **Solution:** Multiple diagrams at different levels

❌ **Inconsistent Styling**
Different colors, fonts, notations.

✅ **Solution:** Define and follow style guide

❌ **Outdated**
Doesn't match actual architecture.

✅ **Solution:** Version control, regular reviews

❌ **No Legend**
Symbols/colors unexplained.

✅ **Solution:** Always include legend

❌ **Poor Readability**
Small text, cluttered layout.

✅ **Solution:** Test readability, use white space

❌ **Isolated**
No context or related documentation.

✅ **Solution:** Link to architecture docs

## Governance

### Standards Approval

**Who Approves:**
- Chief Architect
- Architecture Council
- Design Review Board

**Criteria:**
- Clarity
- Consistency
- Completeness
- Alignment with standards

### Tool Selection

**Approved Tools:**
- Primary: Draw.io (free, flexible)
- C4: Structurizr (specialized)
- Code-based: PlantUML
- Collaboration: Miro

**New Tools:**
- Evaluation process
- Team training
- Cost-benefit analysis
- Approval before adoption

### Quality Checklist

- [ ] Clear, descriptive title
- [ ] Appropriate detail level
- [ ] Consistent styling
- [ ] Readable text
- [ ] Legend included
- [ ] Version labeled
- [ ] Date included
- [ ] Owner identified
- [ ] No spelling errors
- [ ] Links to documentation

## Tools Comparison

| Tool | Best For | Strength | Cost |
|------|----------|----------|------|
| Draw.io | General | Flexible, easy | Free |
| Lucidchart | Professional | Polish | Paid |
| Structurizr | C4 | Specialized | Freemium |
| PlantUML | Code-based | Version control | Free |
| Miro | Collaboration | Real-time | Freemium |
| Visio | Enterprise | Integration | Paid |

## Related Resources

- [Architecture Modeling](./architecture-modeling.md)
- [Documentation Standards](./documentation-standards.md)
- [C4 Model](./c4-model.md)
- [Architecture Decision Records](./adr-framework.md)

## References

- [C4 Model Notation](https://c4model.com/)
- [UML Diagram Notation](https://www.omg.org/spec/UML/)
- [Draw.io Templates](https://www.draw.io/)
- [PlantUML Documentation](https://plantuml.com/)
- _Documenting Software Architectures_ (Clements et al.)

---

**Last Updated:** November 2025  
**Related:** [Architecture Modeling](./architecture-modeling.md) | [Documentation Standards](./documentation-standards.md) | [C4 Model](./c4-model.md)
