# Security Guide

## Overview

Comprehensive guide for designing and implementing secure systems. This playbook covers security principles, identity & access management, data protection, application security, cloud security, and compliance frameworks.

---

## Part 1: Security Principles

### 1.1 Zero Trust Architecture

**Core Concept**: Never trust, always verify
```
Traditional: Trust inside perimeter, verify at edge
Zero Trust: Verify every request, everywhere

Principles:
1. Assume compromise (attackers already inside)
2. Verify identity before access
3. Verify device health
4. Verify network connection
5. Least privilege access
6. Continuous monitoring
```

**Implementation**:
```
User Request
  ↓ Verify identity (MFA)
  ↓ Verify device (MDM)
  ↓ Verify network (VPN, encryption)
  ↓ Check permission (RBAC/ABAC)
  ↓ Grant least privileged access
  ↓ Monitor activity
```

### 1.2 Defense in Depth

**Layered Security**:
```
Layer 1: Network Security
- Firewalls
- WAF
- DDoS protection
- Network segmentation

Layer 2: Application Security
- Input validation
- Authentication
- Authorization
- Encryption

Layer 3: Data Security
- Encryption at rest
- Encryption in transit
- Access controls
- Audit logging

Layer 4: Physical Security
- Secured data centers
- Access controls
- Surveillance
```

### 1.3 Principle of Least Privilege

**Access Control Model**:
```
User needs minimum permissions for their role

Example: Support Agent
- Can view customer information (not edit)
- Can read order history
- Cannot access financial data
- Cannot access system configs

NOT: Full database access

Review: Quarterly access reviews
```

### 1.4 Security By Design

**Secure Development**:
1. Threat modeling during design
2. Secure coding training
3. Code review with security focus
4. Automated security testing
5. Penetration testing
6. Incident response planning

---

## Part 2: Identity & Access Management

### 2.1 Authentication

**Authentication Methods**:

**1. Password-Based**:
```
Requirements:
- Minimum 12 characters
- Complexity (upper, lower, numbers, symbols)
- No common passwords
- Change if compromised
- Hash with bcrypt/Argon2 (never plaintext)

Bcrypt example:
stored_hash = bcrypt.hash(password)
is_valid = bcrypt.verify(input_password, stored_hash)
```

**2. Multi-Factor Authentication (MFA)**:
```
Something you know: Password
Something you have: Phone, security key
Something you are: Biometric

Methods:
- TOTP (Time-based One-Time Password)
- SMS (less secure)
- Push notification
- Hardware security key (most secure)

Flow:
1. Enter username/password
2. Verify with second factor
3. Grant access
```

**3. OAuth 2.0 / OpenID Connect (OIDC)**:
```
User clicks "Sign in with Google"
  ↓ Redirect to Google
  ↓ User authenticates with Google
  ↓ Google redirects back with authorization code
  ↓ Exchange code for ID token
  ↓ Validate token signature
  ↓ Grant access

Tokens:
- ID Token: User identity (JWT)
- Access Token: API authorization
- Refresh Token: Obtain new access token
```

**4. JWT (JSON Web Token)**:
```
Header.Payload.Signature

Example:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIn0.
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ

Validation:
1. Verify signature using public key
2. Check expiration (exp claim)
3. Check issuer (iss claim)
4. Extract user information

Advantages:
- Stateless (no server session storage)
- Can be used across services
- Standard format (widely supported)
```

### 2.2 Authorization

**Role-Based Access Control (RBAC)**:
```
Roles: Admin, Manager, User, Guest
Resources: Orders, Customers, Reports

Admin: all operations
Manager: read/write own region
User: read/write own data
Guest: read-only

Implementation:
if user.role in ['admin', 'manager']:
  return grant_access()
else:
  return deny_access()
```

**Attribute-Based Access Control (ABAC)**:
```
More granular than RBAC

Policy: Grant access if:
- User.department == "Finance"
- AND User.location == "NYC"
- AND Resource.classification == "public"
- AND Time.hour > 9 and Time.hour < 17

Implementation:
attributes = {
  "user.department": "Finance",
  "user.location": "NYC",
  "resource.classification": "public",
  "time.hour": 14
}
if evaluate_policy(attributes):
  return grant_access()
```

**Authorization Examples**:
```
# API endpoint authorization
GET /api/users/123/orders
- User must be authenticated (bearer token)
- User can only access their own orders
- OR user is admin

# Code:
def get_orders(user_id, current_user):
  if current_user.id != user_id and not current_user.is_admin:
    raise AccessDenied()
  return fetch_orders(user_id)
```

