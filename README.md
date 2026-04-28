
# Spec2RTL Agent – Topic 1 (Spec-to-Tapeout)

## Overview

This project implements a **local spec-aware AI agent** that converts hardware specifications into synthesizable Verilog RTL and self-checking testbenches. The system automatically verifies correctness using simulation and applies a **feedback-driven repair loop** when failures occur.

The workflow is fully automated and reproducible with a **single command**.
In this project I have installed WSL to access Ubuntu there I installed Iverilog, Yosys, Openroad.
--- 

## Setup Instructions

### Requirements

- Python 3.10+
- WSL Ubuntu 22.04
- Icarus Verilog (iverilog + vvp)
- Yosys
- OpenRoad
### Clone the repository
The link which have uploaded in the canvas.

### Install Python dependencies
No external dependencies required (uses standard Python libraries).

#### Windows
Download from: https://bleyer.org/icarus/

### Install Icarus Verilog in Ubuntu
```bash
sudo apt install -y iverilog
```
Make sure `iverilog` and `vvp` are added to PATH.

#### macOS (Homebrew)
```bash
brew install icarus-verilog
```
### Install Yosys in Ubuntu
```bash
sudo apt install -y yosys
```
### Install Openroad in Ubuntu
# 1. Clone the repository
```bash
cd ~
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
./setup.sh
./build_openroad.sh --local

## Add path is important
echo 'export PATH=$HOME/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH' >> ~/.bashrc
source ~/.bashrc


### How to Run the System
Run the entire pipeline with a single command:
```bash
python3 agent.py --all specs/
```
This will:
1. Read every YAML spec from the specs/ directory.
2. Create separate output and log folders for each spec.
3. Parse the module name, ports, parameters, clock/reset behavior, and expected functionality.
4. Generate synthesizable Verilog RTL for each spec.
5. Generate a deterministic self-checking Verilog testbench.
6. Preserve the module name and port names exactly as defined in the YAML.
7. Run RTL validation using Yosys sanity checks.
8. Compile the RTL and testbench using Icarus Verilog.
9. Run behavioral simulation using vvp
10. If simulation fails, inspect logs and try the available repair strategy.
11. Run synthesis using Yosys after RTL simulation passes.
12. Run gate-level simulation using the synthesized netlist.
13. Run OpenROAD by default after GLS, unless disabled by flag, environment variable, or spec setting.
14. Collect timing and physical design results such as WNS, TNS, WHS, area, DEF, GDS, logs, and reports.
15. Mark a spec as passed only when RTL sim, synthesis, GLS, OpenROAD, final artifacts, and timing checks pass.
16. Continue running the remaining specs even if one spec fails.
17. Write per-spec outputs under output/<spec_name>/.
18. Write per-spec logs and attempt reports under logs/<spec_name>/.
19. Generate final summary files: summary_table.csv and summary_table.md.
20. Print an overall pass/fail summary for all specs at the end.

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
  Also I have used some cases from GPT p2.yaml, p3.yaml, p4.yaml, p10.yaml

---

### Output

### File Generation and Locations

| Stage                     | Generated Files                     | Location |
|--------------------------|------------------------------------|----------|
| Spec input               | Existing YAML spec                 | `specs/<spec_name>.yaml` |
| RTL/TB generation        | Candidate RTL                      | `output/<spec_name>/design_candidate.v` |
| RTL/TB generation        | Candidate testbench                | `output/<spec_name>/tb_candidate.v` |
| Generation logs          | Generator/Codex log                | `logs/<spec_name>/attempt_XX_generation.log` |
| RTL validation           | Yosys sanity script                | `output/<spec_name>/Synthesis/sanity_check.ys` |
| RTL validation           | Validation log                     | `logs/<spec_name>/attempt_XX_validation.log` |
| RTL validation           | Yosys sanity log                   | `logs/<spec_name>/attempt_XX_yosys_check_rN.log` |
| RTL repair               | Repair log (if attempted)          | `logs/<spec_name>/attempt_XX_repair.log` |
| RTL simulation compile   | Compiled simulation executable     | `output/<spec_name>/sim.out` |
| RTL simulation compile   | Compile log                        | `logs/<spec_name>/attempt_XX_compile.log` |
| RTL simulation run       | Simulation log                     | `logs/<spec_name>/attempt_XX_sim.log` |
| Final RTL/TB promotion   | Final RTL                          | `output/<spec_name>/design.v` |
| Final RTL/TB promotion   | Final testbench                    | `output/<spec_name>/tb.v` |
| Synthesis                | Yosys synthesis script             | `output/<spec_name>/Synthesis/synth.ys` |
| Synthesis                | Gate-level netlist                 | `output/<spec_name>/Synthesis/design_syn.v` |
| Synthesis                | Synthesis log                      | `output/<spec_name>/Synthesis/synth.log` |
| Gate-level simulation    | GLS executable                     | `output/<spec_name>/Synthesis/gls_sim.out` |
| Gate-level simulation    | GLS log                            | `output/<spec_name>/Synthesis/gls_sim.log` |
| OpenROAD setup           | Netlist copy                       | `output/<spec_name>/openroad/design_syn.v` |
| OpenROAD setup           | Config file                        | `output/<spec_name>/openroad/config.mk` |
| OpenROAD setup           | Timing constraints                 | `output/<spec_name>/openroad/constraint.sdc` |
| OpenROAD run             | Run log                            | `output/<spec_name>/openroad/openroad_run.log` |
| OpenROAD results         | Physical design outputs            | `output/<spec_name>/openroad/results/base/` |
| OpenROAD logs            | Stage logs & metrics               | `output/<spec_name>/openroad/logs/base/` |
| OpenROAD reports         | Timing/area/routing reports        | `output/<spec_name>/openroad/reports/base/` |
| Attempt report           | Per-attempt YAML report            | `logs/<spec_name>/reports/attempt_XX.yaml` |
| All-spec summary         | CSV summary                        | `summary_table.csv` |
| All-spec summary         | Markdown summary                   | `summary_table.md` |

---

### Important Final Artifacts (OpenROAD)

- `output/<spec_name>/openroad/results/base/6_final.def`
- `output/<spec_name>/openroad/results/base/6_final.gds`
- `output/<spec_name>/openroad/logs/base/6_report.log`
- `output/<spec_name>/openroad/logs/base/6_report.json`
- `output/<spec_name>/openroad/reports/base/6_finish.rpt`
 ------------

## Expected Results

Expected Results After Running python3 agent.py --all specs/

- Each YAML spec in specs/ should be processed independently.
- For every spec, the agent should generate:
  - Synthesizable RTL: output/<spec_name>/design.v
  - Self-checking testbench: output/<spec_name>/tb.v
  - Synthesized netlist: output/<spec_name>/Synthesis/design_syn.v
  - OpenROAD physical design outputs under output/<spec_name>/openroad/
- RTL simulation is expected to pass with the testbench printing:

TEST PASSED

- Each spec should pass these checks:

rtl_validation=PASS
behavioral_sim=PASS
synthesis=PASS
gls=PASS
openroad=PASS

- A fully successful spec should end with:

=== FINAL STATUS: PASS (timing met) ===

- The final attempt report should contain:

final_status: "PASS"
passed: true
flow_pass: true
compile_pass: true
sim_pass: true
synthesis_pass: true
gls_pass: true
openroad_pass: true
setup_pass: true
hold_pass: true
meets_timing: true


- OpenROAD is expected to generate final physical design files such as:

output/<spec_name>/openroad/results/base/6_final.def
output/<spec_name>/openroad/results/base/6_final.gds
output/<spec_name>/openroad/reports/base/6_finish.rpt
output/<spec_name>/openroad/logs/base/6_report.json


- At the end of all specs, the agent prints an overall summary like:

[agent] overall_summary: total_specs=<N> passed=<N> failed=0


- The final summary files should be generated at:

summary_table.csv
summary_table.md


- If any stage fails, the spec is marked FAIL, but the agent continues running the remaining specs. Failure details are stored in:

logs/<spec_name>/reports/attempt_XX.yaml
logs/<spec_name>/attempt_XX_compile.log
logs/<spec_name>/attempt_XX_sim.log
output/<spec_name>/Synthesis/synth.log
output/<spec_name>/Synthesis/gls_sim.log
output/<spec_name>/openroad/openroad_run.log

## Workflow Description

1. Read all specs
   - The agent reads YAML hardware specs from specs/.
   - Each spec is handled independently.

2. Create output folders
   - For each spec, the agent creates:
     - output/<spec_name>/
     - logs/<spec_name>/
     - logs/<spec_name>/reports/

3. Generate RTL and testbench
   - The agent generates synthesizable Verilog RTL.
   - It also generates a deterministic self-checking Verilog testbench.
   - Generated candidate files are:
     - output/<spec_name>/design_candidate.v
     - output/<spec_name>/tb_candidate.v

4. Validate RTL
   - The RTL is checked for synthesizable Verilog style.
   - Yosys sanity checks are run before simulation.
   - If RTL validation fails, the agent attempts repair.

5. Run RTL simulation
   - The agent compiles RTL and testbench using Icarus Verilog.
   - It runs the simulation using vvp.
   - The testbench checks expected behavior automatically.
   - If simulation fails, logs are inspected and repair is attempted.

6. Promote passing RTL/testbench
   - Once RTL simulation passes, the candidate files are promoted to:
     - output/<spec_name>/design.v
     - output/<spec_name>/tb.v

7. Run synthesis
   - The agent runs Yosys synthesis.
   - It generates a synthesized netlist:
     - output/<spec_name>/Synthesis/design_syn.v

8. Run gate-level simulation
   - The synthesized netlist is simulated with the same testbench.
   - This confirms the synthesized design still matches the expected behavior.

9. Run OpenROAD
   - After GLS passes, OpenROAD runs by default.
   - OpenROAD performs physical design flow steps such as floorplanning, placement, CTS, routing, and final reporting.
   - It generates DEF, GDS, timing reports, logs, and metrics.

10. Check timing and artifacts
    - The agent checks that OpenROAD completed successfully.
    - It verifies final artifacts exist.
    - It checks timing results such as setup and hold slack.

11. Generate reports
    - For each attempt, a YAML report is written under:
      - logs/<spec_name>/reports/attempt_XX.yaml
    - At the end, summary files are generated:
      - summary_table.csv
      - summary_table.md
-----------------

## How to Run Hidden Testcases

1. Add a new YAML spec into:

```
specs/
```

2. Ensure it follows a supported structure (or extend the agent)

3. Run:

```bash
python3 agent.py --all specs/
```

4. Results will be generated under:

```
generated/<new_spec>/
logs/<new_spec>/
```

---

## Repository Structure

## Project Structure

```text
Spec_to_Tapeout-main/
├── specs/
│   ├── p1.yaml
│   ├── p2.yaml
│   ├── ...
│   └── p10.yaml
│
├── agent.py
├── run_sim.py
├── summary_table.py
│
├── output/
│   └── <spec_name>/
│       ├── design_candidate.v
│       ├── tb_candidate.v
│       ├── design.v
│       ├── tb.v
│       ├── sim.out
│       ├── Synthesis/
│       │   ├── sanity_check.ys
│       │   ├── synth.ys
│       │   ├── synth.log
│       │   ├── design_syn.v
│       │   ├── gls_sim.out
│       │   └── gls_sim.log
│       └── openroad/
│           ├── config.mk
│           ├── constraint.sdc
│           ├── design_syn.v
│           ├── openroad_run.log
│           ├── logs/
│           ├── reports/
│           └── results/
│
├── logs/
│   └── <spec_name>/
│       ├── attempt_XX_generation.log
│       ├── attempt_XX_validation.log
│       ├── attempt_XX_compile.log
│       ├── attempt_XX_sim.log
│       ├── attempt_XX_repair.log
│       └── reports/
│           └── attempt_XX.yaml
│
├── openroad_runs/
│   └── <spec_name>/
│       ├── logs/
│       ├── reports/
│       ├── results/
│       └── objects/
│
├── generated/
│   ├── design.v
│   ├── tb.v
│   └── sim.out
│
├── summary_table.csv
├── summary_table.md
└── AGENTS.md
```


Main folders
- specs/ contains the input YAML hardware specifications.
- agent.py is the main automation script for generating RTL, testbenches, synthesis, GLS, and OpenROAD flow.
- run_sim.py is a simple simulation-only runner for generated/design.v and generated/tb.v.
- output/ stores generated RTL, testbenches, synthesis files, GLS files, and OpenROAD outputs for each spec.
- logs/ stores per-attempt logs and YAML reports for each spec.
- openroad_runs/ stores OpenROAD working/run data.
- summary_table.csv and summary_table.md contain the final all-spec summary after running the agent.

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
Install WSL I have used Ubuntu22.04, Install Iverilog & VVP, Install Yosys, Install Openroad
cd Spec2RTL
codex
python3 agent.py --all specs/
summary_table.md -> To see the result in table format
```

Expected:
- No manual steps required
- Logs and outputs generated automatically
- PASS results for supported specs
=======
# VLSI-DESIGN-AUTOMATION
This project implement Spec to GDS with Agent

