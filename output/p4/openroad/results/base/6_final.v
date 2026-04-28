module button_debouncer (clean_btn,
    clk,
    noisy_btn,
    rst);
 output clean_btn;
 input clk;
 input noisy_btn;
 input rst;

 wire _00_;
 wire _01_;
 wire \_02_[0] ;
 wire \_02_[1] ;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire _11_;
 wire _12_;
 wire _13_;
 wire _14_;
 wire _15_;
 wire net4;
 wire net1;
 wire last_sample;
 wire net2;
 wire net3;
 wire \stable_count[0] ;
 wire \stable_count[1] ;

 sky130_fd_sc_hd__inv_1 _16_ (.A(last_sample),
    .Y(_06_));
 sky130_fd_sc_hd__inv_1 _17_ (.A(\stable_count[1] ),
    .Y(_09_));
 sky130_fd_sc_hd__a31oi_1 _18_ (.A1(_05_),
    .A2(\stable_count[0] ),
    .A3(_09_),
    .B1(net3),
    .Y(\_02_[0] ));
 sky130_fd_sc_hd__nor2_1 _19_ (.A(\stable_count[0] ),
    .B(\stable_count[1] ),
    .Y(_10_));
 sky130_fd_sc_hd__nor3b_1 _20_ (.A(net3),
    .B(_10_),
    .C_N(_05_),
    .Y(\_02_[1] ));
 sky130_fd_sc_hd__nor2_1 _21_ (.A(_08_),
    .B(_07_),
    .Y(_11_));
 sky130_fd_sc_hd__nor2_1 _22_ (.A(net3),
    .B(_11_),
    .Y(_01_));
 sky130_fd_sc_hd__nor2b_1 _23_ (.A(\stable_count[0] ),
    .B_N(\stable_count[1] ),
    .Y(_12_));
 sky130_fd_sc_hd__nand2b_1 _24_ (.A_N(net3),
    .B(net4),
    .Y(_13_));
 sky130_fd_sc_hd__nand4bb_1 _25_ (.A_N(\stable_count[0] ),
    .B_N(net3),
    .C(\stable_count[1] ),
    .D(last_sample),
    .Y(_14_));
 sky130_fd_sc_hd__o21ai_1 _26_ (.A1(_12_),
    .A2(_13_),
    .B1(_14_),
    .Y(_00_));
 sky130_fd_sc_hd__ha_1 _27_ (.A(_06_),
    .B(net2),
    .COUT(_07_),
    .SUM(_05_));
 sky130_fd_sc_hd__ha_1 _28_ (.A(last_sample),
    .B(net2),
    .COUT(_08_),
    .SUM(_15_));
 sky130_fd_sc_hd__dfxtp_1 \clean_btn$_DFF_P_  (.D(_00_),
    .Q(net4),
    .CLK(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(clk),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(noisy_btn),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(rst),
    .X(net3));
 sky130_fd_sc_hd__dfxtp_1 \last_sample$_DFF_P_  (.D(_01_),
    .Q(last_sample),
    .CLK(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output4 (.A(net4),
    .X(clean_btn));
 sky130_fd_sc_hd__dfxtp_1 \stable_count[0]$_DFF_P_  (.D(\_02_[0] ),
    .Q(\stable_count[0] ),
    .CLK(net1));
 sky130_fd_sc_hd__dfxtp_1 \stable_count[1]$_DFF_P_  (.D(\_02_[1] ),
    .Q(\stable_count[1] ),
    .CLK(net1));
endmodule
