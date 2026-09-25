# Contribution Workflow

How an idea becomes a merged change in this repository. This ties together the
GitHub templates, ADRs, quality gates, and risk register that already exist.

## Flow

```
┌─────────────┐    assign       ┌──────────────┐    create     ┌────────────────┐
│   IDEA       │───────────────▶│   ISSUE       │──────────────▶│   BRANCH        │
│ (discussion)  │               │ (bug / feat)  │              │  (main + short  │
└─────────────┘               └──────────────┘               │   descriptive   │
                                │                            │   name)         │
                                │ labels:                     └───────┬────────┘
                                │  hardware / firmware /               │
                                │  software / docs                    │ make
                                │                                    ▼
                                │                            ┌────────────────┐
                                │                            │   DEVELOP       │
                                │                            │  (local tests)  │
                                │                            └───────┬────────┘
                                │                                    │ ADR if needed
                                │                                    │ (decisions/)
                                │                                    ▼
                                │   review              ┌────────────────┐
                                └──────────────────────│   PULL REQUEST  │
                                                        │ (fill template) │
                                                        └───────┬────────┘
                                                                │
                                                  ┌─────────────┼──────────────┐
                                                  ▼             ▼              ▼
                                           ┌──────────┐  ┌──────────┐  ┌──────────┐
                                           │ Gate A   │  │ Gate B   │  │ Gate C   │
                                           │ Every PR │  │ HW/FW    │  │ SW/ROS   │
                                           └────┬─────┘  └────┬─────┘  └────┬─────┘
                                                │              │              │
                                                └──────────────┼──────────────┘
                                                               ▼
                                                       ┌──────────────┐
                                                       │    MERGE      │
                                                       │ (squash or    │
                                                       │  rebase)      │
                                                       └──────┬───────┘
                                                              │
                                                    ┌─────────┴──────────┐
                                                    ▼                    ▼
                                             ┌────────────┐       ┌────────────┐
                                             │ Gate D/E/F │       │  CHANGELOG  │
                                             │ (if field/  │       │ (dated entry│
                                             │  release/   │       │  in         │
                                             │  paper)     │       │  changelog) │
                                             └────────────┘       └────────────┘
```

## Step-by-step

1. **Idea → Issue.** Open a GitHub issue (use bug report or feature request
   template). Assign labels (`hardware`, `firmware`, `software`, `docs`) and a
   milestone if applicable. Link any related ADR or risk register entry.

2. **Branch.** Create a branch from `main`: `main + short-name`
   (e.g., `main-fix-reverse-speed-bug`, `main-add-env-sensor-slot`).

3. **Develop.** Write the change. Run relevant tests locally:
   - `make test` (offline unit tests)
   - `make firmware` (compile check)
   - `make web-test` (web control system)
   - `make lint-links` (docs consistency)
   - Hardware/firmware: bench test per Bible §13 (wheels off the ground)

4. **ADR (if needed).** If the change introduces a significant design choice,
   create an ADR in `docs/20_engineering_process/decisions/` using the template
   in `decisions/README.md`. Link it in the PR.

5. **Pull Request.** Fill the PR template:
   - Summary + related issue link
   - ADR linked? (if applicable)
   - Quality gates checked (A always; B for HW/FW; C for SW/ROS)
   - Verification: paste test output
   - Notes for reviewers

6. **Review & Gates.** At least one team member reviews. All applicable quality
   gates (see `quality_gates.md`) must pass before merge.

7. **Merge & Changelog.** Merge (squash or rebase). Add a dated entry to
   `docs/20_engineering_process/changelog.md`.

8. **Post-merge (if applicable).** For field sessions, data collection, or
   version releases, the applicable higher gates (D/E/F) apply — see
   `quality_gates.md`.

## Key references

| What | Where |
|---|---|
| Issue templates | `.github/ISSUE_TEMPLATE/` |
| PR template | `.github/PULL_REQUEST_TEMPLATE.md` |
| Quality gates (A–F) | `docs/20_engineering_process/quality_gates.md` |
| ADR template + index | `docs/20_engineering_process/decisions/README.md` |
| Risk register | `docs/20_engineering_process/risk_register.md` |
| Changelog | `docs/20_engineering_process/changelog.md` |
| Safety-first PR rules | `CONTRIBUTING.md` |
| Bible ("wins" rule) | `versions/V0.3_Ultron/implementation_bible.md` |

> _Last updated: 2026-08-08_
