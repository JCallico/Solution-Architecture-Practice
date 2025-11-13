# Security Architecture Template

## Purpose

The Security Architecture document defines all security controls, threat models, authentication/authorization mechanisms, and compliance requirements for the system.

---

## When to Use

- Designing security for new systems
- Assessing security posture of existing systems
- Planning security improvements
- Documenting compliance requirements
- Conducting security architecture reviews
- Responding to security incidents

---

## Executive Summary

Provide high-level security overview:

```
Security Strategy:
This system employs [defense in depth/zero trust/layered] approach 
combining [identity/encryption/network/data] controls to protect 
against [threat categories]. The architecture achieves [certification/standard] 
compliance and addresses [key regulatory requirements].

Key Controls:
- Identity: [Authentication method, MFA requirement]
- Encryption: [Algorithms, key management approach]
- Network: [Segmentation, DDoS protection]
- Data: [Classification, handling procedures]
- Compliance: [Standards achieved: SOC 2, ISO 27001, etc.]
```

---

## Section 1: Threat Model

Identify and assess threats to the system:

### 1.1 Asset Identification

```
Critical Assets:
- Asset: [Name]
  Value: [Confidentiality/Integrity/Availability criticality: H/M/L]
  Impact of breach: [Business impact if compromised]
  Current protection: [Current controls]

Example:
- Asset: Customer personal data (email, address, phone)
  Value: Confidentiality (H), Integrity (H), Availability (M)
  Impact: GDPR violation ($20M+), reputation damage
  Protection: Database encryption, access controls, audit logs

- Asset: Payment processing API
  Value: Integrity (H), Availability (H), Confidentiality (M)
  Impact: Fraudulent transactions, customer distrust
  Protection: PCI-DSS controls, rate limiting, monitoring
```

### 1.2 Threat Scenarios

```
Threat Matrix:
┌────────────────────┬────────┬────────┬──────────────────┐
│ Threat             │Likeli- │ Impact │ Current Control  │
│                    │hood    │        │ Effectiveness    │
├────────────────────┼────────┼────────┼──────────────────┤
│ SQL Injection       │ Medium │ High   │ Parameterized    │
│                    │        │        │ queries (90%)    │
├────────────────────┼────────┼────────┼──────────────────┤
│ DDoS Attack        │ Medium │ High   │ WAF, rate limit  │
│                    │        │        │ (80%)            │
├────────────────────┼────────┼────────┼──────────────────┤
│ Credential Theft   │ High   │ High   │ MFA, monitoring  │
│                    │        │        │ (85%)            │
├────────────────────┼────────┼────────┼──────────────────┤
│ Insider threat     │ Medium │ High   │ RBAC, audit logs │
│                    │        │        │ (75%)            │
├────────────────────┼────────┼────────┼──────────────────┤
│ Malware            │ Low    │ Medium │ EDR, scanning    │
│                    │        │        │ (95%)            │
└────────────────────┴────────┴────────┴──────────────────┘

Threat Scenarios:

Scenario 1: Compromised API Key
- Attacker: External attacker
- Attack vector: API key exposed in GitHub
- Impact: Unauthorized API access, data theft
- Likelihood: High (keys accidentally committed)
- Mitigation: Key rotation (90 days), vault storage, monitoring
- Detection: Abnormal API patterns, vault alerts
- Response: Immediate key revocation, incident investigation

Scenario 2: Insider Data Exfiltration
- Attacker: Disgruntled employee
- Attack vector: Export customer data before leaving
- Impact: GDPR violation, customer PII breach
- Likelihood: Medium (access control exists)
- Mitigation: DLP tools, data classification, access audits
- Detection: Bulk download detection, unusual query patterns
- Response: Disable access, investigate, notify customers

Scenario 3: Database Ransomware
- Attacker: External threat actor
- Attack vector: SQL injection → database compromise
- Impact: Service unavailability, data loss
- Likelihood: Low (parameterized queries)
- Mitigation: Backup strategy, air-gapped backups, monitoring
- Detection: Database activity monitoring, backup alerts
- Response: Restore from backup, investigate entry point
```

---

## Section 2: Authentication & Authorization

### 2.1 Authentication

