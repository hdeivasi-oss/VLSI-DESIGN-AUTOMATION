`timescale 1ns/1ps

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
        check_pulse(1'b0, "falling edge does not pulse");

        sig_in = 1'b1;
        @(posedge clk);
        check_pulse(1'b1, "second rising edge pulses again");

        @(posedge clk);
        check_pulse(1'b0, "pulse returns low after second edge");

        $display("TEST PASSED");
        $finish;
    end
endmodule
