module fp16_multiplier(
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