```
Authentication Strategy:

┌─────────────────────┬──────────────┬─────────────────────┐
│ User Type           │ Method       │ MFA Requirement     │
├─────────────────────┼──────────────┼─────────────────────┤
│ Internal users      │ OIDC + OKTA  │ Required (TOTP/U2F) │
├─────────────────────┼──────────────┼─────────────────────┤
│ Customers (web)     │ Email/pass   │ Required for admins │
├─────────────────────┼──────────────┼─────────────────────┤
│ Customers (mobile)  │ Biometric    │ Native (built-in)   │
├─────────────────────┼──────────────┼─────────────────────┤
│ Service-to-service  │ mTLS + JWT   │ N/A (certificate)   │
├─────────────────────┼──────────────┼─────────────────────┤
│ API consumers       │ API key +    │ Optional (for admin)│
│ (partners)          │ OAuth 2.0    │                     │
└─────────────────────┴──────────────┴─────────────────────┘

Password Policy:
- Minimum length: 12 characters (14 for admins)
- Complexity: 3/4 of (uppercase, lowercase, numbers, symbols)
- Expiration: No expiration (discouraged by NIST)
- Reuse prevention: Last 5 passwords cannot be reused
- Account lockout: 5 failed attempts → 30 minute lockout
- MFA: Mandatory for admin and PII access

Session Management:
- Session timeout: 30 minutes of inactivity
- Absolute timeout: 8 hours (administrative access)
- Session fixation prevention: New session after login
- Concurrent sessions: Max 3 per user
- HTTPS only: Secure flag, HttpOnly flag on cookies

Code Example (Node.js with Passport):
```javascript
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  
  // Validate input
  if (!email || !password) {
    return res.status(400).json({ error: 'Missing credentials' });
  }
  
  // Hash verification (bcrypt)
  const user = await User.findByEmail(email);
  if (!user || !await bcrypt.compare(password, user.passwordHash)) {
    // Log failed attempt (no user enumeration)
    logger.warn('failed_login', { email });
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  // Check MFA requirement
  if (user.requiresMFA && !req.session.mfaVerified) {
    // Send MFA challenge
    const mfaToken = generateTemporaryToken(user.id, '5m');
    return res.status(202).json({ mfaRequired: true, mfaToken });
  }
  
  // Create session with security headers
  req.session.userId = user.id;
  req.session.loginTime = Date.now();
  req.session.cookie.secure = true;      // HTTPS only
  req.session.cookie.httpOnly = true;    // No JavaScript access
  req.session.cookie.sameSite = 'strict'; // CSRF protection
  
  // Rotate session ID
  req.session.regenerate((err) => {
    if (err) return res.status(500).json({ error: 'Session error' });
    res.json({ success: true, redirectUrl: '/dashboard' });
  });
});
```
```

### 2.2 Authorization

```
Authorization Model:

RBAC (Role-Based Access Control):
┌──────────────────┬──────────────┬────────────────────┐
│ Role             │ Permissions  │ Scope              │
├──────────────────┼──────────────┼────────────────────┤
│ Admin            │ All          │ All resources      │
├──────────────────┼──────────────┼────────────────────┤
│ Manager          │ CRUD users   │ Own team only      │
│ (Department)     │ Read reports │ Own department     │
├──────────────────┼──────────────┼────────────────────┤
│ Analyst          │ Read data    │ Own team data      │
│ (Team)           │ Run queries  │ Pre-approved       │
├──────────────────┼──────────────┼────────────────────┤
│ Viewer           │ Read         │ Public dashboards  │
├──────────────────┼──────────────┼────────────────────┤
│ API consumer     │ Specific ops │ API operations     │
│ (Partner)        │              │ per contract       │
└──────────────────┴──────────────┴────────────────────┘

Attribute-Based Access Control (ABAC) Rules:
```
resource: customer_data
action: read
condition: (user.role == "analyst") AND
           (user.department == resource.owner_dept) AND
           (resource.classification != "confidential") OR
           (user.role == "admin")
```

Access Control Enforcement:
- Authorization checked on every API request
- Use middleware/interceptors for consistent enforcement
- Fail closed (deny by default)
- Audit all access control decisions
- Regular access review (quarterly)

Code Example (Node.js with ABAC):
```javascript
const canAccessCustomer = async (userId, customerId) => {
  const user = await User.findById(userId);
  const customer = await Customer.findById(customerId);
  
  // Admin bypass (with audit logging)
  if (user.role === 'admin') {
    logger.info('admin_access', { userId, customerId });
    return true;
  }
  
  // Department manager can access own department
  if (user.role === 'manager') {
    return user.department === customer.department;
  }
  
  // Analysts can access own team's customers
  if (user.role === 'analyst') {
    return user.teamId === customer.teamId;
  }
  
  // Default deny
  logger.warn('access_denied', { userId, customerId, role: user.role });
  return false;
};

