`timescale 1ns/1ps

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
        sample_output = 16'b0000010001000000;

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
