module rising_edge_detector (
    input wire clk,
    input wire rst,
    input wire sig_in,
    output reg pulse
);
    reg prev_sig;

    always @(posedge clk) begin
        if (rst) begin
            prev_sig <= 1'b0;
            pulse <= 1'b0;
        end else begin
            pulse <= sig_in & ~prev_sig;
            prev_sig <= sig_in;
        end
    end
endmodule