// Middleware enforcement
app.get('/customers/:id', authorize(canAccessCustomer), (req, res) => {
  // Handler code
});
```
```

---

## Section 3: Data Protection

### 3.1 Encryption at Rest

```
Data Classification:
┌────────────────┬─────────────┬──────────────┬──────────────┐
│ Classification │ Encryption  │ Key Rotation │ Access Logs  │
├────────────────┼─────────────┼──────────────┼──────────────┤
│ Public         │ Optional    │ Annual       │ No           │
├────────────────┼─────────────┼──────────────┼──────────────┤
│ Internal       │ Mandatory   │ 90 days      │ Sampling     │
│                │ (AES-256)   │              │ (10%)        │
├────────────────┼─────────────┼──────────────┼──────────────┤
│ Sensitive      │ Mandatory   │ 30 days      │ All access   │
│ (PII, PHI)     │ (AES-256)   │ + HSM        │ + alerting   │
├────────────────┼─────────────┼──────────────┼──────────────┤
│ Secrets        │ Mandatory   │ 14 days      │ All access   │
│ (API keys)     │ (AES-256)   │ + HSM        │ + alerting   │
└────────────────┴─────────────┴──────────────┴──────────────┘

Encryption Implementation:
- Database encryption: TDE (Transparent Data Encryption)
- Backup encryption: Separate key from database
- Field-level encryption: Sensitive fields encrypted at application
- Key management: CloudHSM or AWS KMS
- Key access: Restricted to application service account

Example - Encrypted field in database:
```sql
-- Column encryption (SQL Server example)
CREATE TABLE customers (
  id INT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  ssn_encrypted VARBINARY(128) ENCRYPTED WITH (
    ENCRYPTION_TYPE = DETERMINISTIC,
    ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256',
    COLUMN_ENCRYPTION_KEY = CEK1
  ),
  created_at DATETIME DEFAULT GETDATE()
);

-- Application decryption
SELECT id, email, DECRYPTBYKEY(ssn_encrypted) AS ssn
FROM customers
WHERE id = @customerId;
```

Application-Level Encryption (Node.js):
```javascript
const crypto = require('crypto');

class DataEncryption {
  constructor(masterKey) {
    this.masterKey = Buffer.from(masterKey, 'base64');
  }
  
  encrypt(plaintext) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv('aes-256-cbc', this.masterKey, iv);
    
    let encrypted = cipher.update(plaintext, 'utf-8', 'hex');
    encrypted += cipher.final('hex');
    
    // Return IV + ciphertext
    return iv.toString('hex') + ':' + encrypted;
  }
  
  decrypt(encryptedData) {
    const [iv, encrypted] = encryptedData.split(':');
    const decipher = crypto.createDecipheriv(
      'aes-256-cbc',
      this.masterKey,
      Buffer.from(iv, 'hex')
    );
    
    let plaintext = decipher.update(encrypted, 'hex', 'utf-8');
    plaintext += decipher.final('utf-8');
    
    return plaintext;
  }
}

// Usage
const encryption = new DataEncryption(process.env.ENCRYPTION_KEY);
const encrypted = encryption.encrypt(customer.ssn);
await db.save({ ssn: encrypted });
```
```

### 3.2 Encryption in Transit

```
Network Security:
- HTTPS/TLS 1.2+ (TLS 1.3 preferred) for all external communication
- Certificate pinning for mobile apps
- OCSP stapling for certificate validation
- Perfect forward secrecy (ECDHE cipher suites)

Service-to-Service Communication:
- mTLS (mutual TLS) required
- Certificate rotation every 90 days
- Short-lived certificates (< 1 day) for workloads in Kubernetes

Configuration (NGINX example):
```nginx
server {
    listen 443 ssl http2;
    ssl_certificate /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/private/server.key;
    
    # TLS 1.2+ only
    ssl_protocols TLSv1.2 TLSv1.3;
    
    # Strong cipher suites with PFS
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000" always;
    
    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    
    # Certificate pinning (for APIs)
    add_header Public-Key-Pins "pin-sha256=...";
}
```
```

