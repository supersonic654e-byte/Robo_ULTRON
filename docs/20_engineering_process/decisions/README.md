# Architecture Decision Records (ADR)

We log the "why" behind significant decisions so nobody has to re-derive them.
Format is a stripped-down version of Michael Nygard's ADR pattern.

- `0001-dds-over-vpn.md` — why CycloneDDS + Tailscale instead of Zenoh/plain multicast
- `0002-two-pwm-bts7960.md` — why native two-PWM per motor (not 1-PWM+1-DIR) for BTS7960
- `0003-right-encoder-pcint-fix.md` — why right encoder moved from Port A to Port B
- `0004-tf-single-ownership.md` — why EKF is the sole publisher of odom→base_link
- `0005-amcl-best-effort-qos.md` — why AMCL uses best_effort QoS for /scan
- `0006-containerized-everything.md` — why all ROS 2 software runs in Docker containers

## Template

```markdown
# ADR-00XX: <short title>
Date: <YYYY-MM-DD>
Status: Accepted | Superseded by ADR-00YY | Rejected

## Context
<what problem, what constraints>

## Decision
<what we chose>

## Consequences
<what got easier / harder>
```

## Rules

- One decision per ADR. Number sequentially.
- A decision is "accepted" the moment it is committed; it can be superseded.
- Link the ADR from the PR that implements it.
