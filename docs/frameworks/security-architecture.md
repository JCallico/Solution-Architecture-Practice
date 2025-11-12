# Security Architecture Framework

## Overview

The Security Architecture Framework provides a structured approach to designing and implementing security into systems and organizations. It addresses threat modeling, security controls, compliance, and governance from an architectural perspective.

## Core Principles

**Defense in Depth**
- Multiple layers of security
- No single point of failure
- Layered controls and redundancy
- Assume breach mentality

**Least Privilege**
- Users/systems get minimum necessary access
- Revoke when no longer needed
- Role-based access control
- Regular access reviews

**Zero Trust**
- Trust nothing by default
- Verify everything
- Assume breach occurred
- Continuous verification

**Security by Design**
- Integrate security from start
- Not afterthought
- Threat modeling early
- Secure defaults

**Simplicity**
- Complex security often fails
- Keep it simple to understand
- Fewer moving parts to secure
- Easier to audit and test

## Security Architecture Domains

### 1. Identity & Access Management (IAM)

Control who can access what.

**Components:**

**Authentication**
- Verify identity
- Methods: Password, MFA, biometric, certificate
- Challenge: Compromise, phishing
- Solution: Multi-factor authentication

**Authorization**
- Determine permissions
- Models: RBAC, ABAC, policies
- Challenge: Over-privilege, role explosion
- Solution: Principle of least privilege

**Accounting**
- Track access and actions
- Audit logs
- Challenge: Log volume
- Solution: Centralized logging and analysis

**Access Control Models:**

```
Role-Based Access Control (RBAC):
  Permissions assigned to roles
  Users assigned to roles
  Simple to understand
  Risk: Role explosion

Attribute-Based Access Control (ABAC):
  Permissions based on attributes
  More flexible than RBAC
  Risk: Complex policy management

Identity Federation:
  Delegate to external IdP
  Single sign-on
  Risk: External dependency
```

**Best Practices:**
- Centralized identity management
- Multi-factor authentication
- Conditional access policies
- Regular access reviews
- Separate privileged access

### 2. Network Security

Protect data in transit.

**Segments:**

**Perimeter Security**
- Firewall rules
- DDoS protection
- WAF for web applications
- Intrusion detection/prevention

**Internal Network**
- Network segmentation
- Micro-segmentation for zero trust
- VLANs for isolation
- Private networks

**Endpoint Security**
- Host-based firewalls
- Antivirus/antimalware
- Device hardening
- Configuration management

**Encryption in Transit:**
- TLS/SSL for HTTPS
- IPsec for VPNs
- Encrypted databases connections
- Message encryption

**Architecture Patterns:**

```
DMZ (Demilitarized Zone):
  Internet → Firewall → DMZ → Internal
              ↓
         Public Services
         (Web servers)

Zero Trust Network:
  Every connection verified
  Micro-segmentation
  Encrypted internal traffic
  Continuous monitoring
```

### 3. Application Security

Secure the code and deployment.

**SDLC Integration:**
- Secure design phase
- Code review and scanning
- Security testing (SAST/DAST)
- Dependency vulnerability scanning
- Runtime monitoring

**Common Vulnerabilities (OWASP Top 10):**
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable/Outdated Components
7. Authentication Failures
8. Software/Data Integrity Failures
9. Logging & Monitoring Failures
10. Server-Side Request Forgery (SSRF)

**Mitigation Strategies:**

```
Input Validation:
  Whitelist allowed values
  Reject invalid input
  Parameterized queries (SQL injection)

Output Encoding:
  Encode based on context (HTML, URL, JS)
  Prevent XSS attacks

Authentication:
  Strong password policies
  Multi-factor authentication
  Secure password storage (bcrypt/argon2)

Authorization:
  Check permissions for every action
  Deny by default
  Use proven libraries
```

**Secure Coding Practices:**
- Follow framework security guidelines
- Use security libraries (not crypto from scratch)
- Regular dependency updates
- Security code reviews
- Static analysis tools

### 4. Data Security

Protect sensitive data.

**Classification Framework:**
```
Public:        No encryption required
Internal:      Encrypt at rest
Confidential:   Encrypt at rest & transit
Restricted:    HSM encryption, highest controls
```

**Encryption Strategy:**

