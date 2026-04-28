# Spec2RTL Agent

Goal:
Generate Verilog RTL and a self-checking Verilog testbench from a YAML hardware specification, then verify through simulation.

Files:
- Input spec: specs/problem1.yml
- Generated RTL: generated/design.v
- Generated testbench: generated/tb.v
- Simulation runner: run_sim.py
- Wrapper script: agent.py
- Logs: logs/sim.log

Workflow:
1. Read the YAML spec.
2. Generate synthesizable RTL.
3. Generate a self-checking testbench.
4. Run python agent.py or python run_sim.py.
5. If compilation or simulation fails, inspect the logs and fix the RTL and/or testbench.
6. Repeat until simulation passes.

Rules:
- Preserve module name and ports from the YAML spec.
- Keep RTL synthesizable.
- Keep the testbench deterministic and readable.
- Do not add unnecessary dependencies.
- Run OpenROAD after GLS by default. Skip OpenROAD only when it is explicitly disabled.