---

## Section 4: Network Security

```
Network Architecture:

┌──────────────────────────────────────┐
│        Internet / Users               │
└────────────────┬─────────────────────┘
                 │
        ┌────────▼────────┐
        │  WAF / DDoS      │ (CloudFlare)
        │  Protection      │
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │  API Gateway     │ (Authentication,
        │  (Kong/Nginx)    │  Rate limiting)
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
   ▼            ▼            ▼
┌────────┐ ┌────────┐ ┌────────┐
│Service1│ │Service2│ │Service3│
│(Private)│ │(Private)│ │(Private)│
└───┬────┘ └───┬────┘ └───┬────┘
    │          │          │
    └──────────┼──────────┘
               │
          ┌────▼────┐
          │Databases│
          │(Private)│
          └─────────┘

Network Controls:
- Public: WAF, DDoS protection, API Gateway
- Restricted: Service mesh with mTLS
- Private: No internet access

VPC Security Groups (AWS):
- Ingress: Only API Gateway on port 443
- Egress: Only to internal services + external APIs
- Database: Only from application services
- Management: Bastion host access only
```

---

## Section 5: API Security

```
API Security Controls:

┌──────────────────────────────────────┐
│ 1. API Key Management                 │
├──────────────────────────────────────┤
│ - Keys stored in vault, never logged  │
│ - Automatic rotation every 30 days    │
│ - Revocation immediate               │
│ - Rate limiting per key: 1000 req/hr │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ 2. Rate Limiting & Throttling        │
├──────────────────────────────────────┤
│ - Global: 10,000 req/minute          │
│ - Per API key: 1,000 req/minute      │
│ - Per IP (unauthenticated): 100 req  │
│ - Burst allowance: 20% over limit    │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ 3. Input Validation                  │
├──────────────────────────────────────┤
│ - Schema validation (JSON Schema)    │
│ - Type checking and ranges           │
│ - SQL injection prevention           │
│ - XSS prevention (output encoding)   │
│ - CSRF tokens for state-changing ops │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ 4. Error Handling                    │
├──────────────────────────────────────┤
│ - No sensitive info in error msgs    │
│ - Stack traces only in dev env       │
│ - Unique error request IDs           │
│ - Error logging for investigation    │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ 5. CORS Configuration                │
├──────────────────────────────────────┤
│ - Explicit whitelist of origins      │
│ - No wildcard for credentials        │
│ - Limited HTTP methods allowed       │
│ - Preflight checks enabled           │
└──────────────────────────────────────┘

Code Example (Express.js):
```javascript
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const cors = require('cors');

// Rate limiting
const apiLimiter = rateLimit({
  windowMs: 60 * 1000,      // 1 minute
  max: 100,                 // 100 requests per window
  keyGenerator: (req) => req.apiKey || req.ip, // Rate limit by API key
  handler: (req, res) => {
    res.status(429).json({ error: 'Too many requests' });
  }
});

// CORS configuration
app.use(cors({
  origin: ['https://app.example.com', 'https://www.example.com'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT'],
  maxAge: 3600
}));

// Security headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"]
    }
  }
}));

// Input validation
const validateRequest = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }
    req.validated = value;
    next();
  };
};

// Rate limiting
app.use('/api/', apiLimiter);

// Endpoint with validation
const createOrderSchema = Joi.object({
  customerId: Joi.number().integer().required(),
  items: Joi.array().items(
    Joi.object({
      productId: Joi.number().required(),
      quantity: Joi.number().integer().min(1).required()
    })
  ).required()
});

app.post('/api/orders', validateRequest(createOrderSchema), (req, res) => {
  // Handler code - input is validated
});
```
```

---

## Section 6: Compliance & Standards

