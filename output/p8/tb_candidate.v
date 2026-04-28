`timescale 1ns/1ps

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
