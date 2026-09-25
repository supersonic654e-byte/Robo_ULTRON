# Contributing to ROBO_ULTRON

First: thank you. This is a student-built research robot, and every careful
contribution makes the platform safer and more useful.

This guide tells you **how** to make a change without breaking anything. **What**
you may change, and the project's design rules, live in the documents it links to.
When in doubt, open an issue first and ask.

> Source of truth rule: if the same fact appears in two places, the
> [V0.3 implementation Bible](versions/V0.3_Ultron/implementation_bible.md)
> wins for Ultron_V0.3. See `docs/00_project/naming_and_versioning.md`.

---

## 0. Before you touch anything — safety is a first-class citizen

This repository describes a **physical robot that can move**. A "small" software
or firmware change can make the robot drive into a person or a wall. Read
[docs/10_architecture/safety_architecture.md](docs/10_architecture/safety_architecture.md)
and Bible §10 before any motor/E-stop/heartbeat change, and follow the safety-first
PR rules below.

If your change touches motors, encoders, E-stop, heartbeat, watchdogs,
overcurrent, battery cutoff, or the safety node, **the robot must be on the bench
with the wheels off the ground** for every test, and you must re-run the
[E-stop release + `/ultron/clear_faults`](versions/V0.3_Ultron/implementation_bible.md)
recovery before merging.

---

## 1. Set up your machine

1. Clone the repo.
2. Install Docker (the software stack runs in containers — see
   [software/README.md](versions/V0.3_Ultron/software/README.md)).
3. (Optional but recommended) `arduino-cli` for firmware work — see
   [firmware/README.md](versions/V0.3_Ultron/firmware/README.md).
4. (Optional) ROS 2 Humble native on your laptop if you will run the Nav2 side.

The 30-minute new-contributor path is in
[GETTING_STARTED.md](GETTING_STARTED.md).

---

## 2. The change loop: issue → branch → PR → gate → merge

We keep this deliberately small so it actually gets used. See
[contribution_workflow.md](docs/20_engineering_process/contribution_workflow.md)
for the full picture.

1. **Open or pick an issue.** If it is a meaningful decision (not just a typo),
   consider writing an [ADR](docs/20_engineering_process/decisions/README.md)
   *first* — the discussion belongs in the ADR, the PR implements it.
2. **Branch** off the current version branch. Suggested name:
   `<version>/<short-scope>-<detail>`, e.g. `v0.3/safety-reverse-slow`.
3. **Make the change.** Keep PRs small and one-topic. Touch as few files as
   will get the job done.
4. **Run the local checks** (below). Do not push red.
5. **Open a PR** using the template. Fill every checkbox honestly.
6. **Meet the applicable quality gate(s)** —
   [quality_gates.md](docs/20_engineering_process/quality_gates.md):
   - Gate A applies to **every** PR.
   - Gate B if you touched hardware/firmware.
   - Gate C if you touched software/ROS.
   - Gate D before a field/pilot session.
   - Gate E before tagging a version.
7. **Review and merge** once a reviewer signs off and CI is green.

---

## 3. Local checks — run these before pushing

Everything is wrapped in a `Makefile` so you do not have to memorize paths.

```bash
make help              # list all targets
make lint-links        # broken relative-link check (what CI runs)
make test              # offline unit tests (protocol, safety, depth→scan)
make web-test          # web control-system tests (pytest)
make firmware          # compile the Mega 2560 sketch (needs arduino-cli)
```

On the laptop with the robot powered, also run the pre-session
[smoke test](scripts/smoke_test.sh):

```bash
make smoke             # wraps scripts/smoke_test.sh
```

If you do not have `make`, the exact commands each target runs are listed in
the [Makefile](Makefile) — copy them directly.

---

## 4. Quality gates (what "done" means)

The full gates are in
[quality_gates.md](docs/20_engineering_process/quality_gates.md). The
non-negotiable ones:

- **Gate A (every PR):** CI green, no new TODO without a linked issue, docs
  updated if behavior changed, self-reviewed diff.
- **Gate B (hardware/firmware):** robot on bench, Bible §13.1 tests pass,
  E-stop release + `clear_faults` verified.
