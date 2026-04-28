module dot_product #(
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
