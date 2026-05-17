# Rule: Dependency Management

**Tier:** [WHEN USEFUL] — applies whenever you're about to add, remove, or upgrade a dependency.

A dependency is a permanent liability. The convenience is paid for every time you upgrade, patch a CVE, or debug an issue that turns out to live in node_modules.

## Before adding a new dep

Ask, in order:

1. **Can I do this without a dep?** Often the function you need is 20 lines. Write the 20 lines if the dep is large.
2. **Is it already in the dep tree?** Use the transitive dep you already pay for, not a new direct one.
3. **Is it actively maintained?** Last commit, last release, open vs closed issue ratio, single-maintainer risk. A 6-month-stale dep with one maintainer is a future incident.
4. **License compatible?** Verify before installing, not after. MIT/Apache/BSD generally safe; GPL/AGPL needs explicit OK in commercial contexts.
5. **Supply chain hygiene?** `npm audit signatures` (or your ecosystem's equivalent). Recent typosquatting incidents on npm, PyPI, RubyGems make this non-optional.
6. **What does it pull in?** A 50KB lib that brings 10MB of transitive deps is not a 50KB lib.

If you can't answer 3–5, don't install.

## Pinning policy

- **Pin majors.** Allow patch and minor updates; never `^` across a major boundary in production code.
- **Never `latest`** in `package.json` / `requirements.txt`. That's an "auto-install whatever ships tomorrow" footgun.
- **Lockfile is sacred.** Commit it. Never edit by hand. Treat lockfile conflicts as a regen-from-scratch, not a manual merge.

## Upgrading

- One dep per commit when feasible. Bundled upgrades make it impossible to bisect a regression.
- Read the changelog. Don't just bump and hope.
- For majors: read the migration guide before you start, not after the build breaks.
- Run the full test suite after each upgrade.
- Check the upgrade in staging if the dep is on the request path.

## Removing

- Yes, you can remove deps. Look for dead deps periodically (`depcheck`, `knip`, `cargo-machete`, etc.).
- Removing a dep is a behavior-preserving change — should have no test diff.

## Vulnerabilities

- Run the project's audit command before merge (`npm audit`, `pip-audit`, `cargo audit`, `bundle audit`).
- A critical CVE in a production dep is a stop-the-line. Patch path:
  1. Bump to a patched version if available.
  2. If not, look for a fork or workaround.
  3. If neither, document the risk and time-box the fix.
- Don't suppress audit warnings without a written reason and a follow-up ticket.

## Forbidden

- `curl ... | sh` to install. Download, inspect, then run.
- Installing from a fork without reviewing the diff against upstream.
- Adding a dep to "solve" a problem you haven't reproduced.
- Pulling in a UI framework to use one component.

## When in doubt

The 20-line hand-written version that you understand and own beats the 50KB dep you have to upgrade for the next 10 years.

## Sources

- "left-pad," `event-stream`, `colors.js`, `xz` (the spectrum of supply-chain pain)
- OWASP Top 10 — A06: Vulnerable and Outdated Components
