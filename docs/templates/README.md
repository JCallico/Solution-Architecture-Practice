# Templates & Tools

## Overview

This section provides standardized templates and recommended tools for architecture work. Templates ensure consistency and completeness, while approved tools streamline the architecture process.

## Templates

### Architecture Documents
- [Solution Architecture Document](./documents/solution-architecture-template.md)
- [Technical Design Document](./documents/technical-design-template.md)
- [Architecture Vision Document](./documents/architecture-vision-template.md)
- [System Context Document](./documents/system-context-template.md)

### Architecture Artifacts
- [Architecture Decision Record (ADR)](./adr/)
- [Request for Comments (RFC)](./rfc/)
- [Non-Functional Requirements (NFR)](./nfr-template.md)
- [Architecture Review Checklist](./architecture-review-checklist.md)

### Diagrams
- [C4 Model Templates](./diagrams/c4/)
- [Data Flow Diagrams](./diagrams/data-flow/)
- [Sequence Diagrams](./diagrams/sequence/)
- [Infrastructure Diagrams](./diagrams/infrastructure/)

### Project & Process
- [Architecture Service Request Form](./service-request-form.md)
- [ARB Submission Template](./arb-submission-template.md)
- [Technology Evaluation Template](./technology-evaluation-template.md)
- [Proof of Concept Template](./poc-template.md)

### Specialized Templates
- [API Specification Template](./api-specification-template.md)
- [Security Architecture Template](./security-architecture-template.md)
- [Data Architecture Template](./data-architecture-template.md)
- [Migration Plan Template](./migration-plan-template.md)

## Recommended Tools

### Diagramming Tools

#### Structurizr (Primary)
- **Purpose**: C4 model diagrams as code
- **License**: Freemium (free for open source)
- **Why**: Purpose-built for C4, version control friendly
- **Getting Started**: [Structurizr Guide](./tool-guides/structurizr.md)

#### PlantUML (Primary)
- **Purpose**: Text-based diagrams (UML, C4, sequences, etc.)
- **License**: Open source
- **Why**: Diagrams as code, CI/CD integration, widely supported
- **Getting Started**: [PlantUML Guide](./tool-guides/plantuml.md)

#### Draw.io / Diagrams.net (Secondary)
- **Purpose**: General diagramming
- **License**: Free
- **Why**: Easy collaboration, templates available
- **Getting Started**: [Draw.io Guide](./tool-guides/drawio.md)

#### Miro (Workshops)
- **Purpose**: Collaborative workshops and brainstorming
- **License**: Freemium
- **Why**: Real-time collaboration, great for workshops
- **Getting Started**: [Miro Guide](./tool-guides/miro.md)

### Documentation Tools

#### Markdown (Primary)
- **Purpose**: All documentation
- **Why**: Simple, version control friendly, portable
- **Standard**: CommonMark with GitHub extensions

#### Confluence (Secondary)
- **Purpose**: Stakeholder-facing documentation
- **Why**: Good for collaboration, familiar to organization
- **Integration**: Export from Markdown to Confluence

#### GitHub/GitLab (Primary)
- **Purpose**: Documentation repository and ADRs
- **Why**: Co-located with code, PR workflow, search

### Modeling Tools

#### ArchiMate (Enterprise Architecture)
- **Purpose**: Enterprise architecture modeling
- **Tool**: Archi (open source)
- **When**: Enterprise-level architecture

#### Enterprise Architect
- **Purpose**: UML and enterprise modeling
- **License**: Commercial
- **When**: Complex UML requirements

### Cloud Architecture Tools

#### AWS Tools
- **CloudFormation Designer**: Infrastructure diagrams
- **AWS Architecture Icons**: Official icon set
- **Well-Architected Tool**: Architecture reviews
- [AWS Tools Guide](./tool-guides/aws-tools.md)

#### Azure Tools
- **Azure Architecture Center**: Reference architectures
- **Azure Icons**: Official icon set
- **Azure Advisor**: Architecture recommendations
- [Azure Tools Guide](./tool-guides/azure-tools.md)

#### Terraform
- **Purpose**: Infrastructure as Code
- **Why**: Multi-cloud, declarative, widely adopted
- [Terraform Guide](./tool-guides/terraform.md)

### API Tools

#### OpenAPI / Swagger
- **Purpose**: API specification and documentation
- **Tools**: Swagger Editor, Swagger UI
- [OpenAPI Guide](./tool-guides/openapi.md)

#### Postman
- **Purpose**: API testing and documentation
- **License**: Freemium
- [Postman Guide](./tool-guides/postman.md)

#### AsyncAPI
- **Purpose**: Event-driven API documentation
- **Why**: Standard for async/event APIs
- [AsyncAPI Guide](./tool-guides/asyncapi.md)

### Analysis Tools

#### Architecture Decision Records (ADR) Tools
- **log4brains**: Web-based ADR management
- **adr-tools**: Command-line ADR tools
- [ADR Tools Guide](./tool-guides/adr-tools.md)

#### Dependency Analysis
- **Structure101**: Architecture enforcement
- **SonarQube**: Code quality and architecture metrics
- **ArchUnit**: Architecture unit tests

### Collaboration Tools

#### Slack
- **Channels**: #architecture, #architecture-reviews, #architecture-patterns
- **Purpose**: Quick discussions, Q&A, announcements

#### Microsoft Teams
- **Team**: Solution Architecture Practice
- **Purpose**: Meetings, file sharing, collaboration

#### Zoom
- **Purpose**: Architecture reviews, workshops, office hours

## Tool Selection Criteria

When evaluating new tools, consider:

### Must Have
- ✅ Supports version control / diagrams as code
- ✅ Enables collaboration
- ✅ Exports to portable formats
- ✅ Reasonable cost (prefer free/open source)
- ✅ Active maintenance and community

### Nice to Have
- Integration with existing tools
- CI/CD integration
- API availability
- Cloud-based for accessibility
- Mobile support

### Avoid
- ❌ Proprietary formats only
- ❌ No export capabilities
- ❌ Expensive licensing
- ❌ Desktop-only with no collaboration
- ❌ Abandoned/unmaintained

## Template Usage Guidelines

### When to Use Templates

**Always Use**:
- Solution Architecture Documents
- ADRs for significant decisions
- ARB submissions
- NFR specifications

**Use When Appropriate**:
- RFCs for major changes needing feedback
- Technology evaluations
- POC documentation
- Migration plans

**Optional**:
- Informal diagrams
- Quick sketches
- Exploratory work

### Customizing Templates

Templates are starting points, not rigid requirements:
- ✅ Add sections relevant to your project
- ✅ Remove irrelevant sections
- ✅ Adapt language to your audience
- ❌ Don't skip required sections without reason
- ❌ Don't completely ignore the template structure

### Template Governance

- Templates reviewed annually
- Feedback collected from architects
- Updates communicated to practice
- Old versions marked deprecated

## Getting Help

### Template Questions
- Post in #architecture Slack channel
- Architecture office hours
- Email solution-architecture@company.com

### Tool Support
- Tool-specific channels in Slack
- IT helpdesk for license/access issues
- Tool champions within the practice

### Training
- Monthly tool training sessions
- Self-paced guides in this section
- External vendor training when available

## Contributing

Have a template or tool recommendation?
1. Create a proposal document
2. Share with Architecture Council
3. Pilot with a few projects
4. Submit for formal approval
5. Document and share with practice

---

[Back to Home](../../README.md)
