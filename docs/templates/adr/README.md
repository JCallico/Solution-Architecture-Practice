# Architecture Decision Record (ADR) Templates

This directory contains templates for creating Architecture Decision Records (ADRs).

## Available Templates

### [Simple Template](./simple-template.md)
Basic ADR template for straightforward decisions.

**Use when:**
- Decision is relatively simple
- Few options to compare
- Limited stakeholders

### [Detailed Template (MADR)](./madr-template.md) 
Markdown Architectural Decision Record format - comprehensive template.

**Use when:**
- Complex decision with multiple options
- Need to document detailed trade-offs
- Many stakeholders involved
- High-impact decision

## Quick Start

1. Copy appropriate template
2. Rename file using format: `ADR-###-title.md` (e.g., `ADR-001-use-postgresql.md`)
3. Fill in all sections
4. Submit for review if required
5. Store in `/docs/knowledge-base/decisions/`

## See Also

- [ADR Framework](../../frameworks/adr-framework.md) - Complete ADR guidance
- [Existing ADRs](../../knowledge-base/decisions/README.md) - Past decisions

---

*Templates are based on industry best practices including Michael Nygard's ADR format and MADR (Markdown Architectural Decision Records).*
