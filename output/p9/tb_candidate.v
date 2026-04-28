`timescale 1ns/1ps

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

        expected[0] = 35'sd1;
        expected[1] = 35'sd4;
        expected[2] = 35'sd10;
        expected[3] = 35'sd20;
        expected[4] = 35'sd35;
        expected[5] = 35'sd56;
        expected[6] = 35'sd84;
        expected[7] = 35'sd120;

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
