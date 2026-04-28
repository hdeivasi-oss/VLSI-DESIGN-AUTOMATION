# VLSI-DESIGN-AUTOMATION

## Spec2RTL Agent – Spec-to-Tapeout Pipeline

---

## Overview

This project implements a **local spec-aware AI agent** that converts hardware specifications (YAML) into:

* Synthesizable Verilog RTL
* Self-checking testbenches
* Gate-level netlists
* Physical design outputs (OpenROAD)

The system performs **end-to-end verification and repair** using a feedback-driven loop.

* Fully automated
* Single-command execution
* Reproducible pipeline

---

## Setup Instructions (WSL Ubuntu 22.04)

### Requirements

* Python 3.10+
* WSL (Ubuntu 22.04)
* Icarus Verilog (`iverilog`, `vvp`)
* Yosys
* OpenROAD

---

### Install Icarus Verilog

```bash
sudo apt update
sudo apt install -y iverilog
```

Verify:

```bash
iverilog -V
vvp -V
```

---

### Install Yosys

```bash
sudo apt install -y yosys
```

Verify:

```bash
yosys -V
```

---

### Install OpenROAD

```bash
cd ~
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
./setup.sh
./build_openroad.sh --local
```

Add to PATH:

```bash
echo 'export PATH=$HOME/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Verify:

```bash
openroad
```

---

## How to Run (Single Command)

```bash
python3 agent.py --all specs/
```

✔ This satisfies the requirement: *single entry point execution* 

---

## Input

YAML specifications located in:

```text
specs/
```

Examples:

* `p1.yaml` – sequence detector
* `p5.yaml` – dot product
* `p7.yaml` – exponential
* `p8.yaml` – FP16 multiplier
* `p9.yaml` – FIR filter

---

## Output

Generated per spec under:

```text
output/<spec_name>/
logs/<spec_name>/
```

Includes:

* RTL + Testbench
* Simulation logs
* Synthesis results
* OpenROAD outputs

---

## Expected Results

After running:

```bash
python3 agent.py --all specs/
```

Each spec should produce:

* RTL: `design.v`
* Testbench: `tb.v`
* Netlist: `design_syn.v`
* OpenROAD outputs

Simulation output:

```text
TEST PASSED
```

Final status:

```text
=== FINAL STATUS: PASS (timing met) ===
```

Checks:

```text
rtl_validation=PASS
behavioral_sim=PASS
synthesis=PASS
gls=PASS
openroad=PASS
```

---

## Workflow

1. Read YAML specs
2. Generate RTL + Testbench
3. Validate RTL (Yosys)
4. Run simulation (Icarus Verilog)
5. Repair if needed
6. Run synthesis
7. Gate-level simulation
8. Run OpenROAD
9. Check timing
10. Generate reports

---

## Hidden Testcases

To run additional specs:

1. Add YAML file to:

```text
specs/
```

2. Run:

```bash
python3 agent.py --all specs/
```

---

## Project Structure

```text
Spec_to_Tapeout-main/
├── specs/
├── agent.py
├── run_sim.py
├── summary_table.py
├── output/
├── logs/
├── openroad_runs/
├── generated/
├── summary_table.csv
├── summary_table.md
└── AGENTS.md
```

---

## Reproducibility

```bash
git clone <your-repo-link>
cd VLSI-DESIGN-AUTOMATION
python3 agent.py --all specs/
summary_table.md
```

---

## Notes

* Fully automated pipeline (no manual steps)
* Supports multiple hardware designs
* Repair is rule-based
* Designed for reproducibility

---
