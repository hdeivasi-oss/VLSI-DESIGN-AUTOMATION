module shift_register_4bit (clk,
    load,
    rst,
    serial_in,
    shift_en,
    data_in,
    data_out);
 input clk;
 input load;
 input rst;
 input serial_in;
 input shift_en;
 input [3:0] data_in;
 output [3:0] data_out;

 wire _00_;
 wire \_00_[0] ;
 wire \_00_[1] ;
 wire \_00_[2] ;
 wire \_00_[3] ;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net10;
 wire net11;
 wire net12;
 wire net13;
 wire net6;
 wire net7;
 wire net8;
 wire net9;

 sky130_fd_sc_hd__inv_1 _10_ (.A(net6),
    .Y(_00_));
 sky130_fd_sc_hd__mux2i_1 _12_ (.A0(net12),
    .A1(net11),
    .S(net9),
    .Y(_02_));
 sky130_fd_sc_hd__nor2b_1 _13_ (.A(net4),
    .B_N(net6),
    .Y(_03_));
 sky130_fd_sc_hd__a211oi_1 _14_ (.A1(_00_),
    .A2(_02_),
    .B1(_03_),
    .C1(net7),
    .Y(\_00_[2] ));
 sky130_fd_sc_hd__mux2i_1 _15_ (.A0(net13),
    .A1(net12),
    .S(net9),
    .Y(_04_));
 sky130_fd_sc_hd__nor2b_1 _16_ (.A(net5),
    .B_N(net6),
    .Y(_05_));
 sky130_fd_sc_hd__a211oi_1 _17_ (.A1(_00_),
    .A2(_04_),
    .B1(_05_),
    .C1(net7),
    .Y(\_00_[3] ));
 sky130_fd_sc_hd__mux2i_1 _18_ (.A0(net10),
    .A1(net8),
    .S(net9),
    .Y(_06_));
 sky130_fd_sc_hd__nor2b_1 _19_ (.A(net2),
    .B_N(net6),
    .Y(_07_));
 sky130_fd_sc_hd__a211oi_1 _20_ (.A1(_00_),
    .A2(_06_),
    .B1(_07_),
    .C1(net7),
    .Y(\_00_[0] ));
 sky130_fd_sc_hd__mux2i_1 _21_ (.A0(net11),
    .A1(net10),
    .S(net9),
    .Y(_08_));
 sky130_fd_sc_hd__nor2b_1 _22_ (.A(net3),
    .B_N(net6),
    .Y(_09_));
 sky130_fd_sc_hd__a211oi_1 _23_ (.A1(_00_),
    .A2(_08_),
    .B1(_09_),
    .C1(net7),
    .Y(\_00_[1] ));
 sky130_fd_sc_hd__dfxtp_1 \data_out[0]$_DFF_P_  (.D(\_00_[0] ),
    .Q(net10),
    .CLK(net1));
 sky130_fd_sc_hd__dfxtp_1 \data_out[1]$_DFF_P_  (.D(\_00_[1] ),
    .Q(net11),
    .CLK(net1));
 sky130_fd_sc_hd__dfxtp_1 \data_out[2]$_DFF_P_  (.D(\_00_[2] ),
    .Q(net12),
    .CLK(net1));
 sky130_fd_sc_hd__dfxtp_1 \data_out[3]$_DFF_P_  (.D(\_00_[3] ),
    .Q(net13),
    .CLK(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(clk),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(data_in[0]),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(data_in[1]),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input4 (.A(data_in[2]),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input5 (.A(data_in[3]),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input6 (.A(load),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input7 (.A(rst),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input8 (.A(serial_in),
    .X(net8));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input9 (.A(shift_en),
    .X(net9));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output10 (.A(net10),
    .X(data_out[0]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output11 (.A(net11),
    .X(data_out[1]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output12 (.A(net12),
    .X(data_out[2]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output13 (.A(net13),
    .X(data_out[3]));
endmodule
