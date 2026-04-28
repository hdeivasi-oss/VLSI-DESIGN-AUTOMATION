`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;
    reg load;
    reg shift_en;
    reg serial_in;
    reg [3:0] data_in;
    wire [3:0] data_out;

    shift_register_4bit dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    task check_data_out;
        input [3:0] expected;
        input [127:0] label;
        begin
            #1;
            if (data_out !== expected) begin
                $display("FAIL: %0s expected=%b got=%b time=%0t", label, expected, data_out, $time);
                $fatal(1);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        load = 1'b0;
        shift_en = 1'b0;
        serial_in = 1'b0;
        data_in = 4'b0000;

        rst = 1'b1;
        @(posedge clk);
        check_data_out(4'b0000, "reset clears register");

        rst = 1'b0;
        load = 1'b1;
        data_in = 4'b1010;
        @(posedge clk);
        check_data_out(4'b1010, "load writes data_in");

        shift_en = 1'b1;
        serial_in = 1'b1;
        @(posedge clk);
        check_data_out(4'b1010, "load has priority over shift");

        load = 1'b0;
        serial_in = 1'b0;
        @(posedge clk);
        check_data_out(4'b0100, "shift operation updates bits correctly");

        shift_en = 1'b0;
        @(posedge clk);
        check_data_out(4'b0100, "hold behavior");

        $display("TEST PASSED");
        $finish;
    end
endmodule
