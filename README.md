# VLSI-DESIGN-AUTOMATION

## Spec2RTL Agent – Spec-to-Tapeout Pipeline

---

## Overview

This project implements a **local spec-aware AI agent** that converts YAML hardware specifications into:

* Synthesizable Verilog RTL
* Self-checking testbenches
* Gate-level netlists
* Physical design outputs (OpenROAD)

The system includes a **feedback-driven repair loop** to automatically fix failures during simulation and synthesis.

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

## Quick Start (Reproducibility)

Clone the repository:

```bash
git clone https://github.com/hdeivasi-oss/VLSI-DESIGN-AUTOMATION
cd VLSI-DESIGN-AUTOMATION
```

Run the full pipeline:

```bash
python3 agent.py --all specs/
```

This single command will:

* Generate RTL and testbenches
* Run simulation (Icarus Verilog)
* Perform synthesis (Yosys)
* Run OpenROAD flow
* Generate logs and reports

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

---

## File Generation and Locations

| Stage                | Generated Files         | Location                                    |
| -------------------- | ----------------------- | ------------------------------------------- |
| Spec input           | YAML spec               | `specs/<spec_name>.yaml`                    |
| RTL generation       | Candidate RTL           | `output/<spec_name>/design_candidate.v`     |
| Testbench generation | Candidate testbench     | `output/<spec_name>/tb_candidate.v`         |
| Final RTL            | Synthesizable RTL       | `output/<spec_name>/design.v`               |
| Final Testbench      | Self-checking testbench | `output/<spec_name>/tb.v`                   |
| Simulation output    | Executable              | `output/<spec_name>/sim.out`                |
| Synthesis            | Netlist                 | `output/<spec_name>/Synthesis/design_syn.v` |
| OpenROAD results     | Physical design outputs | `output/<spec_name>/openroad/`              |
| Logs                 | Execution logs          | `logs/<spec_name>/`                         |
| Summary              | Final results           | `summary_table.md`, `summary_table.csv`     |

---

## Example Outputs

From your repository (example: `p1`):

* RTL: `output/p1/design.v`
* Testbench: `output/p1/tb.v`
* Simulation executable: `output/p1/sim.out`
* Synthesis results: `output/p1/Synthesis/`
* OpenROAD results: `output/p1/openroad/`

A successful run produces:

```text
TEST PASSED
=== FINAL STATUS: PASS (timing met) ===
```

---

## Viewing Results

After execution, results are summarized in:

* `summary_table.md` → formatted table
* `summary_table.csv` → raw data

To view:

```bash
cat summary_table.md
```

👉 Best viewed on GitHub (renders as table)

---

## Expected Results

Each spec should pass:

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
5. Apply repair if needed
6. Run synthesis
7. Gate-level simulation
8. Run OpenROAD
9. Check timing and outputs
10. Generate reports

---

## Hidden Testcases

1. Add new YAML spec to:

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

## Notes

* Fully automated pipeline (no manual steps)
* Rule-based repair mechanism
* Designed for reproducibility
* Supports multiple hardware designs

---
