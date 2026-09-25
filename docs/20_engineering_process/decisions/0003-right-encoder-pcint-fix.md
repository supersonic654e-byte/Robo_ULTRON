# ADR-0003: Right-encoder Port-A → Port-B PCINT fix

- **Date:** 2026-08-08
- **Status:** Accepted
- **Bible reference:** §0.1 B1, §2.2 pin mapping, §11.3 config.h + encoders.cpp

## Context

Quadrature encoders need an interrupt on at least one channel per wheel to count
ticks. The ATmega2560 has two kinds of pin-change interrupts:

- **External interrupts** (INT0–INT5) on specific Port D/E pins — hardware-level.
- **Pin-change interrupts** (PCINT0–PCINT23) grouped by port — fires on any change
  in the group, ISR must read the full port register.

The left encoder was on D18/D19 (INT3/INT2, Port D) — correct. The right encoder
was assigned to D23/D24 on **Port A** in v4.0/4.1. However, the ATmega2560 has **no
pin-change interrupt capability on Port A**, so the ISR never fired and right-wheel
odometry was always zero.

## Decision

- Move the right encoder to **D52 (PB1 = PCINT1) / D51 (PB2 = PCINT2)** on
  **Port B**, which has the PCIE0 pin-change group (PCMSK0).
- The ISR (`ISR(PCINT0_vect)`) reads `PINB` to determine which pin changed, then
  reads the paired pin for direction — same decode logic as the left encoder.

## Consequences

- Fixed: right-wheel odometry now counts correctly.
- Minor cost: D51/D52 are on the Arduino Mega's "digital" header, easily accessible;
  no physical PCB change required (jumper wires on proto-board).
- The fix is a one-time hardware rewire + firmware ISR update. All future builds
  must use Port B (or Port D/E) for encoder interrupts.
