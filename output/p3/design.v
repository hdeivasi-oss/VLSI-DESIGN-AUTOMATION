module seq_detect_101 (
    input wire clk,
    input wire rst,
    input wire bit_in,
    output reg match
);
    reg [1:0] state;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
            match <= 1'b0;
        end else begin
            match <= 1'b0;
            case (state)
                S0: state <= bit_in ? S1 : S0;
                S1: state <= bit_in ? S1 : S2;
                S2: begin
                    if (bit_in) begin
                        state <= S1;
                        match <= 1'b1;
                    end else begin
                        state <= S0;
                    end
                end
            endcase
        end
    end
endmodule