### 2.3 Identity Federation

**SAML 2.0 (Enterprise)**:
```
User logs in through corporate SSO
  ↓ Corporate IdP authenticates
  ↓ SAML assertion returned
  ↓ Service provider validates assertion
  ↓ Access granted

Enterprise use case:
- Multiple applications
- Single corporate identity
- Centralized management
```

**API Key Management**:
```
Server generates random API key:
Key: abc123def456ghi789jkl012

Client includes in requests:
GET /api/data
Authorization: Bearer abc123def456ghi789jkl012

Server validates:
1. Key exists in database
2. Key not revoked
3. Key has required permissions
4. Rate limit not exceeded
```

---

## Part 3: Data Protection

### 3.1 Encryption at Rest

**Database Encryption**:
```
Encrypted disk storage:
- AWS RDS with encryption enabled
- Azure SQL with TDE (Transparent Data Encryption)
- PostgreSQL with pgcrypto

Data in database is encrypted:
SELECT * FROM users WHERE id = 123
[Automatically decrypted by database]
- Only authorized users can access key
```

**File Encryption**:
```
Sensitive files encrypted:
- AWS S3 with SSE-S3 or SSE-KMS
- Azure Blob Storage with encryption
- Encrypted backup files

Key Management:
- Keys stored in key vault
- Separate from encrypted data
- Rotation policy (annual or event-based)
```

### 3.2 Encryption in Transit

**HTTPS/TLS**:
```
All network traffic encrypted:
- API endpoints: HTTPS only
- Database connections: SSL/TLS
- Service-to-service: mTLS

Certificate Management:
- Valid certificates (not self-signed in production)
- Regular renewal (Let's Encrypt for free)
- Strong ciphers (TLS 1.2+)
```

**mTLS (Mutual TLS)**:
```
Client and server both authenticate:

Client cert validates to Server
Server cert validates to Client

Implementation:
GET /api/service-data
- Client presents cert (contains service identity)
- Server validates cert (checks trusted CA)
- Server verifies certificate common name matches expected service
- Secure connection established

Use case: Microservices communication
```

### 3.3 Data Classification

**Classification Levels**:
```
Public:
- No confidentiality requirements
- Can be published
- Example: Marketing materials

Internal:
- Not for external use
- Low risk if disclosed
- Example: General documentation

Confidential:
- Restricted access needed
- Risk if disclosed
- Example: Customer data, contracts

Secret:
- Highly restricted access
- High risk if disclosed
- Example: API keys, passwords, financial data
```

**Handling Requirements**:
```
Public:
- Standard storage
- Any backup method
- Accessible to all

Confidential:
- Encrypted database
- Encrypted backups
- Access logs
- Limited access via RBAC

Secret:
- Encrypted at rest
- Encrypted in transit
- Hardware security modules for keys
- Minimal access (only needed systems)
- Full audit logging
```

### 3.4 Privacy Compliance

**GDPR (EU)**:
```
Key Rights:
- Right to access: Users can see their data
- Right to erasure: Users can delete their data
- Right to portability: Users can get data in standard format
- Right to be forgotten: Purge from all systems

Implementation:
- Consent management
- Privacy notices
- Data retention policies
- Data breach notification (72 hours)
```

**CCPA (California)**:
```
Similar to GDPR:
- Consumer rights to access data
- Consumer rights to delete data
- Consumer rights to opt-out

Implementation:
- "Do Not Sell My Data" link
- Privacy policy with specifics
- Vendor consent management
```

---

## Part 4: Application Security

### 4.1 OWASP Top 10

**1. Injection**:
```
Bad: SQL injection
query = "SELECT * FROM users WHERE email = '" + user_input + "'"
Input: ' OR '1'='1
Result: Returns all users

Good: Parameterized query
query = "SELECT * FROM users WHERE email = ?"
params = [user_input]
```

**2. Broken Authentication**:
```
Bad:
- Plaintext passwords
- Session tokens in URL
- Weak password requirements
- No MFA

Good:
- Hash passwords (bcrypt)
- HTTPS only
- Minimum 12 characters + complexity
- MFA enabled
```

**3. Sensitive Data Exposure**:
```
Bad:
- Plaintext passwords in logs
- Credit cards in database
- Unencrypted backups

Good:
- Encrypt sensitive data
- Mask in logs (card last 4 digits)
- PII only when needed
```

**4. XXE (XML External Entity)**:
```
Bad: Parse untrusted XML
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<data>&xxe;</data>

Good: Disable external entities
parser.XXE = False
```

