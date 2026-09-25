# Getting Started — ROBO_ULTRON

Welcome. This is the 30-minute path from "I just cloned the repo" to "I ran the
tests and I know where to look." It does not teach robotics — it shows you the
map. Read this once, then keep [CONTRIBUTING.md](CONTRIBUTING.md) as your
working reference.

---

## 0. The five-sentence orientation

1. ROBO_ULTRON is a line of low-cost autonomous robots for healthcare, built by a
   student team in Dhaka.
2. The **current** build is **Ultron_V0.3**, a supervised pre-deployment
   prototype. Older versions (V0.1, V0.2) are retired.
3. It is a **two-layer** robot: Arduino Mega (real-time) + Jetson Nano (edge) +
   laptop (compute for Nav2/SLAM). ROS 2 Humble in Docker, CycloneDDS over
   Tailscale.
4. The canonical build reference is the
   [implementation Bible](versions/V0.3_Ultron/implementation_bible.md) — if
   something disagrees with it, the Bible wins.
5. **It moves.** Read [safety_architecture.md](docs/10_architecture/safety_architecture.md)
   and Bible §10 before touching anything motor- or E-stop-related.

---

## 1. Clone and orient (5 min)

```bash
git clone <repo-url>
cd ROBO_ULTRON
```

Then read, in order:

1. [README](README.md) — the 1-page map.
2. [docs/00_project/overview.md](docs/00_project/overview.md) — what & why.
3. [docs/00_project/roadmap.md](docs/00_project/roadmap.md) — where it is going.
4. [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — the navigable architecture hub.

Folder map (one screen):

```
docs/          cross-version knowledge (numbered NN_area/)
versions/      one folder per generation; V0.3_Ultron/ is the live one
scripts/       smoke test + tooling
.github/       issue/PR templates + CI
hardware/      cross-version hardware assets (mostly pointers today)
software/      cross-version shared tooling (mostly pointers today)
```

Inside the live version (`versions/V0.3_Ultron/`):

```
implementation_bible.md   the canonical reference
firmware/                 Arduino Mega sketch
software/jetson/          onboard ROS nodes + Docker
software/laptop/          EKF + SLAM/AMCL + Nav2 + RViz2 + web
software/web/             admin + user web control
tests/                    offline unit tests + bench harnesses
calibration/              calibration tools
deploy/                   udev/systemd/chrony + scripts
data_pilot/               mission log + feature extraction
```

---

## 2. Run the offline tests (10 min, no robot needed)

The fastest way to know the code is healthy is to run the offline tests. You do
not need a robot, ROS, or Docker for these.

You need Python 3.10+. From the repo root:

```bash
# Option A — if you have make
make test          # protocol, safety-zone, depth→scan unit tests
make web-test      # web control-system tests (needs: pip install -r
                   #   versions/V0.3_Ultron/software/web/requirements.txt
                   #   pytest httpx)

# Option B — direct commands (what make runs)
cd versions/V0.3_Ultron/tests/scripts && ./run_tests.sh
python -m pytest -q versions/V0.3_Ultron/software/web/tests
```

Expected: all green. If a test fails on a fresh clone with no changes, that is a
bug — open an issue.

The firmware compiles without hardware too, if you have `arduino-cli`:

```bash
make firmware      # compiles the Mega 2560 sketch (no upload)
```

---

## 3. Read the Bible, not all of it (10 min)

The Bible is long. Read only these first:

- **§0–1** — document control, constraints, system overview.
- **§2** — hardware, BOM, wiring, pin map.
- **§10** — safety system (before any motor/E-stop work).
- **§13** — testing & verification (so you know what "done" looks like).

Then jump to whichever section matches the work you plan to do.

---

## 4. Pick a role and follow its trail

| You want to work on… | Read this trail |
|---|---|
| **Firmware / embedded** (motors, encoders, IMU, E-stop, PID) | [firmware README](versions/V0.3_Ultron/firmware/README.md) → Bible §2.2, §11 → [calibration](versions/V0.3_Ultron/calibration/README.md) |
| **Onboard ROS** (serial, safety, kinect, depth→scan, logger) | [software README](versions/V0.3_Ultron/software/README.md) → Bible §9 → [ros_architecture.md](docs/10_architecture/ros_architecture.md) |
| **Nav2 / SLAM / EKF** | [software/laptop](versions/V0.3_Ultron/software/README.md) → Bible §6, §12 → [sensor_fusion.md](docs/10_architecture/sensor_fusion.md) |
| **Safety** | [safety_architecture.md](docs/10_architecture/safety_architecture.md) → Bible §10, §13.4 → [risk register](docs/20_engineering_process/risk_register.md) |
| **Data / privacy** | [data_and_privacy/](docs/30_data_and_privacy/README.md) → Bible §17 → [data_pilot/](versions/V0.3_Ultron/data_pilot/README.md) |
| **Web control system** | [web README](versions/V0.3_Ultron/software/web/README.md) → Bible §19 |
| **Docs / process** | [docs/README](docs/README.md) → [CONTRIBUTING](CONTRIBUTING.md) → [quality_gates.md](docs/20_engineering_process/quality_gates.md) |

---

## 5. Make your first change (5 min)

Follow [CONTRIBUTING.md §2](CONTRIBUTING.md) — short version:

1. Pick an issue (or open one).
2. Branch: `v0.3/<short-scope>-<detail>`.
3. Make a small, one-topic change.
4. `make lint-links && make test` — green before push.
5. Open a PR; fill the template; meet Gate A (and B/C if you touched
   hardware/firmware/software).

> If your change touches motors, E-stop, heartbeat, watchdogs, overcurrent, or
> battery cutoff: **wheels off the ground for every test**, and re-verify the
> E-stop release + `clear_faults` recovery. No exceptions.

---

## 6. Things that bite newcomers (read once)

- **The Bible wins.** If a doc and the Bible disagree, fix the doc (and open an
  issue), do not "fix" the Bible in a drive-by.
- **The `.txt`/`.docx` mirrors of the Bible are deliverable exports**, not the
  source. Edit `implementation_bible.md`; the exports are regenerated.
- **Diagrams are Mermaid `.mmd` sources** under
  [docs/10_architecture/diagrams/](docs/10_architecture/diagrams/) — never edit a
  rendered image.
- **ROS_DOMAIN_ID must be 42 everywhere.** CycloneDDS peers must list both
  Tailscale IPs. If `ros2 topic list` is empty on the laptop, this is the first
  thing to check (Bible §15.3).
- **A benchmark is real only when its CSV is in
  `versions/V0.3_Ultron/tests/results/`** ([tests/README](versions/V0.3_Ultron/tests/README.md)).

---

## 7. Where to ask for help

- **Design question or "should we do X?"** → open an issue, or draft an
  [ADR](docs/20_engineering_process/decisions/README.md).
- **"It does not work"** → the [troubleshooting](versions/V0.3_Ultron/implementation_bible.md)
  section of the Bible (§15) is comprehensive and cause-based.
- **Security-sensitive** → see [SECURITY.md](SECURITY.md); never a public issue.

Welcome aboard.

---

> _Last updated: 2026-08-08_
