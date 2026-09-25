# ADR-0005: AMCL best-effort QoS

- **Date:** 2026-08-08
- **Status:** Accepted
- **Bible reference:** §6.2 nav2_params.yaml, §7.4 QoS strategy, §15.4 troubleshooting

## Context

ROS 2 QoS reliability must match between publisher and subscriber. A **RELIABLE**
subscriber paired with a **BEST_EFFORT** publisher results in **silent failure**:
no data delivered, no error message. This is documented in the Bible's §7.4 rule:
> "Publisher and subscriber reliability MUST match. BEST_EFFORT pub + RELIABLE sub
> = silent failure (no data, no error)."

The rplidar driver publishes `/scan` with **BEST_EFFORT** reliability (appropriate
for high-frequency sensor data where occasional drops are acceptable). However,
ROS 2 Humble's AMCL defaults to **RELIABLE** for its `/scan` subscription. Over
DDS-over-Tailscale, this mismatch meant AMCL never received laser data, so
localization never locked and Nav2 appeared completely broken.

## Decision

- Set `amcl/sensor_data_qos: 2` (best_effort) in `nav2_params.yaml` to match the
  rplidar publisher.
- Set `obstacle_layer/qos_policy_reliability: best_effort` for the same reason.
- Other AMCL QoS settings remain at their defaults (RELIABLE for `/map`).

## Consequences

- Fixed: AMCL receives laser scans and localization converges correctly.
- Caveat: any future sensor replacing the rplidar must also publish `/scan` at
  BEST_EFFORT (or the AMCL param must be updated accordingly). The Bible §7.4
  QoS table documents this mapping.
- This is a common Humble pitfall — calling it out in the ADR saves future
  developers hours of debugging "AMCL doesn't work" over VPN links.