**5. Broken Access Control**:
```
Bad:
GET /api/users/123/profile
- No check if current user is 123 or admin
- Returns all user data

Good:
def get_profile(user_id):
  if user_id != current_user.id and not current_user.is_admin:
    raise AccessDenied()
  return get_user_profile(user_id)
```

**6. Security Misconfiguration**:
```
Bad:
- Debug mode enabled
- Default credentials (admin/admin)
- Directory listing enabled
- Unnecessary services running

Good:
- Production configs hardened
- Unique credentials
- Directory listing disabled
- Only required services
```

**7. Cross-Site Scripting (XSS)**:
```
Bad: Unescaped user input in HTML
<div>{{ user_input }}</div>
Input: <img src=x onerror="alert('hacked')">
Result: Script executes

Good: Escape output
<div>{{ user_input | escape }}</div>
HTML entities: < becomes &lt;, > becomes &gt;
```

**8. Insecure Deserialization**:
```
Bad: Deserialize untrusted data
user = pickle.loads(user_data)  # Python
- Attacker can execute arbitrary code

Good:
- Use safe deserialization
- Validate data schema
- Whitelist allowed classes
```

**9. Using Components with Known Vulnerabilities**:
```
Bad:
- Old dependencies
- npm packages with vulnerabilities
- Ignoring security advisories

Good:
- Regular dependency updates
- Automated vulnerability scanning
- Security advisories reviewed
- Known vulnerabilities: don't use
```

**10. Insufficient Logging & Monitoring**:
```
Bad:
- No audit logs
- No alerts
- Slow incident detection

Good:
- Log all auth events
- Log privileged actions
- Alert on suspicious activity
- Monitor for intrusions
```

### 4.2 Secure Coding Practices

**Input Validation**:
```
Rule: Never trust user input

Validate:
1. Type (is it a number, email, etc?)
2. Length (within acceptable range?)
3. Format (matches expected pattern?)
4. Whitelist (only allowed values?)

Example:
def create_user(email, age):
  # Type validation
  if not isinstance(email, str) or not isinstance(age, int):
    raise ValueError()
  
  # Format validation
  if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
    raise ValueError("Invalid email")
  
  # Range validation
  if age < 18 or age > 120:
    raise ValueError("Invalid age")
  
  # Whitelist (database only allows specific domains)
  allowed_domains = ['company.com', 'partner.com']
  domain = email.split('@')[1]
  if domain not in allowed_domains:
    raise ValueError("Domain not allowed")
```

**Error Handling**:
```
Bad: Exposing implementation details
Error: Database connection failed: postgres://user:password@db.internal:5432/prod

Good: Generic error messages
Error: System error occurred. Please contact support.

Implementation:
try:
  result = database.query(sql)
except Exception as e:
  log_error(e)  # Log full error
  return "System error occurred"  # Return generic message
```

### 4.3 Dependency Management

**Vulnerability Scanning**:
```
npm audit
pip audit
gradle dependencyCheck

Identify:
- Packages with known vulnerabilities
- Severity level (critical, high, medium, low)
- Suggested fixes/upgrades

GitHub:
- Automated dependency scanning
- Automated security alerts
- Suggested pull requests
```

**Update Policy**:
```
Regular Schedule:
- Monthly: Check for updates
- Critical vulns: Patch within 24-48 hours
- High: Patch within 1-2 weeks
- Medium: Patch within 1 month

Testing:
- Run full test suite after update
- Automated CI/CD testing
- Staging environment testing
```

---

## Part 5: Cloud Security

### 5.1 Cloud-Specific Threats

**Misconfiguration**:
```
Common Issues:
- S3 bucket publicly readable
- Security group allows 0.0.0.0/0
- Unencrypted database
- IAM overly permissive

Prevention:
- Infrastructure as Code (Terraform, CloudFormation)
- Policy as Code (HashiCorp Sentinel)
- Cloud Security Posture Management (CSPM)
- Regular audits
```

**Identity & Access (IAM)**:
```
AWS IAM Best Practices:
1. Root account: MFA only, minimal use
2. Create IAM users: One per person
3. Use groups: Easier permission management
4. Least privilege: Minimum needed permissions
5. Regular audits: Remove unused permissions
6. Rotate keys: Every 90 days
7. MFA: All user accounts

Example Policy:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::my-bucket/public/*"
    }
  ]
}
```

