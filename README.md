# Comparative Study of Fast and Low-Power Adder Architectures

A hands-on **RTL-to-GDS VLSI project** focused on the design, verification, synthesis, physical implementation, and PPA comparison of three adder architectures:

- **Ripple Carry Adder (RCA)**
- **Carry Look-Ahead Adder (CLA)**
- **Kogge–Stone Adder (KSA)**

The project is based on the proposed study **“Comparative Study of Fast and Low-Power Adder Architectures from RTL to GDS using SKY130 Technology.”** The objective is to understand how architectural differences affect **power, performance, area, timing, routing, congestion, buffering, and parasitic effects** from RTL through physical implementation. fileciteturn9file0L19-L39

> **Project status:** RCA and CLA RTL implementations are currently present in this repository. KSA is the next architecture being added. The full RTL-to-GDS flow and multi-bit-width study are planned stages of the project.

---

## Project Overview

Digital adders are fundamental building blocks in processors, ALUs, DSP systems, and other VLSI architectures. Different adder architectures make different trade-offs between carry propagation, speed, area, power, and implementation complexity.

This project studies RCA, CLA, and KSA under a **common implementation methodology**, rather than comparing them only at RTL. The proposed flow takes each architecture through:

```text
Architecture Specification
        ↓
Structural RTL Design
        ↓
Functional Simulation & Verification
        ↓
Logic Synthesis
        ↓
Floorplanning & Placement
        ↓
Routing & Parasitic Analysis
        ↓
Timing & Power Analysis
        ↓
Physical Verification
        ↓
GDSII Generation
        ↓
PPA Comparison
```

The project synopsis specifies a common RTL-to-GDS methodology using **SkyWater 130 nm**, with the intention of keeping technology, design width, library, and physical constraints consistent across architectures. fileciteturn9file0L56-L85

---

## Current Project Status

| Architecture | Current RTL | Verification | Planned Physical Flow |
|---|---:|---:|---:|
| Ripple Carry Adder (RCA) | ✅ 4-bit | ✅ Testbench + waveform | 🔄 Planned |
| Carry Look-Ahead Adder (CLA) | ✅ 4-bit | ✅ Exhaustive 512-case test | 🔄 Planned |
| Kogge–Stone Adder (KSA) | 🔄 To be added | 🔄 Planned | 🔄 Planned |

The long-term study targets multiple widths such as **4, 8, 16, 32, and 64 bits** to analyze how architecture and bit-width scaling affect PPA and physical characteristics. fileciteturn9file0L113-L124

---

# 1. Ripple Carry Adder (RCA)

The **Ripple Carry Adder** is a simple adder architecture in which the carry output of one full-adder stage becomes the carry input of the next stage.

### 4-bit structure

```text
A0, B0, Cin → FA0 → C1
A1, B1, C1  → FA1 → C2
A2, B2, C2  → FA2 → C3
A3, B3, C3  → FA3 → Cout
```

The RCA provides a simple baseline architecture against which faster carry-computation architectures can be compared.

### Current Files

- `RAC/RAC_4bit.v` — 4-bit RCA implementation
- `RAC/RAC_4bit_tb.v` — testbench
- `RAC/output.vcd` — simulation waveform
- `RAC/rac_4bit_tb.vcd` — waveform dump

---

# 2. Carry Look-Ahead Adder (CLA)

The **Carry Look-Ahead Adder** reduces serial carry propagation by using generate and propagate signals.

For each bit:

```text
P_i = A_i XOR B_i
G_i = A_i AND B_i
```

The carry equations are expanded so that carries can be calculated using combinational logic rather than waiting for the carry to ripple through every previous stage.

The current implementation is a **gate-level Verilog CLA** using XOR, AND, OR, and buffer primitives.

### Current Files

- `CLA/CLA_4bit.v` — 4-bit gate-level CLA
- `CLA/CLA_4bit_tb.v` — exhaustive testbench
- `CLA/CLA_4bit_gate_level.vcd` — simulation waveform

### Verification

The testbench checks all **512 possible input combinations**:

- 4-bit A
- 4-bit B
- 1-bit carry-in

The generated result is compared against the expected 5-bit result:

```text
{cout, sum}
```

---

# 3. Kogge–Stone Adder (KSA)

The **Kogge–Stone Adder** is a parallel-prefix adder architecture designed for fast carry computation using a prefix tree.

The project synopsis specifically includes KSA as the third architecture and includes an **8-bit Kogge–Stone block diagram** as part of the proposed architecture study. fileciteturn9file0L145-L165

### Planned Implementation

The KSA development will include:

- Structural Verilog implementation
- Prefix generate/propagate network
- Carry computation
- Sum generation
- Dedicated testbench
- Exhaustive functional verification
- VCD waveform generation
- Multiple-width implementations
- Comparison against RCA and CLA

