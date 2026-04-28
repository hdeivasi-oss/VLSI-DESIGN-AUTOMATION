from __future__ import annotations

import csv
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SPECS_DIR = ROOT / "specs"
LOGS_DIR = ROOT / "logs"
OUTPUT_DIR = ROOT / "output"
SUMMARY_CSV = ROOT / "summary_table.csv"
SUMMARY_MD = ROOT / "summary_table.md"


def natural_spec_key(path: Path):
    match = re.match(r"([A-Za-z_]+)(\d+)$", path.stem)
    if match:
        return (match.group(1), int(match.group(2)))
    return (path.stem, -1)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def latest_attempt_report(spec_name: str) -> Path | None:
    reports_dir = LOGS_DIR / spec_name / "reports"
    reports = sorted(
        reports_dir.glob("attempt_*.yaml"),
        key=lambda p: int(re.search(r"(\d+)", p.stem).group(1)) if re.search(r"(\d+)", p.stem) else -1,
    )
    return reports[-1] if reports else None


def extract_attempt_number(report_path: Path | None) -> int | None:
    if report_path is None:
        return None
    match = re.search(r"attempt_(\d+)\.yaml$", report_path.name)
    return int(match.group(1)) if match else None


def parse_report_scalar(text: str, key: str) -> str | None:
    match = re.search(rf"(?m)^{re.escape(key)}:\s*(.+?)\s*$", text)
    if not match:
        return None
    value = match.group(1).strip()
    if len(value) >= 2 and value[0] == '"' and value[-1] == '"':
        value = value[1:-1]
    return value


def parse_report_status(report_path: Path | None) -> str:
    if report_path is None or not report_path.exists():
        return "FAIL"
    text = read_text(report_path)
    status = parse_report_scalar(text, "final_status")
    if status:
        return status.upper()
    status = parse_report_scalar(text, "status")
    if status:
        return status.upper()
    passed = parse_report_scalar(text, "passed")
    if passed and passed.strip().lower() == "true":
        return "PASS"
    return "FAIL"


def parse_report_bool(report_path: Path | None, key: str) -> bool | None:
    if report_path is None or not report_path.exists():
        return None
    text = read_text(report_path)
    value = parse_report_scalar(text, key)
    if value is None:
        return None
    lowered = value.strip().lower()
    if lowered == "true":
        return True
    if lowered == "false":
        return False
    return None


def parse_report_number(report_path: Path | None, key: str) -> float | None:
    if report_path is None or not report_path.exists():
        return None
    text = read_text(report_path)
    value = parse_report_scalar(text, key)
    if value is None or value == "null":
        return None
    return parse_number(value)


def parse_report_int(report_path: Path | None, key: str) -> int | None:
    if report_path is None or not report_path.exists():
        return None
    value = parse_report_scalar(read_text(report_path), key)
    if value is None:
        return None
    value = value.strip().lower()
    if not value or value == "null":
        return None
    try:
        return int(value)
    except ValueError:
        parsed = parse_number(value)
        return int(parsed) if parsed is not None else None


def parse_number(text: str) -> float | None:
    value = text.strip().strip('"').strip("'")
    if not value:
        return None
    lowered = value.lower()
    if lowered in {"inf", "+inf", "infinity", "+infinity"}:
        return 0.0
    if lowered in {"-inf", "-infinity"}:
        return float("-inf")
    try:
        parsed = float(value)
        if abs(parsed) > 1e20:
            return 0.0
        return parsed
    except ValueError:
        return None


def extract_clock_from_spec(spec_text: str) -> float | None:
    clock_period = re.search(r"(?m)^\s*clock_period:\s*([^\s#]+)", spec_text)
    if clock_period:
        raw = clock_period.group(1).strip().lower()
        raw = raw.rstrip(",")
        number = re.match(r"([0-9]*\.?[0-9]+)", raw)
        if number:
            value = float(number.group(1))
            if "ps" in raw:
                return value / 1000.0
            if "us" in raw:
                return value * 1000.0
            if "ms" in raw:
                return value * 1_000_000.0
            return value

    clk_freq = re.search(r"(?m)^\s*clk_frequency:\s*([^\s#]+)", spec_text)
    if clk_freq:
        raw = clk_freq.group(1).strip().lower()
        number = re.match(r"([0-9]*\.?[0-9]+)", raw)
        if number:
            value = float(number.group(1))
            if "ghz" in raw:
                return 1.0 / value
            if "mhz" in raw:
                return 1000.0 / value
            if "khz" in raw:
                return 1_000_000.0 / value
            if "hz" in raw and value != 0:
                return 1_000_000_000.0 / value
    return None