**At Rest:**
- Database-level encryption
- File-level encryption
- Backup encryption
- Full-disk encryption

**In Transit:**
- TLS/SSL for all connections
- Perfect forward secrecy
- Certificate management
- Encrypted messaging

**Key Management:**
- Centralized key management (AWS KMS, Azure Key Vault)
- Key rotation policies
- Separate keys per environment
- Access controls on keys

**Data Protection Patterns:**

```
Tokenization:
  Replace sensitive data with tokens
  Store mapping in secure location
  Reduces PII exposure

Masking:
  Hide data from non-authorized users
  Show partial data when needed
  Audit visible access

Anonymization:
  Irreversibly remove PII
  For analytics/development
  Legally compliant
```

### 5. Identity & Access for Cloud

Special considerations for cloud environments.

**Cloud-Native IAM:**
- Service principals/managed identities
- Temporary credentials
- Just-in-time access
- Privilege access workstations

**Multi-Cloud Identity:**
- Centralized identity
- SAML/OAuth for federation
- Consistent access policies
- Cross-cloud authentication

**Container Security:**
- Image scanning
- Runtime policies
- Pod security policies
- Admission controllers

**Examples:**

```
AWS:
  IAM roles for EC2
  Temporary STS credentials
  Service-linked roles
  Resource-based policies

Azure:
  Managed identities
  Azure AD integration
  Role-based access control
  Conditional access

GCP:
  Service accounts
  GCP Identity Provider
  Workload identity
  Fine-grained permissions
```

### 6. Security Operations & Monitoring

Detect and respond to threats.

**Components:**

**Logging & Monitoring**
- Centralized log collection
- Log retention policies
- Real-time monitoring
- Alerting on anomalies

**Threat Detection**
- SIEM (Security Information Event Management)
- Behavioral analytics
- Anomaly detection
- Threat intelligence

**Incident Response**
- Incident response plan
- Playbooks for common scenarios
- Escalation procedures
- Communication plan
- Post-incident analysis

**Compliance Monitoring**
- Configuration compliance
- Policy compliance
- Vulnerability scanning
- Penetration testing

**Security Operations Center (SOC):**
```
Monitoring → Detection → Triage → Response → Investigation → Recovery
    ↓
 Continuous improvement
```

### 7. Supply Chain & Third-Party Security

Manage security of dependencies and vendors.

**Third-Party Risk Management:**
- Vendor assessment
- Security questionnaires
- Contract requirements
- Regular audits
- Incident notification

**Software Supply Chain:**
- Secure dependency management
- Version pinning
- Vulnerability scanning
- Software composition analysis

**Build & Deployment Security:**
- Signed artifacts
- Secure build pipelines
- Access controls
- Audit trails

## Security Frameworks & Standards

### NIST Cybersecurity Framework

**Components:**
1. **Identify** - Understand business/assets
2. **Protect** - Implement safeguards
3. **Detect** - Identify attacks
4. **Respond** - Contain incidents
5. **Recover** - Restore operations

### ISO 27001

**Information Security Management System**
- Policies and procedures
- Risk assessment and treatment
- Incident management
- Compliance and audit

### CIS Controls

**Top 18 Controls:**
1. Inventory of hardware/software
2. Secure configuration
3. Network access control
4. Secure configurations
5. Account management
... (13 more)

### OWASP

**Web Application Security:**
- Top 10 vulnerabilities
- Testing guide
- Cheat sheets
- Project examples

## Threat Modeling

Identify and mitigate threats systematically.

### STRIDE Model

**Categories:**
- **S**poofing - Identity spoofing
- **T**ampering - Data modification
- **R**epudiation - Denial of actions
- **I**nformation Disclosure - Data exposure
- **D**enial of Service - Service unavailable
- **E**levation of Privilege - Unauthorized access

### Process

```
1. Model the system
   ├─ Components and flows
   ├─ Data stores
   └─ Trust boundaries

2. Identify threats
   ├─ Apply STRIDE
   ├─ Known vulnerabilities
   └─ Attack vectors

3. Mitigate
   ├─ Technology controls
   ├─ Process controls
   └─ Prioritize by risk

4. Validate
   ├─ Verify mitigations
   ├─ Testing
   └─ Monitoring
```

### Threat Modeling Tools

