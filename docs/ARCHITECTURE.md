# Architecture Hub

One-page map of every architecture document and diagram in the repository.
Build-specific facts live in the **implementation Bible**; this hub links to the
cross-version design knowledge.

> **Authoritative source:** for V0.3 constants, wiring, and params, the
> implementation Bible (`versions/V0.3_Ultron/implementation_bible.md`) wins.
> The docs below describe *design intent* and *patterns* that span versions.

---

## System layers

| Layer | Where it runs | Detail doc |
|---|---|---|
| **Real-time MCU** | Arduino Mega 2560 R3 (onboard) | `system_architecture.md` §2 |
| **Edge compute** | Jetson Nano 4 GB (onboard, Docker) | `system_architecture.md` §3 |
| **Remote compute** | Laptop (Nav2, SLAM, EKF, teleop) | `system_architecture.md` §4 |

## Key architecture documents

| Doc | What it covers | Also see |
|---|---|---|
| [**System Architecture**](10_architecture/system_architecture.md) | Three-layer split, design intent, industrial-grade considerations | Bible §0–§2 |
| [**ROS 2 Architecture**](10_architecture/ros_architecture.md) | Node graph, QoS profiles, TF tree, topic naming, CycloneDDS transport | ADR-0001, Bible §7 |
| [**Sensor Fusion**](10_architecture/sensor_fusion.md) | EKF fusion chain, build blocks, tuning approach | Bible §8, `fusion_build_parts.md` |
| [**Fusion Build Parts**](10_architecture/fusion_build_parts.md) | Reusable fusion components (Part 1–6) with interfaces | `sensor_fusion.md` |
| [**Data Flow**](10_architecture/data_flow.md) | Up/down data paths, bandwidth budgets, latency budget | Bible §17 (privacy) |
| [**Safety Architecture**](10_architecture/safety_architecture.md) | Layered safety (HW E-stop, MCU watchdogs, SW node), zones, watchdog chain | Bible §12 |
| [**AI Architecture**](10_architecture/ai_architecture.md) | collect → find patterns → predict loop (InsightV1.0+) | Roadmap |

## Diagrams (Mermaid sources + rendered PNGs)

All diagrams live in [`diagrams/`](10_architecture/diagrams/) and are version-controlled as `.mmd` sources.

| Diagram | What it shows |
|---|---|
| [`two-layer-overview.mmd`](10_architecture/diagrams/two-layer-overview.mmd) | Edge + remote compute split, Arduino real-time layer |
| [`full-system-architecture.mmd`](10_architecture/diagrams/full-system-architecture.mmd) | Full node/layer breakdown, data paths |
| [`ros2-node-communication.mmd`](10_architecture/diagrams/ros2-node-communication.mmd) | Topic-level communication, QoS, TF ownership |

> See the [`diagrams/README.md`](10_architecture/diagrams/README.md) for rendering instructions.

## Data pipeline & privacy

The robot follows a **privacy-by-design** data pipeline:

- Anonymous motion features extracted on-edge (no raw video by default).
- Laptop acts as V0.3 "cloud" — data never leaves the local network.
- See [Data Flow](10_architecture/data_flow.md) and Bible §17 for the full model.

## Architecture Decision Records (ADRs)

Significant "why" decisions are logged in `docs/20_engineering_process/decisions/`:

| ADR | Decision |
|---|---|
| [0001](20_engineering_process/decisions/0001-dds-over-vpn.md) | CycloneDDS + Tailscale unicast instead of Zenoh / multicast |

## Version-specific specs

| Version | Spec |
|---|---|
| **V0.3** (current build) | [`versions/V0.3_Ultron/implementation_bible.md`](../versions/V0.3_Ultron/implementation_bible.md) |
| **InsightV1.0** (planned) | [`versions/InsightV1.0_Ultron/implementation_spec.md`](../versions/InsightV1.0_Ultron/implementation_spec.md) |
| **Future roadmap** | [`versions/_future/roadmap.md`](../versions/_future/roadmap.md) |

## Quick orientation for newcomers

1. Start with [System Architecture](10_architecture/system_architecture.md) — it explains the three layers.
2. Then [Safety Architecture](10_architecture/safety_architecture.md) — safety is non-negotiable.
3. Skim the diagrams in [`diagrams/`](10_architecture/diagrams/) for the visual picture.
4. Deep-dive into [ROS 2 Architecture](10_architecture/ros_architecture.md) when you start coding.
5. For the "why" behind transport, read [ADR-0001](20_engineering_process/decisions/0001-dds-over-vpn.md).

> _Last updated: 2026-08-08_