- **Gate C (software/ROS):** `ros2 topic hz` checks pass, QoS table either
  unchanged or intentionally changed + documented, TF chain verified,
  heartbeat/watchdog kill test verified.

---

## 5. Where things live (do not scatter)

| You are changing… | Put it under… | Reference |
|---|---|---|
| Firmware | `versions/<gen>/firmware/` | [firmware README](versions/V0.3_Ultron/firmware/README.md) |
| Onboard ROS nodes | `versions/<gen>/software/jetson/` | [software README](versions/V0.3_Ultron/software/README.md) |
| Laptop ROS (Nav2/SLAM/EKF) | `versions/<gen>/software/laptop/` | same |
| Web control system | `versions/<gen>/software/web/` | [web README](versions/V0.3_Ultron/software/web/README.md) |
| Tests | `versions/<gen>/tests/` | [tests README](versions/V0.3_Ultron/tests/README.md) |
| Calibration tools | `versions/<gen>/calibration/` | [calibration README](versions/V0.3_Ultron/calibration/README.md) |
| Deploy assets (udev/systemd/chrony) | `versions/<gen>/deploy/` | [deploy README](versions/V0.3_Ultron/deploy/README.md) |
| Cross-version knowledge | `docs/NN_area/` | [docs README](docs/README.md) |
| A decision (the "why") | `docs/20_engineering_process/decisions/` | [ADR README](docs/20_engineering_process/decisions/README.md) |

---

## 6. Documentation conventions

- **Format:** Markdown; line endings LF (enforced by `.gitattributes`).
- **Every doc gets a `Last updated` footer** — this is a project rule
  (`docs/00_project/naming_and_versioning.md` §5). Add
  `> _Last updated: YYYY-MM-DD_` at the bottom of any doc you create or
  meaningfully change.
- **Cross-links must resolve.** The `docs-lint` CI job catches broken relative
  links; run `make lint-links` before pushing.
- **Do not commit large binaries.** Datasheets/PDFs are gitignored; CAD/STL
  likewise. Put them under `docs/90_reference/` pointers and use Git LFS or an
  external store (see `docs/90_reference/README.md`).
- **Diagrams:** Mermaid sources live in
  [docs/10_architecture/diagrams/](docs/10_architecture/diagrams/); never
  hand-edit a rendered image, edit the `.mmd`.

---

## 7. Commit messages

Short and honest. Suggested prefix by area:

```
firmware: close right-encoder double-transition under-count
safety: clamp reverse inside SLOW zone (Bible §10)
docs: add ADR-0004 TF single-ownership
web: rate-limit /api/cmd/twist globally
```

Reference the issue and any ADR in the body, not just the subject.

---

## 8. Tests and results

- **Offline unit tests** are run in CI and locally (`make test`). Any new
  behavior in a pure-logic module should get a unit test next to the existing
  ones in `versions/V0.3_Ultron/tests/scripts/`.
- **Benchmark results are real only when their CSV is in
  `versions/V0.3_Ultron/tests/results/`.** That is the project rule
  ([tests/README](versions/V0.3_Ultron/tests/README.md)). A claim in a doc or
  PR with no backing CSV is not a result.
- Recording convention for every result row: `date, operator, firmware/software
  hash, battery_voltage, N, mean ± std, units, deviation notes`.

---

## 9. Updating the changelog

Add a dated entry to
[docs/20_engineering_process/changelog.md](docs/20_engineering_process/changelog.md),
newest first, format `YYYY-MM-DD — what changed (author/PR)`. Do this in the
same PR as the change.

---

## 10. When you cannot finish something

- Leave a clear TODO that links to an issue (Gate A forbids orphan TODOs).
- Note it in your PR under "Notes for reviewers".
- Update the [risk register](docs/20_engineering_process/risk_register.md) if
  it introduces a new risk.

---

## 11. Credit and privacy

This is **pre-publication research** (see the root README). Until the paper is
accepted:

- Use only role labels (**Student Researcher**, **Technical Expert**) in commits,
  docs, and the changelog — no personal names or emails.
- Do not push anything that attributes a person publicly.

When the team lifts that notice, this section gets updated — not the history.

---

Thank you for reading this far. When in doubt: **open an issue, keep the PR
small, leave the wheels off the ground.**
