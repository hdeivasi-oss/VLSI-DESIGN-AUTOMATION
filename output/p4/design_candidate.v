module button_debouncer (
    input wire clk,
    input wire rst,
    input wire noisy_btn,
    output reg clean_btn
);
    reg last_sample;
    reg [1:0] stable_count;

    always @(posedge clk) begin
        if (rst) begin
            clean_btn <= 1'b0;
            last_sample <= 1'b0;
            stable_count <= 2'd0;
        end else begin
            if (noisy_btn != last_sample) begin
                last_sample <= noisy_btn;
                stable_count <= 2'd1;
            end else if (stable_count < 2'd3) begin
                stable_count <= stable_count + 2'd1;
            end

            if (stable_count == 2'd2) begin
                clean_btn <= last_sample;
            end
        end
    end
endmodule
