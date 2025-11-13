# Quality Gates

## Overview

Quality gates are automated and manual checkpoints that enforce quality standards throughout the development and deployment lifecycle. They prevent low-quality code, non-compliant architecture, and unsafe deployments from reaching production.

**Core Principle:** Fail fast and fix early - quality issues caught at the gate are less expensive than issues discovered in production.

## Quality Gates Framework

### Three-Level Approach

```
Development Quality Gates
        ↓
Architecture Quality Gates
        ↓
Deployment Quality Gates
```

## Development Quality Gates

### Gate 1: Pre-Commit Code Quality

**Trigger:** Developer attempts to commit code

**Automated Checks:**
- [ ] Code formatting compliance (linting)
- [ ] Syntax validation
- [ ] No hardcoded credentials or secrets
- [ ] No large files (>10MB) committed
- [ ] Branch naming convention compliance

**Tools:**
- `pre-commit` hooks
- `husky` for Git hooks
- ESLint / Prettier (JavaScript/TypeScript)
- pylint / black (Python)
- Similar tools for other languages

**Failure Action:** Commit blocked until issues resolved
**Bypass:** Senior engineer approval (logged and tracked)

### Gate 2: Pull Request Code Review

**Trigger:** Pull request opened

**Manual Checks:**
- [ ] Code follows coding standards
- [ ] Design patterns applied correctly
- [ ] Tests written for all new code
- [ ] No obvious bugs or security issues
- [ ] Documentation updated
- [ ] Comments explaining complex logic

**Automated Checks:**
```
✓ Linting passed
✓ Unit tests pass (100% pass rate)
✓ Code coverage ≥ 80% for new code
✓ No critical or high-severity vulnerabilities
✓ No deprecated functions used
✓ Performance impact acceptable
✓ Backward compatibility maintained (if applicable)
```

**Decision Criteria:**
- Minimum 2 approvals required
- All conversations resolved
- All status checks passing
- No changes requested from critical reviewers

**Merge Rules:**
- Squash commits to keep history clean
- Branch deleted after merge
- Commit message follows format: `[TICKET] Brief summary - detailed explanation`

**Failure Action:** PR blocked until requirements met

### Gate 3: Build and Unit Test

**Trigger:** After merge to main/release branches

**Automated Checks:**
```
✓ Build succeeds (no compilation errors)
✓ All unit tests pass (100% pass rate)
✓ Code coverage ≥ 85% (increasing over time)
✓ No new code smell violations
✓ Performance not degraded > 5% vs baseline
✓ Dependency vulnerabilities scanned
✓ No breaking API changes (if library)
✓ Version bump appropriate (for releases)
```

**Tools:**
- CI/CD pipeline (GitHub Actions, Jenkins, GitLab CI)
- Test coverage reporting (Codecov, Sonarqube)
- Build performance tracking
- Dependency scanning (Snyk, Dependabot)

**Timing:** Must complete within 15 minutes
**Failure Action:** Build marked as failed, notifications sent to team, commit tagged as problematic
**Recovery:** Developer fixes and pushes new commit - build re-triggered automatically

### Code Quality Metrics

**Sonarqube Integration:**
```
Quality Gate Status: PASS/FAIL

Required Metrics:
├── Code Coverage: ≥ 85%
├── Duplicated Lines: < 3%
├── Maintainability Rating: A
├── Reliability Rating: A
├── Security Rating: A
├── Security Hotspots: 0 critical
└── Technical Debt Ratio: < 5%
```

**Fail Criteria:**
- Coverage drops below threshold
- New security hotspots introduced
- Complexity increases dramatically (>15 for cyclomatic)
- Code smell density > 1 per 100 lines
- High-priority issues introduced

## Quality Gate Framework

### Pre-Development Gate

**Purpose:** Ensure proposed architecture meets quality standards before implementation begins

**Triggers:** Before starting new development on significant features or systems

**Checks:**

**Architectural Quality:**
- [ ] Architecture design complete (high-level design doc)
- [ ] Architecture pattern selected and justified
- [ ] Scalability analysis completed (capacity planning)
- [ ] Dependency analysis completed
- [ ] Security architecture reviewed
- [ ] Operational requirements documented

**Compliance & Governance:**
- [ ] Relevant standards and policies identified
- [ ] Security and compliance requirements documented
- [ ] Data privacy requirements addressed
- [ ] Regulatory requirements identified (if applicable)

**Technical Readiness:**
- [ ] Technology stack selected and approved
- [ ] Build/deployment approach documented
- [ ] Testing strategy defined
- [ ] Monitoring and observability strategy defined