### KSA Concept

The architecture will use prefix operations to combine generate/propagate information across multiple bit positions.

Conceptually:

```text
Input A/B
   ↓
Generate / Propagate
   ↓
Prefix Network
   ↓
Carry Computation
   ↓
XOR Sum Generation
```

The objective is not to assume that KSA is always superior, but to measure how its architectural characteristics translate into actual **timing, area, power, routing, and congestion** after implementation.

---

# Architecture Comparison

The three architectures will ultimately be evaluated under common conditions.

| Metric | What will be studied |
|---|---|
| **Area** | Standard-cell area and final physical area |
| **Performance** | Critical input-to-output path delay |
| **Power** | Power consumption under consistent analysis conditions |
| **Utilization** | Physical resource utilization |
| **Wirelength** | Interconnect requirements |
| **Congestion** | Routing congestion |
| **Buffering** | Number/effect of inserted buffers |
| **Parasitics** | Resistance and capacitance effects |
| **Scaling** | Effect of increasing bit width |
| **Timing response** | Behavior under common timing constraints |

These comparison parameters are directly aligned with the project synopsis, which proposes studying area, performance, power, utilization, wirelength, routing congestion, buffering, parasitics, and architecture scaling. fileciteturn9file0L90-L104

---

# RTL-to-GDS Implementation Flow

## 1. RTL Design and Verification

Develop RCA, CLA, and KSA in **Verilog HDL** and verify their functional behavior.

```text
RTL
 ↓
Testbench
 ↓
Simulation
 ↓
Functional Verification
```

## 2. Logic Synthesis

Use **Yosys** to synthesize RTL into technology-mapped gate-level netlists using the Sky130 standard-cell library.

## 3. Floorplanning and Placement

Use **OpenROAD** for floorplanning and placement while maintaining consistent implementation conditions across the architectures.

## 4. Routing

Complete physical routing and analyze the effects of interconnect resistance and capacitance.

## 5. Timing Analysis

Use **OpenSTA** to evaluate critical paths, delay, slack, and timing characteristics.

## 6. Power Analysis

Collect power results under consistent analysis assumptions to enable meaningful comparison.

## 7. Physical Verification and Layout

Use **Magic** and **KLayout** for layout inspection and physical verification.

## 8. GDSII Generation

Generate the final physical layout and **GDSII** output.

The project is explicitly intended to generate reproducible RTL, synthesized netlists, SDC constraints, DEF files, timing/power reports, physical-layout views, and GDSII outputs. fileciteturn9file0L108-L112

---

# Clock-Free Physical Implementation

RCA, CLA, and KSA in this study are **combinational circuits**.

Therefore:

- No clock-tree synthesis is required.
- The main focus is on combinational data paths.
- Timing is evaluated from input-to-output paths.
- Physical effects such as wire delay, buffering, routing congestion, and parasitics become important.

This matches the proposed methodology in the project synopsis. fileciteturn9file0L71-L85

---

# PPA / Physical Analysis

A major objective of this project is to compare **Power, Performance, and Area (PPA)** after implementation instead of relying only on theoretical RTL behavior.

The study will investigate:

```text
             ┌──────────────┐
             │   Architecture│
             └──────┬───────┘
                    ↓
              RTL / Synthesis
                    ↓
          ┌─────────┼─────────┐
          ↓         ↓         ↓
        Area     Timing     Power
          │         │         │
          └─────────┼─────────┘
                    ↓
          Physical Implementation
                    ↓
      Routing + Parasitic Extraction
                    ↓
            Post-Layout PPA
```

The project also studies **physical characteristics** such as routing congestion, wirelength, buffering, and parasitic effects, because these can change the behavior observed at RTL or synthesis. fileciteturn9file0L93-L104

---

# Bit-Width Scaling

The planned study includes:

```text
4-bit
  ↓
8-bit
  ↓
16-bit
  ↓
32-bit
  ↓
64-bit
```

For each width, the project will investigate how the architecture affects:

- Area
- Critical-path delay
- Power
- Wirelength
- Routing congestion
- Buffering
- Parasitic effects

The measured scaling will then be compared with the expected architectural behavior of RCA, CLA, and KSA. fileciteturn9file0L137-L141

---

# Verification Strategy

The current project uses exhaustive functional verification for the 4-bit designs.

Future verification will follow:

```text
RTL Design
    ↓
Testbench
    ↓
Exhaustive / Directed Tests
    ↓
Expected vs Actual
    ↓
PASS / FAIL
    ↓
Waveform Analysis
```

Only designs that pass functional verification should proceed to synthesis and physical implementation.

---

# Project Structure

Current repository structure:

