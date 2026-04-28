module seq_detector_0011(
    input clk,
    input reset,
    input data_in,
    output reg detected
);
    reg [3:0] history;
    reg detect_pending;

    always @(posedge clk) begin
        if (reset) begin
            history <= 4'b0000;
            detect_pending <= 1'b0;
            detected <= 1'b0;
        end else begin
            detected <= detect_pending;
            history <= {history[2:0], data_in};
            detect_pending <= ({history[2:0], data_in} == 4'b0011);
        end
    end
endmodule
