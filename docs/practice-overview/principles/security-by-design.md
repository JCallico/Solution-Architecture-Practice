# Security by Design Principle

## Overview

**Principle**: Security must be built into solutions from the ground up, not bolted on afterward.

Security is not a feature to be added at the end; it must be integrated into every design decision. Breaches are increasingly costly in terms of financial, legal, and reputational impact.

## Rationale

- Security breaches have catastrophic business impact (financial, legal, reputation)
- Retrofitting security is more expensive and less effective than building it in
- Security threats are evolving constantly; architecture must adapt
- Regulatory compliance increasingly requires security-by-design
- Customer trust depends on perceived security

## Core Implications

### 1. Zero-Trust Architecture
Assume nothing is inherently trustworthy:

**Zero-Trust Principles:**
- Never trust, always verify (every access request)
- Assume breach (design for compromised credentials)
- Verify explicitly (authentication/authorization for every transaction)
- Use least privilege (minimal necessary access)
- Inspect and log all traffic
- Secure every layer (no implicit trust)

**Implementation:**

```
Traditional Approach (Trust the Network):
┌─────────────────────────────────┐
│ Trusted Internal Network         │
│ ┌─────────────────────────────┐ │
│ │ Unverified Internal Traffic │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘

Zero-Trust Approach (Verify Everything):
                    ↓ Verify ↓
    User → Auth → Access Control
                    ↓ Log & Monitor ↓
               Microservice
                    ↓ Verify ↓
              Database Access
```

### 2. Defense in Depth
Multiple layers of security controls:

**Security Layers:**

1. **Perimeter Security**
   - Firewalls, WAF, DDoS protection
   - Geographic restrictions
   - Rate limiting

2. **Application Security**
   - Input validation and sanitization
   - Output encoding
   - Secure coding practices
   - OWASP Top 10 compliance

3. **Data Security**
   - Encryption in transit (TLS)
   - Encryption at rest (AES-256)
   - Key management
   - Data loss prevention (DLP)

4. **Access Control**
   - Authentication (who are you?)
   - Authorization (what can you access?)
   - Accounting (what did you do?)

5. **Network Security**
   - Network segmentation
   - VPCs, security groups
   - Private link for sensitive services
   - Encrypted inter-service communication

6. **Operational Security**
   - Patch management
   - Vulnerability scanning
   - Security monitoring
   - Incident response

### 3. Threat Modeling
Identify and mitigate security risks systematically:

**STRIDE Model:**

```
Spoofing:    Attacker pretends to be someone else
             Mitigation: Strong authentication, MFA

Tampering:   Attacker modifies data or code
             Mitigation: Encryption, integrity checks, access control

Repudiation: Attacker denies their actions
             Mitigation: Audit logging, digital signatures

Information Disclosure: Data exposed to unauthorized parties
             Mitigation: Encryption, access control, data classification

Denial of Service: System unavailable
             Mitigation: Rate limiting, DDoS protection, auto-scaling

Elevation of Privilege: Attacker gains higher permissions
             Mitigation: Least privilege, RBAC, secure defaults
```

**Threat Modeling Process:**

1. Define system scope
2. Create architecture diagrams
3. Identify assets to protect
4. Identify threat actors
5. Apply STRIDE to each component
6. Document threats and mitigations
7. Prioritize by risk
8. Implement controls
9. Verify and test

### 4. Compliance Integration
Security supports compliance requirements:

**Common Frameworks:**

| Framework | Focus | Key Requirements |
|-----------|-------|------------------|
| GDPR | Data privacy | Consent, data rights, DPO, breach notification |
| PCI-DSS | Payment card | Encryption, access control, monitoring |
| HIPAA | Health data | Privacy, security, breach notification |
| SOC 2 | Audit controls | Access, availability, processing integrity, confidentiality |
| ISO 27001 | Information security | Risk management, asset protection, access control |

### 5. Automated Security Testing
Build security verification into CI/CD:

**Testing Types:**

- **Static Analysis (SAST):** Code scanning for vulnerabilities
- **Dependency Scanning:** Vulnerable library detection
- **Dynamic Analysis (DAST):** Runtime testing
- **Infrastructure Scanning:** Misconfiguration detection
- **Compliance Scanning:** Regulatory requirement validation
- **Penetration Testing:** Manual security assessment

## Implementation Practices

### Secure Architecture Design

**1. Authentication & Authorization**

```
Authentication: Verify identity
Methods:
- MFA (multi-factor authentication) for sensitive systems
- OAuth/OIDC for delegated access
- Service-to-service: mTLS, API keys, JWT tokens
- Avoid passwords when possible

Authorization: Verify permissions
Methods:
- RBAC (role-based): User has role → Role has permissions
- ABAC (attribute-based): Permissions based on attributes
- Principle of least privilege: Minimal necessary access
- Regular access reviews
```

**2. Data Protection**

```
In Transit:
- TLS 1.2+ for all external communication
- mTLS for service-to-service
- Encrypted VPN for remote access

At Rest:
- AES-256 encryption for sensitive data
- Field-level encryption for PII
- Encryption keys managed in Key Vault
- Key rotation policies

In Memory:
- Clear sensitive data from memory after use
- Don't log passwords, tokens, keys
- Minimize sensitive data exposure
```

**3. Network Security**

