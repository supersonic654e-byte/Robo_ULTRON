# Reproducibility Checklist

Steps to ensure a result, experiment, or build can be reproduced by any team
member. These rules already exist scattered across the Bible, test docs, and
process files — this checklist brings them together.

## Before any experiment / field session

- [ ] **Firmware version tagged** — note the exact commit hash on the Jetson and MCU.
- [ ] **Docker images tagged** — `docker compose build` with a known image ID; note it
  in the session log.
- [ ] **Calibration current** — wheel radius, encoder CPR, IMU offsets, depth-camera
  intrinsics all match the deployed config (Bible §13).
- [ ] **Smoke test passed** — run `scripts/smoke_test.sh` (topics, heartbeat, battery, E-stop).
- [ ] **Tailscale version pinned** — 1.68.2 (or whatever the current pinned version is;
  see ADR-0001).
- [ ] **`ROS_DOMAIN_ID=42`** set on all machines and containers.

## During data collection (Bible §17)

- [ ] **rosbag recording** — `ros2 bag record` running with a known mission ID.
- [ ] **JSONL logger running** — onboard logger writing to `/mnt/ssd/ultron/logs/`.
- [ ] **Mission ID** — unique per session, recorded in `data_pilot/` index.
- [ ] **Start time** — logged (for clock-sync verification with chrony).
- [ ] **E-stop within reach** — operator present at all times (Gate D).

## After the session

- [ ] **rosbag archived** — stored in `data_pilot/<mission_id>/` with checksum.
- [ ] **JSONL archived** — same location; hash recorded.
- [ ] **Bag checksum verified** — `bag_checksum.py` hash matches (no corruption).
- [ ] **Feature extraction run** — `feature_extract.py` output archived.
- [ ] **Battery return voltage noted** — must be ≥ 11.1 V (Bible §16.3).
- [ ] **Session log updated** — `data_pilot/` mission index entry added.

## When sharing results (paper / report)

- [ ] **Git commit hash** — of the exact firmware + software used for the experiment.
- [ ] **Docker image IDs** — noted in the methods section.
- [ ] **Raw data committed or archived with a DOI** — (Gate F).
- [ ] **Protocol / scripts committed** — anyone can replay the pipeline.
- [ ] **Privacy gate** — no raw video of identifiable persons (Bible §17.2).

## Quick commands

```bash
# Full offline test suite
make test

# Firmware compile check
make firmware

# Pre-session smoke test (robot powered)
make smoke

# Docs consistency
make lint-links

# Archive a bag with checksum
python3 versions/V0.3_Ultron/tests/scripts/bag_checksum.py <bag_path>
```

> _Last updated: 2026-08-08_