**Ownership:**
- [ ] Clear owner assigned
- [ ] Team readiness assessed
- [ ] Skill gaps identified
- [ ] Training plan in place (if needed)

**Gate Decision:**
- ✅ **Proceed:** All checks passed, can start development
- ⚠️ **Conditional Proceed:** Minor gaps, proceed with conditions/mitigations
- ❌ **Stop:** Major gaps, must be addressed before proceeding

### Pre-Integration Gate

**Purpose:** Verify code quality before merging to main/development branch

**Triggers:** Before every pull request merge

**Automated Checks (must pass):**
- [ ] All unit tests passing (100% of touched code)
- [ ] Code compiles without errors
- [ ] No security vulnerabilities (< critical threshold)
- [ ] Test coverage maintained (> 80%)
- [ ] Code style and linting (0 critical violations)
- [ ] No dependency vulnerabilities
- [ ] Peer code review approved (≥ 1 reviewer)

**Manual Checks (before merge):**
- [ ] Code changes follow patterns and standards
- [ ] Architecture consistency maintained
- [ ] Performance impact assessed (if applicable)
- [ ] Documentation updated
- [ ] Backward compatibility maintained (if applicable)

**Gate Tool:** GitHub/GitLab status checks (automated enforcement)

**Gate Decision:**
- ✅ **Approve:** All checks passed, merge approved
- ⚠️ **Approve with Caution:** Checks passed but reviewer has concerns
- ❌ **Reject:** Checks failed or major concerns, fix and resubmit

### Pre-Staging Gate

**Purpose:** Verify system readiness before deploying to production-like environment

**Triggers:** Before deployment to staging for major releases

**Checks:**

**Functional Quality:**
- [ ] All acceptance criteria met
- [ ] Integration tests passing (100% success)
- [ ] End-to-end tests passing (100% success)
- [ ] No critical or high defects open
- [ ] Performance testing completed (if applicable)
- [ ] Accessibility testing completed (if applicable)

**Operational Readiness:**
- [ ] Deployment runbook documented and tested
- [ ] Monitoring and alerting configured
- [ ] Incident response procedures in place
- [ ] Rollback procedure documented and tested
- [ ] On-call support staffed
- [ ] Logging configured and validated

**Security & Compliance:**
- [ ] Security testing completed
- [ ] Vulnerability scan results reviewed
- [ ] Compliance requirements verified
- [ ] Data protection measures verified
- [ ] Access controls validated

**Documentation:**
- [ ] Release notes prepared
- [ ] User documentation updated (if applicable)
- [ ] API documentation updated
- [ ] Known issues documented
- [ ] Migration guide prepared (if applicable)

**Team Readiness:**
- [ ] Team trained on changes
- [ ] Support procedures prepared
- [ ] Communication plan finalized
- [ ] Escalation procedures in place

**Gate Decision:**
- ✅ **Ready for Staging:** All checks passed
- ⚠️ **Ready with Caveats:** Checks passed with known limitations
- ❌ **Not Ready:** Major gaps, must be addressed before staging

**Gate Authority:** QA Lead + Product Manager + Technical Lead

### Pre-Production Gate

**Purpose:** Final verification before deploying to production

**Triggers:** Before production deployment

**Checks:**

**All Pre-Staging Checks Must Still Be Passing:**
- [ ] All staging tests successful
- [ ] Performance benchmarks met
- [ ] Staging validation complete
- [ ] No production-environment-specific blockers

**Production-Specific Checks:**
- [ ] Capacity planning verified (infrastructure ready)
- [ ] Canary or blue-green deployment plan confirmed
- [ ] Automated rollback procedure tested
- [ ] Database migration script tested (if applicable)
- [ ] Infrastructure and configuration verified
- [ ] Load balancing and routing validated
- [ ] DNS and CDN configuration verified
- [ ] Third-party integrations verified

**Go/No-Go Checklist:**
- [ ] No critical defects open
- [ ] All blockers resolved
- [ ] Rollback plan ready and tested
- [ ] On-call team briefed
- [ ] Leadership approval obtained
- [ ] Deployment window confirmed
- [ ] Communication plan activated
- [ ] Monitoring and alerting validated

**Deployment Criteria:**
- [ ] No critical or high severity issues
- [ ] Performance metrics within acceptable range
- [ ] All stakeholders ready
- [ ] Success metrics defined
- [ ] Rollback criteria defined

**Gate Authority:** VP Engineering + VP Infrastructure + VP Architecture

