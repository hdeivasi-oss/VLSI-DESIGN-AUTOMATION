`timescale 1ns/1ps

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
        check_output(2, 16'd0);

        @(posedge clk);
        check_output(3, 16'd341);

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
