# ADR-0006: Containerized-everything upgradeability

- **Date:** 2026-08-08
- **Status:** Accepted
- **Bible reference:** §0.1 B3/D2, §0.2 compatibility matrix, §5, §12.1, §18

## Context

The robot runs ROS 2 Humble on two physically different machines (Jetson Nano 4 GB
arm64, laptop amd64) connected over Tailscale VPN. Installing and maintaining ROS 2,
its packages, and Python dependencies natively on both hosts — especially the Jetson
with its constrained 4 GB RAM — would be fragile and hard to reproduce across
team members' laptops.

Additionally, CycloneDDS unicast peer discovery requires all nodes to share the
host network stack. Docker's default bridge networking NATs container traffic,
which breaks DDS discovery silently.

## Decision

- **All ROS 2 software runs in Docker containers.** No native ROS installation on
  either host.
- Base image: `ros:humble-ros-base` (Linux arm64 on Jetson, amd64 on laptop).
  The container runs Ubuntu 22.04 even when the Jetson host is Ubuntu 20.04.
- Every container uses **`network_mode: host`** (v4.2r2 D2) so CycloneDDS binds
  the Tailscale interface directly — no bridge/NAT hop.
- Jetson: single container built from `software/jetson/Dockerfile` (colcon build,
  CycloneDDS, serial/safety/depth/lidar nodes). `MAKEFLAGS=-j2` caps parallelism
  to prevent OOM on the 4 GB Nano (B11).
- Laptop: three containers via `docker-compose`:
  - `nav2_slam` (EKF + SLAM + Nav2)
  - `rviz2` (visualization, on-demand)
  - `ultron_web` (web control system, on-demand)
- Deployment (§18): zip `software/jetson/` and `software/laptop/`, transfer to
  machines, `docker compose build && docker compose up`. No ROS installation needed.

## Consequences

- Reproducible: any team member can rebuild the exact same images from the repo.
- Upgradeable: bump the base image tag or `apt-get` line and rebuild — no host
  package management.
- Low overhead: containers add <1–2% CPU (native namespaces, no hypervisor);
  `network_mode: host` eliminates bridge overhead entirely.
- Constraint: `network_mode: host` means containers share the host's network
  namespace — acceptable because both machines are single-purpose robot hosts.
- B11 persists: any future Jetson with 4 GB RAM must keep `MAKEFLAGS=-j2` during
  image builds.
