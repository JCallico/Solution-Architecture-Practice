# Architecture Frameworks & Methodologies

## Overview

This section provides comprehensive guidance on the architecture frameworks, methodologies, and approaches used within our practice. These frameworks provide structure, consistency, and best practices for architecture work.

## Contents

### Core Frameworks
- [TOGAF Framework](./togaf.md) - The Open Group Architecture Framework
- [C4 Model](./c4-model.md) - Context, Containers, Components, Code
- [AWS Well-Architected Framework](./aws-well-architected.md)
- [Azure Well-Architected Framework](./azure-well-architected.md)
- [12-Factor App Methodology](./twelve-factor.md)

### Architecture Approaches
- [Domain-Driven Design (DDD)](./domain-driven-design.md)
- [Event-Driven Architecture](./event-driven-architecture.md)
- [Microservices Architecture](./microservices.md)
- [API-First Design](./api-first.md)
- [Serverless Architecture](./serverless.md)

### Modeling & Documentation
- [Architecture Modeling](./architecture-modeling.md)
- [Documentation Standards](./documentation-standards.md)
- [Diagram Standards](./diagram-standards.md)
- [Architecture Decision Records (ADRs)](./adr-framework.md)

### Specialized Frameworks
- [Data Architecture Framework](./data-architecture-framework.md)
- [Security Architecture Framework](./security-framework.md)
- [Integration Architecture Framework](./integration-framework.md)
- [Cloud Architecture Framework](./cloud-framework.md)

## When to Use Which Framework

### TOGAF
**Use When**:
- Enterprise-wide architecture initiatives
- Strategic planning and roadmapping
- Governance and standards definition
- Large-scale transformations

### C4 Model
**Use When**:
- Communicating solution architecture
- Creating architecture documentation
- Different audience levels (exec to developer)
- All solution architecture work

### Well-Architected Frameworks
**Use When**:
- Cloud-native solutions
- Architecture reviews and assessments
- Cloud migration planning
- Cost, security, reliability optimization

### Domain-Driven Design
**Use When**:
- Complex business domains
- Microservices decomposition
- Large-scale applications
- Need for clear bounded contexts

### Event-Driven Architecture
**Use When**:
- Asynchronous processing needed
- System decoupling required
- High scalability demands
- Real-time data streaming

## Framework Selection Guide

| Initiative Type | Recommended Framework(s) |
|----------------|-------------------------|
| Enterprise Strategy | TOGAF |
| Solution Design | C4 Model + Domain-Driven Design |
| Cloud Migration | Well-Architected Frameworks + 12-Factor |
| Microservices | DDD + Microservices Patterns + C4 |
| API Platform | API-First + Integration Framework |
| Data Platform | Data Architecture Framework + Well-Architected |
| Security Design | Security Framework + Well-Architected |
| Serverless Solutions | Serverless Patterns + Well-Architected |

## Adopting a Framework

### 1. Understand the Framework
- Review framework documentation
- Complete training if available
- Study example implementations
- Understand principles and patterns

### 2. Adapt to Context
- Tailor to your specific needs
- Don't apply frameworks dogmatically
- Focus on value, not compliance
- Document your adaptations

### 3. Apply Incrementally
- Start with core concepts
- Apply to pilot projects
- Learn and refine
- Scale successful practices

### 4. Share Learnings
- Document experiences
- Create internal guides
- Train team members
- Contribute to practice knowledge base

## Framework Governance

### Approved Frameworks
The frameworks listed in this section are approved for use. When using other frameworks:
1. Evaluate against our principles
2. Propose to Architecture Council
3. Get approval before wide adoption
4. Document decision in ADR

### Framework Updates
- Review frameworks annually
- Track industry evolution
- Update documentation
- Communicate changes to practice

### Training & Certification
- Training available for major frameworks
- Certifications encouraged (TOGAF, AWS/Azure, etc.)
- Internal framework training provided
- Budget support for external training

## Resources

### Books
- _Software Architecture: The Hard Parts_ (Ford, Richards, Sadalage, Dehghani)
- _Fundamentals of Software Architecture_ (Richards, Ford)
- _Building Microservices_ (Newman)
- _Domain-Driven Design_ (Evans)
- _Enterprise Integration Patterns_ (Hohpe, Woolf)

### Online Resources
- [C4 Model](https://c4model.com)
- [TOGAF Standard](https://www.opengroup.org/togaf)
- [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)
- [12 Factor](https://12factor.net)

### Internal Resources
- Architecture pattern library
- Reference architectures
- Example ADRs
- Architecture presentations archive

---

[Back to Home](../../README.md)
