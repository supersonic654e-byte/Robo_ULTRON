# ADR-0002: Two-PWM BTS7960 native drive

- **Date:** 2026-08-08
- **Status:** Accepted
- **Bible reference:** §0.1 v4.2r2 D1, §2.1, §2.2, §11.3

## Context

The IBT-2 motor driver uses the BTS7960 H-bridge IC, which has **two PWM inputs
(RPWM, LPWM) and one enable (EN) per half-bridge — no DIR pin**. The original v4.2
firmware drove it with a single PWM pin plus a DIR pin held high (1-PWM + 1-DIR
scheme). This was electrically incorrect: with LPWM=1 the BTS7960 latches M- to
B+, giving reverse with inverted duty — not clean bidirectional drive.

## Decision

- Use **native two-PWM per motor** (one PWM per direction), matching the BTS7960
  datasheet:
  - **Left motor:** Timer4 — OC4A = D6 (forward), OC4B = D7 (reverse)
  - **Right motor:** Timer3 — OC3A = D5 (forward), OC3C = D3 (reverse)
  - Both EN pins (D4, D8) held HIGH permanently.
- Fast PWM mode, ICRn as TOP, prescaler 8, TOP = 99 → **20 kHz**.
- Timer1 and Timer2 are unused by motor drive.

## Consequences

- Correct: both BTS7960 half-bridges receive proper PWM control — forward is
  RPWM=PWM/LPWM=0, reverse is RPWM=0/LPWM=PWM.
- Hardware-compatible: no wiring change needed (the IBT-2 boards expose both
  RPWM and LPWM pins).
- Cost: four PWM pins consumed (D3, D5, D6, D7) plus two GPIO EN pins (D4, D8).
  All on pins that do not conflict with encoders or E-stop.