def extract_clock_from_outputs(spec_name: str) -> float | None:
    sdc_path = OUTPUT_DIR / spec_name / "openroad" / "constraint.sdc"
    if sdc_path.exists():
        match = re.search(r"create_clock\s+\[get_ports\s+\S+\]\s+-period\s+([0-9]*\.?[0-9]+)", read_text(sdc_path))
        if match:
            return float(match.group(1))

    for clock_path in (ROOT / "openroad_runs" / spec_name).glob("results/*/*/base/clock_period.txt"):
        text = read_text(clock_path).strip()
        value = parse_number(text)
        if value is not None:
            return value
    return None


def find_final_metrics_json(spec_name: str) -> Path | None:
    candidate = OUTPUT_DIR / spec_name / "openroad" / "logs" / "base" / "6_report.json"
    return candidate if candidate.exists() else None


def find_finish_report(spec_name: str) -> Path | None:
    candidate = OUTPUT_DIR / spec_name / "openroad" / "reports" / "base" / "6_finish.rpt"
    return candidate if candidate.exists() else None


def choose_area(metrics: dict) -> float | None:
    candidates = [
        "finish__design__instance__area",
        "finish__design__instance__area__stdcell",
        "design__instance__area",
        "instance_area",
        "area",
    ]
    for key in candidates:
        if key in metrics:
            value = parse_number(str(metrics[key]))
            if value is not None:
                return value
    for key, value in metrics.items():
        lowered = key.lower()
        if (
            "area" in lowered
            and "class:" not in lowered
            and "die" not in lowered
            and "core" not in lowered
            and "cover" not in lowered
            and "macro" not in lowered
            and "pad" not in lowered
        ):
            parsed = parse_number(str(value))
            if parsed is not None:
                return parsed
    return None


def choose_tns(metrics: dict) -> float | None:
    candidates = [
        "finish__timing__setup__tns",
        "timing__setup__tns",
        "setup__tns",
        "tns",
    ]
    for key in candidates:
        if key in metrics:
            value = parse_number(str(metrics[key]))
            if value is not None:
                return value
    for key, value in metrics.items():
        lowered = key.lower()
        if lowered.endswith("setup__tns") or lowered.endswith("__tns") or lowered == "tns":
            parsed = parse_number(str(value))
            if parsed is not None:
                return parsed
    return None


def choose_whs(metrics: dict) -> float | None:
    candidates = [
        "finish__timing__hold__ws",
        "timing__hold__ws",
        "hold__ws",
        "whs",
    ]
    for key in candidates:
        if key in metrics:
            value = parse_number(str(metrics[key]))
            if value is not None:
                return value
    for key, value in metrics.items():
        lowered = key.lower()
        if lowered.endswith("hold__ws") or lowered.endswith("__hold__ws") or lowered == "whs":
            parsed = parse_number(str(value))
            if parsed is not None:
                return parsed
    return None


def parse_metrics(spec_name: str, report_path: Path | None = None) -> tuple[float | None, float | None, float | None, float | None]:
    metrics = {}
    report_wns = parse_report_number(report_path, "wns")
    report_tns = parse_report_number(report_path, "tns")
    report_whs = parse_report_number(report_path, "whs")
    report_area = parse_report_number(report_path, "area")
    if report_wns is not None or report_tns is not None or report_whs is not None or report_area is not None:
        return report_wns, report_tns, report_whs, report_area
    metrics_path = find_final_metrics_json(spec_name)
    if metrics_path is not None:
        metrics = json.loads(read_text(metrics_path))

    area = choose_area(metrics)
    tns = choose_tns(metrics)
    whs = choose_whs(metrics)
    wns = None

    finish_report = find_finish_report(spec_name)
    if finish_report is not None:
        text = read_text(finish_report)
        wns_match = re.search(r"finish report_wns.*?^\s*wns max\s+([^\s]+)", text, re.MULTILINE | re.DOTALL)
        if wns_match:
            wns = parse_number(wns_match.group(1))
        if tns is None:
            tns_match = re.search(r"finish report_tns.*?^\s*tns max\s+([^\s]+)", text, re.MULTILINE | re.DOTALL)
            if tns_match:
                tns = parse_number(tns_match.group(1))
        if whs is None:
            whs_match = re.search(
                r"finish report_worst_slack_min.*?^\s*worst slack min\s+([^\s]+)",
                text,
                re.MULTILINE | re.DOTALL,
            )
            if whs_match:
                whs = parse_number(whs_match.group(1))
        if wns is None:
            worst_slack = re.search(
                r"finish report_worst_slack.*?^\s*worst slack max\s+([^\s]+)",
                text,
                re.MULTILINE | re.DOTALL,
            )
            if worst_slack:
                wns = parse_number(worst_slack.group(1))

    return wns, tns, whs, area


