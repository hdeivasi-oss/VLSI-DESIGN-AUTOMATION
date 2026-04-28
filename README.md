# Spec2RTL Agent – Topic 1 (Spec-to-Tapeout)

## Overview

This project implements a **local spec-aware AI agent** that converts hardware specifications into synthesizable Verilog RTL and self-checking testbenches. The system automatically verifies correctness using simulation and applies a **feedback-driven repair loop** when failures occur.

The workflow is fully automated and reproducible with a **single command**.

---

## Setup Instructions

### Requirements

- Python 3.10+
- Icarus Verilog (iverilog + vvp)

### Install Python dependencies
No external dependencies required (uses standard Python libraries).

### Install Icarus Verilog

#### Windows
Download from: https://bleyer.org/icarus/

Make sure `iverilog` and `vvp` are added to PATH.

#### Linux (Ubuntu)
```bash
sudo apt update
sudo apt install iverilog
```

#### macOS (Homebrew)
```bash
brew install icarus-verilog
```

---

## How to Run the System

Run the entire pipeline with a single command:

```bash
python agent.py
```

This will:
1. Select a spec
2. Generate RTL and testbench
3. Compile using `iverilog -g2012`
4. Run simulation using `vvp`
5. Apply automatic repair if needed
6. Save results and logs

---

## Input / Output Description

### Input

YAML hardware specifications located in:

```
specs/
```

Examples:
- `p1.yaml` – sequence detector
- `p5.yaml` – dot product
- `p7.yaml` – fixed-point exponential
- `p8.yaml` – FP16 multiplier
- `p9.yaml` – FIR filter

---

### Output

Generated files are organized per spec:

```
generated/<spec_id>/
    design.v
    tb.v
    sim.out

logs/<spec_id>/
    compile.log
    sim.log
    reports/
        attempt_01.yaml
        attempt_02.yaml
        ...
```

Each attempt report includes:
- attempt number
- RTL strategy
- testbench strategy
- compile/simulation status
- failure classification
- tool outputs

---

## Expected Results

For a correct run:

- `iverilog` compiles successfully
- `vvp` simulation runs without errors
- Output includes:

```
TEST PASSED
```

If initial generation fails:
- The agent retries with alternate strategies
- Converges within a bounded number of attempts

---

## Workflow Description

The system follows a closed-loop agent workflow:

```
Spec → RTL/TB Generation → Compile → Simulate → Diagnose → Repair → Retry
```

Steps:
1. Parse YAML spec
2. Select generation strategy
3. Generate RTL + testbench locally
4. Compile using Icarus Verilog
5. Run simulation
6. If failure:
   - classify error
   - switch strategy
   - regenerate
7. Repeat until pass or max attempts reached

---

## How to Run Hidden Testcases

1. Add a new YAML spec into:

```
specs/
```

2. Ensure it follows a supported structure (or extend the agent)

3. Run:

```bash
python agent.py
```

4. Results will be generated under:

```
generated/<new_spec>/
logs/<new_spec>/
```

---

## Repository Structure

```
Spec2RTL/
├── agent.py
├── run_sim.py
├── specs/
├── generated/
├── logs/
├── AGENTS.md
└── README.md
```

---

## Notes

- The system is **spec-family aware**, not fully general
- Repair logic is **rule-based**
- Designed for reproducibility and automation
- Supports multiple hardware design types

---

## Reproducibility

To reproduce results:

```bash
git clone <repo>
cd Spec2RTL
python agent.py
```

Expected:
- No manual steps required
- Logs and outputs generated automatically
- PASS results for supported specs