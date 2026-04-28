from pathlib import Path
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import tempfile
import traceback


ROOT = Path(__file__).resolve().parent
SPECS_DIR = ROOT / "specs"
GENERATED_DIR = ROOT / "output"
LOGS_DIR = ROOT / "logs"
OPENROAD_RUNS_DIR = ROOT / "openroad_runs"
MAX_RETRIES = 1
RTL_REPAIR_RETRIES = 3
DEFAULT_SPEC_TIMEOUT_SECONDS = int(os.environ.get("SPEC2RTL_SPEC_TIMEOUT_SECONDS", "1800"))


def find_command(candidates):
    for candidate in candidates:
        path = shutil.which(candidate)
        if path:
            return path
    return None


def find_python():
    if sys.executable and Path(sys.executable).exists():
        return sys.executable
    return find_command(["python.exe", "python", "py.exe", "py"])


CODEX_CMD = find_command(["codex", "codex.cmd", "codex.exe"])
IVERILOG_CMD = find_command(["iverilog", "iverilog.exe"])
VVP_CMD = find_command(["vvp", "vvp.exe"])
YOSYS_CMD = find_command(["yosys", "yosys.exe"])
OPENROAD_CMD = find_command(["openroad", "openroad.exe"])
PYTHON_CMD = find_python()


def run(command, input_text=None):
    return subprocess.run(
        command,
        cwd=ROOT,
        text=True,
        input=input_text,
        capture_output=True,
        check=False,
    )


def read_text(path):
    return path.read_text(encoding="utf-8")


def write_text(path, text):
    path.write_text(text, encoding="utf-8")


def print_step(message):
    print(f"[agent] {message}")


def parse_args():
    spec_arg = None
    run_all = False
    summary_table = False
    demo_repair = False
    demo_tb_repair = False
    disable_openroad = False
    max_attempts = MAX_RETRIES
    pending_max_attempts = False

    for arg in sys.argv[1:]:
        if pending_max_attempts:
            max_attempts = int(arg)
            pending_max_attempts = False
        elif arg == "--disable-openroad":
            disable_openroad = True
        elif arg == "--demo-repair":
            demo_repair = True
        elif arg == "--demo-tb-repair":
            demo_tb_repair = True
        elif arg == "--all":
            run_all = True
        elif arg == "--summary-table":
            summary_table = True
        elif arg == "--max-attempts":
            pending_max_attempts = True
        elif spec_arg is None:
            spec_arg = arg

    return spec_arg, run_all, summary_table, demo_repair, demo_tb_repair, disable_openroad, max_attempts


def first_top_level_key(spec_text):
    for line in spec_text.splitlines():
        if line and not line.startswith((" ", "\t")) and ":" in line:
            return line.split(":", 1)[0].strip()
    return ""


def extract_scalar(spec_text, key_name):
    prefix = f"{key_name}:"
    for line in spec_text.splitlines():
        stripped = line.strip()
        if stripped.startswith(prefix):
            return stripped.split(":", 1)[1].strip().strip("'\"")
    return ""


def extract_bool(spec_text, key_name, default=False):
    value = extract_scalar(spec_text, key_name)
    if not value:
        return default
    normalized = value.strip().lower()
    if normalized in {"1", "true", "yes", "on"}:
        return True
    if normalized in {"0", "false", "no", "off"}:
        return False
    return default


def detect_spec_key(spec_text):
    top_key = first_top_level_key(spec_text)
    if top_key == "name":
        module_name = extract_scalar(spec_text, "name")
        if module_name == "button_debouncer":
            return "button_debouncer"
    if top_key == "module_name":
        module_name = extract_scalar(spec_text, "module_name")
        if module_name == "rising_edge_detector":
            return "rising_edge_detector"
        if module_name == "shift_register_4bit":
            return "shift_register_4bit"
        if module_name == "seq_detect_101":
            return "seq_detect_101"
    return top_key


def choose_spec_path():
    spec_arg, _, _, _, _, _, _ = parse_args()
    if spec_arg:
        candidate = Path(spec_arg)
        if not candidate.is_absolute():
            candidate = ROOT / candidate
        if candidate.is_dir():
            return None
        return candidate
    return None


def choose_all_spec_paths():
    spec_arg, _, _, _, _, _, _ = parse_args()
    if spec_arg:
        candidate = Path(spec_arg)
        if not candidate.is_absolute():
            candidate = ROOT / candidate
        if candidate.is_dir():
            return sorted(candidate.glob("*.y*ml"))
        if candidate.exists():
            return [candidate]
        return []
    return sorted(SPECS_DIR.glob("*.y*ml"))


def choose_spec_dir():
    spec_arg, _, _, _, _, _, _ = parse_args()
    if spec_arg:
        candidate = Path(spec_arg)
        if not candidate.is_absolute():
            candidate = ROOT / candidate
        if candidate.is_dir():
            return candidate
    return SPECS_DIR


def ensure_directories():
    GENERATED_DIR.mkdir(exist_ok=True)
    LOGS_DIR.mkdir(exist_ok=True)
    OPENROAD_RUNS_DIR.mkdir(exist_ok=True)


def spec_output_paths(spec_path):
    spec_name = spec_path.stem
    generated_spec_dir = GENERATED_DIR / spec_name
    logs_spec_dir = LOGS_DIR / spec_name
    synthesis_dir = generated_spec_dir / "Synthesis"
    openroad_dir = generated_spec_dir / "openroad"
    openroad_run_home = OPENROAD_RUNS_DIR / spec_name
    return {
        "spec_name": spec_name,
        "generated_dir": generated_spec_dir,
        "logs_dir": logs_spec_dir,
        "reports_dir": logs_spec_dir / "reports",
        "synthesis_dir": synthesis_dir,
        "openroad_dir": openroad_dir,
        "openroad_run_home": openroad_run_home,
        "rtl": generated_spec_dir / "design.v",
        "tb": generated_spec_dir / "tb.v",
        "candidate_rtl": generated_spec_dir / "design_candidate.v",
        "candidate_tb": generated_spec_dir / "tb_candidate.v",
        "sim_out": generated_spec_dir / "sim.out",
        "sim_log": logs_spec_dir / "sim.log",
        "synth_script": synthesis_dir / "synth.ys",
        "synth_log": synthesis_dir / "synth.log",
        "synth_netlist": synthesis_dir / "design_syn.v",
        "gls_out": synthesis_dir / "gls_sim.out",
        "gls_log": synthesis_dir / "gls_sim.log",
        "openroad_logs_dir": openroad_dir / "logs",
        "openroad_reports_dir": openroad_dir / "reports",
        "openroad_results_dir": openroad_dir / "results",
        "openroad_design_dir": openroad_dir / "designs",
        "openroad_run_log": openroad_dir / "openroad_run.log",
        "openroad_config": openroad_dir / "config.mk",
        "openroad_sdc": openroad_dir / "constraint.sdc",
        "openroad_netlist": openroad_dir / "design_syn.v",
    }


def ensure_spec_directories(paths):
    paths["generated_dir"].mkdir(parents=True, exist_ok=True)
    paths["logs_dir"].mkdir(parents=True, exist_ok=True)
    paths["reports_dir"].mkdir(parents=True, exist_ok=True)
    paths["synthesis_dir"].mkdir(parents=True, exist_ok=True)
    paths["openroad_dir"].mkdir(parents=True, exist_ok=True)
    paths["openroad_run_home"].mkdir(parents=True, exist_ok=True)
    paths["openroad_logs_dir"].mkdir(parents=True, exist_ok=True)
    paths["openroad_reports_dir"].mkdir(parents=True, exist_ok=True)
    paths["openroad_results_dir"].mkdir(parents=True, exist_ok=True)
    paths["openroad_design_dir"].mkdir(parents=True, exist_ok=True)


def write_outputs(paths, design_text, tb_text):
    write_text(paths["rtl"], design_text)
    write_text(paths["tb"], tb_text)


def write_candidate_outputs(paths, design_text, tb_text):
    write_text(paths["candidate_rtl"], design_text)
    write_text(paths["candidate_tb"], tb_text)


def promote_candidate_outputs(paths):
    shutil.copyfile(paths["candidate_rtl"], paths["rtl"])
    shutil.copyfile(paths["candidate_tb"], paths["tb"])


def next_attempt_number(paths):
    max_attempt = 0
    for report_path in paths["reports_dir"].glob("attempt_*.yaml"):
        match = re.match(r"attempt_(\d+)\.yaml$", report_path.name)
        if match:
            max_attempt = max(max_attempt, int(match.group(1)))
    return max_attempt + 1


def yaml_quote(value):
    text = str(value)
    text = text.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{text}"'


def yaml_block(text, indent=2):
    lines = text.splitlines() or [""]
    prefix = " " * indent
    return "|\n" + "\n".join(f"{prefix}{line}" for line in lines)


def write_attempt_report(paths, report):
    report_path = paths["reports_dir"] / f"attempt_{report['attempt']:02d}.yaml"
    lines = [
        f"attempt: {report['attempt']}",
        f"spec_name: {yaml_quote(paths['spec_name'])}",
        f"rtl_variant: {yaml_quote(report['rtl_variant'])}",
        f"tb_variant: {yaml_quote(report['tb_variant'])}",
        f"status: {yaml_quote(report['status'])}",
        f"failure_type: {yaml_quote(report['failure_type'])}",
        f"compile_returncode: {report['compile_returncode']}",
        f"simulation_returncode: {report['simulation_returncode']}",
        "analysis:",
        f"  summary: {yaml_quote(report['analysis_summary'])}",
        f"compile_command: {yaml_quote(report['compile_command'])}",
        f"simulation_command: {yaml_quote(report['simulation_command'])}",
        "compile_stdout: " + yaml_block(report["compile_stdout"], indent=2),
        "compile_stderr: " + yaml_block(report["compile_stderr"], indent=2),
        "simulation_stdout: " + yaml_block(report["simulation_stdout"], indent=2),
        "simulation_stderr: " + yaml_block(report["simulation_stderr"], indent=2),
        "combined_log: " + yaml_block(report["combined_log"], indent=2),
    ]
    write_text(report_path, "\n".join(lines) + "\n")


def analyze_failure(spec_key, current_strategy, combined_log):
    failure_type = classify_failure(combined_log)
    if failure_type == "compile_error":
        summary = "Compile failed. Try a simpler or alternate implementation variant."
    elif failure_type == "detected_mismatch":
        summary = "Sequence detector timing mismatched expected pulse cycle."
    elif failure_type == "valid_mismatch":
        summary = "Valid timing mismatched expected behavior."
    elif failure_type == "exp_mismatch":
        summary = "Pipeline latency or fixed-point arithmetic mismatched expected output."
    elif failure_type == "fir_mismatch":
        summary = "FIR accumulation or tap ordering mismatched expected convolution."
    elif failure_type == "value_mismatch":
        summary = "Simulation value mismatched expected result."
    else:
        summary = "Unknown failure mode. Try the next available variant."

    next_choice = next_strategy(spec_key, current_strategy, combined_log)
    return failure_type, summary, next_choice