```
Architecture:
┌─ WAF (Web Application Firewall)
   ├─ API Gateway
      ├─ Service 1 (VPC/Subnet)
      ├─ Service 2 (VPC/Subnet)
      └─ Service 3 (VPC/Subnet)
         ├─ Database (Encrypted)
         └─ Secrets Vault

Segmentation:
- DMZ for public-facing services
- Private subnets for sensitive services
- Service mesh for inter-service communication
- No public internet access for databases
```

### Security Requirements in Design Documents

Include in every architecture document:

**Security Architecture Section:**

```
1. Authentication
   - Who are the users?
   - How do we verify identity?
   - MFA requirements?
   - Third-party integrations (SSO)?

2. Authorization
   - What roles/permissions exist?
   - How do we enforce least privilege?
   - Admin access controls?
   - Regular access reviews?

3. Data Protection
   - What data requires encryption?
   - Encryption keys (managed where)?
   - Key rotation policy?
   - Data retention/deletion?

4. Network Security
   - Public vs. private components?
   - Network segmentation approach?
   - DDoS protection?
   - WAF rules?

5. Compliance
   - Which regulations apply?
   - Audit logging requirements?
   - Compliance mapping?
   - Regular compliance reviews?

6. Incident Response
   - How do we detect breaches?
   - Incident escalation path?
   - Forensics/investigation capability?
   - Breach notification plan?
```

### Security Checklist for Implementations

Before deploying to production:

- [ ] Authentication implemented and tested
- [ ] Authorization enforced (least privilege verified)
- [ ] All sensitive data encrypted (in transit and at rest)
- [ ] Secrets not stored in code/config (using Key Vault)
- [ ] OWASP Top 10 addressed
- [ ] Dependency vulnerabilities scanned
- [ ] Infrastructure scanning completed
- [ ] Security group rules minimized
- [ ] Logging and monitoring enabled
- [ ] Incident response plan documented
- [ ] Security testing integrated in CI/CD
- [ ] Compliance requirements verified
- [ ] Third-party security assessments (if needed)
- [ ] Security documentation up to date

## Common Scenarios

### Scenario 1: API Security
**Situation:** Building API that needs to be secure and accessible.

**Approach:**
```
1. Authentication
   - OAuth 2.0 for delegated access
   - JWT tokens with short expiration
   - Token refresh capability

2. Authorization
   - API key rate limiting
   - Scopes for granular permissions
   - Resource-level access control

3. Data Protection
   - TLS for all API calls
   - Sensitive data not in logs
   - Input validation on all endpoints

4. Monitoring
   - Log all API calls (without sensitive data)
   - Alert on suspicious patterns
   - Rate limit violations
```

### Scenario 2: Microservices Security
**Situation:** Multiple services need secure inter-service communication.

**Approach:**
```
1. Service Identification
   - mTLS for service-to-service communication
   - Service certificates in certificate store

2. Network Security
   - Service mesh (Istio/Linkerd) for encryption
   - Network policies limiting traffic
   - Private networks for inter-service communication

3. Authorization
   - Service identity verification
   - Per-request authorization policies
   - Audit logging of inter-service calls
```

### Scenario 3: Data Protection Compliance
**Situation:** Handling sensitive customer data (PII, payments, etc.).

**Approach:**
```
1. Data Classification
   - Identify data sensitivity levels
   - Map to protection requirements

2. Encryption
   - At-rest encryption for sensitive data
   - In-transit encryption (TLS)
   - Field-level encryption for highest sensitivity

3. Access Control
   - Minimize who can access
   - Role-based access
   - Audit logging

4. Compliance
   - GDPR right to be forgotten implementation
   - Data retention policies
   - Regular compliance audits
```

## Risks of Ignoring This Principle

❌ **Data Breaches:** Exposure of customer/business data
❌ **Compliance Violations:** Legal and regulatory penalties
❌ **Reputational Damage:** Loss of customer trust
❌ **Operational Disruption:** DDoS, ransomware, system compromise
❌ **Expensive Remediation:** Fixing security after the fact is costly
❌ **Regulatory Fines:** GDPR, PCI-DSS violations can be expensive

## Best Practices

✅ **Make security everyone's responsibility**
Not just the security team; every engineer must think about security.

✅ **Automate security testing**
Integrate scanning into CI/CD; don't rely on manual processes.

✅ **Keep security simple**
Overly complex security often gets circumvented or misconfigured.

✅ **Regular security training**
Keep team updated on threats, vulnerabilities, and best practices.

✅ **Design for compromise**
Assume breach will happen; minimize blast radius.

✅ **Monitor and log everything**
If you can't log it, you can't investigate it.

✅ **Least privilege principle**
Give users/services only the minimum access needed.

✅ **Security reviews in architecture**
Include security experts in design reviews, not just implementation.

## Related Principles

- **[Compliance and Governance](./compliance-and-governance.md)** - Meeting regulatory requirements
- **[Data as an Asset](./data-as-an-asset.md)** - Protecting valuable data
- **[Observability Built-In](./observability-built-in.md)** - Detecting security issues

## References

- OWASP Top 10
- NIST Cybersecurity Framework
- _Zero Trust Architecture_ (Evan Gilman, Doug Barth)
- _Threat Modeling_ (Adam Shostack)

---

**Last Updated:** November 2025
**Principle Category:** Quality/Compliance
**Applies To:** All systems, especially those handling sensitive data
**Related Documents:** [Architecture Review Checklist](../../knowledge-base/playbooks/architecture-playbook.md), [Compliance Requirements](../../knowledge-base/standards/compliance.md)
