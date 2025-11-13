# Security Patterns

## Overview

Security patterns address authentication, authorization, data protection, and application security. These patterns help build systems that protect against common threats while maintaining usability.

---

## Authentication Patterns

### 1. Single Sign-On (SSO)

**Problem:** Users need to authenticate to multiple applications.

**Solution:** Central authentication service handles login for all applications.

```
User → Application A → Redirect to SSO
           ↓
       SSO Provider (authenticate)
           ↓
       Redirect with token back to App A
           ↓
       User accesses App A with token

Later: User visits Application B
       → App B checks SSO → Already authenticated
       → User accesses App B without login
```

**Benefits:**
- Single credential management
- Better user experience
- Centralized security policy

**Implementation:** SAML, OAuth 2.0, OpenID Connect

---

### 2. Multi-Factor Authentication (MFA)

**Problem:** Passwords alone are insufficient for sensitive systems.

**Solution:** Require multiple verification factors.

```
Factors:
1. Something you know (password)
2. Something you have (phone, hardware key)
3. Something you are (biometric)
4. Somewhere you are (location)

Typical MFA: Password + TOTP code from authenticator app
```

**When to use:**
- Admin/privileged access
- Financial systems
- Healthcare systems
- Sensitive data access

---

### 3. Token-Based Authentication

**Problem:** Server-side session storage doesn't scale across distributed systems.

**Solution:** Client holds token containing identity information.

```
Login Flow:
1. POST /login {username, password}
2. Server validates, returns JWT token
3. Client stores token (localStorage, cookie)
4. Client sends token with each request in Authorization header

Token Validation:
Server verifies token signature without database lookup
```

**Benefits:**
- Stateless (scales horizontally)
- Mobile-friendly
- Cross-domain

**Implementation:** JWT (JSON Web Tokens)

---

### 4. Federated Identity

**Problem:** Organizations need to trust external identity providers.

**Solution:** Accept identity assertions from trusted external providers.

```
User logs in with Corporate ID
       ↓
Corporate Identity Provider issues SAML assertion
       ↓
Application trusts assertion
       ↓
User granted access
```

---

## Authorization Patterns

### 5. Role-Based Access Control (RBAC)

**Problem:** Managing permissions for individual users doesn't scale.

**Solution:** Assign users to roles, roles have permissions.

```
Users → Roles → Permissions

Roles:
- Admin: read, write, delete, manage
- Editor: read, write
- Viewer: read

Example:
User "john" has role "Editor"
→ john can read and write documents
```

**When to use:**
- Simple permission hierarchy
- Well-defined roles
- Most organizations

---

### 6. Attribute-Based Access Control (ABAC)

**Problem:** RBAC doesn't handle complex authorization rules.

**Solution:** Use attributes of user, resource, and context to make decisions.

```
Rule: A user can read a document if:
- User.department == Document.owner_department AND
- Document.classification != "confidential" OR
- User.role == "admin"

Attributes:
- User: role, department, clearance_level, location
- Resource: owner, classification, sensitivity
- Context: time, IP address, network_location
```

**When to use:**
- Complex authorization rules
- Attributes change frequently
- Fine-grained control needed

---

## Data Protection Patterns

### 7. Encryption at Rest

**Problem:** Stolen databases expose sensitive data.

**Solution:** Encrypt data stored on disk.

```
Database Encryption:
- Transparent Database Encryption (TDE)
- Column-level encryption
- Field-level encryption

Key Management:
- Store keys in HSM (Hardware Security Module)
- Separate from data
- Access logging
```

---

### 8. Encryption in Transit

**Problem:** Data intercepted on network.

**Solution:** Encrypt data as it travels over network.

```
HTTPS/TLS:
- Encrypt all external communication
- TLS 1.2 minimum, 1.3 preferred
- Certificate management
- Certificate pinning for mobile

Service-to-Service:
- mTLS (mutual TLS)
- Client and server certificates
- Network policies
```

---

### 9. Secrets Management

**Problem:** API keys, passwords scattered in code/configs.

**Solution:** Centralized vault for sensitive credentials.

```
Vault:
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault

Access:
- API for applications to request secrets
- Audit logging
- Automatic rotation
- Temporary credentials
```

---

## Application Security Patterns

### 10. Input Validation

**Problem:** Malicious input can cause injection attacks.

**Solution:** Validate and sanitize all input.

```
Validation Levels:
1. Type checking (string, number, email)
2. Format validation (regex patterns)
3. Range checking (min/max length, values)
4. Business rule validation

Example:
email: must be valid email format
age: must be integer, 0-150
username: must be alphanumeric, 3-20 chars
```

---

### 11. Output Encoding

**Problem:** Unescaped data in HTML causes XSS attacks.

**Solution:** Encode output based on context.

```
Contexts:
- HTML: Escape <, >, &, ", '
- JavaScript: Escape quotes, newlines
- URL: Percent-encode special chars
- CSS: Escape special characters

Example:
User input: <script>alert('xss')</script>
Output HTML: &lt;script&gt;alert('xss')&lt;/script&gt;
Renders as text, not executed
```

---

### 12. Parameterized Queries

**Problem:** String concatenation in SQL causes injection.

**Solution:** Use parameterized queries or prepared statements.

```
WRONG - vulnerable to injection:
query = "SELECT * FROM users WHERE email = '" + email + "'"
// If email = "' OR '1'='1", bypasses check

RIGHT - safe:
query = "SELECT * FROM users WHERE email = ?"
execute(query, [email])
// Parameter safely escaped
```

---

### 13. Security Headers

**Problem:** Browsers don't protect against modern attacks without guidance.

**Solution:** HTTP headers tell browser how to behave.

```
Content-Security-Policy: default-src 'self'
  → Only load resources from same origin

Strict-Transport-Security: max-age=31536000
  → Always use HTTPS

X-Content-Type-Options: nosniff
  → Don't guess MIME types

X-Frame-Options: DENY
  → Prevent clickjacking

X-XSS-Protection: 1; mode=block
  → Enable XSS filter
```

---

### 14. CSRF Protection

**Problem:** Attacker tricks user into making unwanted request.

**Solution:** Require token in state-changing requests.

```
GET /form
  → Server generates CSRF token
  → Token included in form as hidden field

POST /action
  → Client sends CSRF token from form
  → Server verifies token matches session
  → Only if match, allow action
```

---

## Network Security Patterns

### 15. Zero Trust

**Problem:** Perimeter security doesn't work with cloud/remote workers.

**Solution:** Never trust, always verify. Verify every request regardless of source.

```
Principles:
- Authenticate every user and device
- Authorize based on identity + attributes
- Encrypt all communication
- Verify security posture
- Monitor continuously
```

---

## References

- [OWASP](https://owasp.org/)
- [Security Patterns](https://www.securitypatternsdb.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Zero Trust Architecture](https://www.nist.gov/publications/zero-trust-architecture)

### Network Security
- Zero Trust Network
- Network Segmentation
- DMZ Architecture
- Web Application Firewall (WAF)
- DDoS Protection
- API Gateway Security

### Monitoring & Detection
- Security Information and Event Management (SIEM)
- Intrusion Detection System (IDS)
- Intrusion Prevention System (IPS)
- Audit Logging
- Anomaly Detection

## Related Resources

- [Security Guide](../playbooks/security-guide.md)
- [Well-Architected Framework](../../frameworks/well-architected.md)
- [Reference Architecture: API Platform](../reference-architectures/api-platform.md)

---

**Status:** Placeholder  
**Last Updated:** November 2025
