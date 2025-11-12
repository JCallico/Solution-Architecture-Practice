# Compliance and Governance Principle

## Overview

**Principle**: All systems must meet regulatory requirements, maintain audit trails, and operate under organizational governance.

Compliance isn't optional—it's a requirement. Governance ensures consistency, quality, and risk management across the enterprise.

## Rationale

- Regulations exist for customer protection
- Non-compliance triggers fines and legal action
- Breaches destroy trust and brand
- Audit trails enable accountability
- Governance prevents chaos
- Compliance must be designed in, not added later

## Core Implications

### 1. Regulatory Frameworks

**Common Regulations:**

```
GDPR (General Data Protection Regulation)
├─ Applies to: Processing data of EU residents
├─ Key Requirements:
│  ├─ Data subject rights (access, erasure)
│  ├─ Data minimization (only collect needed)
│  ├─ Purpose limitation (use only for stated purpose)
│  ├─ Consent management
│  ├─ Data breach notification (72 hours)
│  └─ Data Protection Impact Assessment
├─ Penalties: 4% of revenue or €20M (whichever higher)
└─ Example Impact:
   └─ Must delete user data on request
   └─ Must notify users of breaches

HIPAA (Health Insurance Portability and Accountability Act)
├─ Applies to: Healthcare data in US
├─ Key Requirements:
│  ├─ Encryption in transit and at rest
│  ├─ Access controls and audit logs
│  ├─ Business Associate Agreements
│  ├─ Security risk assessments
│  └─ Incident response procedures
├─ Penalties: $100-$50K per violation ($1.5M annual maximum)
└─ Example Impact:
   └─ Must encrypt all patient data
   └─ Must track all access to records

PCI-DSS (Payment Card Industry Data Security Standard)
├─ Applies to: Processing credit cards
├─ Key Requirements:
│  ├─ Secure network architecture
│  ├─ Data encryption (cardholder data)
│  ├─ Access control and monitoring
│  ├─ Regular security assessments
│  └─ Incident response plan
├─ Levels: 1-4 (based on transaction volume)
├─ Penalties: $5K-$100K per month for non-compliance
└─ Example Impact:
   └─ Cannot store full credit card numbers
   └─ Must use tokenization or encryption

CCPA (California Consumer Privacy Act)
├─ Applies to: Processing personal data of California residents
├─ Key Requirements:
│  ├─ Right to know what data collected
│  ├─ Right to delete personal data
│  ├─ Right to opt-out of data sales
│  ├─ Privacy policy
│  └─ Data security safeguards
├─ Penalties: Up to $7,500 per violation
└─ Similar to GDPR but stricter in some areas

SOC2 (Service Organization Control)
├─ Applies to: SaaS and service providers
├─ Key Principles:
│  ├─ Security
│  ├─ Availability
│  ├─ Processing integrity
│  ├─ Confidentiality
│  └─ Privacy
├─ Not regulated, but required by customers
└─ Example Impact:
   └─ Must document and maintain security controls
   └─ Must pass annual audit
```

### 2. Audit and Accountability

**Audit Trail Requirements:**
```
What to Log:
├─ Data access (who, what, when)
├─ Data modifications (old value, new value, who, when)
├─ Authentication events (login, logout, failed attempts)
├─ Authorization decisions (who requested, what resource, allowed?)
├─ Administrative actions (config changes, permission changes)
└─ System events (errors, backups, deployments)

Audit Log Example:
{
  "timestamp": "2025-11-12T10:30:45.123Z",
  "event_type": "DATA_ACCESS",
  "user_id": "user-456",
  "user_name": "john.smith",
  "resource": "patient_records",
  "resource_id": "record-789",
  "action": "read",
  "result": "allowed",
  "source_ip": "192.168.1.100",
  "session_id": "session-123"
}

Retention: Typically 3-7 years depending on regulation
Storage: Immutable (can't modify), separate from operational data
Access: Restricted to compliance/audit teams
```

**Chain of Custody:**
```
Protects evidence integrity:
├─ Who touched the data?
├─ When did they touch it?
├─ What did they do?
└─ Why did they do it?

Example:
Data Incident Discovered
├─ Who found it? (compliance officer)
├─ When? (timestamp)
├─ What actions taken? (isolated systems)
├─ Documented every step (log every action)
└─ Maintain copy for investigation

Result: Evidence admissible in legal proceedings
```

### 3. Data Governance

