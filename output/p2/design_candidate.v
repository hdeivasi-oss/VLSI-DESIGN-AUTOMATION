module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift_en,
    input wire serial_in,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift_en) begin
            data_out <= {data_out[2:0], serial_in};
        end
    end
endmodule
