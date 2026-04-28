module seq_detector_0011 (clk,
    data_in,
    detected,
    reset);
 input clk;
 input data_in;
 output detected;
 input reset;

 wire _00_;
 wire _01_;
 wire \_02_[0] ;
 wire \_02_[1] ;
 wire \_02_[2] ;
 wire _2_;
 wire net1;
 wire detect_pending;
 wire net3;
 wire \history[0] ;
 wire \history[1] ;
 wire \history[2] ;
 wire net2;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 sky130_fd_sc_hd__nor2b_2 _3_ (.A(net2),
    .B_N(net1),
    .Y(\_02_[0] ));
 sky130_fd_sc_hd__nor2_1 _4_ (.A(\history[1] ),
    .B(\history[2] ),
    .Y(_2_));
 sky130_fd_sc_hd__and3_1 _5_ (.A(\history[0] ),
    .B(\_02_[0] ),
    .C(_2_),
    .X(_00_));
 sky130_fd_sc_hd__and2b_2 _6_ (.A_N(net2),
    .B(\history[0] ),
    .X(\_02_[1] ));
 sky130_fd_sc_hd__and2b_2 _7_ (.A_N(net2),
    .B(\history[1] ),
    .X(\_02_[2] ));
 sky130_fd_sc_hd__and2b_2 _8_ (.A_N(net2),
    .B(detect_pending),
    .X(_01_));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_1 clkload0 (.A(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \detect_pending$_DFF_P_  (.D(_00_),
    .Q(detect_pending),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \detected$_DFF_P_  (.D(_01_),
    .Q(net3),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \history[0]$_DFF_P_  (.D(\_02_[0] ),
    .Q(\history[0] ),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \history[1]$_DFF_P_  (.D(\_02_[1] ),
    .Q(\history[1] ),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \history[2]$_DFF_P_  (.D(\_02_[2] ),
    .Q(\history[2] ),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(data_in),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(reset),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output3 (.A(net3),
    .X(detected));
endmodule
