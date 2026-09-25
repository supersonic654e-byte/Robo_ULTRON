# Glossary

| Term | Meaning |
|---|---|
| Edge layer | The Jetson on the robot: sensors, safety node, MCU bridge. Works without the network. |
| Remote compute layer | The laptop running Nav2/SLAM/EKF (V0.3). |
| Real-time layer | The Arduino Mega: E-stop ISR, watchdogs, PWM drive. |
| Two-layer architecture | Edge + remote compute split used by Ultron_V0.3. |
| Nav2 | ROS 2 Navigation stack (planner, controller, costmaps). |
| slam_toolbox | ROS 2 package used for SLAM mapping. |
| AMCL | Adaptive Monte Carlo Localization (used against saved maps). |
| EKF | Extended Kalman Filter (robot_localization) for odom+IMU fusion. |
| DDS | Data Distribution Service — ROS 2 middleware. CycloneDDS here. |
| Tailscale | WireGuard-based VPN used to link the laptop and robot. |
| CycloneDDS | Our RMW implementation (`rmw_cyclonedds_cpp`). |
| BTS7960 / IBT-2 | Motor driver module (two-PWM H-bridge). |
| Watchdog (WDT) | Hardware/software timer that stops the robot on a hang. |
| E-stop | Emergency stop; hardware-latched, two-step release. |
| ROS bag | Recorded ROS 2 message log (pilot data). |
| mcap | Compact indexed bag storage format. |
| JSONL | Newline-delimited JSON used by the onboard logger. |
| Motion features | Anonymous counts/flow/dwell derived from perception (no identity). |
| Privacy-by-design | Data minimization as an architecture requirement, not an afterthought. |
| Ultron_insightV1.0 | First real-world deployment generation (planned). |

Add new terms as we introduce them. Keep definitions short and concrete.

| Term | Meaning |
|---|---|
| IBT-2 | Motor driver module using the BTS7960 H-bridge IC; driven via two PWM inputs (RPWM/LPWM), no DIR pin. |
| OC3A / OC3C / OC4A / OC4B | Timer3/Timer4 output-compare channels used for two-PWM motor drive on D3/D5/D6/D7. |
| PCINT | Pin-change interrupt — ATmega2560 interrupt group fired on any change in a port register. Used for right-encoder quadrature (Port B). |
| PCIE0 / PCMSK0 | Pin-change interrupt enable / mask registers for Port B (right encoder, D51/D52). |
| `cdc_acm` | Linux kernel module for USB CDC ACM devices (USB serial — the MCU↔Jetson link). |
| DWB | Dynamic Window Approach — the local planner plugin used by Nav2 for obstacle avoidance. |
| DWA Planner | Nav2 local planner that samples velocities within the robot's dynamic window. |
| `ros:humble-ros-base` | Official ROS 2 Humble base Docker image used for both Jetson and web containers. |
| `network_mode: host` | Docker networking mode where the container shares the host's network namespace — required for CycloneDDS unicast discovery over Tailscale. |
| CRC-8 | Cyclic redundancy check (8-bit) used in the MCU↔Jetson serial protocol for packet integrity. |
| `ROS_DOMAIN_ID` | ROS 2 namespace selector; ROBO_ULTRON uses ID 42 to avoid conflicting with other ROS 2 networks on the same LAN. |
| `depth_to_scan` | Onboard node that projects Kinect depth frames into a 2D laser-scan message for Nav2 consumption. |
| Bag | Recorded ROS 2 message log (rosbag2); pilot data archive format. |
| Quality gate | A pass/fail check at defined milestones (Gates A–F); see `docs/20_engineering_process/quality_gates.md`. |
| ADR | Architecture Decision Record — documents the "why" behind significant design choices. |