**Data Classification:**
```
Public Data:
- Can be disclosed without harm
- Example: Marketing materials, public APIs
- No special protection needed

Internal Data:
- Not for public but not sensitive
- Example: Internal documentation, metrics
- Access restricted to employees

Confidential Data:
- Could harm if disclosed
- Example: Customer lists, business strategies
- Strong access controls required

Restricted Data:
- Must be protected (regulatory)
- Example: Passwords, API keys, credit cards
- Highest protection level

Governance by Classification:
Public: No special handling
Internal: Encrypt in transit
Confidential: Encrypt in transit and at rest, audit log access
Restricted: All of above + tokenization/hashing, multi-factor access
```

**Data Retention Policies:**
```
Retention Schedule:
├─ Customer data: 3 years after account closure
├─ Transaction records: 7 years (audit requirement)
├─ Logs: 6 months to 1 year
├─ Backups: 30 days
└─ Archived data: As per legal requirements

Deletion Process:
1. Identify data to delete (by retention date)
2. Generate deletion report
3. Execute deletion in database
4. Verify deletion (spot check)
5. Update audit log
6. Archive deletion report
```

### 4. Access Control and Least Privilege

**Role-Based Access Control (RBAC):**
```
Roles:
├─ Admin: Full system access
├─ Manager: Can view team data, no sensitive data
├─ Analyst: Can view reports, read-only
└─ User: Can view own data only

Role Assignment Rules:
1. Assign lowest privilege needed
2. Regularly review assignments
3. Remove when no longer needed
4. Document all assignments

Example:
Junior Developer needs to:
├─ Read production logs (Assign: LogViewer role)
├─ Deploy code (Assign: Deployer role)
└─ DON'T assign: Admin role (too much access)
```

**Multi-Factor Authentication:**
```
For Sensitive Systems:
├─ Something you know: Password
├─ Something you have: Phone (SMS, app)
├─ Something you are: Biometric (fingerprint)
└─ Someone you are: Security questions

Implementation:
├─ Required for admin access
├─ Required for sensitive data access
├─ Optional for regular users (but recommended)
```

## Implementation Practices

### 1. Compliance Architecture

```
┌──────────────────────────────────────────────┐
│         Application Layer                    │
│  ┌────────────┐  ┌────────────┐  ┌────────┐ │
│  │ Auth       │  │ Data Access│  │ Audit  │ │
│  │ Service    │  │ Controls   │  │ Logs   │ │
│  └────────────┘  └────────────┘  └────────┘ │
└───────────────────┬──────────────────────────┘
                    │
┌───────────────────▼──────────────────────────┐
│      Security Controls Layer                 │
│  ┌────────────┐  ┌────────────┐  ┌────────┐ │
│  │Encryption  │  │Secrets Mgmt│  │Network │ │
│  │(TLS, AES)  │  │(Vault)     │  │(FW,VPC)│ │
│  └────────────┘  └────────────┘  └────────┘ │
└───────────────────┬──────────────────────────┘
                    │
┌───────────────────▼──────────────────────────┐
│    Monitoring and Compliance Layer           │
│  ┌────────────┐  ┌────────────┐  ┌────────┐ │
│  │Monitoring  │  │Compliance  │  │Incident│ │
│  │(Metrics)   │  │Reporting   │  │Response│ │
│  └────────────┘  └────────────┘  └────────┘ │
└──────────────────────────────────────────────┘
```

### 2. Compliance Checklist

**Data Protection:**
```
☐ Data encrypted in transit (TLS 1.2+)
☐ Data encrypted at rest (AES-256)
☐ Encryption keys managed securely (KMS)
☐ No sensitive data in logs
☐ No sensitive data in error messages
☐ Data retention policies documented
☐ Data deletion process implemented
☐ Regular encryption key rotation
```

**Access Control:**
```
☐ Authentication required (strong passwords or MFA)
☐ Authorization enforced (role-based)
☐ Least privilege principle applied
☐ Access reviews conducted quarterly
☐ Unused accounts disabled
☐ Admin access logged and reviewed
☐ Service accounts don't have human passwords
☐ Privileged access management (PAM) implemented
```

**Audit and Logging:**
```
☐ Audit logs immutable
☐ Audit logs retained per policy (3-7 years)
☐ Audit logs stored separately from operational logs
☐ All sensitive operations logged
☐ Audit logs reviewed regularly
☐ Anomalies detected and investigated
☐ Chain of custody documented
☐ Incident response plan tested
```

**Monitoring and Compliance:**
```
☐ Security events monitored (SIEM)
☐ Alerts configured for suspicious activity
☐ Penetration testing conducted annually
☐ Vulnerability assessments completed
☐ Security patches applied timely
☐ Incident response plan documented
☐ Disaster recovery plan tested
☐ Business continuity plan documented
```

### 3. Compliance Tools