**Container Security**:
```
Docker Best Practices:
1. Use official base images
2. Minimal base images (alpine)
3. Run as non-root user
4. Don't run privileged containers
5. Scan images for vulnerabilities
6. Sign images
7. Immutable tags

Kubernetes Security:
1. Network policies: Restrict traffic
2. RBAC: Role-based access control
3. Pod security policies: Enforce standards
4. Secrets encryption: Encrypt etcd
5. Regular scanning: Container vulnerability scanning
```

### 5.2 Threat Detection

**Cloud Security Monitoring**:
```
Monitor:
- API calls (CloudTrail)
- Network flows (VPC Flow Logs)
- Resource changes
- Unusual activities

Alert on:
- Root account usage
- Disabled MFA
- Policy changes
- Large data transfers
- Access from unusual locations
```

**Incident Response**:
```
1. Detection: Alert triggered
2. Investigation: Analyze logs
3. Containment: Limit damage
4. Remediation: Fix the issue
5. Recovery: Restore to normal
6. Post-mortem: Learn for future
```

---

## Part 6: Compliance & Governance

### 6.1 Audit Logging

**What to Log**:
```
Authentication:
- Login attempts (success/failure)
- MFA events
- Password changes
- Session creation/destruction

Authorization:
- Permission checks
- Access grants/denials
- Privilege escalation attempts

Data Access:
- Read operations on sensitive data
- Modifications to data
- Deletions

Administrative:
- Configuration changes
- User/role management
- Security policy changes
```

**Log Management**:
```
Centralized Logging:
- All logs → Central log store
- Searchable and queryable
- Long retention (1-3 years)
- Immutable (can't be modified)
- Encrypted

Tools:
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Splunk
- AWS CloudWatch
- Azure Monitor
```

### 6.2 Compliance Frameworks

**SOC 2 Type II**:
```
Security: Access controls, encryption
Availability: Uptime, redundancy
Processing Integrity: Accurate processing
Confidentiality: Data protection
Privacy: Compliance with regulations

Audit: Annual or semi-annual
```

**ISO 27001**:
```
Information Security Management System (ISMS)

Requirements:
- Information security policy
- Access control
- Cryptography
- Physical and environmental security
- Operations management
- Communications security
- System development security
- Incident management
- Business continuity
- Compliance monitoring
```

**Payment Card Industry (PCI)**:
```
For processing credit cards:

Requirements:
- Firewall configuration
- Default passwords changed
- Cardholder data protection
- Vulnerability scanning
- Access controls
- Regular monitoring
- Secure systems policy

Levels:
1: > 6 million transactions/year
2: 1-6 million transactions/year
3: 20,000-1 million transactions/year
4: < 20,000 transactions/year
```

### 6.3 Security Policies

**Password Policy**:
```
Requirements:
- Minimum 12 characters
- Must include: uppercase, lowercase, number, symbol
- Change if compromised
- Don't reuse previous 5 passwords
- Account lockout after 5 failed attempts
- Password history (prevent reuse)
```

**Data Retention**:
```
Customer data:
- Keep while customer active
- Keep 90 days after account deletion
- Then securely delete

Financial records:
- Keep 7 years (regulatory requirement)
- Encrypted storage
- Limited access
```

---

## Security Checklist

### Design Phase
- [ ] Threat model completed
- [ ] Security requirements defined
- [ ] Authentication method chosen
- [ ] Authorization model selected
- [ ] Encryption requirements defined
- [ ] Compliance requirements identified

### Development Phase
- [ ] Secure coding standards followed
- [ ] Code review includes security review
- [ ] SAST (Static code analysis) passed
- [ ] Dependency vulnerabilities: none critical
- [ ] OWASP Top 10 mitigations implemented
- [ ] Error handling doesn't expose details

### Testing Phase
- [ ] DAST (Dynamic security testing) passed
- [ ] Penetration testing completed
- [ ] Security test cases included
- [ ] Secrets management configured
- [ ] Rate limiting configured
- [ ] Logging configured

### Deployment Phase
- [ ] Security configs hardened
- [ ] TLS/HTTPS enforced
- [ ] Encryption enabled
- [ ] Access controls configured
- [ ] Monitoring and alerting enabled
- [ ] Incident response plan ready

### Operations Phase
- [ ] Security patches applied promptly
- [ ] Dependencies updated
- [ ] Logs monitored
- [ ] Alerts reviewed
- [ ] Access reviewed quarterly
- [ ] Annual security audit completed

---

## Related Resources

- [Security Patterns](../patterns/security-patterns.md)
- [API Design Guide](./api-design-guide.md)
- [Architecture Playbook](./architecture-playbook.md)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Contributors:** Architecture Practice Team