```text
mega_project_2026/
│
├── CLA/
│   ├── CLA_4bit.v
│   ├── CLA_4bit_tb.v
│   ├── CLA_4bit_gate_level.vcd
│   └── a.out
│
├── RAC/
│   ├── RAC_4bit.v
│   ├── RAC_4bit_tb.v
│   ├── output.vcd
│   ├── rac_4bit_tb.vcd
│   └── a.out
│
└── README.md
```

> **Note:** `a.out` files are generated simulation executables and are not RTL source files.

As KSA and the RTL-to-GDS flow are implemented, additional directories for KSA, synthesis, constraints, physical design, reports, and GDSII outputs can be added.

---

# Tools and Technologies

### RTL / Verification

- **Verilog HDL**
- **Icarus Verilog**
- **GTKWave / VCD**

### Synthesis

- **Yosys**

### Physical Design

- **OpenROAD**

### Timing Analysis

- **OpenSTA**

### Physical Verification / Layout

- **Magic VLSI**
- **KLayout**

### Technology

- **SkyWater SKY130 — 130 nm open-source PDK**

The synopsis identifies Yosys, OpenROAD, OpenSTA, Magic, KLayout, and the SkyWater SKY130 PDK as the intended open-source implementation stack. fileciteturn9file0L171-L192

---

# Expected Outputs

The planned final project will produce:

- RTL source files
- Testbenches
- Simulation waveforms
- Synthesized gate-level netlists
- SDC constraints
- Synthesis reports
- DEF files
- Floorplan and placement results
- Routed designs
- Timing reports
- Power reports
- Physical-layout views
- GDSII files
- Comparative PPA results

The project synopsis describes these outputs as part of the intended reproducible RTL-to-GDS flow. fileciteturn9file0L108-L112

---

# Project Objectives

1. Design and functionally verify RCA, CLA, and KSA using Verilog HDL.
2. Implement the architectures at multiple widths including **4, 8, 16, 32, and 64 bits**.
3. Synthesize all architectures using the same SkyWater 130 nm standard-cell library.
4. Apply consistent physical-design conditions to make the comparison meaningful.
5. Perform floorplanning, placement, routing, and parasitic extraction.
6. Measure **area, power, and critical-path delay**.
7. Analyze the effect of bit-width scaling.
8. Compare theoretical architectural behavior with measured post-layout behavior.
9. Study routing congestion, wirelength, buffering, and parasitic effects.
10. Build a reproducible open-source **RTL-to-GDS** implementation flow. fileciteturn9file0L113-L124

---

# Roadmap

```text
                    ┌─────────────────────┐
                    │ Architecture Study  │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │    RTL Development  │
                    └──────────┬──────────┘
                               ↓
                ┌──────────────┼──────────────┐
                ↓              ↓              ↓
              RCA            CLA            KSA
                └──────────────┼──────────────┘
                               ↓
                    Functional Verification
                               ↓
                         RTL Synthesis
                               ↓
                    Floorplan + Placement
                               ↓
                            Routing
                               ↓
                    Parasitic Extraction
                               ↓
                    Timing + Power Analysis
                               ↓
                         PPA Comparison
                               ↓
                       Physical Verification
                               ↓
                           GDSII
```

## Milestones

- [x] RCA 4-bit RTL
- [x] RCA 4-bit testbench
- [x] RCA simulation waveform
- [x] CLA 4-bit RTL
- [x] CLA 4-bit exhaustive verification
- [x] CLA simulation waveform
- [ ] KSA RTL
- [ ] KSA testbench
- [ ] KSA verification
- [ ] Multi-width implementations
- [ ] Yosys synthesis flow
- [ ] Sky130 technology mapping
- [ ] OpenROAD physical design
- [ ] OpenSTA timing analysis
- [ ] Power analysis
- [ ] Magic / KLayout physical verification
- [ ] GDSII generation
- [ ] Final PPA comparison

---

# Learning Outcomes

This project is intended to provide practical experience with:

- RTL design
- Structural Verilog
- Digital arithmetic architectures
- Carry propagation and prefix computation
- Functional verification
- Logic synthesis
- Technology mapping
- Floorplanning
- Placement
- Routing
- Static timing analysis
- Power analysis
- Parasitic-aware analysis
- Physical verification
- GDSII generation
- PPA-driven architecture comparison

---

## Project Team

The project synopsis lists the project group as:

- **Prathamesh Shirish Pachore**
- **Krishna Nandkumar Bhosale**
- **Ankit Gajanand Saini**

The synopsis identifies the work as a project of the **Department of Electronics Engineering, Walchand College of Engineering, Sangli**. fileciteturn9file0L8-L17

---

## Author

**Ankit Saini**

This repository is part of an ongoing digital design and VLSI project focused on understanding the complete path from **RTL architecture to physical silicon implementation**.
