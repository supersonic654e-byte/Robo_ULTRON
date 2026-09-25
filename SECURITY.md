# Security Policy

ROBO_ULTRON is a student-built research robot. This document explains how to
**report** a security issue and what the project's known security posture is.
It does **not** change any technical content, code, or the engineering audit.

> This is a pre-publication research repository (see the root README). Treat
> everything here as research-grade and **not** a certified medical device.

---

## Reporting a vulnerability

**Do not open a public GitHub issue for anything security-sensitive.**

Instead, report it privately to the maintainers:

- Use GitHub's **"Report a vulnerability"** feature on the **Security** tab
  (private advisory), **or**
- contact a maintainer directly through a private channel the team already
  uses internally.

Please include:

- A clear description of the issue and its impact.
- The affected version (e.g. Ultron_V0.3) and file(s)/component(s).
- Reproduction steps, logs, or a proof of concept if you have one.
- Any suggested fix (optional).

We will acknowledge receipt, investigate, and coordinate a fix and disclosure
timeline with you.

---

## Scope

Security-relevant issues include, for this project:

- Anything that lets an unauthorized party **move the robot** or defeat a
  safety stop (e.g. the ROS 2 `/cmd_vel` data plane, the web `/api/cmd/*`
  endpoints, the E-stop / `clear_faults` recovery path, firmware motor drive).
- **Authentication / authorization** weaknesses (e.g. the web PIN / admin
  password / token handling).
- Exposure of **secrets or private data** (API keys, Tailscale keys, recorded
  bags, mission data).
- Supply-chain concerns (pinned dependencies, downloaded binaries without
  integrity checks).
- Any issue that could lead to **physical harm** or a **data breach**.

Out of scope for a security report: general bugs, feature requests, and
documentation typos — use the normal issue templates for those.

---

## Known security posture (summary only — see the audit for details)

The security-relevant findings are documented (without exaggeration or
minimization) in the engineering audit and the implementation Bible. They are
**not** fixed by this policy — they are tracked there so they get fixed on the
roadmap. Refer to:

- [Engineering audit](docs/20_engineering_process/engineering_audit.md) —
  security-relevant items appear in the risk register and the per-layer audits.
- [Implementation Bible §7 (CycloneDDS) and §19 (web control)](versions/V0.3_Ultron/implementation_bible.md)
  — describe the data plane and the web layer as built.
- [Privacy policy](docs/30_data_and_privacy/privacy_policy.md) — data handling.

If you believe any of those documented items is mis-stated or worse than
described, that is a security report — tell us privately.

---

## Supported versions

Only the **active** version receives security attention. Older generations are
kept for history.

| Version | Supported |
|---|---|
| Ultron_V0.3 (active) | ✅ security fixes |
| Ultron_insightV1.0 (planned) | 🔜 when built |
| Ultron_V0.1 / V0.2 (retired) | ❌ no — see their history files |

---

> _Last updated: 2026-08-08_
