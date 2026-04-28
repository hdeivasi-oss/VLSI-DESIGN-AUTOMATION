from pathlib import Path
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
GENERATED = ROOT / "generated"
LOGS = ROOT / "logs"
DESIGN = GENERATED / "design.v"
TESTBENCH = GENERATED / "tb.v"
OUTPUT = GENERATED / "sim.out"
LOG_FILE = LOGS / "sim.log"

EXIT_PASS = 0
EXIT_MISSING_INPUT = 1
EXIT_COMPILE_FAIL = 2
EXIT_SIM_FAIL = 3


def run_command(command, log_handle):
    result = subprocess.run(
        command,
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    log_handle.write(f"$ {' '.join(command)}\n")
    if result.stdout:
        log_handle.write(result.stdout)
    if result.stderr:
        log_handle.write(result.stderr)
    log_handle.write("\n")
    return result.returncode


def main():
    GENERATED.mkdir(exist_ok=True)
    LOGS.mkdir(exist_ok=True)

    with LOG_FILE.open("w", encoding="utf-8") as log_handle:
        missing = [str(path.relative_to(ROOT)) for path in (DESIGN, TESTBENCH) if not path.exists()]
        if missing:
            log_handle.write("Missing required files:\n")
            for path in missing:
                log_handle.write(f"- {path}\n")
            print("FAIL")
            return EXIT_MISSING_INPUT

        compile_rc = run_command(
            ["iverilog", "-o", str(OUTPUT), str(DESIGN), str(TESTBENCH)],
            log_handle,
        )
        if compile_rc != 0:
            print("FAIL")
            return EXIT_COMPILE_FAIL

        run_rc = run_command(["vvp", str(OUTPUT)], log_handle)
        if run_rc != 0:
            print("FAIL")
            return EXIT_SIM_FAIL

    print("PASS")
    return EXIT_PASS


if __name__ == "__main__":
    sys.exit(main())
