# Rule: Data Handling and PII / PHI

**Tier:** [ALWAYS] when the system touches user data, health data, payment data, or anything not safely public.

Health and personal data are not "just data." Mishandling them is a regulatory, ethical, and reputational issue. Default to the strictest interpretation when unsure.

## Data classification

Treat every field as one of:

- **Public** — already published, no harm if leaked (marketing copy, public docs).
- **Internal** — fine inside the org, not for outside (internal IDs, non-sensitive metadata).
- **Confidential** — restricted access, harm if leaked (user emails, plain user content).
- **Restricted** — regulated, contractual, or directly identifying (PII, PHI, payment data, credentials).

If you don't know the class, assume Restricted until told otherwise.

## Never

- Log PII, PHI, payment data, full tokens, full session IDs, or raw passwords. Mask (`user_***@***.com`, `card_***1234`) or omit.
- Put real user data into test fixtures, seed data, examples, or screenshots. Use synthetic data — Faker, factory libraries, or hand-rolled obviously-fake values (`test@example.test`, `Jane Doe`, `555-0100`).
- Copy production data into dev/staging without an approved anonymization pipeline.
- Use production credentials in development.
- Email, Slack, paste, or attach restricted data anywhere outside the approved store.
- Cache restricted data in browser/local storage longer than the session requires.

## Always

- Encrypt at rest (database-level or column-level for PHI).
- Encrypt in transit (TLS, including internal service-to-service).
- Access-control every endpoint that returns user data. Default deny.
- Log *who* accessed *what* restricted data, *when*, and *why* (audit log).
- Make deletion actually delete (right-to-be-forgotten) — including backups, caches, search indexes, and downstream pipelines.
- Implement retention limits. Data you don't have can't leak.
- Validate data class on egress: API responses, exports, webhooks. The right query returning the wrong field is a breach.

## Health-specific (HIPAA / privacy)

- PHI requires named access (no shared service accounts for PHI access).
- Audit log retention typically 6+ years; check your jurisdiction.
- Minimum necessary rule: each role gets the least PHI it needs to do its job.
- BAAs required for any third-party processor that touches PHI.
- Breach disclosure obligations are time-bounded and unforgiving — escalate any suspected exposure immediately to the privacy officer / counsel.

## In code

- Mark restricted fields in the schema (a `PII()` or `@sensitive` decorator if your stack supports it).
- Centralize redaction at the logging boundary, not at every call site.
- Test that redaction works — add a test that asserts a log call with a sensitive field produces a masked output.
- Linting: ban `console.log(user)` patterns where `user` is typed with sensitive fields.

## When migrating or backfilling

- Restricted data backfills go through the same audit and access controls as live access.
- Dry-run on a sampled, anonymized subset first.
- Document who ran the migration, when, and over what scope.

## When in doubt

Ask. Privacy mistakes are expensive and often irreversible.

## Sources

- HIPAA Privacy and Security Rules
- GDPR Articles 5, 15, 17, 25, 32
- OWASP ASVS V8 (Data Protection)
