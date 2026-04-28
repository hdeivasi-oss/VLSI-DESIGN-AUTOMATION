module fir_filter #(
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
