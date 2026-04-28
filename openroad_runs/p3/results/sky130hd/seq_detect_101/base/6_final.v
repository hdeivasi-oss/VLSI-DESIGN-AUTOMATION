module seq_detect_101 (bit_in,
    clk,
    match,
    rst);
 input bit_in;
 input clk;
 output match;
 input rst;

 wire _00_;
 wire _01_;
 wire _02_;
 wire net1;
 wire net2;
 wire net4;
 wire net3;
 wire \state_reg[1] ;
 wire \state_reg[2] ;

 sky130_fd_sc_hd__and3b_2 _3_ (.A_N(net3),
    .B(net1),
    .C(\state_reg[1] ),
    .X(_00_));
 sky130_fd_sc_hd__nor3b_1 _4_ (.A(net3),
    .B(net1),
    .C_N(\state_reg[2] ),
    .Y(_01_));
 sky130_fd_sc_hd__and2b_2 _5_ (.A_N(net3),
    .B(net1),
    .X(_02_));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(bit_in),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(clk),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(rst),
    .X(net3));
 sky130_fd_sc_hd__dfxtp_1 \match$_DFF_P_  (.D(_00_),
    .Q(net4),
    .CLK(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output4 (.A(net4),
    .X(match));
 sky130_fd_sc_hd__dfxtp_1 \state_reg[1]$_DFF_P_  (.D(_01_),
    .Q(\state_reg[1] ),
    .CLK(net2));
 sky130_fd_sc_hd__dfxtp_1 \state_reg[2]$_DFF_P_  (.D(_02_),
    .Q(\state_reg[2] ),
    .CLK(net2));
endmodule