**Gate Decision:**
- ✅ **Approved for Production:** All checks passed, proceed with deployment
- ⚠️ **Conditional Approval:** Checks passed with mitigations in place
- ⛔ **Hold:** Issues found, must be resolved before deployment
- ❌ **Reject:** Major blockers, cancel this deployment attempt

### Post-Production Gate

**Purpose:** Verify production deployment is successful and stable

**Triggers:** Immediately after production deployment

**Checks (First 4 Hours):**
- [ ] Deployment successful (0 errors)
- [ ] Application responding to requests
- [ ] Error rates normal (< baseline)
- [ ] Latency normal (< baseline)
- [ ] No critical alerts firing
- [ ] Database operations normal
- [ ] External integrations functioning
- [ ] User reports positive (no issues reported)

**Checks (First 24 Hours):**
- [ ] All metrics within normal range
- [ ] No abnormal traffic patterns
- [ ] Performance acceptable
- [ ] Data integrity verified
- [ ] All features functioning
- [ ] User experience acceptable
- [ ] No critical issues reported

**Stabilization Criteria:**
- [ ] 24+ hours with no critical issues
- [ ] Rollback no longer needed
- [ ] Celebration and communication
- [ ] Issues documented for retrospective

**Gate Authority:** On-call Engineer + QA

**Gate Decision:**
- ✅ **Successful:** Deployment stable and working well
- ⚠️ **Qualified Success:** Working but with minor issues being addressed
- 🔄 **Partial Rollback:** Some components rolled back, investigation ongoing
- ❌ **Full Rollback:** Critical issues, complete rollback executed

## Quality Gate Metrics

### Code Quality Metrics

| Metric | Target | Tool |
|--------|--------|------|
| **Test Coverage** | > 80% | SonarQube, CodeCov |
| **Code Duplication** | < 5% | SonarQube |
| **Cyclomatic Complexity** | < 10 per method | SonarQube |
| **Code Style Violations** | 0 critical | ESLint, Checkstyle |
| **Security Issues** | 0 critical, <5 high | SonarQube, Snyk |
| **Dependency Vulnerabilities** | 0 critical | Snyk, Dependabot |
| **Code Review Approval** | Required | GitHub |

### Testing Metrics

| Metric | Target | Notes |
|--------|--------|-------|
| **Unit Test Pass Rate** | 100% | All unit tests |
| **Integration Test Pass Rate** | 100% | All integration tests |
| **E2E Test Pass Rate** | 100% | All functional tests |
| **Test Execution Time** | < 5 min | For quick feedback |
| **Defect Escape Rate** | < 2% | Defects escaping to production |

### Performance Metrics

| Metric | Target | Tools |
|--------|--------|-------|
| **P99 Latency** | Within SLA | APM tools |
| **Throughput** | > baseline | Load testing |
| **Error Rate** | < 0.1% | Monitoring |
| **Resource Utilization** | < 80% | Infrastructure monitoring |

### Security Metrics

| Metric | Target | Assessment |
|--------|--------|-----------|
| **Security Scan Completion** | 100% | Before release |
| **Critical Vulnerabilities** | 0 | Must fix before release |
| **High Vulnerabilities** | < 5 | May proceed with plan |
| **Medium Vulnerabilities** | No limit | Can accept with justification |
| **OWASP Top 10 Coverage** | 100% | Testing coverage |

## Automated Quality Gates

### CI/CD Pipeline Gates

**In GitHub/GitLab CI/CD pipeline:**

```yaml
quality-gates:
  unit-tests:
    command: npm test
    pass-criteria: 100% pass, >80% coverage
    fail-action: block-merge
    
  lint-check:
    command: npm run lint
    pass-criteria: 0 critical violations
    fail-action: block-merge
    
  security-scan:
    command: npm audit
    pass-criteria: 0 critical, <5 high
    fail-action: block-merge
    
  dependency-check:
    command: snyk test
    pass-criteria: 0 critical vulnerabilities
    fail-action: block-merge
    
  code-quality:
    command: sonarqube scan
    pass-criteria: Coverage >80%, Debt <10%
    fail-action: block-merge
    
  build:
    command: npm run build
    pass-criteria: Build succeeds
    fail-action: block-merge
```

**Gate Enforcement:**
- Automated checks run on every commit
- Must pass before human review
- Cannot merge if gates fail
- Developer notified immediately of failures

### Automated Deployment Gates

**In deployment pipeline:**

```
Staging Deployment
  ↓ (all tests pass)
Automated Smoke Tests
  ↓ (smoke tests pass)
Performance Validation
  ↓ (performance meets baseline)
Production Deployment Ready
  ↓ (wait for approval)
Human Approval Gate
  ↓ (approved)
Production Deployment
```

