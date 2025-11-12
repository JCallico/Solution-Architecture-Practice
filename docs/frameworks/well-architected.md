# Well-Architected Frameworks

Cloud provider well-architected frameworks provide best practices for designing and operating reliable, secure, efficient, and cost-effective systems in the cloud.

## Overview

Both AWS and Azure provide comprehensive frameworks based on pillars of architectural excellence. These frameworks guide architectural decisions and help identify areas for improvement.

## AWS Well-Architected Framework

### Six Pillars

#### 1. Operational Excellence
**Focus:** Running and monitoring systems to deliver business value

**Key Practices:**
- Perform operations as code (IaC)
- Make frequent, small, reversible changes
- Refine operations procedures frequently
- Anticipate failure
- Learn from operational failures

**Tools:** CloudFormation, Systems Manager, CloudWatch, X-Ray

#### 2. Security
**Focus:** Protecting information, systems, and assets

**Key Practices:**
- Implement strong identity foundation
- Enable traceability
- Apply security at all layers
- Automate security best practices
- Protect data in transit and at rest
- Keep people away from data
- Prepare for security events

**Tools:** IAM, KMS, CloudTrail, GuardDuty, Security Hub

#### 3. Reliability
**Focus:** Recovery from failures and meeting demand

**Key Practices:**
- Automatically recover from failure
- Test recovery procedures
- Scale horizontally
- Stop guessing capacity
- Manage change through automation

**Tools:** Auto Scaling, RDS Multi-AZ, Route 53, CloudWatch

#### 4. Performance Efficiency
**Focus:** Using resources efficiently

**Key Practices:**
- Democratize advanced technologies
- Go global in minutes
- Use serverless architectures
- Experiment more often
- Consider mechanical sympathy

**Tools:** Lambda, ECS/EKS, CloudFront, ElastiCache

#### 5. Cost Optimization
**Focus:** Avoiding unnecessary costs

**Key Practices:**
- Implement cloud financial management
- Adopt consumption model
- Measure overall efficiency
- Stop spending on undifferentiated heavy lifting
- Analyze and attribute expenditure

**Tools:** Cost Explorer, Trusted Advisor, S3 Intelligent-Tiering

#### 6. Sustainability
**Focus:** Environmental impact

**Key Practices:**
- Understand your impact
- Establish sustainability goals
- Maximize utilization
- Anticipate and adopt new efficient technologies
- Use managed services
- Reduce downstream impact

## Azure Well-Architected Framework

### Five Pillars

#### 1. Cost Optimization
**Focus:** Managing costs to maximize value

**Key Areas:**
- Choose the right resources
- Set up budgets and maintain cost constraints
- Dynamically allocate and de-allocate resources
- Optimize workloads, aim for scalable costs

**Tools:** Cost Management, Advisor, Reservations, Spot VMs

#### 2. Operational Excellence
**Focus:** Operations processes for deployment, monitoring, and management

**Key Areas:**
- Embrace DevOps culture
- Establish development standards
- Evolve operations with observability
- Deploy with confidence
- Automate for efficiency

**Tools:** Azure DevOps, Monitor, Application Insights, Automation

#### 3. Performance Efficiency
**Focus:** Ability to scale and meet demands efficiently

**Key Areas:**
- Negotiate realistic performance targets
- Design for horizontal scaling
- Shift resource-intensive tasks to background
- Minimize latency with caching
- Optimize network performance

**Tools:** App Service, AKS, Redis Cache, Front Door, CDN

#### 4. Reliability
**Focus:** System recovery and continued function

**Key Areas:**
- Design for business requirements
- Design for resilience
- Design for recovery
- Design for operations
- Keep it simple

**Tools:** Availability Zones, Load Balancer, Site Recovery, Backup

#### 5. Security
**Focus:** Protecting applications and data

**Key Areas:**
- Plan resources and maintain compliance
- Automate and use least privilege
- Classify and encrypt data
- Monitor system security, plan incident response
- Identify and protect endpoints
- Protect against code-level vulnerabilities

**Tools:** Entra ID, Key Vault, Security Center, Sentinel

## Applying Well-Architected Frameworks

### Architecture Review Process

1. **Assessment** - Evaluate current architecture against pillars
2. **Identify Issues** - Find high and medium risk items
3. **Prioritize** - Focus on highest impact improvements
4. **Remediate** - Implement improvements
5. **Re-assess** - Validate improvements

### Integration with Our Practice

We incorporate well-architected principles into:

- **[Architecture Review Board](../processes/arb/README.md)** - Use pillars as review criteria
- **[Solution Architecture Template](../templates/documents/solution-architecture-template.md)** - Include well-architected assessment
- **[Architecture Principles](../practice-overview/principles.md)** - Aligned with framework pillars
- **[Quality Gates](../processes/quality-gates.md)** - Well-architected checks at each gate

### Well-Architected Review Checklist

Use this in [architecture reviews](../processes/arb/README.md):

**For Each Pillar:**
- [ ] Key practices documented
- [ ] Risks identified and mitigated
- [ ] Metrics defined and monitored
- [ ] Improvement plan created
- [ ] Ownership assigned

## Tools & Resources

### AWS Resources
- Well-Architected Tool (automated review)
- Well-Architected Labs (hands-on exercises)
- Well-Architected Partner Program
- Architecture Center (reference architectures)

### Azure Resources  
- Well-Architected Review (assessment tool)
- Azure Advisor (automated recommendations)
- Azure Architecture Center
- Cloud Adoption Framework

### Our Resources
- [Cloud Architecture Best Practices](../knowledge-base/patterns/cloud-patterns.md)
- [Reference Architectures](../knowledge-base/reference-architectures/README.md)
- [ARB Review Criteria](../processes/arb/README.md#review-criteria)

## Best Practices

1. **Review Regularly** - Conduct reviews at each lifecycle phase
2. **Use Automation** - Leverage built-in assessment tools
3. **Prioritize Ruthlessly** - Fix high-risk items first
4. **Document Decisions** - Use [ADRs](./adr-framework.md) for trade-offs
5. **Measure Progress** - Track improvements over time
6. **Share Learnings** - Document patterns and anti-patterns

## Comparison: AWS vs Azure

| Aspect | AWS | Azure |
|--------|-----|-------|
| Pillars | 6 | 5 |
| Sustainability | Dedicated pillar | Integrated across pillars |
| Tool | Well-Architected Tool | Well-Architected Review + Advisor |
| Focus | Prescriptive practices | Principled guidance |
| Lenses | Specialized (SaaS, Serverless, ML, etc.) | Workload-specific guidance |

---

**Last Updated:** November 2025  
**Related:** [Cloud Patterns](../knowledge-base/patterns/cloud-patterns.md) | [Architecture Principles](../practice-overview/principles.md)

*For cloud architecture training, see [Cloud Architecture Learning Path](../training/learning-paths/cloud-architecture.md)*