- Microsoft Threat Modeling Tool
- IriusRisk
- ThreatDragon
- Draw.io (manual)

## Security Architecture Patterns

### Defense in Depth Layers

```
Perimeter
  ↓
Network
  ↓
Application
  ↓
Data
  ↓
People/Process
```

### Zero Trust Architecture

```
User/Device Authentication
         ↓
    Verify every request
         ↓
    Minimal access grant
         ↓
    Continuous monitoring
         ↓
    Revoke if suspicious
```

### Security by Design Pattern

```
1. Threat modeling
   ↓
2. Design mitigations
   ↓
3. Implement securely
   ↓
4. Test security
   ↓
5. Monitor & update
```

## Cloud Security Considerations

### Shared Responsibility Model

**Provider Responsible:**
- Physical security
- Network infrastructure
- Hypervisor security
- Data center facilities

**Customer Responsible:**
- Identity and access
- Data encryption
- Network configuration
- Operating system patches

**IaaS:**
More customer responsibility

**PaaS:**
Shared responsibility

**SaaS:**
Mostly provider responsibility

### Cloud-Specific Controls

**Access Control:**
- IAM policies
- Multi-factor authentication
- Conditional access
- Service principals

**Data Protection:**
- Encryption key management
- Field-level encryption
- Secrets management
- Data residency

**Compliance:**
- Audit trails
- Encryption at rest
- Encryption in transit
- Compliance certifications

## Compliance Frameworks

### GDPR (General Data Protection Regulation)
- EU data protection
- Privacy by design
- Data subject rights
- Breach notification

### HIPAA (Health Insurance Portability & Accountability Act)
- Healthcare data protection
- Encryption requirements
- Access controls
- Audit logging

### PCI DSS (Payment Card Industry)
- Card data protection
- Secure network
- Cardholder data protection
- Monitoring & testing

### SOC 2 (Service Organization Control)
- Security and availability
- Controls testing
- Audit by third party

## Security Architecture Checklist

**Design Phase:**
- [ ] Threat modeling completed
- [ ] Security requirements defined
- [ ] Architecture reviewed for threats
- [ ] Mitigations designed
- [ ] Trade-offs documented

**Implementation Phase:**
- [ ] Security controls implemented
- [ ] Code reviewed for security
- [ ] Security testing completed
- [ ] Vulnerability scanning done
- [ ] Dependency check completed

**Deployment Phase:**
- [ ] Secure configuration applied
- [ ] Access controls enforced
- [ ] Encryption enabled
- [ ] Monitoring active
- [ ] Incident response ready

**Operations Phase:**
- [ ] Logs collected centrally
- [ ] Alerts configured
- [ ] Updates applied promptly
- [ ] Access reviewed regularly
- [ ] Incidents tracked

## Best Practices

✅ **Threat Model Early**
Identify risks before implementation.

✅ **Layered Security**
Multiple controls for defense in depth.

✅ **Principle of Least Privilege**
Users get minimum necessary access.

✅ **Secure by Default**
Secure configurations out of the box.

✅ **Encrypt Everything**
Data at rest and in transit.

✅ **Monitor & Alert**
Detect problems quickly.

✅ **Regular Testing**
Penetration testing and simulations.

✅ **Keep Software Current**
Patch promptly, update dependencies.

❌ **Security as Afterthought**
Builds unsecure systems.

❌ **Single Point of Failure**
Critical systems need redundancy.

❌ **Storing Secrets in Code**
Use secure secrets management.

❌ **Trusting Network**
Assume breach, verify everything.

## Related Resources

- [Well-Architected Frameworks](./well-architected.md)
- [Microservices Architecture](./microservices.md)
- [Data Architecture](./data-architecture.md)
- [Security Patterns](../knowledge-base/patterns/security-patterns.md)

## References

- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [ISO 27001](https://www.iso.org/isoiec-27001-information-security-management.html)
- [OWASP](https://owasp.org/)
- [CIS Controls](https://www.cisecurity.org/cis-controls/)
- _Security Architecture and Design_ (Jaeger)
- _The Security of Things_ (Sheldon)

---

**Last Updated:** November 2025  
**Related:** [Well-Architected Frameworks](./well-architected.md) | [Microservices Architecture](./microservices.md) | [Data Architecture](./data-architecture.md)