## Manual Quality Gate Reviews

### Code Review Gate

**For all significant code changes:**

**Reviewer Selection:**
- At least 1 peer with domain expertise
- Optional: Architecture team for large changes
- Owner: Lead developer / tech lead

**Review Checklist:**
- [ ] Code follows architectural patterns
- [ ] Code style and standards followed
- [ ] No obvious bugs or issues
- [ ] Comments are clear and helpful
- [ ] Performance implications considered
- [ ] Security implications considered
- [ ] Tests are sufficient
- [ ] Documentation is updated

**Review Standards:**
- Average review time: < 24 hours
- Review feedback: Clear and actionable
- Approval: Clear approval statement
- Disapproval: Clear concerns and path to approval

### Design Review Gate

**For architecture or system design changes:**

**Audience:**
- Architects (minimum 2)
- Technical leads of affected systems
- Infrastructure (if infrastructure implications)
- Security (if security implications)

**Review Focus:**
- [ ] Design meets requirements
- [ ] Scalability considered
- [ ] Reliability and resilience considered
- [ ] Security properly addressed
- [ ] Operational considerations addressed
- [ ] Consistency with standards
- [ ] Alternative approaches considered
- [ ] Risks and mitigations identified

**Review Output:**
- Design approved ✅
- Design approved with conditions ⚠️
- Design needs rework ❌
- Written feedback and guidance

### Compliance Gate

**For changes affecting compliance or security:**

**Review By:**
- Security team
- Compliance team
- Legal (if contractual implications)

**Checks:**
- [ ] Regulatory requirements met
- [ ] Data protection measures adequate
- [ ] Access controls proper
- [ ] Audit logging in place
- [ ] Compliance certifications maintained

## Escalation for Failed Gates

### Gate Failure Process

**If quality gate fails:**

1. **Severity Assessment**
   - Is this a blocker?
   - Can it be fixed quickly?
   - What's the impact?

2. **Path Forward (choose one)**
   - **Fix the Issue:** Address root cause
   - **Waive the Gate:** With documented justification
   - **Defer the Work:** Move to later sprint/release

3. **Waiver Process** (if gate must be bypassed)
   - Authority: [Who can approve waiver]
   - Documentation: [Reason for waiver]
   - Risk Acceptance: [Who accepts the risk]
   - Follow-up: [When will this be addressed]
   - Communication: [Who is informed]

**Example Waiver:**
```
Quality Gate Waiver Request

Gate: Security scan shows 3 high-severity vulnerabilities
Reason: Libraries are being updated in follow-up task (TICKET-123)
Risk: Temporary exposure to known vulnerabilities (24 hours)
Authority: CISO + Tech Lead
Timeline: Will be fixed by EOD tomorrow
Communication: Will notify security team before deploy
```

4. **Appeal Process** (if requester disagrees with gate decision)
   - Request review by gate authority + manager
   - Present business case for exception
   - Authority makes final decision

## Gate Metrics and Reporting

### Gate Performance Dashboard

**Track quality gate metrics:**

```
Monthly Quality Gate Report

Gate Pass Rates:
- Pre-development: 95% (4 of 21 designs needed revisions)
- Pre-integration: 98% (2 of 102 PRs failed code style)
- Pre-staging: 100% (0 failures)
- Pre-production: 100% (0 failures)
- Post-production: 99% (1 deployment had minor issue)

Most Common Failures:
1. Test coverage < 80% (40% of failures)
2. Security vulnerabilities (30% of failures)
3. Code style violations (20% of failures)
4. Performance regression (10% of failures)

Average Time by Gate:
- Code review: 8 hours
- Design review: 12 hours
- Integration testing: 20 minutes
- Staging deployment: 1 hour
- Production deployment: 30 minutes

Waiver Requests: 3 (all approved)
- 2 for follow-up vulnerability fixes
- 1 for hotfix bypass (emergency)
```

### Continuous Improvement

**Quarterly gate review:**

- Which gates are most effective?
- Which gates are creating bottlenecks?
- What metrics should we add/remove?
- Are standards achievable? (if not, adjust)
- Any automation opportunities?
- Feedback from teams

## Related Resources

- [Standards Compliance](./standards-compliance.md)
- [Technical Debt Management](./technical-debt-management.md)
- [Change Management](./change-management.md)
- [Decision Process](./decision-process.md)

---

**Status:** Complete  
**Last Updated:** November 2025  
**Version:** 1.0  
**Owner:** VP Architecture
