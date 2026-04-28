`timescale 1ns/1ps

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
        check_state(2, 1'b0, 20'sd96, 1'b0);

        @(posedge clk);
        check_state(3, 1'b1, 20'sd96, 1'b1);

        @(posedge clk);
        check_state(4, 1'b0, 20'sd96, 1'b0);

        rst = 1'b1;
        @(posedge clk);
        check_state(5, 1'b0, '0, 1'b0);

        $display("TEST PASSED");
        $finish;
    end
endmodule