def format_clock(value: float | None) -> str:
    if value is None:
        return ""
    return f"{value:g}ns"


def format_metric(value: float | None) -> str:
    if value is None:
        return ""
    if value == float("-inf"):
        return "-inf"
    return f"{value:.3f}".rstrip("0").rstrip(".")


def build_rows(spec_paths: list[Path]) -> list[dict[str, object]]:
    rows = []
    for spec_path in spec_paths:
        spec_name = spec_path.stem
        report_path = latest_attempt_report(spec_name)
        flow_pass = parse_report_bool(report_path, "flow_pass")
        if flow_pass is None:
            report_status = parse_report_status(report_path)
            flow_pass = report_status == "PASS"
        current_run_iterations = parse_report_int(report_path, "current_run_iterations")
        if current_run_iterations is None and report_path is not None:
            current_run_iterations = 1

        spec_text = read_text(spec_path)
        clock = extract_clock_from_spec(spec_text)
        if clock is None:
            clock = extract_clock_from_outputs(spec_name)
        if clock is None:
            clock = 10.0

        wns, tns, whs, area = parse_metrics(spec_name, report_path=report_path)
        setup_pass = parse_report_bool(report_path, "setup_pass")
        if setup_pass is None:
            setup_pass = (wns is not None) and (wns >= 0)
        hold_pass = parse_report_bool(report_path, "hold_pass")
        if hold_pass is None:
            hold_pass = (whs is not None) and (whs >= 0)
        meets_timing = parse_report_bool(report_path, "meets_timing")
        if meets_timing is None:
            meets_timing = setup_pass and hold_pass

        rows.append(
            {
                "spec": spec_name,
                "flow_pass": flow_pass,
                "meets_timing": meets_timing,
                "clock": format_clock(clock),
                "WNS": format_metric(wns),
                "TNS": format_metric(tns),
                "WHS": format_metric(whs),
                "iterations": "" if current_run_iterations is None else str(current_run_iterations),
                "area": format_metric(area),
            }
        )
    return rows


def render_table(rows: list[dict[str, object]]) -> str:
    columns = ["spec", "flow_pass", "meets_timing", "clock", "WNS", "TNS", "WHS", "iterations", "area"]
    widths = {column: len(column) for column in columns}
    for row in rows:
        for column in columns:
            widths[column] = max(widths[column], len(str(row[column])))

    def render(values):
        return "| " + " | ".join(str(value).ljust(widths[column]) for column, value in zip(columns, values)) + " |"

    lines = [render(columns), "|-" + "-|-".join("-" * widths[column] for column in columns) + "-|"]
    for row in rows:
        lines.append(render([row[column] for column in columns]))
    return "\n".join(lines)


def print_table(rows: list[dict[str, object]]):
    print(render_table(rows))


def write_csv(rows: list[dict[str, object]], csv_path: Path):
    columns = ["spec", "flow_pass", "meets_timing", "clock", "WNS", "TNS", "WHS", "iterations", "area"]
    with csv_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=columns)
        writer.writeheader()
        writer.writerows(rows)


def write_markdown(rows: list[dict[str, object]], md_path: Path):
    md_path.write_text(render_table(rows) + "\n", encoding="utf-8")


def generate_summary(
    spec_dir: Path = SPECS_DIR,
    csv_path: Path = SUMMARY_CSV,
    md_path: Path = SUMMARY_MD,
    print_stdout: bool = True,
) -> list[dict[str, object]]:
    spec_paths = sorted(spec_dir.glob("*.y*ml"), key=natural_spec_key)
    rows = build_rows(spec_paths)
    if print_stdout:
        print_table(rows)
    write_csv(rows, csv_path)
    write_markdown(rows, md_path)
    if print_stdout:
        print(f"\nWrote {csv_path}")
        print(f"Wrote {md_path}")
    return rows


if __name__ == "__main__":
    generate_summary()
