# Onboarding Log

A running record of who set up what and how, so knowledge isn't siloed in one
person's head. Fill this in as each team member completes a setup step.

> **This is a template.** Copy the table below and add your entries. Delete these
> instruction lines when the team starts using it.

## Setup history

| Date | Who (role) | What was set up | Key findings / gotchas |
|---|---|---|---|
| _YYYY-MM-DD_ | _e.g., Embedded Lead_ | _e.g., Arduino IDE + arduino-cli on laptop_ | _e.g., needed FQBN `arduino:avr:mega:cpu=atmega2560` manually_ |
| | | | |
| | | | |
| | | | |

## Environment details (fill once per machine)

| Machine | OS / version | Docker version | Tailscale version | Notes |
|---|---|---|---|---|
| Jetson Nano (robot) | Ubuntu 20.04, L4T R32.7.2 | _e.g., 24.x_ | 1.68.2 | Qengineering community image |
| Laptop (pilot) | _e.g., Ubuntu 22.04_ | _e.g., 25.x_ | 1.68.2 | |
| | | | | |

## Flashing / provisioning checklist (per machine)

- [ ] OS installed (Jetson: Qengineering image; Laptop: Ubuntu 22.04)
- [ ] Docker CE installed + `docker compose` working
- [ ] Tailscale installed + linked to the team network (1.68.2)
- [ ] `ROS_DOMAIN_ID=42` in `/etc/environment` (or per-shell)
- [ ] Jetson: SSD mounted at `/mnt/ssd` (UUID in `/etc/fstab`)
- [ ] Jetson: ZRAM + swap configured (Bible §3)
- [ ] Jetson: headless mode + journald-on-volatile (Bible §3)
- [ ] Jetson: Chrony installed and synced (Bible §4)
- [ ] Arduino flashed via `arduino-cli compile --fqbn arduino:avr:mega:cpu=atmega2560`
- [ ] `scripts/smoke_test.sh` passes end-to-end
- [ ] Web server accessible at `http://<laptop>:8080/admin`

## Tips from the team

> Add anything that tripped you up during setup — this is the "tribal knowledge"
> that would otherwise be lost when a member graduates.

> _Last updated: 2026-08-08_