def generator_seq_detector(rtl_variant="delayed_pulse", tb_variant="sample_delayed"):
    if rtl_variant == "immediate_pulse":
        design = """module seq_detector_0011(
    input clk,
    input reset,
    input data_in,
    output reg detected
);
    reg [1:0] state;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
        end else begin
            detected <= 1'b0;
            case (state)
                S0: state <= data_in ? S0 : S1;
                S1: state <= data_in ? S0 : S2;
                S2: state <= data_in ? S3 : S2;
                S3: begin
                    if (data_in) begin
                        state <= S0;
                        detected <= 1'b1;
                    end else begin
                        state <= S1;
                    end
                end
            endcase
        end
    end
endmodule
"""
    else:
        design = """module seq_detector_0011(
    input clk,
    input reset,
    input data_in,
    output reg detected
);
    reg [3:0] history;
    reg detect_pending;

    always @(posedge clk) begin
        if (reset) begin
            history <= 4'b0000;
            detect_pending <= 1'b0;
            detected <= 1'b0;
        end else begin
            detected <= detect_pending;
            history <= {history[2:0], data_in};
            detect_pending <= ({history[2:0], data_in} == 4'b0011);
        end
    end
endmodule
"""
    sample_output = "16'b0000010001000000" if tb_variant == "sample_delayed" else "16'b0000100010000000"
    tb = f"""`timescale 1ns/1ps

module tb;
    reg clk;
    reg reset;
    reg data_in;
    wire detected;
    reg [15:0] sample_input;
    reg [15:0] sample_output;
    integer i;

    seq_detector_0011 dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    task check_detected;
        input expected;
        input integer cycle_idx;
        begin
            #1;
            if (detected !== expected) begin
                $display("FAIL: cycle=%0d expected detected=%0b got=%0b time=%0t", cycle_idx, expected, detected, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        data_in = 1'b0;
        sample_input = 16'b0001100110110010;
        sample_output = {sample_output};

        reset = 1'b1;
        @(posedge clk);
        check_detected(1'b0, 0);

        reset = 1'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            data_in = sample_input[i];
            @(posedge clk);
            check_detected(sample_output[i], 16 - i);
        end

        reset = 1'b1;
        @(posedge clk);
        check_detected(1'b0, 17);

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_dot_product(rtl_variant="single_pulse", tb_variant="pulse_check"):
    if rtl_variant == "level_valid":
        design = """module dot_product #(
    parameter N = 8,
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input [N*WIDTH-1:0] A,
    input [N*WIDTH-1:0] B,
    output reg signed [2*WIDTH+3:0] dot_out,
    output reg valid
);
    integer i;
    reg signed [2*WIDTH+3:0] sum_reg;

    function signed [WIDTH-1:0] vec_elem;
        input [N*WIDTH-1:0] vec;
        input integer idx;
        begin
            vec_elem = vec[idx*WIDTH +: WIDTH];
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            dot_out <= {(2*WIDTH+4){1'b0}};
            valid <= 1'b0;
        end else begin
            sum_reg = {(2*WIDTH+4){1'b0}};
            for (i = 0; i < N; i = i + 1) begin
                sum_reg = sum_reg + $signed(vec_elem(A, i)) * $signed(vec_elem(B, i));
            end
            dot_out <= sum_reg;
            valid <= 1'b1;
        end
    end
endmodule
"""
    elif rtl_variant == "timing_pipelined":
        design = """module dot_product #(
    parameter N = 8,
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input [N*WIDTH-1:0] A,
    input [N*WIDTH-1:0] B,
    output reg signed [2*WIDTH+3:0] dot_out,
    output reg valid
);
    localparam ACC_WIDTH = 2*WIDTH+4;
    reg signed [2*WIDTH-1:0] prod_regs [0:N-1];
    reg stage1_valid;
    reg stage2_valid;
    reg computed_once;
    integer i;

    reg signed [ACC_WIDTH-1:0] pair_sum_0;
    reg signed [ACC_WIDTH-1:0] pair_sum_1;
    reg signed [ACC_WIDTH-1:0] pair_sum_2;
    reg signed [ACC_WIDTH-1:0] pair_sum_3;
    reg signed [ACC_WIDTH-1:0] tree_sum_reg_0;
    reg signed [ACC_WIDTH-1:0] tree_sum_reg_1;
    reg signed [ACC_WIDTH-1:0] final_sum_comb;

    function signed [WIDTH-1:0] vec_elem;
        input [N*WIDTH-1:0] vec;
        input integer idx;
        begin
            vec_elem = vec[idx*WIDTH +: WIDTH];
        end
    endfunction

    always @* begin
        pair_sum_0 = $signed(prod_regs[0]) + $signed(prod_regs[1]);
        pair_sum_1 = $signed(prod_regs[2]) + $signed(prod_regs[3]);
        pair_sum_2 = $signed(prod_regs[4]) + $signed(prod_regs[5]);
        pair_sum_3 = $signed(prod_regs[6]) + $signed(prod_regs[7]);
        final_sum_comb = tree_sum_reg_0 + tree_sum_reg_1;
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                prod_regs[i] <= {(2*WIDTH){1'b0}};
            end
            tree_sum_reg_0 <= {ACC_WIDTH{1'b0}};
            tree_sum_reg_1 <= {ACC_WIDTH{1'b0}};
            dot_out <= {ACC_WIDTH{1'b0}};
            valid <= 1'b0;
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
            computed_once <= 1'b0;
        end else begin
            valid <= stage2_valid;
            if (stage2_valid) begin
                dot_out <= final_sum_comb;
            end

            if (stage1_valid) begin
                tree_sum_reg_0 <= pair_sum_0 + pair_sum_1;
                tree_sum_reg_1 <= pair_sum_2 + pair_sum_3;
                stage2_valid <= 1'b1;
            end else begin
                stage2_valid <= 1'b0;
            end

            if (!computed_once) begin
                for (i = 0; i < N; i = i + 1) begin
                    prod_regs[i] <= $signed(vec_elem(A, i)) * $signed(vec_elem(B, i));
                end
                stage1_valid <= 1'b1;
                computed_once <= 1'b1;
            end else begin
                stage1_valid <= 1'b0;
            end
        end
    end
endmodule
"""
    else:
        design = """module dot_product #(
    parameter N = 8,
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input [N*WIDTH-1:0] A,
    input [N*WIDTH-1:0] B,
    output reg signed [2*WIDTH+3:0] dot_out,
    output reg valid
);
    reg signed [2*WIDTH+3:0] sum_reg;
    reg pending_valid;
    reg computed_once;
    integer i;

    function signed [WIDTH-1:0] vec_elem;
        input [N*WIDTH-1:0] vec;
        input integer idx;
        begin
            vec_elem = vec[idx*WIDTH +: WIDTH];
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            sum_reg <= {(2*WIDTH+4){1'b0}};
            dot_out <= {(2*WIDTH+4){1'b0}};
            valid <= 1'b0;
            pending_valid <= 1'b0;
            computed_once <= 1'b0;
        end else begin
            valid <= pending_valid;
            if (pending_valid) begin
                dot_out <= sum_reg;
            end

            if (!computed_once) begin
                sum_reg = {(2*WIDTH+4){1'b0}};
                for (i = 0; i < N; i = i + 1) begin
                    sum_reg = sum_reg + $signed(vec_elem(A, i)) * $signed(vec_elem(B, i));
                end
                pending_valid <= 1'b1;
                computed_once <= 1'b1;
            end else begin
                pending_valid <= 1'b0;
            end
        end
    end
endmodule
"""
    if rtl_variant == "timing_pipelined":
        cycle2_valid = "1'b0"
        cycle2_check_dot = "1'b0"
        cycle3_valid = "1'b1"
        cycle3_check_dot = "1'b1"
        cycle4_valid = "1'b0" if tb_variant == "pulse_check" else "1'b1"
    else:
        cycle2_valid = "1'b1" if tb_variant == "pulse_check" else "1'b0"
        cycle2_check_dot = "1'b1"
        cycle3_valid = "1'b0" if tb_variant == "pulse_check" else "1'b1"
        cycle3_check_dot = "1'b0" if tb_variant == "pulse_check" else "1'b1"
        cycle4_valid = "1'b0" if tb_variant == "pulse_check" else "1'b1"
    tb = """`timescale 1ns/1ps

module tb;
    localparam int N = 8;
    localparam int WIDTH = 8;

    logic clk;
    logic rst;
    logic signed [N-1:0][WIDTH-1:0] A;
    logic signed [N-1:0][WIDTH-1:0] B;
    logic signed [2*WIDTH+3:0] dot_out;
    logic valid;

    dot_product #(
        .N(N),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .dot_out(dot_out),
        .valid(valid)
    );

    always #5 clk = ~clk;

    task check_state;
        input integer cycle_id;
        input expected_valid;
        input signed [2*WIDTH+3:0] expected_dot;
        input check_dot;
        begin
            #1;
            if (valid !== expected_valid) begin
                $display("FAIL: cycle %0d expected valid=%0b got valid=%0b time=%0t", cycle_id, expected_valid, valid, $time);
                $fatal(1);
            end
            if (check_dot && dot_out !== expected_dot) begin
                $display("FAIL: cycle %0d expected dot_out=%0d got dot_out=%0d time=%0t", cycle_id, expected_dot, dot_out, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        A[0] = -8'sd40;
        A[1] = 8'sd50;
        A[2] = -8'sd50;
        A[3] = 8'sd31;
        A[4] = 8'sd14;
        A[5] = 8'sd9;
        A[6] = 8'sd6;
        A[7] = -8'sd32;
        B[0] = -8'sd1;
        B[1] = 8'sd30;
        B[2] = 8'sd41;
        B[3] = 8'sd14;
        B[4] = 8'sd37;
        B[5] = 8'sd50;
        B[6] = 8'sd22;
        B[7] = 8'sd29;

        rst = 1'b1;
        @(posedge clk);
        check_state(0, 1'b0, '0, 1'b0);

        rst = 1'b0;
        @(posedge clk);
        check_state(1, 1'b0, '0, 1'b0);

        @(posedge clk);
        check_state(2, """ + cycle2_valid + """, 20'sd96, """ + cycle2_check_dot + """);

        @(posedge clk);
        check_state(3, """ + cycle3_valid + """, 20'sd96, """ + cycle3_check_dot + """);

        @(posedge clk);
        check_state(4, """ + cycle4_valid + """, 20'sd96, 1'b0);

        rst = 1'b1;
        @(posedge clk);
        check_state(5, 1'b0, '0, 1'b0);

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_exp_fixed_point(rtl_variant="two_stage", tb_variant="two_stage_check"):
    if rtl_variant == "lut_pipeline":
        lut_entries = []
        frac = 7
        for x in range(256):
            x_sq_full = x * x
            x2_q = x_sq_full >> frac
            x_cu_full = x_sq_full * x
            x3_q = x_cu_full >> (2 * frac)
            approx = (1 << frac) + x + (x2_q >> 1) + (x3_q // 6)
            lut_entries.append(f"        8'd{x}: approx_exp = 16'd{approx};")
        lut_case = "\n".join(lut_entries)
        design = """module exp_fixed_point #(
  parameter WIDTH = 8
) (
  input clk,
  input rst,
  input enable,
  input [WIDTH-1:0] x_in,
  output reg [2*WIDTH-1:0] exp_out
);
  reg [WIDTH-1:0] x_stage1;
  reg [2*WIDTH-1:0] lut_stage2;
  reg stage1_valid;
  reg stage2_valid;

  function [2*WIDTH-1:0] approx_exp;
    input [WIDTH-1:0] xin;
    reg [2*WIDTH-1:0] x_sq_full;
    reg [3*WIDTH-1:0] x_cu_full;
    reg [2*WIDTH-1:0] x2_q;
    reg [2*WIDTH-1:0] x3_q;
    begin
      if (WIDTH == 8) begin
        case (xin)
""" + lut_case + """
        default: approx_exp = {(2*WIDTH){1'b0}};
        endcase
      end else begin
        x_sq_full = xin * xin;
        x2_q = x_sq_full >> (WIDTH - 1);
        x_cu_full = x_sq_full * xin;
        x3_q = x_cu_full >> (2 * (WIDTH - 1));
        approx_exp = ({{(WIDTH+1){1'b0}}, {1'b1, {(WIDTH-1){1'b0}}}})
                   + {{WIDTH{1'b0}}, xin}
                   + (x2_q >> 1)
                   + (x3_q / 6);
      end
    end
  endfunction

  always @(posedge clk) begin
    if (rst) begin
      x_stage1 <= {WIDTH{1'b0}};
      lut_stage2 <= {(2*WIDTH){1'b0}};
      stage1_valid <= 1'b0;
      stage2_valid <= 1'b0;
      exp_out <= {(2*WIDTH){1'b0}};
    end else begin
      if (enable) begin
        x_stage1 <= x_in;
        stage1_valid <= 1'b1;
      end else begin
        stage1_valid <= 1'b0;
      end

      if (stage1_valid) begin
        lut_stage2 <= approx_exp(x_stage1);
      end
      stage2_valid <= stage1_valid;

      if (stage2_valid) begin
        exp_out <= lut_stage2;
      end
    end
  end
endmodule
"""
    elif rtl_variant == "one_stage":
        design = """module exp_fixed_point #(
  parameter WIDTH = 8
) (
  input clk,
  input rst,
  input enable,
  input [WIDTH-1:0] x_in,
  output reg [2*WIDTH-1:0] exp_out
);
  localparam FRAC = WIDTH - 1;

  reg [2*WIDTH-1:0] x_sq_full;
  reg [3*WIDTH-1:0] x_cu_full;
  reg [2*WIDTH-1:0] x2_q;
  reg [2*WIDTH-1:0] x3_q;
  reg [2*WIDTH-1:0] sum_next;

  always @* begin
    x_sq_full = x_in * x_in;
    x2_q = x_sq_full >> FRAC;
    x_cu_full = x_sq_full * x_in;
    x3_q = x_cu_full >> (2 * FRAC);
    sum_next = ({{(WIDTH+1){1'b0}}, {1'b1, {FRAC{1'b0}}}})
             + {{WIDTH{1'b0}}, x_in}
             + (x2_q >> 1)
             + (x3_q / 6);
  end

  always @(posedge clk) begin
    if (rst) begin
      exp_out <= {(2*WIDTH){1'b0}};
    end else if (enable) begin
      exp_out <= sum_next;
    end
  end
endmodule
"""
    else:
        design = """module exp_fixed_point #(
  parameter WIDTH = 8
) (
  input clk,
  input rst,
  input enable,
  input [WIDTH-1:0] x_in,
  output reg [2*WIDTH-1:0] exp_out
);
  localparam FRAC = WIDTH - 1;

  reg [2*WIDTH-1:0] x2_q_stage1;
  reg [2*WIDTH-1:0] x3_q_stage1;
  reg [WIDTH-1:0] x_stage1;
  reg [2*WIDTH-1:0] x2_q_stage2;
  reg [2*WIDTH-1:0] x3_q_stage2;
  reg [WIDTH-1:0] x_stage2;
  reg stage1_valid;
  reg stage2_valid;

  reg [2*WIDTH-1:0] x_sq_full;
  reg [3*WIDTH-1:0] x_cu_full;
  reg [2*WIDTH-1:0] x2_q_next;
  reg [2*WIDTH-1:0] x3_q_next;
  reg [2*WIDTH-1:0] sum_next;

  always @* begin
    x_sq_full = x_in * x_in;
    x2_q_next = x_sq_full >> FRAC;

    x_cu_full = x_sq_full * x_in;
    x3_q_next = x_cu_full >> (2 * FRAC);

    sum_next = ({{(WIDTH+1){1'b0}}, {1'b1, {FRAC{1'b0}}}})
             + {{WIDTH{1'b0}}, x_stage2}
             + (x2_q_stage2 >> 1)
             + (x3_q_stage2 / 6);
  end

  always @(posedge clk) begin
    if (rst) begin
      x2_q_stage1 <= {(2*WIDTH){1'b0}};
      x3_q_stage1 <= {(2*WIDTH){1'b0}};
      x_stage1 <= {WIDTH{1'b0}};
      x2_q_stage2 <= {(2*WIDTH){1'b0}};
      x3_q_stage2 <= {(2*WIDTH){1'b0}};
      x_stage2 <= {WIDTH{1'b0}};
      stage1_valid <= 1'b0;
      stage2_valid <= 1'b0;
      exp_out <= {(2*WIDTH){1'b0}};
    end else begin
      if (enable) begin
        x2_q_stage1 <= x2_q_next;
        x3_q_stage1 <= x3_q_next;
        x_stage1 <= x_in;
        stage1_valid <= 1'b1;
      end else begin
        stage1_valid <= 1'b0;
      end

      x2_q_stage2 <= x2_q_stage1;
      x3_q_stage2 <= x3_q_stage1;
      x_stage2 <= x_stage1;
      stage2_valid <= stage1_valid;
      if (stage2_valid) begin
        exp_out <= sum_next;
      end
    end
  end
endmodule
"""
    cycle2_expected = "16'd0" if tb_variant == "two_stage_check" else "16'd341"
    cycle3_expected = "16'd341" if tb_variant == "two_stage_check" else "16'd341"
    tb = """`timescale 1ns/1ps

module tb;
    localparam WIDTH = 8;

    logic clk;
    logic rst;
    logic enable;
    logic [WIDTH-1:0] x_in;
    logic [2*WIDTH-1:0] exp_out;

    exp_fixed_point #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .x_in(x_in),
        .exp_out(exp_out)
    );

    always #5 clk = ~clk;

    task check_output;
        input integer cycle_id;
        input [2*WIDTH-1:0] expected;
        begin
            #1;
            if (exp_out !== expected) begin
                $display("FAIL: cycle %0d expected exp_out=%0d got exp_out=%0d time=%0t", cycle_id, expected, exp_out, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        enable = 1'b0;
        x_in = '0;

        rst = 1'b1;
        enable = 1'b1;
        @(posedge clk);
        check_output(0, 16'd0);

        rst = 1'b0;
        x_in = 8'd128;

        @(posedge clk);
        check_output(1, 16'd0);

        @(posedge clk);
        check_output(2, """ + cycle2_expected + """);

        @(posedge clk);
        check_output(3, """ + cycle3_expected + """);

        enable = 1'b0;
        @(posedge clk);
        check_output(4, 16'd341);

        rst = 1'b1;
        @(posedge clk);
        check_output(5, 16'd0);

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_fp16_multiplier(rtl_variant="default", tb_variant="default"):
    design = """module fp16_multiplier(
  input [15:0] a,
  input [15:0] b,
  output reg [15:0] result
);
  reg sign_a;
  reg sign_b;
  reg [4:0] exp_a;
  reg [4:0] exp_b;
  reg [9:0] frac_a;
  reg [9:0] frac_b;
  reg [10:0] mant_a;
  reg [10:0] mant_b;
  reg sign_r;
  reg [5:0] exp_sum;
  reg [21:0] mant_prod;
  reg [4:0] exp_norm;
  reg [9:0] frac_norm;
  reg guard_bit;
  reg round_bit;
  reg sticky_bit;
  reg [10:0] rounded_mant;
  reg [4:0] rounded_exp;

  always @* begin
    sign_a = a[15];
    sign_b = b[15];
    exp_a = a[14:10];
    exp_b = b[14:10];
    frac_a = a[9:0];
    frac_b = b[9:0];
    mant_a = 11'd0;
    mant_b = 11'd0;
    sign_r = 1'b0;
    exp_sum = 6'd0;
    mant_prod = 22'd0;
    exp_norm = 5'd0;
    frac_norm = 10'd0;
    guard_bit = 1'b0;
    round_bit = 1'b0;
    sticky_bit = 1'b0;
    rounded_mant = 11'd0;
    rounded_exp = 5'd0;
    result = 16'd0;

    if ((exp_a == 5'd0 && frac_a == 10'd0) || (exp_b == 5'd0 && frac_b == 10'd0)) begin
      result = 16'd0;
    end else begin
      mant_a = {1'b1, frac_a};
      mant_b = {1'b1, frac_b};
      sign_r = sign_a ^ sign_b;
      exp_sum = exp_a + exp_b - 5'd15;
      mant_prod = mant_a * mant_b;

      if (mant_prod[21]) begin
        exp_norm = exp_sum[4:0] + 5'd1;
        frac_norm = mant_prod[20:11];
        guard_bit = mant_prod[10];
        round_bit = mant_prod[9];
        sticky_bit = |mant_prod[8:0];
      end else begin
        exp_norm = exp_sum[4:0];
        frac_norm = mant_prod[19:10];
        guard_bit = mant_prod[9];
        round_bit = mant_prod[8];
        sticky_bit = |mant_prod[7:0];
      end

      rounded_mant = {1'b0, frac_norm};
      rounded_exp = exp_norm;
      if (guard_bit && (round_bit || sticky_bit || frac_norm[0])) begin
        rounded_mant = {1'b0, frac_norm} + 11'd1;
        if (rounded_mant[10]) begin
          rounded_mant = 11'd0;
          rounded_exp = exp_norm + 5'd1;
        end
      end

      result = {sign_r, rounded_exp, rounded_mant[9:0]};
    end
  end
endmodule
"""
    tb = """`timescale 1ns/1ps

module tb;
    logic [15:0] a;
    logic [15:0] b;
    logic [15:0] result;

    fp16_multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );

    task check_result;
        input [15:0] expected;
        input [127:0] name;
        begin
            #1;
            if (result !== expected) begin
                $display("FAIL: %0s expected=%h got=%h time=%0t", name, expected, result, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        a = 16'b0_01111_0000000000;
        b = 16'b0_10000_0000000000;
        #1 check_result(16'b0_10000_0000000000, "1.0 times 2.0 equals 2.0");

        a = 16'd0;
        b = 16'b0_10000_0000000000;
        #1 check_result(16'd0, "zero detection");

        a = 16'b1_01111_0000000000;
        b = 16'b0_01111_0000000000;
        #1 check_result(16'b1_01111_0000000000, "sign handling");

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_fir_filter(rtl_variant="direct_form", tb_variant="direct_expectation"):
    if rtl_variant == "reversed_taps":
        design = """module fir_filter #(
  parameter WIDTH = 16,
  parameter N = 8
) (
  input clk,
  input rst,
  input signed [WIDTH-1:0] x_in,
  input [N*WIDTH-1:0] h,
  output reg signed [2*WIDTH+3:0] y_out
);
  localparam ACC_WIDTH = 2*WIDTH+4;
  reg signed [WIDTH-1:0] samples [0:N-1];
  integer i;
  reg signed [ACC_WIDTH-1:0] acc;

  function signed [WIDTH-1:0] coeff_at;
    input [N*WIDTH-1:0] coeffs;
    input integer idx;
    begin
      coeff_at = coeffs[idx*WIDTH +: WIDTH];
    end
  endfunction

  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < N; i = i + 1) begin
        samples[i] <= {WIDTH{1'b0}};
      end
      y_out <= {ACC_WIDTH{1'b0}};
    end else begin
      samples[0] <= x_in;
      for (i = 1; i < N; i = i + 1) begin
        samples[i] <= samples[i-1];
      end

      acc = $signed(x_in) * $signed(coeff_at(h, N-1));
      for (i = 1; i < N; i = i + 1) begin
        acc = acc + ($signed(samples[i-1]) * $signed(coeff_at(h, N-1-i)));
      end
      y_out <= acc;
    end
  end
endmodule
"""
    elif rtl_variant == "transposed_form":
        design = """module fir_filter #(
  parameter WIDTH = 16,
  parameter N = 8
) (
  input clk,
  input rst,
  input signed [WIDTH-1:0] x_in,
  input [N*WIDTH-1:0] h,
  output reg signed [2*WIDTH+3:0] y_out
);
  localparam ACC_WIDTH = 2*WIDTH+4;
  reg signed [ACC_WIDTH-1:0] state [0:N-2];
  reg signed [ACC_WIDTH-1:0] prod [0:N-1];
  reg signed [ACC_WIDTH-1:0] stage_sum [0:N-1];
  integer i;

  function signed [WIDTH-1:0] coeff_at;
    input [N*WIDTH-1:0] coeffs;
    input integer idx;
    begin
      coeff_at = coeffs[idx*WIDTH +: WIDTH];
    end
  endfunction

  always @* begin
    for (i = 0; i < N; i = i + 1) begin
      prod[i] = $signed(x_in) * $signed(coeff_at(h, i));
    end

    stage_sum[N-1] = prod[N-1];
    for (i = N-2; i >= 0; i = i - 1) begin
      stage_sum[i] = prod[i] + state[i];
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < N-1; i = i + 1) begin
        state[i] <= {ACC_WIDTH{1'b0}};
      end
      y_out <= {ACC_WIDTH{1'b0}};
    end else begin
      y_out <= stage_sum[0];
      for (i = 0; i < N-2; i = i + 1) begin
        state[i] <= stage_sum[i+1];
      end
      state[N-2] <= prod[N-1];
    end
  end
endmodule
"""
    else:
        design = """module fir_filter #(
  parameter WIDTH = 16,
  parameter N = 8
) (
  input clk,
  input rst,
  input signed [WIDTH-1:0] x_in,
  input [N*WIDTH-1:0] h,
  output reg signed [2*WIDTH+3:0] y_out
);
  localparam ACC_WIDTH = 2*WIDTH+4;
  reg signed [WIDTH-1:0] samples [0:N-1];
  integer i;
  reg signed [ACC_WIDTH-1:0] acc;

  function signed [WIDTH-1:0] coeff_at;
    input [N*WIDTH-1:0] coeffs;
    input integer idx;
    begin
      coeff_at = coeffs[idx*WIDTH +: WIDTH];
    end
  endfunction

  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < N; i = i + 1) begin
        samples[i] <= {WIDTH{1'b0}};
      end
      y_out <= {ACC_WIDTH{1'b0}};
    end else begin
      samples[0] <= x_in;
      for (i = 1; i < N; i = i + 1) begin
        samples[i] <= samples[i-1];
      end

      acc = $signed(x_in) * $signed(coeff_at(h, 0));
      for (i = 1; i < N; i = i + 1) begin
        acc = acc + ($signed(samples[i-1]) * $signed(coeff_at(h, i)));
      end
      y_out <= acc;
    end
  end
endmodule
"""
    expected_values = [
        "35'sd1",
        "35'sd4",
        "35'sd10",
        "35'sd20",
        "35'sd35",
        "35'sd56",
        "35'sd84",
        "35'sd120",
    ]
    if tb_variant == "reversed_expectation":
        expected_values = [
            "35'sd8",
            "35'sd23",
            "35'sd44",
            "35'sd70",
            "35'sd100",
            "35'sd133",
            "35'sd168",
            "35'sd204",
        ]
    tb = """`timescale 1ns/1ps

module tb;
    localparam WIDTH = 16;
    localparam N = 8;

    logic clk;
    logic rst;
    logic signed [WIDTH-1:0] x_in;
    logic signed [N-1:0][WIDTH-1:0] h;
    logic signed [2*WIDTH+$clog2(N):0] y_out;
    integer i;

    reg signed [WIDTH-1:0] stimuli [0:7];
    reg signed [2*WIDTH+$clog2(N):0] expected [0:7];

    fir_filter #(
        .WIDTH(WIDTH),
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .h(h),
        .y_out(y_out)
    );

    always #5 clk = ~clk;

    task check_output;
        input integer idx;
        input signed [2*WIDTH+$clog2(N):0] expected_value;
        begin
            #1;
            if (y_out !== expected_value) begin
                $display("FAIL: sample %0d expected y_out=%0d got y_out=%0d time=%0t", idx, expected_value, y_out, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        x_in = '0;

        h[0] = 16'sd1;
        h[1] = 16'sd2;
        h[2] = 16'sd3;
        h[3] = 16'sd4;
        h[4] = 16'sd5;
        h[5] = 16'sd6;
        h[6] = 16'sd7;
        h[7] = 16'sd8;

        stimuli[0] = 16'sd1;
        stimuli[1] = 16'sd2;
        stimuli[2] = 16'sd3;
        stimuli[3] = 16'sd4;
        stimuli[4] = 16'sd5;
        stimuli[5] = 16'sd6;
        stimuli[6] = 16'sd7;
        stimuli[7] = 16'sd8;

        expected[0] = """ + expected_values[0] + """;
        expected[1] = """ + expected_values[1] + """;
        expected[2] = """ + expected_values[2] + """;
        expected[3] = """ + expected_values[3] + """;
        expected[4] = """ + expected_values[4] + """;
        expected[5] = """ + expected_values[5] + """;
        expected[6] = """ + expected_values[6] + """;
        expected[7] = """ + expected_values[7] + """;

        rst = 1'b1;
        @(posedge clk);
        check_output(-1, '0);

        rst = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            x_in = stimuli[i];
            @(posedge clk);
            check_output(i, expected[i]);
        end

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_rising_edge_detector(rtl_variant="prev_reg", tb_variant="default_check"):
    if rtl_variant == "combinational_bug":
        design = """module rising_edge_detector (
    input wire clk,
    input wire rst,
    input wire sig_in,
    output reg pulse
);
    reg prev_sig;

    always @(posedge clk) begin
        if (rst) begin
            prev_sig <= 1'b0;
            pulse <= 1'b0;
        end else begin
            pulse <= sig_in;
            prev_sig <= sig_in;
        end
    end
endmodule
"""
    else:
        design = """module rising_edge_detector (
    input wire clk,
    input wire rst,
    input wire sig_in,
    output reg pulse
);
    reg prev_sig;

    always @(posedge clk) begin
        if (rst) begin
            prev_sig <= 1'b0;
            pulse <= 1'b0;
        end else begin
            pulse <= sig_in & ~prev_sig;
            prev_sig <= sig_in;
        end
    end
endmodule
"""
    pulse_after_fall = "1'b0" if tb_variant == "default_check" else "1'b1"
    tb = """`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg sig_in;
    wire pulse;

    rising_edge_detector dut (
        .clk(clk),
        .rst(rst),
        .sig_in(sig_in),
        .pulse(pulse)
    );

    always #5 clk = ~clk;

    task check_pulse;
        input expected;
        input [127:0] label;
        begin
            #1;
            if (pulse !== expected) begin
                $display("FAIL: %0s expected pulse=%0b got pulse=%0b time=%0t", label, expected, pulse, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        sig_in = 1'b0;

        rst = 1'b1;
        @(posedge clk);
        check_pulse(1'b0, "reset clears state");

        rst = 1'b0;
        @(posedge clk);
        check_pulse(1'b0, "idle low input");

        sig_in = 1'b1;
        @(posedge clk);
        check_pulse(1'b1, "first rising edge pulses");

        @(posedge clk);
        check_pulse(1'b0, "stable high does not keep pulse high");

        sig_in = 1'b0;
        @(posedge clk);
        check_pulse(""" + pulse_after_fall + """, "falling edge does not pulse");

        sig_in = 1'b1;
        @(posedge clk);
        check_pulse(1'b1, "second rising edge pulses again");

        @(posedge clk);
        check_pulse(1'b0, "pulse returns low after second edge");

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_shift_register_4bit(rtl_variant="correct", tb_variant="default_check"):
    if rtl_variant == "shift_priority_bug":
        design = """module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift_en,
    input wire serial_in,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (shift_en) begin
            data_out <= {data_out[2:0], serial_in};
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule
"""
    else:
        design = """module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift_en,
    input wire serial_in,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift_en) begin
            data_out <= {data_out[2:0], serial_in};
        end
    end
endmodule
"""
    load_expected = "4'b1010" if tb_variant == "default_check" else "4'b0101"
    priority_expected = "4'b1010" if tb_variant == "default_check" else "4'b0101"
    tb = """`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg load;
    reg shift_en;
    reg serial_in;
    reg [3:0] data_in;
    wire [3:0] data_out;

    shift_register_4bit dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    task check_data_out;
        input [3:0] expected;
        input [127:0] label;
        begin
            #1;
            if (data_out !== expected) begin
                $display("FAIL: %0s expected=%b got=%b time=%0t", label, expected, data_out, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        load = 1'b0;
        shift_en = 1'b0;
        serial_in = 1'b0;
        data_in = 4'b0000;

        rst = 1'b1;
        @(posedge clk);
        check_data_out(4'b0000, "reset clears register");

        rst = 1'b0;
        load = 1'b1;
        data_in = 4'b1010;
        @(posedge clk);
        check_data_out(""" + load_expected + """, "load writes data_in");

        shift_en = 1'b1;
        serial_in = 1'b1;
        @(posedge clk);
        check_data_out(""" + priority_expected + """, "load has priority over shift");

        load = 1'b0;
        serial_in = 1'b0;
        @(posedge clk);
        check_data_out(4'b0100, "shift operation updates bits correctly");

        shift_en = 1'b0;
        @(posedge clk);
        check_data_out(4'b0100, "hold behavior");

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_seq_detect_101(rtl_variant="overlap_correct", tb_variant="default_check"):
    if rtl_variant == "no_overlap_bug":
        design = """module seq_detect_101 (
    input wire clk,
    input wire rst,
    input wire bit_in,
    output reg match
);
    reg [1:0] state;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
            match <= 1'b0;
        end else begin
            match <= 1'b0;
            case (state)
                S0: state <= bit_in ? S1 : S0;
                S1: state <= bit_in ? S1 : S2;
                S2: begin
                    if (bit_in) begin
                        state <= S0;
                        match <= 1'b1;
                    end else begin
                        state <= S0;
                    end
                end
            endcase
        end
    end
endmodule
"""
    else:
        design = """module seq_detect_101 (
    input wire clk,
    input wire rst,
    input wire bit_in,
    output reg match
);
    reg [1:0] state;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
            match <= 1'b0;
        end else begin
            match <= 1'b0;
            case (state)
                S0: state <= bit_in ? S1 : S0;
                S1: state <= bit_in ? S1 : S2;
                S2: begin
                    if (bit_in) begin
                        state <= S1;
                        match <= 1'b1;
                    end else begin
                        state <= S0;
                    end
                end
            endcase
        end
    end
endmodule
"""
    overlap_expected_4 = "1'b1" if tb_variant == "default_check" else "1'b0"
    tb = """`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg bit_in;
    wire match;

    seq_detect_101 dut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .match(match)
    );

    always #5 clk = ~clk;

    task drive_and_check;
        input stimulus;
        input expected;
        input [127:0] label;
        begin
            bit_in = stimulus;
            @(posedge clk);
            #1;
            if (match !== expected) begin
                $display("FAIL: %0s expected match=%0b got match=%0b time=%0t", label, expected, match, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        bit_in = 1'b0;

        rst = 1'b1;
        @(posedge clk);
        #1;
        if (match !== 1'b0) begin
            $display("FAIL: reset clears FSM state");
            $fatal(1);
        end

        rst = 1'b0;
        drive_and_check(1'b1, 1'b0, "start single 101");
        drive_and_check(1'b0, 1'b0, "middle single 101");
        drive_and_check(1'b1, 1'b1, "single 101 pulses");

        drive_and_check(1'b0, 1'b0, "overlap pattern bit 4");
        drive_and_check(1'b1, """ + overlap_expected_4 + """, "overlap pattern bit 5");

        drive_and_check(1'b1, 1'b0, "unrelated high input");
        drive_and_check(1'b1, 1'b0, "stable high does not false trigger");
        drive_and_check(1'b0, 1'b0, "trailing low no pulse");

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


def generator_button_debouncer(rtl_variant="counter_correct", tb_variant="default_check"):
    if rtl_variant == "two_cycle_bug":
        threshold = "2'd2"
        compare_count = "stable_count == 2'd2"
    else:
        threshold = "2'd3"
        compare_count = "stable_count == 2'd2"

    if tb_variant == "default_check":
        high_expected = "1'b1"
        low_expected = "1'b0"
    else:
        high_expected = "1'b0"
        low_expected = "1'b1"

    design = """module button_debouncer (
    input wire clk,
    input wire rst,
    input wire noisy_btn,
    output reg clean_btn
);
    reg last_sample;
    reg [1:0] stable_count;

    always @(posedge clk) begin
        if (rst) begin
            clean_btn <= 1'b0;
            last_sample <= 1'b0;
            stable_count <= 2'd0;
        end else begin
            if (noisy_btn != last_sample) begin
                last_sample <= noisy_btn;
                stable_count <= 2'd1;
            end else if (stable_count < """ + threshold + """) begin
                stable_count <= stable_count + 2'd1;
            end

            if (""" + compare_count + """) begin
                clean_btn <= last_sample;
            end
        end
    end
endmodule
"""
    tb = """`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg noisy_btn;
    wire clean_btn;

    button_debouncer dut (
        .clk(clk),
        .rst(rst),
        .noisy_btn(noisy_btn),
        .clean_btn(clean_btn)
    );

    always #5 clk = ~clk;

    task drive_and_check;
        input stimulus;
        input expected;
        input [127:0] label;
        begin
            noisy_btn = stimulus;
            @(posedge clk);
            #1;
            if (clean_btn !== expected) begin
                $display("FAIL: %0s expected clean_btn=%0b got clean_btn=%0b time=%0t", label, expected, clean_btn, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        noisy_btn = 1'b0;

        rst = 1'b1;
        @(posedge clk);
        #1;
        if (clean_btn !== 1'b0) begin
            $display("FAIL: reset forces clean_btn low");
            $fatal(1);
        end

        rst = 1'b0;
        drive_and_check(1'b1, 1'b0, "glitch cycle 1");
        drive_and_check(1'b0, 1'b0, "glitch cycle 2");
        drive_and_check(1'b1, 1'b0, "stable high cycle 1");
        drive_and_check(1'b1, 1'b0, "stable high cycle 2");
        drive_and_check(1'b1, """ + high_expected + """, "stable high cycle 3 updates output");
        drive_and_check(1'b0, """ + high_expected + """, "stable low cycle 1 keeps previous value");
        drive_and_check(1'b0, """ + high_expected + """, "stable low cycle 2 keeps previous value");
        drive_and_check(1'b0, """ + low_expected + """, "stable low cycle 3 updates output");

        $display("TEST PASSED");
        $finish;
    end
endmodule
"""
    return design, tb


KNOWN_GENERATORS = {
    "seq_detector_0011": {
        "generator": generator_seq_detector,
        "rtl_variants": ["delayed_pulse", "immediate_pulse"],
        "tb_variants": ["sample_delayed", "sample_immediate"],
    },
    "dot_product": {
        "generator": generator_dot_product,
        "rtl_variants": ["timing_pipelined", "single_pulse", "level_valid"],
        "tb_variants": ["pulse_check", "level_check"],
    },
    "exp_fixed_point": {
        "generator": generator_exp_fixed_point,
        "rtl_variants": ["lut_pipeline", "two_stage", "one_stage"],
        "tb_variants": ["two_stage_check", "one_stage_check"],
    },
    "fp16_multiplier": {
        "generator": generator_fp16_multiplier,
        "rtl_variants": ["default"],
        "tb_variants": ["default"],
    },
    "fir_filter": {
        "generator": generator_fir_filter,
        "rtl_variants": ["transposed_form", "direct_form", "reversed_taps"],
        "tb_variants": ["direct_expectation", "reversed_expectation"],
    },
    "rising_edge_detector": {
        "generator": generator_rising_edge_detector,
        "rtl_variants": ["prev_reg", "combinational_bug"],
        "tb_variants": ["default_check", "buggy_fall_check"],
    },
    "shift_register_4bit": {
        "generator": generator_shift_register_4bit,
        "rtl_variants": ["correct", "shift_priority_bug"],
        "tb_variants": ["default_check", "buggy_load_check"],
    },
    "seq_detect_101": {
        "generator": generator_seq_detect_101,
        "rtl_variants": ["overlap_correct", "no_overlap_bug"],
        "tb_variants": ["default_check", "no_overlap_expectation"],
    },
    "button_debouncer": {
        "generator": generator_button_debouncer,
        "rtl_variants": ["counter_correct", "two_cycle_bug"],
        "tb_variants": ["default_check", "inverted_expectation"],
    },
}


def generate_known_spec(spec_key, rtl_variant=None, tb_variant=None):
    entry = KNOWN_GENERATORS.get(spec_key)
    if not entry:
        return None, None
    chosen_rtl_variant = rtl_variant or entry["rtl_variants"][0]
    chosen_tb_variant = tb_variant or entry["tb_variants"][0]
    return entry["generator"](chosen_rtl_variant, chosen_tb_variant)


def run_codex_prompt(prompt):
    if not CODEX_CMD:
        return {
            "returncode": 1,
            "stdout": "",
            "stderr": "codex executable not found",
        }
    result = run(
        [CODEX_CMD, "exec", "--skip-git-repo-check", "--cd", str(ROOT), "-"],
        input_text=prompt,
    )
    return {
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }


def call_codex(prompt):
    result = run_codex_prompt(prompt)
    return result["returncode"] == 0


def generate_with_codex(spec_text, paths):
    prompt = f"""Read this YAML spec:

{spec_text}

Generate synthesizable Verilog-2005 RTL in {paths["candidate_rtl"].relative_to(ROOT).as_posix()}.
Generate a self-checking Verilog testbench in {paths["candidate_tb"].relative_to(ROOT).as_posix()}.
Use the module name and ports exactly as given in the YAML spec.
The design must be valid Verilog-2005 for Yosys and Icarus.
Do not use delays, initial blocks, unsupported system tasks, always_ff, always_comb, logic, typedefs, interfaces, classes, or inferred latches in the design.
Assign every combinational output on every path and use edge-triggered always blocks for sequential state.
Keep everything minimal and readable.
"""
    result = run_codex_prompt(prompt)
    return {
        "pass": result["returncode"] == 0 and paths["candidate_rtl"].exists() and paths["candidate_tb"].exists(),
        "stdout": result["stdout"],
        "stderr": result["stderr"],
        "prompt": prompt,
    }


BUGGY_RTL_VARIANTS = {
    "immediate_pulse",
    "level_valid",
    "one_stage",
    "reversed_taps",
    "combinational_bug",
    "shift_priority_bug",
    "no_overlap_bug",
    "two_cycle_bug",
}

BUGGY_TB_VARIANTS = {
    "sample_immediate",
    "level_check",
    "one_stage_check",
    "reversed_expectation",
    "buggy_fall_check",
    "buggy_load_check",
    "no_overlap_expectation",
    "inverted_expectation",
}

SIM_TIMEOUT_SECONDS = 10


def run_process(command, timeout_seconds=None, cwd=None, env=None):
    process = None
    try:
        process = subprocess.Popen(
            command,
            cwd=cwd or ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            env=env,
            start_new_session=True,
        )
        stdout, stderr = process.communicate(timeout=timeout_seconds)
        return {
            "returncode": process.returncode,
            "stdout": stdout,
            "stderr": stderr,
            "timed_out": False,
        }
    except subprocess.TimeoutExpired:
        if process is not None:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            stdout, stderr = process.communicate()
        else:
            stdout, stderr = "", ""
        return {
            "returncode": -9,
            "stdout": stdout or "",
            "stderr": stderr or "",
            "timed_out": True,
        }


def top_module_name(spec_text):
    top_key = first_top_level_key(spec_text)
    if top_key == "name":
        return extract_scalar(spec_text, "name")
    if top_key == "module_name":
        return extract_scalar(spec_text, "module_name")
    return top_key


def rtl_validation_errors(rtl_text, top_module):
    errors = []
    if not rtl_text.strip():
        errors.append("RTL file is empty.")
    if f"module {top_module}" not in rtl_text and f"module {top_module} " not in rtl_text and f"module {top_module}(" not in rtl_text:
        errors.append(f"Top module {top_module} was not found.")
    if re.search(r"(^|[^a-zA-Z0-9_])initial\s+begin", rtl_text):
        errors.append("Design contains an initial block.")
    if re.search(r"(^|[^a-zA-Z0-9_])always_ff\b", rtl_text):
        errors.append("Design uses always_ff instead of Verilog-2005 always blocks.")
    if re.search(r"(^|[^a-zA-Z0-9_])always_comb\b", rtl_text):
        errors.append("Design uses always_comb instead of Verilog-2005 always @*.")
    if re.search(r"(^|[^a-zA-Z0-9_])logic\b", rtl_text):
        errors.append("Design uses logic instead of Verilog reg/wire.")
    if re.search(r"(^|[^a-zA-Z0-9_])typedef\b", rtl_text):
        errors.append("Design uses typedef which is not Verilog-2005.")
    if re.search(r"(^|[^a-zA-Z0-9_])(interface|class|program)\b", rtl_text):
        errors.append("Design uses a SystemVerilog-only construct.")
    if re.search(r"(^|[^a-zA-Z0-9_])\$((display)|(monitor)|(finish)|(fatal)|(error)|(warning))\b", rtl_text):
        errors.append("Design uses simulation-only system tasks.")
    if re.search(r"^\s*#\s*[0-9]", rtl_text, re.MULTILINE):
        errors.append("Design contains a delay control.")
    return errors


def build_yosys_check_script(rtl_path, top_module):
    rtl_relative_path = Path("..") / rtl_path.name
    return "\n".join(
        [
            f"read_verilog {rtl_relative_path.as_posix()}",
            f"hierarchy -check -top {top_module}",
            "proc",
            "check",
            "",
        ]
    )


def run_yosys_sanity_check(paths, spec_text, attempt_number, repair_attempt):
    paths["synthesis_dir"].mkdir(parents=True, exist_ok=True)
    top_module = top_module_name(spec_text)
    script_path = paths["synthesis_dir"] / "sanity_check.ys"
    log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_yosys_check_r{repair_attempt}.log"
    write_text(script_path, build_yosys_check_script(paths["candidate_rtl"], top_module))

    if not YOSYS_CMD:
        message = "yosys executable not found.\n"
        write_text(log_path, message)
        return {
            "pass": False,
            "error": message,
            "log_path": log_path,
        }

    result = run_process([YOSYS_CMD, script_path.name], cwd=paths["synthesis_dir"])
    log_text = (
        f"$ yosys {script_path.name}\n"
        f"{result['stdout']}{result['stderr']}"
    )
    write_text(log_path, log_text)
    return {
        "pass": result["returncode"] == 0,
        "error": (result["stdout"] + result["stderr"]).strip(),
        "log_path": log_path,
    }


def build_rtl_repair_prompt(spec_text, paths, validation_error, current_rtl):
    return f"""Read this YAML spec:

{spec_text}

The current RTL in {paths["candidate_rtl"].relative_to(ROOT).as_posix()} failed synthesis sanity checks.

Error details:
{validation_error}

Current RTL:
```verilog
{current_rtl}
```

Rewrite only {paths["candidate_rtl"].relative_to(ROOT).as_posix()} so it is valid synthesizable Verilog-2005.
Preserve the module name, parameters, ports, and intended behavior.
Do not modify the testbench file.
Do not use delays, initial blocks, simulation-only system tasks, always_ff, always_comb, logic, typedefs, interfaces, classes, or inferred latches.
Ensure every combinational signal is assigned on every path and sequential logic uses always @(posedge clk) or always @(posedge clk or posedge rst) as appropriate.
"""


def attempt_rtl_repair(spec_text, paths, validation_error):
    if not CODEX_CMD:
        return {
            "pass": False,
            "stderr": "codex executable not found for RTL repair",
        }
    current_rtl = read_text(paths["candidate_rtl"]) if paths["candidate_rtl"].exists() else ""
    prompt = build_rtl_repair_prompt(spec_text, paths, validation_error, current_rtl)
    result = run_codex_prompt(prompt)
    return {
        "pass": result["returncode"] == 0 and paths["candidate_rtl"].exists(),
        "stderr": result["stderr"],
    }


def build_behavioral_repair_prompt(spec_text, paths, failure_summary, compile_log_text, sim_log_text, current_rtl):
    return f"""Read this YAML spec:

{spec_text}

The current RTL in {paths["candidate_rtl"].relative_to(ROOT).as_posix()} failed behavioral validation.

Failure summary:
{failure_summary}

Compile log:
{compile_log_text}

Simulation log:
{sim_log_text}

Current RTL:
```verilog
{current_rtl}
```

Rewrite only {paths["candidate_rtl"].relative_to(ROOT).as_posix()} so it remains synthesizable Verilog-2005 and passes the provided testbench behaviorally.
Do not modify the testbench file.
Do not use delays, initial blocks, simulation-only system tasks, always_ff, always_comb, logic, typedefs, interfaces, classes, or inferred latches.
Assign every combinational signal on every path and use clocked always blocks for sequential logic.
"""


def attempt_behavioral_rtl_repair(spec_text, paths, failure_summary, compile_log_text, sim_log_text):
    if not CODEX_CMD:
        return {
            "pass": False,
            "stderr": "codex executable not found for behavioral RTL repair",
        }
    current_rtl = read_text(paths["candidate_rtl"]) if paths["candidate_rtl"].exists() else ""
    prompt = build_behavioral_repair_prompt(
        spec_text,
        paths,
        failure_summary,
        compile_log_text,
        sim_log_text,
        current_rtl,
    )
    result = run_codex_prompt(prompt)
    return {
        "pass": result["returncode"] == 0 and paths["candidate_rtl"].exists(),
        "stderr": result["stderr"],
    }


def generate_candidate_files(spec_key, spec_text, paths, strategy, generation_log_path, reuse_existing_candidate=False):
    if reuse_existing_candidate and paths["candidate_rtl"].exists() and paths["candidate_tb"].exists():
        write_text(generation_log_path, "Reusing existing candidate RTL/TB from prior repair attempt.\n")
        return True, ""
    if spec_key in KNOWN_GENERATORS:
        design_text, tb_text = generate_known_spec(spec_key, strategy["rtl"], strategy["tb"])
        write_candidate_outputs(paths, design_text, tb_text)
        write_text(
            generation_log_path,
            (
                f"Generated locally for spec_key={spec_key}\n"
                f"rtl_strategy={strategy['rtl'] or 'codex'}\n"
                f"tb_strategy={strategy['tb'] or 'codex'}\n"
            ),
        )
        return True, ""

    generation_result = generate_with_codex(spec_text, paths)
    write_text(
        generation_log_path,
        (
            "$ codex exec\n"
            f"{generation_result['stdout']}{generation_result['stderr']}"
        ),
    )
    if not generation_result["pass"]:
        return False, "Codex generation failed before RTL validation."
    return True, ""


def validate_and_repair_rtl(spec_key, spec_text, paths, strategy, attempt_number, reuse_existing_candidate=False):
    generation_log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_generation.log"
    validation_log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_validation.log"
    repair_log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_repair.log"
    generated, generation_error = generate_candidate_files(
        spec_key,
        spec_text,
        paths,
        strategy,
        generation_log_path,
        reuse_existing_candidate=reuse_existing_candidate,
    )
    if not generated:
        write_text(validation_log_path, generation_error + "\n")
        return {
            "pass": False,
            "failure_summary": generation_error,
            "failure_type": "rtl_generation_failed",
            "generation_log_path": generation_log_path,
            "validation_log_path": validation_log_path,
            "repair_log_path": repair_log_path,
        }

    validation_entries = []
    repair_entries = []
    for repair_attempt in range(RTL_REPAIR_RETRIES):
        rtl_text = read_text(paths["candidate_rtl"]) if paths["candidate_rtl"].exists() else ""
        validation_errors = rtl_validation_errors(rtl_text, top_module_name(spec_text))
        if validation_errors:
            validation_error = "\n".join(validation_errors)
            log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_yosys_check_r{repair_attempt}.log"
            write_text(log_path, validation_error + "\n")
            sanity_result = {"pass": False, "error": validation_error, "log_path": log_path}
        else:
            sanity_result = run_yosys_sanity_check(paths, spec_text, attempt_number, repair_attempt)
        validation_entries.append(
            f"validation_round={repair_attempt}\n"
            f"log_path={sanity_result['log_path']}\n"
            f"status={'PASS' if sanity_result['pass'] else 'FAIL'}\n"
            f"details={sanity_result['error']}\n"
        )
        write_text(validation_log_path, "\n".join(validation_entries) + "\n")

        if sanity_result["pass"]:
            return {
                "pass": True,
                "sanity_log_path": sanity_result["log_path"],
                "repair_attempts_used": repair_attempt,
                "generation_log_path": generation_log_path,
                "validation_log_path": validation_log_path,
                "repair_log_path": repair_log_path,
            }

        print_step(
            f"RTL sanity check failed for {paths['spec_name']}: "
            f"{sanity_result['error'].splitlines()[0] if sanity_result['error'] else 'unknown error'}"
        )
        if repair_attempt >= RTL_REPAIR_RETRIES - 1:
            return {
                "pass": False,
                "failure_summary": sanity_result["error"] or "RTL failed Yosys sanity check.",
                "failure_type": "rtl_sanity_failure",
                "sanity_log_path": sanity_result["log_path"],
            }

        print_step(f"repair attempt {repair_attempt + 1}/{RTL_REPAIR_RETRIES - 1} for RTL sanity failure")
        repair_result = attempt_rtl_repair(spec_text, paths, sanity_result["error"])
        repair_entries.append(
            f"repair_round={repair_attempt}\n"
            f"reason={sanity_result['error']}\n"
            f"status={'PASS' if repair_result['pass'] else 'FAIL'}\n"
            f"stderr={repair_result['stderr']}\n"
        )
        write_text(repair_log_path, "\n".join(repair_entries) + "\n")
        if not repair_result["pass"]:
            failure_summary = sanity_result["error"]
            if repair_result["stderr"]:
                failure_summary += "\nRepair failed:\n" + repair_result["stderr"]
            return {
                "pass": False,
                "failure_summary": failure_summary,
                "failure_type": "rtl_repair_failed",
                "sanity_log_path": sanity_result["log_path"],
                "generation_log_path": generation_log_path,
                "validation_log_path": validation_log_path,
                "repair_log_path": repair_log_path,
            }

    return {
        "pass": False,
        "failure_summary": "RTL validation exhausted retries.",
        "failure_type": "rtl_sanity_failure",
        "generation_log_path": generation_log_path,
        "validation_log_path": validation_log_path,
        "repair_log_path": repair_log_path,
    }


def run_synthesis(paths, spec_text, rtl_path=None):
    paths["synthesis_dir"].mkdir(parents=True, exist_ok=True)

    top_module = top_module_name(spec_text)
    rtl_source = rtl_path or paths["rtl"]
    rtl_relative_path = Path("..") / rtl_source.name
    synth_script = "\n".join(
        [
            f"read_verilog {rtl_relative_path.as_posix()}",
            f"synth -top {top_module}",
            f"write_verilog {paths['synth_netlist'].name}",
            "",
        ]
    )
    write_text(paths["synth_script"], synth_script)

    if not YOSYS_CMD:
        message = "yosys executable not found.\n"
        write_text(paths["synth_log"], message)
        return {
            "pass": False,
            "returncode": 1,
            "stdout": "",
            "stderr": message,
            "command": "yosys synth.ys > synth.log 2>&1",
        }

    synth_result = run_process([YOSYS_CMD, "synth.ys"], cwd=paths["synthesis_dir"])
    synth_log = (
        f"$ yosys synth.ys > {paths['synth_log'].name} 2>&1\n"
        f"{synth_result['stdout']}{synth_result['stderr']}"
    )
    write_text(paths["synth_log"], synth_log)
    return {
        "pass": synth_result["returncode"] == 0,
        "returncode": synth_result["returncode"],
        "stdout": synth_result["stdout"],
        "stderr": synth_result["stderr"],
        "command": "yosys synth.ys > synth.log 2>&1",
    }


def run_netlist_simulation(netlist_path, tb_path, sim_out_path, log_path, label):
    compile_cmd = [IVERILOG_CMD, "-g2012", "-o", str(sim_out_path), str(netlist_path), str(tb_path)]
    sim_cmd = [VVP_CMD, str(sim_out_path)]

    compile_result = run_process(compile_cmd)
    log_parts = [f"$ {' '.join(compile_cmd)}\n{compile_result['stdout']}{compile_result['stderr']}"]
    sim_result = {"returncode": -1, "stdout": "", "stderr": "", "timed_out": False}

    if compile_result["returncode"] == 0:
        sim_result = run_process(sim_cmd, timeout_seconds=SIM_TIMEOUT_SECONDS)
        log_parts.append(f"$ {' '.join(sim_cmd)}\n{sim_result['stdout']}{sim_result['stderr']}")
    write_text(log_path, "\n".join(log_parts) + ("\n" if log_parts else ""))

    if compile_result["returncode"] != 0:
        return {
            "pass": False,
            "compile_pass": False,
            "sim_pass": False,
            "compile_result": compile_result,
            "sim_result": sim_result,
            "summary": f"{label} compile failed.",
        }

    return {
        "pass": sim_result["returncode"] == 0 and not sim_result["timed_out"],
        "compile_pass": True,
        "sim_pass": sim_result["returncode"] == 0 and not sim_result["timed_out"],
        "compile_result": compile_result,
        "sim_result": sim_result,
        "summary": f"{label} simulation {'passed' if sim_result['returncode'] == 0 and not sim_result['timed_out'] else 'failed'}.",
    }


def run_gls(paths):
    return run_netlist_simulation(
        paths["synth_netlist"],
        paths["candidate_tb"],
        paths["gls_out"],
        paths["gls_log"],
        "GLS",
    )


def find_openroad_flow_root():
    env_candidates = [
        os.environ.get("OPENROAD_FLOW_ROOT"),
        os.environ.get("OPENROAD_FLOW_DIR"),
        os.environ.get("ORFS_ROOT"),
    ]
    path_candidates = [
        ROOT / "OpenROAD-flow-scripts",
        ROOT.parent / "OpenROAD-flow-scripts",
        ROOT.parent.parent / "OpenROAD-flow-scripts",
        Path.home() / "OpenROAD-flow-scripts",
    ]
    for candidate in env_candidates:
        if candidate:
            path_candidates.insert(0, Path(candidate))

    for candidate in path_candidates:
        flow_dir = candidate / "flow"
        if flow_dir.exists() and (flow_dir / "Makefile").exists():
            return candidate
    return None


def infer_openroad_platform(spec_text):
    tech_node = extract_scalar(spec_text, "tech_node").lower()
    if "skywater" in tech_node or "sky130" in tech_node or "130" in tech_node:
        return "sky130hd"
    if "45" in tech_node or "nangate" in tech_node:
        return "nangate45"
    if "gf180" in tech_node or "180" in tech_node:
        return "gf180"
    return "sky130hd"


def infer_clock_port(spec_text):
    preferred_names = []
    lines = spec_text.splitlines()
    for idx, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("- name:"):
            port_name = stripped.split(":", 1)[1].strip().strip("'\"")
            next_lines = "\n".join(lines[idx + 1: idx + 4]).lower()
            if "direction: input" in next_lines:
                preferred_names.append(port_name)
    for preferred in preferred_names:
        lowered = preferred.lower()
        if lowered in ("clk", "clock") or "clk" in lowered or "clock" in lowered:
            return preferred
    return None


def infer_clock_period_ns(spec_text):
    raw = extract_scalar(spec_text, "clock_period")
    if not raw:
        return "10.0"
    value = raw.lower().replace("ns", "").strip()
    try:
        return f"{float(value):g}"
    except ValueError:
        return "10.0"


def openroad_config_overrides(spec_text):
    design_name = top_module_name(spec_text)
    overrides = {
        "core_utilization": "35",
        "core_aspect_ratio": "1",
        "core_margin": "2",
        "place_density": "0.50",
        "place_density_lb_addon": "0.15",
        "tns_end_percent": "100",
        "lec_check": "0",
        "remove_abc_buffers": "0",
        "setup_slack_margin": "0.0",
        "hold_slack_margin": "0.0",
        "hold_repair_mode": "baseline",
    }
    per_design = {
        "dot_product": {
            "core_utilization": "20",
            "core_margin": "4",
            "place_density": "0.30",
            "place_density_lb_addon": "0.10",
            "cts_cluster_size": "10",
            "cts_cluster_diameter": "50",
            "remove_abc_buffers": "1",
            "setup_slack_margin": "0.10",
            "hold_slack_margin": "0.05",
        },
        "exp_fixed_point": {
            "core_utilization": "18",
            "core_margin": "4",
            "place_density": "0.28",
            "place_density_lb_addon": "0.08",
            "cts_cluster_size": "10",
            "cts_cluster_diameter": "50",
            "remove_abc_buffers": "1",
            "setup_slack_margin": "0.10",
            "hold_slack_margin": "0.05",
        },
        "fir_filter": {
            "core_utilization": "18",
            "core_margin": "4",
            "place_density": "0.28",
            "place_density_lb_addon": "0.08",
            "cts_cluster_size": "10",
            "cts_cluster_diameter": "50",
            "remove_abc_buffers": "1",
            "setup_slack_margin": "0.08",
            "hold_slack_margin": "0.05",
        },
        "seq_detector_0011": {
            # Tiny designs need extra area so sky130 PDN straps can be generated.
            "core_utilization": "10",
            "core_margin": "4",
            "place_density": "0.35",
            "place_density_lb_addon": "0.10",
        },
    }
    overrides.update(per_design.get(design_name, {}))
    return overrides


def write_openroad_workspace(paths, spec_text, overrides=None):
    platform = infer_openroad_platform(spec_text)
    design_name = top_module_name(spec_text)
    clock_port = infer_clock_port(spec_text)
    clock_period = infer_clock_period_ns(spec_text)
    overrides = dict(overrides or openroad_config_overrides(spec_text))

    shutil.copyfile(paths["synth_netlist"], paths["openroad_netlist"])

    sdc_lines = []
    if clock_port:
        sdc_lines.extend(
            [
                f"create_clock [get_ports {clock_port}] -period {clock_period}",
                "set_input_delay 0.0 -clock [get_clocks *] [all_inputs]",
                "set_output_delay 0.0 -clock [get_clocks *] [all_outputs]",
            ]
        )
    sdc_text = "\n".join(sdc_lines + [""])
    write_text(paths["openroad_sdc"], sdc_text)

    config_lines = [
        f"export DESIGN_NAME = {design_name}",
        f"export PLATFORM = {platform}",
        f"export VERILOG_FILES = src/{paths['openroad_netlist'].name}",
        f"export SDC_FILE = {paths['openroad_sdc'].name}",
        f"export CORE_UTILIZATION = {overrides['core_utilization']}",
        f"export CORE_ASPECT_RATIO = {overrides['core_aspect_ratio']}",
        f"export CORE_MARGIN = {overrides['core_margin']}",
        f"export PLACE_DENSITY = {overrides['place_density']}",
        f"export PLACE_DENSITY_LB_ADDON = {overrides['place_density_lb_addon']}",
        f"export TNS_END_PERCENT = {overrides['tns_end_percent']}",
        f"export LEC_CHECK = {overrides['lec_check']}",
    ]
    if clock_port:
        config_lines.append(f"export CLOCK_PORT = {clock_port}")
        config_lines.append(f"export CLOCK_PERIOD = {clock_period}")
    if "cts_cluster_size" in overrides:
        config_lines.append(f"export CTS_CLUSTER_SIZE = {overrides['cts_cluster_size']}")
    if "cts_cluster_diameter" in overrides:
        config_lines.append(f"export CTS_CLUSTER_DIAMETER = {overrides['cts_cluster_diameter']}")
    config_lines.append(f"export SETUP_SLACK_MARGIN = {overrides.get('setup_slack_margin', '0.0')}")
    config_lines.append(f"export HOLD_SLACK_MARGIN = {overrides.get('hold_slack_margin', '0.0')}")
    config_lines.append("")
    config_text = "\n".join(config_lines)
    write_text(paths["openroad_config"], config_text)
    return {
        "platform": platform,
        "design_name": design_name,
        "clock_port": clock_port or "<none>",
        "clock_period": clock_period if clock_port else "<none>",
    }


def openroad_retry_profiles(spec_text):
    base = openroad_config_overrides(spec_text)
    profiles = [dict(base)]
    hold_focus = dict(base)
    hold_focus.update(
        {
            "hold_slack_margin": "0.08",
            "place_density": "0.27" if base.get("place_density") in {"0.28", "0.30"} else base.get("place_density", "0.50"),
            "place_density_lb_addon": "0.05",
            "hold_repair_mode": "hold_buffering",
        }
    )
    relaxed = dict(base)
    relaxed.update(
        {
            "core_utilization": "10",
            "core_margin": "4",
            "place_density": "0.35",
            "place_density_lb_addon": "0.10",
            "setup_slack_margin": "0.05",
            "hold_slack_margin": "0.05",
            "hold_repair_mode": "setup_relaxed",
        }
    )
    aggressive = dict(base)
    aggressive.update(
        {
            "core_utilization": "5",
            "core_margin": "6",
            "place_density": "0.30",
            "place_density_lb_addon": "0.05",
            "setup_slack_margin": "0.10",
            "hold_slack_margin": "0.10",
            "hold_repair_mode": "setup_and_hold_aggressive",
        }
    )
    for candidate in (hold_focus, relaxed, aggressive):
        if candidate not in profiles:
            profiles.append(candidate)
    return profiles


def openroad_timing_metrics(paths):
    metrics_path = paths["openroad_logs_dir"] / "base" / "6_report.json"
    report_path = paths["openroad_reports_dir"] / "base" / "6_finish.rpt"
    wns = None
    tns = None
    whs = None
    hold_tns = None
    hold_violation_count = None
    area = None

    if metrics_path.exists():
        try:
            data = json.loads(read_text(metrics_path))
            if "finish__timing__setup__ws" in data:
                wns = float(data["finish__timing__setup__ws"])
            if "finish__timing__setup__tns" in data:
                tns = float(data["finish__timing__setup__tns"])
            if "finish__timing__hold__ws" in data:
                whs = float(data["finish__timing__hold__ws"])
            if "finish__timing__hold__tns" in data:
                hold_tns = float(data["finish__timing__hold__tns"])
            if "finish__timing__drv__hold_violation_count" in data:
                hold_violation_count = int(data["finish__timing__drv__hold_violation_count"])
            if "finish__design__instance__area" in data:
                area = float(data["finish__design__instance__area"])
        except (ValueError, TypeError, json.JSONDecodeError):
            pass

    if report_path.exists():
        report_text = read_text(report_path)
        if wns is None:
            match = re.search(r"finish report_wns.*?^\s*wns max\s+([^\s]+)", report_text, re.MULTILINE | re.DOTALL)
            if match:
                try:
                    wns = float(match.group(1))
                except ValueError:
                    pass
        if tns is None:
            match = re.search(r"finish report_tns.*?^\s*tns max\s+([^\s]+)", report_text, re.MULTILINE | re.DOTALL)
            if match:
                try:
                    tns = float(match.group(1))
                except ValueError:
                    pass
        if whs is None:
            match = re.search(r"finish report_worst_slack_min.*?^\s*worst slack min\s+([^\s]+)", report_text, re.MULTILINE | re.DOTALL)
            if match:
                try:
                    whs = float(match.group(1))
                except ValueError:
                    pass

    if wns is not None and abs(wns) > 1e20:
        wns = 0.0
    if tns is not None and abs(tns) > 1e20:
        tns = 0.0
    if whs is not None and abs(whs) > 1e20:
        whs = 0.0
    if hold_tns is not None and abs(hold_tns) > 1e20:
        hold_tns = 0.0
    if area is not None and abs(area) > 1e20:
        area = None
    setup_pass = (wns is not None and wns >= 0.0)
    hold_pass = (whs is not None and whs >= 0.0)
    hold_violation = (not hold_pass) or ((hold_violation_count or 0) > 0)
    meets_timing = setup_pass and hold_pass
    return {
        "wns": wns,
        "tns": tns,
        "whs": whs,
        "hold_tns": hold_tns,
        "area": area,
        "setup_pass": setup_pass,
        "hold_pass": hold_pass,
        "hold_violation": hold_violation,
        "hold_violation_count": hold_violation_count,
        "meets_timing": meets_timing,
    }


def openroad_should_retry_with_relaxed_floorplan(output_text):
    lowered = output_text.lower()
    return (
        "pdn-0185" in lowered
        or ("insufficient width" in lowered and "pdn" in lowered)
        or ("unable to add straps" in lowered and "pdn" in lowered)
    )


def copy_tree_contents(src_dir, dst_dir):
    if not src_dir.exists():
        return
    dst_dir.mkdir(parents=True, exist_ok=True)
    for item in src_dir.iterdir():
        destination = dst_dir / item.name
        if item.is_dir():
            if destination.exists():
                shutil.rmtree(destination)
            shutil.copytree(item, destination)
        else:
            shutil.copyfile(item, destination)


def clear_directory(path):
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def collect_openroad_outputs(run_home, paths, platform, design_name):
    for category, dest in (
        ("logs", paths["openroad_logs_dir"]),
        ("reports", paths["openroad_reports_dir"]),
        ("results", paths["openroad_results_dir"]),
    ):
        source = run_home / category / platform / design_name
        if source.exists():
            copy_tree_contents(source, dest)


def snapshot_openroad_outputs(paths, snapshot_dir):
    clear_directory(snapshot_dir)
    copy_tree_contents(paths["openroad_logs_dir"], snapshot_dir / "logs")
    copy_tree_contents(paths["openroad_reports_dir"], snapshot_dir / "reports")
    copy_tree_contents(paths["openroad_results_dir"], snapshot_dir / "results")


def restore_openroad_snapshot(paths, snapshot_dir):
    if not snapshot_dir.exists():
        return
    clear_directory(paths["openroad_logs_dir"])
    clear_directory(paths["openroad_reports_dir"])
    clear_directory(paths["openroad_results_dir"])
    copy_tree_contents(snapshot_dir / "logs", paths["openroad_logs_dir"])
    copy_tree_contents(snapshot_dir / "reports", paths["openroad_reports_dir"])
    copy_tree_contents(snapshot_dir / "results", paths["openroad_results_dir"])


def better_timing_metrics(candidate, incumbent):
    if incumbent is None:
        return True
    if candidate.get("meets_timing", False) != incumbent.get("meets_timing", False):
        return candidate.get("meets_timing", False)
    if candidate.get("hold_pass", False) != incumbent.get("hold_pass", False):
        return candidate.get("hold_pass", False)
    candidate_whs = float("-inf") if candidate.get("whs") is None else candidate["whs"]
    incumbent_whs = float("-inf") if incumbent.get("whs") is None else incumbent["whs"]
    if candidate_whs != incumbent_whs:
        return candidate_whs > incumbent_whs
    candidate_wns = float("-inf") if candidate.get("wns") is None else candidate["wns"]
    incumbent_wns = float("-inf") if incumbent.get("wns") is None else incumbent["wns"]
    if candidate_wns != incumbent_wns:
        return candidate_wns > incumbent_wns
    candidate_tns = float("-inf") if candidate.get("tns") is None else candidate["tns"]
    incumbent_tns = float("-inf") if incumbent.get("tns") is None else incumbent["tns"]
    return candidate_tns > incumbent_tns


def openroad_reports_exist(paths):
    return any(paths["openroad_reports_dir"].rglob("*")) and any(paths["openroad_results_dir"].rglob("*"))


def openroad_final_outputs_exist(paths):
    required = [
        paths["openroad_results_dir"] / "base" / "6_final.def",
        paths["openroad_results_dir"] / "base" / "6_final.gds",
        paths["openroad_logs_dir"] / "base" / "6_report.log",
    ]
    return all(path.exists() for path in required)


def openroad_stale_logs_exist(paths):
    stale_patterns = [
        paths["openroad_logs_dir"].rglob("*.tmp.log"),
        paths["openroad_run_home"].rglob("*.tmp.log"),
    ]
    return any(True for pattern in stale_patterns for _ in pattern)


def compute_attempt_pass(paths, report):
    report_path = paths["reports_dir"] / f"attempt_{report['attempt']:02d}.yaml"
    compile_pass = report.get("compile_pass", False)
    sim_pass = report.get("sim_pass", False)
    synthesis_pass = report.get("synthesis_pass", False)
    gls_pass = report.get("gls_pass", False)
    openroad_pass = report.get("openroad_pass", False)
    wns = report.get("wns")
    whs = report.get("whs")
    setup_pass = (wns is not None and wns >= 0.0)
    hold_pass = (whs is not None and whs >= 0.0)
    hold_violation = report.get("hold_violation", not hold_pass)
    meets_timing = setup_pass and hold_pass
    final_artifacts_exist = openroad_final_outputs_exist(paths)
    stale_logs = openroad_stale_logs_exist(paths)
    report_generated = report_path.exists()
    flow_pass = (
        compile_pass
        and sim_pass
        and synthesis_pass
        and gls_pass
        and openroad_pass
        and final_artifacts_exist
        and report_generated
        and not stale_logs
    )
    passed = flow_pass and meets_timing
    failure_type = report.get("failure_type", "none")
    failure_summary = report.get("failure_summary", "")
    final_status = "PASS" if passed else "FAIL"
    if flow_pass and not meets_timing:
        if not hold_pass:
            failure_type = "hold_violation"
            failure_summary = "Hold violation: OpenROAD completed but final WHS is negative."
        else:
            failure_type = "timing_violation"
            failure_summary = "Timing violation: OpenROAD completed but final WNS is negative."
    return {
        "flow_pass": flow_pass,
        "setup_pass": setup_pass,
        "hold_pass": hold_pass,
        "hold_violation": hold_violation,
        "meets_timing": meets_timing,
        "passed": passed,
        "status": final_status,
        "final_status": final_status,
        "report_generated": report_generated,
        "final_artifacts_exist": final_artifacts_exist,
        "stale_logs": stale_logs,
        "failure_type": failure_type,
        "failure_summary": failure_summary,
    }


def latest_attempt_report_path(paths):
    reports = sorted(
        paths["reports_dir"].glob("attempt_*.yaml"),
        key=lambda path: int(re.match(r"attempt_(\d+)\.yaml$", path.name).group(1)) if re.match(r"attempt_(\d+)\.yaml$", path.name) else -1,
    )
    return reports[-1] if reports else None


def attempt_number_from_report_path(report_path):
    if not report_path:
        return None
    match = re.match(r"attempt_(\d+)\.yaml$", report_path.name)
    return int(match.group(1)) if match else None


def parse_report_kv(report_path):
    if not report_path or not report_path.exists():
        return {}
    parsed = {}
    for line in read_text(report_path).splitlines():
        if ": " not in line:
            continue
        key, value = line.split(": ", 1)
        parsed[key.strip()] = value.strip().strip('"')
    return parsed


def report_is_finalized(report_path):
    parsed = parse_report_kv(report_path)
    return bool(parsed.get("final_status")) and "passed" in parsed and "flow_pass" in parsed


def append_runner_log(paths, attempt, label, stdout_text, stderr_text):
    runner_log_path = paths["logs_dir"] / f"attempt_{attempt:02d}_runner.log"
    text = (
        f"runner_event: {label}\n"
        f"stdout:\n{stdout_text}\n"
        f"stderr:\n{stderr_text}\n"
    )
    write_text(runner_log_path, text)
    return runner_log_path


def emit_partial_failure_report(paths, attempt, failure_type, failure_summary, stdout_text="", stderr_text=""):
    runner_log_path = append_runner_log(paths, attempt, failure_type, stdout_text, stderr_text)
    report = {
        "attempt": attempt,
        "current_run_iterations": 1,
        "status": "FAIL",
        "final_status": "FAIL",
        "passed": False,
        "flow_pass": False,
        "rtl_strategy": "isolated_runner",
        "tb_strategy": "isolated_runner",
        "compile_pass": False,
        "sim_pass": False,
        "synthesis_pass": False,
        "gls_pass": False,
        "openroad_pass": False,
        "openroad_skipped": False,
        "report_generated": True,
        "final_artifacts_exist": openroad_final_outputs_exist(paths),
        "stale_logs": openroad_stale_logs_exist(paths),
        "setup_pass": False,
        "hold_pass": False,
        "hold_violation": failure_type == "hold_violation",
        "meets_timing": False,
        "wns": None,
        "tns": None,
        "whs": None,
        "area": None,
        "timing_fix": "",
        "failure_type": failure_type,
        "compile_log_path": runner_log_path,
        "sim_log_path": runner_log_path,
        "synthesis_log_path": paths["synth_log"],
        "gls_log_path": paths["gls_log"],
        "openroad_log_path": paths["openroad_run_log"],
        "generation_log_path": runner_log_path,
        "validation_log_path": runner_log_path,
        "repair_log_path": runner_log_path,
        "failure_summary": failure_summary,
    }
    return write_attempt_report(paths, report)


def isolated_spec_command(spec_path, demo_repair=False, demo_tb_repair=False, disable_openroad=False, max_attempts=MAX_RETRIES):
    command = [PYTHON_CMD or sys.executable or "python3", str(ROOT / "agent.py"), str(spec_path)]
    if demo_repair:
        command.append("--demo-repair")
    if demo_tb_repair:
        command.append("--demo-tb-repair")
    if disable_openroad:
        command.append("--disable-openroad")
    command.extend(["--max-attempts", str(max_attempts)])
    return command


def run_spec_isolated(spec_path, demo_repair=False, demo_tb_repair=False, disable_openroad=False, max_attempts=MAX_RETRIES, timeout_seconds=DEFAULT_SPEC_TIMEOUT_SECONDS):
    paths = spec_output_paths(spec_path)
    ensure_spec_directories(paths)
    starting_attempt = next_attempt_number(paths)
    command = isolated_spec_command(
        spec_path,
        demo_repair=demo_repair,
        demo_tb_repair=demo_tb_repair,
        disable_openroad=disable_openroad,
        max_attempts=max_attempts,
    )

    process = None
    stdout_text = ""
    stderr_text = ""
    timeout_hit = False
    exception_text = ""
    try:
        process = subprocess.Popen(
            command,
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            start_new_session=True,
        )
        stdout_text, stderr_text = process.communicate(timeout=timeout_seconds)
    except subprocess.TimeoutExpired:
        timeout_hit = True
        if process is not None:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            stdout_text, stderr_text = process.communicate()
    except Exception:
        exception_text = traceback.format_exc()
        if process is not None:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            stdout_text, stderr_text = process.communicate()

    if stdout_text:
        print(stdout_text, end="" if stdout_text.endswith("\n") else "\n")
    if stderr_text:
        print(stderr_text, end="" if stderr_text.endswith("\n") else "\n", file=sys.stderr)

    latest_report = latest_attempt_report_path(paths)
    latest_attempt = attempt_number_from_report_path(latest_report)
    if (
        latest_report
        and latest_attempt is not None
        and latest_attempt >= starting_attempt
        and report_is_finalized(latest_report)
    ):
        parsed = parse_report_kv(latest_report)
        return 0 if parsed.get("final_status") == "PASS" else 1

    if timeout_hit:
        print_step(f"{spec_path.name} exceeded timeout of {timeout_seconds}s; marking spec as failed and continuing")
        emit_partial_failure_report(
            paths,
            next_attempt_number(paths),
            "timeout",
            f"Spec timed out or got stuck before a final report was produced. timeout_seconds={timeout_seconds}",
            stdout_text,
            stderr_text,
        )
        return 1

    if exception_text:
        print_step(f"{spec_path.name} raised an exception in isolated execution; marking spec as failed and continuing")
        emit_partial_failure_report(
            paths,
            next_attempt_number(paths),
            "exception",
            "Spec crashed before a final report was produced.",
            stdout_text,
            stderr_text + ("\n" if stderr_text else "") + exception_text,
        )
        return 1

    returncode = process.returncode if process is not None else 1
    print_step(f"{spec_path.name} did not produce a finalized report; marking spec as failed and continuing")
    emit_partial_failure_report(
        paths,
        next_attempt_number(paths),
        "stuck_stage" if returncode == 0 else "runner_failure",
        (
            "Spec completed without a finalized attempt report."
            if returncode == 0
            else f"Spec runner exited with return code {returncode} before a finalized report was produced."
        ),
        stdout_text,
        stderr_text,
    )
    return 1


def openroad_stage_targets(run_home, platform, design_name):
    base_dir = run_home / "results" / platform / design_name / "base"
    log_dir = run_home / "logs" / platform / design_name / "base"
    targets = []
    checkpoints = [
        ((base_dir / "3_3_place_gp.odb").exists(), base_dir / "3_4_place_resized.odb"),
        ((base_dir / "3_4_place_resized.odb").exists(), base_dir / "3_5_place_dp.odb"),
        ((base_dir / "3_5_place_dp.odb").exists(), base_dir / "3_place.odb"),
        ((base_dir / "3_place.odb").exists(), base_dir / "3_place.sdc"),
        ((base_dir / "3_place.odb").exists() and (base_dir / "3_place.sdc").exists(), base_dir / "4_1_cts.odb"),
        ((base_dir / "4_1_cts.odb").exists(), base_dir / "4_cts.odb"),
        ((base_dir / "4_cts.odb").exists(), base_dir / "4_cts.sdc"),
        ((base_dir / "4_cts.odb").exists() and (base_dir / "4_cts.sdc").exists(), base_dir / "5_1_grt.odb"),
        ((base_dir / "5_1_grt.odb").exists(), base_dir / "5_1_grt.sdc"),
        ((base_dir / "5_1_grt.odb").exists() and (base_dir / "5_1_grt.sdc").exists(), base_dir / "5_2_route.odb"),
        ((base_dir / "5_2_route.odb").exists(), base_dir / "5_3_fillcell.odb"),
        ((base_dir / "5_3_fillcell.odb").exists(), base_dir / "5_route.odb"),
        ((base_dir / "5_route.odb").exists(), base_dir / "5_route.sdc"),
        ((base_dir / "5_route.odb").exists() and (base_dir / "5_route.sdc").exists(), base_dir / "6_1_fill.odb"),
        ((base_dir / "6_1_fill.odb").exists(), base_dir / "6_1_fill.sdc"),
        ((base_dir / "5_route.sdc").exists(), base_dir / "6_final.sdc"),
        ((base_dir / "6_1_fill.odb").exists() and (base_dir / "6_1_fill.sdc").exists(), log_dir / "6_report.log"),
    ]
    for ready, target in checkpoints:
        if ready and not target.exists():
            targets.append(str(target))
    return targets


def run_openroad_make(make_cmd, cwd, env, log_lines, label):
    result = run_process(make_cmd, cwd=cwd, env=env)
    log_lines.append(f"$ {' '.join(make_cmd)}")
    log_lines.append(f"# step: {label}")
    log_lines.append(result["stdout"])
    log_lines.append(result["stderr"])
    return result


def stage_status(value, skipped=False):
    if skipped:
        return "SKIP"
    return "PASS" if value else "FAIL"


def should_run_openroad(spec_text, disable_openroad=False):
    if disable_openroad:
        return False
    value = os.environ.get("SPEC2RTL_DISABLE_OPENROAD", "").strip().lower()
    if value in {"1", "true", "yes", "on"}:
        return False
    if extract_bool(spec_text, "disable_openroad", default=False):
        return False
    return extract_bool(spec_text, "run_openroad", default=True)


def run_openroad(paths, spec_text):
    flow_root = find_openroad_flow_root()
    run_home = paths["openroad_run_home"]
    log_lines = [
        f"openroad_output_dir={paths['openroad_dir']}",
        f"openroad_run_home={run_home}",
    ]

    if flow_root is None:
        message = "OpenROAD required but OpenROAD-flow-scripts was not found."
        log_lines.append(message)
        write_text(paths["openroad_run_log"], "\n".join(log_lines) + "\n")
        return {
            "pass": False,
            "skipped": False,
            "summary": message,
            "output_dir": paths["openroad_dir"],
        }

    if not OPENROAD_CMD:
        message = "OpenROAD required but the openroad executable was not found."
        log_lines.append(message)
        write_text(paths["openroad_run_log"], "\n".join(log_lines) + "\n")
        return {
            "pass": False,
            "skipped": False,
            "summary": message,
            "output_dir": paths["openroad_dir"],
        }

    profiles = openroad_retry_profiles(spec_text)
    result = {"returncode": 1, "stdout": "", "stderr": "", "timed_out": False}
    reports_found = False
    final_outputs_found = False
    last_output_text = ""
    workspace_info = None
    best_timing_metrics = None
    best_snapshot_dir = paths["openroad_dir"] / ".best_timing_snapshot"

    for profile_index, overrides in enumerate(profiles, start=1):
        workspace_info = write_openroad_workspace(paths, spec_text, overrides=overrides)
        if profile_index == 1:
            log_lines.extend(
                [
                    f"platform={workspace_info['platform']}",
                    f"design_name={workspace_info['design_name']}",
                    f"clock_port={workspace_info['clock_port']}",
                    f"clock_period={workspace_info['clock_period']}",
                ]
            )
        log_lines.append(
            f"retry_profile_{profile_index}=core_utilization:{overrides['core_utilization']},"
            f"core_margin:{overrides['core_margin']},place_density:{overrides['place_density']},"
            f"place_density_lb_addon:{overrides['place_density_lb_addon']},"
            f"remove_abc_buffers:{overrides.get('remove_abc_buffers', '0')},"
            f"setup_slack_margin:{overrides.get('setup_slack_margin', '0.0')},"
            f"hold_slack_margin:{overrides.get('hold_slack_margin', '0.0')},"
            f"hold_repair_mode:{overrides.get('hold_repair_mode', 'baseline')}"
        )

        workspace = Path(tempfile.gettempdir()) / "spec2rtl_openroad" / paths["spec_name"]
        if workspace.exists():
            shutil.rmtree(workspace)
        clear_directory(run_home)
        clear_directory(paths["openroad_logs_dir"])
        clear_directory(paths["openroad_reports_dir"])
        clear_directory(paths["openroad_results_dir"])
        runtime_dir = run_home / ".xdg_runtime"
        runtime_dir.mkdir(parents=True, exist_ok=True)
        flow_design_dir = workspace / "flow" / "designs" / workspace_info["platform"] / workspace_info["design_name"]
        flow_design_src_dir = flow_design_dir / "src"
        flow_design_src_dir.mkdir(parents=True, exist_ok=True)
        log_lines.append(f"workspace={workspace}")
        flow_netlist = flow_design_src_dir / paths["openroad_netlist"].name
        flow_sdc = flow_design_dir / "constraint.sdc"
        shutil.copyfile(paths["synth_netlist"], flow_netlist)
        shutil.copyfile(paths["openroad_sdc"], flow_sdc)
        workspace_config_text = "\n".join(
            (
                [
                    f"export DESIGN_NAME = {workspace_info['design_name']}",
                    f"export PLATFORM = {workspace_info['platform']}",
                    f"export VERILOG_FILES = {flow_netlist}",
                    f"export SDC_FILE = {flow_sdc}",
                    f"export CORE_UTILIZATION = {overrides['core_utilization']}",
                    f"export CORE_ASPECT_RATIO = {overrides['core_aspect_ratio']}",
                    f"export CORE_MARGIN = {overrides['core_margin']}",
                    f"export PLACE_DENSITY = {overrides['place_density']}",
                    f"export PLACE_DENSITY_LB_ADDON = {overrides['place_density_lb_addon']}",
                    f"export TNS_END_PERCENT = {overrides['tns_end_percent']}",
                    f"export LEC_CHECK = {overrides['lec_check']}",
                    f"export REMOVE_ABC_BUFFERS = {overrides.get('remove_abc_buffers', '0')}",
                    f"export SETUP_SLACK_MARGIN = {overrides.get('setup_slack_margin', '0.0')}",
                    f"export HOLD_SLACK_MARGIN = {overrides.get('hold_slack_margin', '0.0')}",
                ]
                + (
                    [
                        f"export CLOCK_PORT = {workspace_info['clock_port']}",
                        f"export CLOCK_PERIOD = {workspace_info['clock_period']}",
                    ]
                    if workspace_info["clock_port"] != "<none>"
                    else []
                )
                + (
                    [f"export CTS_CLUSTER_SIZE = {overrides['cts_cluster_size']}"]
                    if "cts_cluster_size" in overrides
                    else []
                )
                + (
                    [f"export CTS_CLUSTER_DIAMETER = {overrides['cts_cluster_diameter']}"]
                    if "cts_cluster_diameter" in overrides
                    else []
                )
                + [""]
            )
        )
        write_text(flow_design_dir / "config.mk", workspace_config_text)

        make_cmd = [
            "make",
            "-C",
            str(flow_root / "flow"),
            f"DESIGN_CONFIG={flow_design_dir / 'config.mk'}",
            f"PLATFORM={workspace_info['platform']}",
            f"DESIGN_NAME={workspace_info['design_name']}",
            f"WORK_HOME={run_home}",
        ]
        openroad_env = os.environ.copy()
        openroad_env["QT_QPA_PLATFORM"] = "offscreen"
        openroad_env["XDG_RUNTIME_DIR"] = str(runtime_dir)
        openroad_env.pop("DISPLAY", None)
        log_lines.append(f"env: QT_QPA_PLATFORM=offscreen XDG_RUNTIME_DIR={runtime_dir} DISPLAY=<unset>")
        result = run_openroad_make(make_cmd, paths["openroad_dir"], openroad_env, log_lines, f"full_flow_profile_{profile_index}")
        collect_openroad_outputs(run_home, paths, workspace_info["platform"], workspace_info["design_name"])
        reports_found = openroad_reports_exist(paths)
        final_outputs_found = openroad_final_outputs_exist(paths)
        if not final_outputs_found:
            attempted_targets = set()
            while True:
                pending_targets = [
                    target
                    for target in openroad_stage_targets(run_home, workspace_info["platform"], workspace_info["design_name"])
                    if target not in attempted_targets
                ]
                if not pending_targets:
                    break
                target = pending_targets[0]
                attempted_targets.add(target)
                resume_cmd = make_cmd + [target]
                result = run_openroad_make(resume_cmd, paths["openroad_dir"], openroad_env, log_lines, f"resume:{target}")
                collect_openroad_outputs(run_home, paths, workspace_info["platform"], workspace_info["design_name"])
                reports_found = openroad_reports_exist(paths)
                final_outputs_found = openroad_final_outputs_exist(paths)
                if final_outputs_found:
                    break
        last_output_text = f"{result['stdout']}\n{result['stderr']}"
        if final_outputs_found:
            timing_metrics = openroad_timing_metrics(paths)
            if better_timing_metrics(timing_metrics, best_timing_metrics):
                best_timing_metrics = dict(timing_metrics)
                snapshot_openroad_outputs(paths, best_snapshot_dir)
            log_lines.append(
                "timing_metrics="
                f"wns:{timing_metrics['wns']},tns:{timing_metrics['tns']},"
                f"whs:{timing_metrics['whs']},area:{timing_metrics['area']},"
                f"setup_pass:{timing_metrics['setup_pass']},hold_pass:{timing_metrics['hold_pass']},"
                f"meets_timing:{timing_metrics['meets_timing']}"
            )
            if timing_metrics["meets_timing"]:
                break
            if profile_index < len(profiles):
                if not timing_metrics.get("hold_pass", False):
                    log_lines.append("retry_reason=Hold not closed, retrying with hold-aware optimization settings.")
                else:
                    log_lines.append("retry_reason=Timing not closed, retrying with more timing-aggressive flow settings.")
                continue
            break
        if not openroad_should_retry_with_relaxed_floorplan(last_output_text):
            break
        if profile_index < len(profiles):
            log_lines.append("retry_reason=Detected PDN/floorplan width failure, retrying with relaxed floorplan constraints.")

    if best_timing_metrics is not None:
        restore_openroad_snapshot(paths, best_snapshot_dir)
        final_outputs_found = openroad_final_outputs_exist(paths)
        log_lines.append(
            "selected_timing_metrics="
            f"wns:{best_timing_metrics['wns']},tns:{best_timing_metrics['tns']},"
            f"whs:{best_timing_metrics['whs']},area:{best_timing_metrics['area']},"
            f"setup_pass:{best_timing_metrics['setup_pass']},hold_pass:{best_timing_metrics['hold_pass']},"
            f"meets_timing:{best_timing_metrics['meets_timing']}"
        )

    log_lines.append(f"reports_found={reports_found}")
    log_lines.append(f"final_outputs_found={final_outputs_found}")
    write_text(paths["openroad_run_log"], "\n".join(log_lines) + "\n")

    openroad_output = last_output_text.lower()
    if "read-only file system" in openroad_output or "permission denied" in openroad_output:
        return {
            "pass": False,
            "skipped": False,
            "summary": "OpenROAD failed because the environment does not permit required filesystem writes.",
            "output_dir": paths["openroad_dir"],
        }

    return {
        "pass": final_outputs_found,
        "skipped": False,
        "summary": (
            "OpenROAD completed successfully."
            if final_outputs_found
            else "OpenROAD failed or expected reports/results were not produced."
        ),
        "output_dir": paths["openroad_dir"],
        "timing_metrics": openroad_timing_metrics(paths) if final_outputs_found else {"wns": None, "tns": None, "whs": None, "area": None, "setup_pass": False, "hold_pass": False, "hold_violation": False, "meets_timing": False},
    }


def classify_failure(result, strategy):
    compile_text = (result["compile"]["stdout"] + result["compile"]["stderr"]).lower()
    sim_text = (result["sim"]["stdout"] + result["sim"]["stderr"]).lower()

    if result["compile"]["returncode"] != 0:
        if "port" in compile_text and ("mismatch" in compile_text or "expects" in compile_text or "unable to bind" in compile_text):
            return "compile_port_mismatch", "Compile failed because module ports did not match the testbench."
        if "syntax error" in compile_text or "invalid module item" in compile_text or "malformed" in compile_text:
            return "compile_syntax", "Compile failed with a Verilog/SystemVerilog syntax issue."
        return "unknown_failure", "Compile failed with an unclassified compiler error."

    if result["sim"]["timed_out"]:
        return "sim_timeout", "Simulation timed out before the testbench completed."

    if result["sim"]["returncode"] != 0:
        if "fail:" in sim_text or "fatal:" in sim_text or "assert" in sim_text:
            if strategy["tb"] in BUGGY_TB_VARIANTS:
                return "tb_wrong_expectation", "Simulation assertion suggests the testbench expectation is wrong."
            if strategy["rtl"] in BUGGY_RTL_VARIANTS:
                return "rtl_off_by_one", "Simulation assertion suggests an RTL timing or off-by-one bug."
            return "sim_assertion_failure", "Simulation failed due to a testbench assertion or fatal check."
        return "unknown_failure", "Simulation failed without a recognized assertion pattern."

    return "none", "Compile and simulation passed."


def select_repair(spec_key, strategy, failure_type):
    entry = KNOWN_GENERATORS.get(spec_key)
    if not entry:
        return None, "none"

    current_rtl = strategy["rtl"]
    current_tb = strategy["tb"]
    rtl_variants = entry["rtl_variants"]
    tb_variants = entry["tb_variants"]

    if failure_type in ("compile_syntax", "compile_port_mismatch", "rtl_off_by_one", "synthesis_failure", "gls_failure"):
        for rtl_variant in rtl_variants:
            if rtl_variant != current_rtl:
                return {"rtl": rtl_variant, "tb": current_tb}, "rtl_only"

    if failure_type == "tb_wrong_expectation":
        for tb_variant in tb_variants:
            if tb_variant != current_tb:
                return {"rtl": current_rtl, "tb": tb_variant}, "tb_only"

    if failure_type == "sim_assertion_failure":
        for tb_variant in tb_variants:
            if tb_variant != current_tb:
                return {"rtl": current_rtl, "tb": tb_variant}, "tb_only"
        for rtl_variant in rtl_variants:
            if rtl_variant != current_rtl:
                return {"rtl": rtl_variant, "tb": current_tb}, "rtl_only"

    if failure_type == "sim_timeout":
        if len(rtl_variants) > 1 and len(tb_variants) > 1:
            return {"rtl": rtl_variants[0], "tb": tb_variants[0]}, "rtl_and_tb"

    if failure_type == "unknown_failure":
        for rtl_variant in rtl_variants:
            if rtl_variant != current_rtl:
                return {"rtl": rtl_variant, "tb": current_tb}, "rtl_only"
        for tb_variant in tb_variants:
            if tb_variant != current_tb:
                return {"rtl": current_rtl, "tb": tb_variant}, "tb_only"

    return None, "none"


def run_attempt(spec_key, spec_text, paths, strategy, attempt_number, reuse_existing_candidate=False):
    compile_log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_compile.log"
    sim_log_path = paths["logs_dir"] / f"attempt_{attempt_number:02d}_sim.log"
    sanity_result = validate_and_repair_rtl(
        spec_key,
        spec_text,
        paths,
        strategy,
        attempt_number,
        reuse_existing_candidate=reuse_existing_candidate,
    )

    if not sanity_result["pass"]:
        compile_message = sanity_result["failure_summary"].rstrip() + "\n"
        write_text(compile_log_path, compile_message)
        write_text(sim_log_path, "")
        return {
            "attempt": attempt_number,
            "rtl_strategy": strategy["rtl"] or "codex",
            "tb_strategy": strategy["tb"] or "codex",
            "compile_pass": False,
            "sim_pass": False,
            "failure_type": sanity_result["failure_type"],
            "failure_summary": sanity_result["failure_summary"],
            "compile_log_path": compile_log_path,
            "sim_log_path": sim_log_path,
            "compile": {"returncode": 1, "stdout": "", "stderr": compile_message, "timed_out": False},
            "sim": {"returncode": -1, "stdout": "", "stderr": "", "timed_out": False},
            "sanity_log_path": sanity_result.get("sanity_log_path"),
            "generation_log_path": sanity_result.get("generation_log_path"),
            "validation_log_path": sanity_result.get("validation_log_path"),
            "repair_log_path": sanity_result.get("repair_log_path"),
        }

    compile_cmd = [IVERILOG_CMD, "-g2012", "-o", str(paths["sim_out"]), str(paths["candidate_rtl"]), str(paths["candidate_tb"])]
    sim_cmd = [VVP_CMD, str(paths["sim_out"])]

    compile_result = run_process(compile_cmd)
    compile_log = f"$ {' '.join(compile_cmd)}\n{compile_result['stdout']}{compile_result['stderr']}"
    write_text(compile_log_path, compile_log)

    sim_result = {"returncode": -1, "stdout": "", "stderr": "", "timed_out": False}
    if compile_result["returncode"] == 0:
        sim_result = run_process(sim_cmd, timeout_seconds=SIM_TIMEOUT_SECONDS)
        sim_log = f"$ {' '.join(sim_cmd)}\n{sim_result['stdout']}{sim_result['stderr']}"
        write_text(sim_log_path, sim_log)
        if sim_result["stdout"]:
            print(sim_result["stdout"], end="")
        if sim_result["stderr"]:
            print(sim_result["stderr"], end="", file=sys.stderr)
    else:
        write_text(sim_log_path, "")
        print("FAIL")

    result = {
        "compile": compile_result,
        "sim": sim_result,
    }
    failure_type, failure_summary = classify_failure(result, strategy)

    return {
        "attempt": attempt_number,
        "rtl_strategy": strategy["rtl"] or "codex",
        "tb_strategy": strategy["tb"] or "codex",
        "compile_pass": compile_result["returncode"] == 0,
        "sim_pass": sim_result["returncode"] == 0 and not sim_result["timed_out"],
        "failure_type": failure_type,
        "failure_summary": failure_summary,
        "compile_log_path": compile_log_path,
        "sim_log_path": sim_log_path,
        "compile": compile_result,
        "sim": sim_result,
        "sanity_log_path": sanity_result.get("sanity_log_path"),
        "generation_log_path": sanity_result.get("generation_log_path"),
        "validation_log_path": sanity_result.get("validation_log_path"),
        "repair_log_path": sanity_result.get("repair_log_path"),
    }


def write_attempt_report(paths, report):
    report_path = paths["reports_dir"] / f"attempt_{report['attempt']:02d}.yaml"
    lines = [
        f"attempt: {report['attempt']}",
        f"current_run_iterations: {report.get('current_run_iterations', 1)}",
        f"spec_id: {yaml_quote(paths['spec_name'])}",
        f"status: {yaml_quote(report.get('status', 'FAIL'))}",
        f"final_status: {yaml_quote(report.get('final_status', report.get('status', 'FAIL')))}",
        f"passed: {'true' if report.get('passed', False) else 'false'}",
        f"flow_pass: {'true' if report.get('flow_pass', False) else 'false'}",
        f"rtl_strategy: {yaml_quote(report['rtl_strategy'])}",
        f"tb_strategy: {yaml_quote(report['tb_strategy'])}",
        f"compile_pass: {'true' if report['compile_pass'] else 'false'}",
        f"sim_pass: {'true' if report['sim_pass'] else 'false'}",
        f"synthesis_pass: {'true' if report.get('synthesis_pass', False) else 'false'}",
        f"gls_pass: {'true' if report.get('gls_pass', False) else 'false'}",
        f"openroad_pass: {'true' if report.get('openroad_pass', False) else 'false'}",
        f"openroad_skipped: {'true' if report.get('openroad_skipped', False) else 'false'}",
        f"report_generated: {'true' if report.get('report_generated', False) else 'false'}",
        f"final_artifacts_exist: {'true' if report.get('final_artifacts_exist', False) else 'false'}",
        f"stale_logs: {'true' if report.get('stale_logs', False) else 'false'}",
        f"setup_pass: {'true' if report.get('setup_pass', False) else 'false'}",
        f"hold_pass: {'true' if report.get('hold_pass', False) else 'false'}",
        f"hold_violation: {'true' if report.get('hold_violation', False) else 'false'}",
        f"meets_timing: {'true' if report.get('meets_timing', False) else 'false'}",
        f"wns: {report.get('wns', 'null') if report.get('wns') is not None else 'null'}",
        f"tns: {report.get('tns', 'null') if report.get('tns') is not None else 'null'}",
        f"whs: {report.get('whs', 'null') if report.get('whs') is not None else 'null'}",
        f"area: {report.get('area', 'null') if report.get('area') is not None else 'null'}",
        f"timing_fix: {yaml_quote(report.get('timing_fix', ''))}",
        f"failure_type: {yaml_quote(report['failure_type'])}",
        f"compile_log_path: {yaml_quote(str(report['compile_log_path']))}",
        f"sim_log_path: {yaml_quote(str(report['sim_log_path']))}",
        f"synthesis_log_path: {yaml_quote(str(report.get('synthesis_log_path', '')))}",
        f"gls_log_path: {yaml_quote(str(report.get('gls_log_path', '')))}",
        f"openroad_log_path: {yaml_quote(str(report.get('openroad_log_path', '')))}",
        f"generation_log_path: {yaml_quote(str(report.get('generation_log_path', '')))}",
        f"validation_log_path: {yaml_quote(str(report.get('validation_log_path', '')))}",
        f"repair_log_path: {yaml_quote(str(report.get('repair_log_path', '')))}",
        f"failure_summary: {yaml_quote(report['failure_summary'])}",
    ]
    write_text(report_path, "\n".join(lines) + "\n")
    return report_path


def run_spec(spec_path, demo_repair=False, demo_tb_repair=False, disable_openroad=False, max_attempts=MAX_RETRIES):
    paths = spec_output_paths(spec_path)
    ensure_spec_directories(paths)
    first_attempt = next_attempt_number(paths)

    spec_text = read_text(spec_path)
    spec_key = detect_spec_key(spec_text)
    entry = KNOWN_GENERATORS.get(spec_key)

    strategy = {"rtl": None, "tb": None}
    if entry:
        strategy["rtl"] = entry["rtl_variants"][0]
        strategy["tb"] = entry["tb_variants"][0]
        if demo_tb_repair and len(entry["tb_variants"]) > 1:
            strategy["tb"] = entry["tb_variants"][1]
            print_step(f"demo TB mode enabled, starting from intentionally risky testbench strategy {strategy['tb']}")
        elif demo_repair and len(entry["rtl_variants"]) > 1:
            strategy["rtl"] = entry["rtl_variants"][1]
            print_step(f"demo mode enabled, starting from intentionally risky RTL strategy {strategy['rtl']}")

    print_step(f"using spec {spec_path.name}")
    if spec_key in KNOWN_GENERATORS:
        print_step(
            f"generating locally for {spec_key} "
            f"(rtl={strategy['rtl']}, tb={strategy['tb']})"
        )
    else:
        print_step("unknown spec schema, falling back to Codex")

    final_report = None
    reuse_existing_candidate = False
    effective_max_attempts = 1
    for offset in range(effective_max_attempts):
        attempt = first_attempt + offset
        current_run_iterations = offset + 1
        print_step(f"running compile and simulation attempt {attempt}/{effective_max_attempts}")
        attempt_report = run_attempt(
            spec_key,
            spec_text,
            paths,
            strategy,
            attempt,
            reuse_existing_candidate=reuse_existing_candidate,
        )
        attempt_report["current_run_iterations"] = current_run_iterations
        final_report = attempt_report
        reuse_existing_candidate = False

        if attempt_report["compile_pass"] and attempt_report["sim_pass"]:
            print_step("RTL simulation passed, running synthesis")
            synth_result = run_synthesis(paths, spec_text, rtl_path=paths["candidate_rtl"])
            attempt_report["synthesis_pass"] = synth_result["pass"]
            attempt_report["synthesis_log_path"] = paths["synth_log"]
            attempt_report["gls_pass"] = False
            attempt_report["gls_log_path"] = paths["gls_log"]
            attempt_report["openroad_pass"] = False
            attempt_report["openroad_skipped"] = False
            attempt_report["openroad_log_path"] = paths["openroad_run_log"]

            if synth_result["pass"]:
                print_step("synthesis passed, running GLS")
                gls_result = run_gls(paths)
                attempt_report["gls_pass"] = gls_result["pass"]
                if gls_result["pass"]:
                    if should_run_openroad(spec_text, disable_openroad=disable_openroad):
                        print_step("GLS passed, running OpenROAD")
                        openroad_result = run_openroad(paths, spec_text)
                        attempt_report["openroad_pass"] = openroad_result["pass"]
                        attempt_report["openroad_skipped"] = openroad_result.get("skipped", False)
                        timing_metrics = openroad_result.get("timing_metrics", {})
                        attempt_report["wns"] = timing_metrics.get("wns")
                        attempt_report["tns"] = timing_metrics.get("tns")
                        attempt_report["whs"] = timing_metrics.get("whs")
                        attempt_report["area"] = timing_metrics.get("area")
                        attempt_report["setup_pass"] = timing_metrics.get("setup_pass", False)
                        attempt_report["hold_pass"] = timing_metrics.get("hold_pass", False)
                        attempt_report["hold_violation"] = timing_metrics.get("hold_violation", False)
                        attempt_report["meets_timing"] = timing_metrics.get("meets_timing", False)
                        attempt_report["timing_fix"] = (
                            f"rtl={attempt_report['rtl_strategy']}; "
                            f"flow_profile={timing_metrics.get('meets_timing', False) and 'timing_closed' or 'timing_optimized'}; "
                            f"hold_mode={timing_metrics.get('hold_pass', False) and 'hold_closed' or 'hold_repair'}"
                        )
                        print(f"[agent] openroad_dir: {openroad_result['output_dir']}")
                    else:
                        print_step("GLS passed, OpenROAD disabled for this spec")
                        attempt_report["openroad_pass"] = False
                        attempt_report["openroad_skipped"] = True
                        attempt_report["wns"] = None
                        attempt_report["tns"] = None
                        attempt_report["whs"] = None
                        attempt_report["area"] = None
                        attempt_report["setup_pass"] = False
                        attempt_report["hold_pass"] = False
                        attempt_report["hold_violation"] = False
                        attempt_report["meets_timing"] = False
                        attempt_report["timing_fix"] = ""
                        openroad_result = {
                            "pass": False,
                            "skipped": True,
                            "summary": "OpenROAD not requested for this spec.",
                            "output_dir": paths["openroad_dir"],
                        }
                        write_text(paths["openroad_run_log"], openroad_result["summary"] + "\n")
                        print(f"[agent] openroad_dir: {openroad_result['output_dir']}")
                    if openroad_result["pass"] or openroad_result["skipped"]:
                        promote_candidate_outputs(paths)
                        attempt_report["failure_type"] = "none" if openroad_result["pass"] else "openroad_failure"
                        attempt_report["failure_summary"] = (
                            "Flow completed successfully."
                            if openroad_result["pass"]
                            else openroad_result["summary"]
                        )
                        attempt_report["status"] = "FAIL"
                        attempt_report["passed"] = False
                        attempt_report["report_generated"] = False
                        attempt_report["final_artifacts_exist"] = False
                        attempt_report["stale_logs"] = False
                        write_attempt_report(paths, attempt_report)
                        attempt_report.update(compute_attempt_pass(paths, attempt_report))
                        write_attempt_report(paths, attempt_report)
                        print(
                            f"[agent] checks: spec_id={paths['spec_name']} "
                            f"rtl_validation={stage_status(attempt_report.get('compile_pass'))} "
                            f"behavioral_sim={stage_status(attempt_report.get('sim_pass'))} "
                            f"synthesis={stage_status(attempt_report.get('synthesis_pass'))} "
                            f"gls={stage_status(attempt_report.get('gls_pass'))} "
                            f"openroad={stage_status(attempt_report['openroad_pass'], attempt_report.get('openroad_skipped', False))}"
                        )
                        if attempt_report["passed"]:
                            print_step("flow completed successfully with timing met")
                            print(
                                f"[agent] summary: spec_id={paths['spec_name']} attempts_used={current_run_iterations} "
                                f"final_status=PASS final_rtl_strategy={attempt_report['rtl_strategy']} "
                                f"final_tb_strategy={attempt_report['tb_strategy']}"
                            )
                            print("=== FINAL STATUS: PASS (timing met) ===")
                            return 0
                        if attempt_report.get("flow_pass") and not attempt_report.get("meets_timing"):
                            if not attempt_report.get("hold_pass", False):
                                print_step("hold timing is not met after OpenROAD")
                            else:
                                print_step("setup timing is not met after OpenROAD")
                        else:
                            attempt_report["failure_type"] = "openroad_failure"
                            attempt_report["failure_summary"] = (
                                "OpenROAD run was incomplete: missing final artifacts, stale logs, or missing report sync."
                            )
                            print_step("OpenROAD finalization checks failed")

                    attempt_report["failure_type"] = "openroad_failure"
                    if attempt_report.get("flow_pass") and not attempt_report.get("meets_timing"):
                        if not attempt_report.get("hold_pass", False):
                            attempt_report["failure_type"] = "hold_violation"
                            attempt_report["failure_summary"] = "Hold violation: OpenROAD completed but final WHS is negative."
                            print_step("OpenROAD completed but hold timing is violated")
                        else:
                            attempt_report["failure_type"] = "timing_violation"
                            attempt_report["failure_summary"] = "Timing violation: OpenROAD completed but final WNS is negative."
                            print_step("OpenROAD completed but setup timing is violated")
                    elif not attempt_report.get("failure_summary"):
                        attempt_report["failure_summary"] = openroad_result["summary"]
                        print_step("OpenROAD failed")
                else:
                    attempt_report["failure_type"] = "gls_failure"
                    attempt_report["failure_summary"] = gls_result["summary"]
                    print_step("GLS failed")
            else:
                attempt_report["failure_type"] = "synthesis_failure"
                attempt_report["failure_summary"] = "Synthesis failed. See synthesis log for details."
                print_step("synthesis failed")
        else:
            attempt_report["synthesis_pass"] = False
            attempt_report["gls_pass"] = False
            attempt_report["openroad_pass"] = False
            attempt_report["openroad_skipped"] = False
            attempt_report["synthesis_log_path"] = paths["synth_log"]
            attempt_report["gls_log_path"] = paths["gls_log"]
            attempt_report["openroad_log_path"] = paths["openroad_run_log"]
            attempt_report["wns"] = None
            attempt_report["tns"] = None
            attempt_report["whs"] = None
            attempt_report["area"] = None
            attempt_report["setup_pass"] = False
            attempt_report["hold_pass"] = False
            attempt_report["hold_violation"] = False
            attempt_report["meets_timing"] = False
            attempt_report["timing_fix"] = ""

        attempt_report["status"] = "FAIL"
        attempt_report["passed"] = False
        attempt_report["report_generated"] = False
        attempt_report["final_artifacts_exist"] = False
        attempt_report["stale_logs"] = False
        write_attempt_report(paths, attempt_report)
        attempt_report.update(compute_attempt_pass(paths, attempt_report))
        write_attempt_report(paths, attempt_report)

        next_strategy_value, repair_scope = select_repair(spec_key, strategy, attempt_report["failure_type"])
        if not next_strategy_value:
            if spec_key not in KNOWN_GENERATORS and attempt < effective_max_attempts:
                print_step("repairing RTL from behavioral failure logs")
                compile_log_text = read_text(attempt_report["compile_log_path"]) if attempt_report["compile_log_path"].exists() else ""
                sim_log_text = read_text(attempt_report["sim_log_path"]) if attempt_report["sim_log_path"].exists() else ""
                if attempt_report["failure_type"] in ("synthesis_failure", "gls_failure"):
                    compile_log_text += "\n\n[SYNTHESIS LOG]\n"
                    compile_log_text += read_text(paths["synth_log"]) if paths["synth_log"].exists() else ""
                    sim_log_text += "\n\n[GLS LOG]\n"
                    sim_log_text += read_text(paths["gls_log"]) if paths["gls_log"].exists() else ""
                if attempt_report["failure_type"] == "openroad_failure":
                    compile_log_text += "\n\n[OPENROAD LOG]\n"
                    compile_log_text += read_text(paths["openroad_run_log"]) if paths["openroad_run_log"].exists() else ""
                repair_result = attempt_behavioral_rtl_repair(
                    spec_text,
                    paths,
                    attempt_report["failure_summary"],
                    compile_log_text,
                    sim_log_text,
                )
                repair_log_path = attempt_report.get("repair_log_path")
                if repair_log_path:
                    existing_text = read_text(repair_log_path) if repair_log_path.exists() else ""
                    appended = (
                        f"behavioral_repair_round={attempt}\n"
                        f"status={'PASS' if repair_result['pass'] else 'FAIL'}\n"
                        f"reason={attempt_report['failure_summary']}\n"
                        f"stderr={repair_result['stderr']}\n"
                    )
                    write_text(repair_log_path, existing_text + appended)
                if repair_result["pass"]:
                    reuse_existing_candidate = True
                    continue
            print_step("no repair strategy matched")
            break
        strategy = next_strategy_value
        print_step(f"repairing with {repair_scope}: rtl={strategy['rtl']}, tb={strategy['tb']}")

    if final_report is not None:
        print(
            f"[agent] checks: spec_id={paths['spec_name']} "
            f"rtl_validation={stage_status(final_report.get('compile_pass'))} "
            f"behavioral_sim={stage_status(final_report.get('sim_pass'))} "
            f"synthesis={stage_status(final_report.get('synthesis_pass'))} "
            f"gls={stage_status(final_report.get('gls_pass'))} "
            f"openroad={stage_status(final_report.get('openroad_pass'), final_report.get('openroad_skipped', False))}"
        )
        print(f"[agent] openroad_dir: {paths['openroad_dir']}")
        print(
            f"[agent] summary: spec_id={paths['spec_name']} attempts_used={final_report.get('current_run_iterations', 1)} "
            f"final_status=FAIL final_rtl_strategy={final_report['rtl_strategy']} "
            f"final_tb_strategy={final_report['tb_strategy']}"
        )
    if final_report is not None and final_report.get("flow_pass") and not final_report.get("meets_timing"):
        if not final_report.get("hold_pass", False):
            print("=== FINAL STATUS: FAIL (hold violation) ===")
        else:
            print("=== FINAL STATUS: FAIL (timing violation) ===")
    else:
        print("=== FINAL STATUS: FAIL ===")
    print(f"Flow did not pass after {effective_max_attempts} attempts.", file=sys.stderr)
    return 1


def run_all_specs(spec_paths, demo_repair=False, demo_tb_repair=False, disable_openroad=False, max_attempts=MAX_RETRIES):
    from summary_table import generate_summary, render_table

    overall_status = 0
    passed = 0
    failed = 0

    for current_spec_path in spec_paths:
        try:
            status = run_spec_isolated(
                current_spec_path,
                demo_repair=demo_repair,
                demo_tb_repair=demo_tb_repair,
                disable_openroad=disable_openroad,
                max_attempts=max_attempts,
            )
        except Exception as exc:
            paths = spec_output_paths(current_spec_path)
            ensure_spec_directories(paths)
            print_step(f"{current_spec_path.name} hit an unexpected error boundary: {exc}")
            emit_partial_failure_report(
                paths,
                next_attempt_number(paths),
                "exception",
                f"Unhandled exception while running spec in --all mode: {exc}",
                "",
                traceback.format_exc(),
            )
            status = 1
        if status == 0:
            passed += 1
        else:
            failed += 1
            overall_status = status

    print(
        f"[agent] overall_summary: total_specs={len(spec_paths)} "
        f"passed={passed} failed={failed}"
    )
    print_step("regenerating summary table from latest spec reports")
    rows = generate_summary(
        spec_dir=spec_paths[0].parent if spec_paths else SPECS_DIR,
        print_stdout=False,
    )
    print("[agent] final_report_table:")
    print(render_table(rows))
    print(f"\n[agent] summary_csv: {ROOT / 'summary_table.csv'}")
    print(f"[agent] summary_md: {ROOT / 'summary_table.md'}")
    return overall_status


def main():
    ensure_directories()

    spec_path = choose_spec_path()
    spec_dir = choose_spec_dir()
    _, run_all, summary_table, demo_repair, demo_tb_repair, disable_openroad, max_attempts = parse_args()
    if summary_table:
        from summary_table import generate_summary

        generate_summary(spec_dir=spec_dir)
        return 0
    if spec_path:
        if not spec_path.exists():
            print("No spec file found.", file=sys.stderr)
            return 1
        return run_spec(
            spec_path,
            demo_repair=demo_repair,
            demo_tb_repair=demo_tb_repair,
            disable_openroad=disable_openroad,
            max_attempts=max_attempts,
        )

    spec_paths = choose_all_spec_paths()
    if not spec_paths:
        print("No spec file found.", file=sys.stderr)
        return 1

    if run_all:
        print_step("--all specified; running every spec")
    else:
        print_step("no spec path provided; running every spec")
    return run_all_specs(
        spec_paths,
        demo_repair=demo_repair,
        demo_tb_repair=demo_tb_repair,
        disable_openroad=disable_openroad,
        max_attempts=max_attempts,
    )


if __name__ == "__main__":
    sys.exit(main())
