# ADR-0004: TF single-ownership (EKF)

- **Date:** 2026-08-08
- **Status:** Accepted
- **Bible reference:** §0.1 B4, §7.4, §8 serial_node notes, §12.1, §13.2

## Context

ROS 2's TF2 library allows multiple publishers for the *same* frame pair, but when
two nodes publish the same transform (e.g., `odom → base_link`), TF2 throws a
**transform extrapolation** error and consumers (Nav2, AMCL) get conflicting poses.

In early v4.2 builds, both `serial_node` (which converts MCU odometry to ROS
messages) and the laptop EKF (`robot_localization`) published `odom → base_link`.
This caused constant TF conflicts.

## Decision

- **EKF is the single publisher of `odom → base_link`.**
  - `serial_node` publishes only the `/odom` message (nav_msgs/Odometry) — it
    no longer runs a `TransformBroadcaster`.
  - `robot_localization` (EKF) subscribes to `/odom`, `/imu/data`, and any other
    sensor inputs, fuses them, and publishes the single `odom → base_link` TF.
- EKF params: `world_frame: odom`, `odom_frame: odom`,
  `base_link_frame: base_link`, `publish_tf: true`.
- AMCL publishes `map → odom` (not `odom → base_link`) — no conflict.
- The EKF can optionally run onboard the Jetson (`ekf_onboard:=true`), but the
  laptop EKF must be disabled (`run_ekf:=false`) to preserve single ownership.

## Consequences

- Fixed: TF chain is clean — `map → odom → base_link → sensor frames`.
- Constraint: only one EKF instance must ever run at a time. The launch system
  enforces this via mutually exclusive launch arguments.
- Diagnostic: `view_frames` / `ros2 run tf2_tools view_frames` should show exactly
  one arrow from `odom` to `base_link`.