```
Compliance Requirements:

┌──────────────┬──────────────┬────────────┐
│ Standard     │ Applicability│ Requirements
├──────────────┼──────────────┼────────────┤
│ GDPR         │ EU users     │ Data right
│              │              │ Privacy by
│              │              │ design, DPA
├──────────────┼──────────────┼────────────┤
│ PCI-DSS      │ Payment data │ No storing
│              │              │ card numbers
│              │              │ Encryption
├──────────────┼──────────────┼────────────┤
│ SOC 2 Type II│ Customers    │ Security
│              │ require it   │ monitoring
│              │              │ Audit trail
├──────────────┼──────────────┼────────────┤
│ HIPAA        │ Health data  │ Encryption
│              │              │ Access logs
│              │              │ Business
│              │              │ Associate
│              │              │ Agreement
└──────────────┴──────────────┴────────────┘

GDPR Compliance:
- Data subject rights: Export, deletion, correction
- Consent management: Explicit opt-in, tracking
- Data retention: Delete after 30 days inactivity
- DPA with processors: Required for cloud services
- Breach notification: 72 hours to regulators
- Privacy impact assessment: For new processing

Implementation:
```python
class GDPRCompliance:
    def export_user_data(self, user_id):
        """Export all personal data in machine-readable format"""
        user = User.get(user_id)
        orders = Order.find_by_user(user_id)
        payments = Payment.find_by_user(user_id)
        
        data = {
            'profile': user.to_dict(),
            'orders': [o.to_dict() for o in orders],
            'payments': [p.to_dict() for p in payments]
        }
        
        # Return as JSON
        return json.dumps(data)
    
    def delete_user_data(self, user_id):
        """Delete all personal data (right to be forgotten)"""
        # Anonymize PII
        user = User.get(user_id)
        user.update({
            'email': f'deleted_{user.id}@example.com',
            'phone': None,
            'address': None
        })
        
        # Log for audit trail
        audit_log('user_deleted', {'user_id': user_id})
```
```

---

## Section 7: Security Controls Summary

```
Control Categories:

Access Control:
- ✓ Least privilege principle applied
- ✓ MFA mandatory for sensitive access
- ✓ Regular access reviews (quarterly)
- ✓ Privileged access management (PAM)

Data Protection:
- ✓ Encryption at rest (AES-256)
- ✓ Encryption in transit (TLS 1.2+)
- ✓ Key rotation policy
- ✓ DLP (Data Loss Prevention)

Network Security:
- ✓ WAF (Web Application Firewall)
- ✓ DDoS protection
- ✓ VPC segmentation
- ✓ Network monitoring

Application Security:
- ✓ Input validation
- ✓ Output encoding
- ✓ CSRF protection
- ✓ Security headers (CSP, HSTS, etc.)

Monitoring & Detection:
- ✓ SIEM (Security Information Event Management)
- ✓ Intrusion detection
- ✓ Security audit logs
- ✓ Alerting for anomalies

Incident Response:
- ✓ Incident response plan
- ✓ On-call security team
- ✓ Forensics capability
- ✓ Communication procedures

Vulnerability Management:
- ✓ Regular security scanning
- ✓ Dependency vulnerability checking
- ✓ Penetration testing (annual)
- ✓ Bug bounty program
```

---

## Section 8: Security Checklist

```
Design Review:
☐ Threat model completed
☐ Assets identified and classified
☐ Attack vectors identified
☐ Risk levels assigned
☐ All significant risks mitigated

Authentication:
☐ Strong authentication required
☐ MFA enabled for sensitive users
☐ Session management secure
☐ Password policy strong

Authorization:
☐ RBAC/ABAC implemented
☐ Least privilege enforced
☐ Regular access reviews
☐ Audit logging enabled

Data Protection:
☐ Encryption at rest implemented
☐ Encryption in transit enforced
☐ Key management secure
☐ Data classification applied
☐ PII handling procedures defined

Network Security:
☐ Network segmentation implemented
☐ WAF/DDoS protection configured
☐ Rate limiting enabled
☐ Network monitoring active

API Security:
☐ API key rotation implemented
☐ Rate limiting configured
☐ Input validation enforced
☐ Error handling secure
☐ CORS configured

Compliance:
☐ Compliance requirements mapped
☐ Controls implemented for each requirement
☐ Audit trail enabled
☐ Regular audits scheduled
☐ Compliance testing planned

Incident Response:
☐ Incident response plan documented
☐ On-call team established
☐ Communication procedures defined
☐ Recovery procedures tested
☐ Post-incident reviews enabled
```

---

## Related Resources

- [Security Guide](../knowledge-base/playbooks/security-guide.md)
- [Security Patterns](../knowledge-base/patterns/security-patterns.md)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Contributors:** Architecture Practice Team
