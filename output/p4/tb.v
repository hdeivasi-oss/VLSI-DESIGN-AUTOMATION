`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg noisy_btn;
    wire clean_btn;

    button_debouncer dut (
        .clk(clk),
        .rst(rst),
        .noisy_btn(noisy_btn),
        .clean_btn(clean_btn)
    );

    always #5 clk = ~clk;

    task drive_and_check;
        input stimulus;
        input expected;
        input [127:0] label;
        begin
            noisy_btn = stimulus;
            @(posedge clk);
            #1;
            if (clean_btn !== expected) begin
                $display("FAIL: %0s expected clean_btn=%0b got clean_btn=%0b time=%0t", label, expected, clean_btn, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        noisy_btn = 1'b0;

        rst = 1'b1;
        @(posedge clk);
        #1;
        if (clean_btn !== 1'b0) begin
            $display("FAIL: reset forces clean_btn low");
            $fatal(1);
        end

        rst = 1'b0;
        drive_and_check(1'b1, 1'b0, "glitch cycle 1");
        drive_and_check(1'b0, 1'b0, "glitch cycle 2");
        drive_and_check(1'b1, 1'b0, "stable high cycle 1");
        drive_and_check(1'b1, 1'b0, "stable high cycle 2");
        drive_and_check(1'b1, 1'b1, "stable high cycle 3 updates output");
        drive_and_check(1'b0, 1'b1, "stable low cycle 1 keeps previous value");
        drive_and_check(1'b0, 1'b1, "stable low cycle 2 keeps previous value");
        drive_and_check(1'b0, 1'b0, "stable low cycle 3 updates output");

        $display("TEST PASSED");
        $finish;
    end
endmodule
