module rising_edge_detector (clk,
    pulse,
    rst,
    sig_in);
 input clk;
 output pulse;
 input rst;
 input sig_in;

 wire _0_;
 wire _1_;
 wire net1;
 wire prev_sig;
 wire net4;
 wire net2;
 wire net3;

 sky130_fd_sc_hd__nor2b_1 _2_ (.A(net2),
    .B_N(net3),
    .Y(_0_));
 sky130_fd_sc_hd__nor3b_2 _3_ (.A(prev_sig),
    .B(net2),
    .C_N(net3),
    .Y(_1_));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(clk),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(rst),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(sig_in),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output4 (.A(net4),
    .X(pulse));
 sky130_fd_sc_hd__dfxtp_1 \prev_sig$_DFF_P_  (.D(_0_),
    .Q(prev_sig),
    .CLK(net1));
 sky130_fd_sc_hd__dfxtp_1 \pulse$_DFF_P_  (.D(_1_),
    .Q(net4),
    .CLK(net1));
endmodule