| Area | Tools |
|------|-------|
| IAM/Access Control | Okta, Azure AD, Keycloak |
| Secrets Management | HashiCorp Vault, AWS Secrets Manager |
| Encryption | AWS KMS, Azure Key Vault |
| Audit Logging | Splunk, ELK, DataDog |
| Compliance Monitoring | CloudHealth, Cloudmapper, ScoutSuite |
| Vulnerability Scanning | Snyk, OWASP ZAP, Qualys |

### 4. Governance Framework

**Governance Structure:**
```
┌─────────────────────────────────────┐
│  Security Steering Committee        │
│  (CISO, Architects, Compliance)     │
│  ├─ Sets security policies          │
│  ├─ Reviews incidents               │
│  └─ Approves exceptions             │
└─────────────────┬───────────────────┘
                  │
    ┌─────────────┼─────────────┐
    │             │             │
┌───▼────┐   ┌───▼────┐   ┌───▼────┐
│Access  │   │Data    │   │Security │
│Control │   │Privacy │   │Incident │
│Team    │   │Team    │   │Team     │
└────────┘   └────────┘   └─────────┘
```

**Policy Examples:**
```
Password Policy:
├─ Minimum 12 characters
├─ Must contain uppercase, lowercase, numbers, symbols
├─ Cannot reuse last 5 passwords
├─ Expires every 90 days
└─ Account locked after 5 failed attempts

Data Access Policy:
├─ Only access data needed for job
├─ Sensitive data requires approval
├─ All access logged
├─ Access reviewed quarterly
└─ Unauthorized access triggers investigation

Incident Response Policy:
├─ Classify severity (Critical, High, Medium, Low)
├─ Notify stakeholders (based on severity)
├─ Investigate root cause
├─ Implement remediation
└─ Document lessons learned
```

## Common Scenarios

### Scenario 1: Data Breach
**Situation:** Unauthorized access to customer data detected.

**Response (Incident Plan):**
1. Classify severity (High → Initiate incident response)
2. Contain (Isolate affected systems)
3. Eradicate (Remove attacker access)
4. Recover (Restore normal operations)
5. Notify (GDPR requires 72 hours)
6. Investigate (Root cause analysis)
7. Remediate (Fix vulnerability)
8. Document (Create incident report)

**Result:** Compliance maintained, trust preserved

### Scenario 2: Compliance Audit
**Situation:** Annual SOC2 audit required.

**Preparation:**
1. Review all security controls
2. Gather documentation
3. Run vulnerability assessments
4. Fix any issues
5. Brief team on audit

**During Audit:**
1. Auditor reviews controls
2. Conducts interviews
3. Tests controls
4. Reviews logs and evidence

**After Audit:**
1. Address audit findings
2. Implement remediation
3. Document improvements
4. Schedule follow-up

### Scenario 3: New Regulation
**Situation:** New privacy law applies to company.

**Response:**
1. Assess impact (which systems affected)
2. Design compliance architecture
3. Implement controls
4. Test thoroughly
5. Document compliance
6. Train team

## Risks of Ignoring This Principle

❌ **Legal Liability:** Fines, lawsuits, personal criminal liability
❌ **Operational Disruption:** Incidents require response
❌ **Reputational Damage:** Breaches destroy trust
❌ **Customer Loss:** Compliance breaches lose business
❌ **Vendor Issues:** Non-compliance blocks partnerships

## Best Practices

✅ **Make compliance a design principle**
Build in from start, don't add later.

✅ **Use established frameworks**
NIST, CIS, OWASP provide guidance.

✅ **Automate compliance**
Policy-as-code, automated checks.

✅ **Document everything**
Clear policies, audit trails, decision records.

✅ **Educate teams**
Security training, regular awareness.

✅ **Test controls**
Penetration testing, vulnerability scanning.

✅ **Plan for incidents**
Response procedures documented and practiced.

✅ **Review regularly**
Quarterly access reviews, annual audits.

✅ **Stay informed**
Follow regulatory updates, threat landscape.

## Related Principles

- **[Security by Design](./security-by-design.md)** - Security underpins compliance
- **[Data as an Asset](./data-as-an-asset.md)** - Data governance critical for compliance
- **[Observability Built-In](./observability-built-in.md)** - Audit trails enable accountability

## References

- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework
- CIS Controls: https://www.cisecurity.org/controls/
- OWASP Top 10: https://owasp.org/Top10/
- Regulatory Guidance: https://www.privacy-regulation.eu/

---

**Last Updated:** November 2025
**Principle Category:** Governance
**Applies To:** All systems handling sensitive data
**Related Documents:** [Security Guide](../../knowledge-base/guides/security.md), [Compliance Checklist](../../knowledge-base/standards/compliance-checklist.md)
