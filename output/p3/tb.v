`timescale 1ns/1ps

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
        drive_and_check(1'b1, 1'b1, "overlap pattern bit 5");

        drive_and_check(1'b1, 1'b0, "unrelated high input");
        drive_and_check(1'b1, 1'b0, "stable high does not false trigger");
        drive_and_check(1'b0, 1'b0, "trailing low no pulse");

        $display("TEST PASSED");
        $finish;
    end
endmodule
