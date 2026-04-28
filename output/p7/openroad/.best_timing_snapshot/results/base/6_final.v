module exp_fixed_point (clk,
    enable,
    rst,
    exp_out,
    x_in);
 input clk;
 input enable;
 input rst;
 output [15:0] exp_out;
 input [7:0] x_in;

 wire \_0000_[0] ;
 wire \_0000_[10] ;
 wire \_0000_[11] ;
 wire \_0000_[12] ;
 wire \_0000_[13] ;
 wire \_0000_[14] ;
 wire \_0000_[15] ;
 wire \_0000_[1] ;
 wire \_0000_[2] ;
 wire \_0000_[3] ;
 wire \_0000_[4] ;
 wire \_0000_[5] ;
 wire \_0000_[6] ;
 wire \_0000_[7] ;
 wire \_0000_[8] ;
 wire \_0000_[9] ;
 wire \_0001_[0] ;
 wire \_0001_[10] ;
 wire \_0001_[11] ;
 wire \_0001_[12] ;
 wire \_0001_[13] ;
 wire \_0001_[14] ;
 wire \_0001_[15] ;
 wire \_0001_[1] ;
 wire \_0001_[2] ;
 wire \_0001_[3] ;
 wire \_0001_[4] ;
 wire \_0001_[5] ;
 wire \_0001_[6] ;
 wire \_0001_[7] ;
 wire \_0001_[8] ;
 wire \_0001_[9] ;
 wire _0002_;
 wire _0003_;
 wire \_0004_[0] ;
 wire \_0004_[1] ;
 wire \_0004_[2] ;
 wire \_0004_[3] ;
 wire \_0004_[4] ;
 wire \_0004_[5] ;
 wire \_0004_[6] ;
 wire \_0004_[7] ;
 wire _0013_;
 wire clknet_2_3__leaf_clk;
 wire clknet_2_2__leaf_clk;
 wire clknet_2_1__leaf_clk;
 wire clknet_2_0__leaf_clk;
 wire net71;
 wire net64;
 wire net62;
 wire net58;
 wire net57;
 wire net56;
 wire net53;
 wire net52;
 wire _0027_;
 wire net51;
 wire _0029_;
 wire _0030_;
 wire net50;
 wire _0032_;
 wire _0033_;
 wire _0034_;
 wire net49;
 wire net48;
 wire _0037_;
 wire _0038_;
 wire _0039_;
 wire net47;
 wire clknet_0_clk;
 wire _0042_;
 wire net73;
 wire net67;
 wire net65;
 wire _0046_;
 wire _0047_;
 wire _0048_;
 wire _0049_;
 wire net63;
 wire net61;
 wire _0052_;
 wire _0053_;
 wire _0054_;
 wire _0055_;
 wire _0056_;
 wire net59;
 wire net60;
 wire _0059_;
 wire _0060_;
 wire net55;
 wire _0062_;
 wire net54;
 wire _0064_;
 wire net72;
 wire net70;
 wire _0067_;
 wire _0068_;
 wire _0069_;
 wire net69;
 wire _0071_;
 wire _0072_;
 wire _0073_;
 wire _0074_;
 wire _0075_;
 wire _0076_;
 wire net68;
 wire net66;
 wire _0079_;
 wire _0080_;
 wire _0082_;
 wire _0083_;
 wire _0084_;
 wire _0085_;
 wire _0086_;
 wire _0087_;
 wire _0088_;
 wire _0089_;
 wire _0093_;
 wire _0095_;
 wire _0096_;
 wire _0097_;
 wire _0098_;
 wire _0099_;
 wire _0100_;
 wire _0101_;
 wire _0102_;
 wire _0103_;
 wire _0104_;
 wire _0105_;
 wire _0106_;
 wire _0107_;
 wire _0109_;
 wire _0110_;
 wire _0111_;
 wire _0112_;
 wire _0113_;
 wire _0114_;
 wire _0116_;
 wire _0119_;
 wire _0120_;
 wire _0121_;
 wire _0123_;
 wire _0124_;
 wire _0125_;
 wire _0126_;
 wire _0127_;
 wire _0128_;
 wire _0129_;
 wire _0131_;
 wire _0132_;
 wire _0133_;
 wire _0135_;
 wire _0137_;
 wire _0138_;
 wire _0139_;
 wire _0140_;
 wire _0141_;
 wire _0142_;
 wire _0143_;
 wire _0144_;
 wire _0145_;
 wire _0146_;
 wire _0147_;
 wire _0148_;
 wire _0149_;
 wire _0151_;
 wire _0152_;
 wire _0153_;
 wire _0154_;
 wire _0155_;
 wire _0156_;
 wire _0157_;
 wire _0158_;
 wire _0159_;
 wire _0161_;
 wire _0162_;
 wire _0163_;
 wire _0164_;
 wire _0165_;
 wire _0166_;
 wire _0168_;
 wire _0169_;
 wire _0170_;
 wire _0171_;
 wire _0172_;
 wire _0173_;
 wire _0174_;
 wire _0175_;
 wire _0176_;
 wire _0178_;
 wire _0179_;
 wire _0180_;
 wire _0181_;
 wire _0182_;
 wire _0183_;
 wire _0184_;
 wire _0185_;
 wire _0186_;
 wire _0187_;
 wire _0188_;
 wire _0189_;
 wire _0190_;
 wire _0191_;
 wire _0192_;
 wire _0193_;
 wire _0194_;
 wire _0195_;
 wire _0197_;
 wire _0198_;
 wire _0199_;
 wire _0200_;
 wire _0201_;
 wire _0202_;
 wire _0203_;
 wire _0204_;
 wire _0205_;
 wire _0206_;
 wire _0207_;
 wire _0208_;
 wire _0209_;
 wire _0210_;
 wire _0211_;
 wire _0212_;
 wire _0213_;
 wire _0214_;
 wire _0215_;
 wire _0216_;
 wire _0217_;
 wire _0218_;
 wire _0219_;
 wire _0220_;
 wire _0221_;
 wire _0222_;
 wire _0223_;
 wire _0224_;
 wire _0225_;
 wire _0226_;
 wire _0227_;
 wire _0228_;
 wire _0229_;
 wire _0230_;
 wire _0231_;
 wire _0232_;
 wire _0233_;
 wire _0235_;
 wire _0236_;
 wire _0237_;
 wire _0238_;
 wire _0239_;
 wire _0240_;
 wire _0241_;
 wire _0242_;
 wire _0243_;
 wire _0244_;
 wire _0245_;
 wire _0246_;
 wire _0247_;
 wire _0248_;
 wire _0249_;
 wire _0250_;
 wire _0251_;
 wire _0252_;
 wire _0253_;
 wire _0254_;
 wire _0255_;
 wire _0256_;
 wire _0257_;
 wire _0258_;
 wire _0259_;
 wire _0260_;
 wire _0261_;
 wire _0262_;
 wire _0263_;
 wire _0264_;
 wire _0266_;
 wire _0267_;
 wire _0269_;
 wire _0270_;
 wire _0271_;
 wire _0272_;
 wire _0273_;
 wire _0274_;
 wire _0275_;
 wire _0276_;
 wire _0277_;
 wire _0278_;
 wire _0279_;
 wire _0280_;
 wire _0281_;
 wire _0282_;
 wire _0283_;
 wire _0284_;
 wire _0285_;
 wire _0286_;
 wire _0287_;
 wire _0288_;
 wire _0289_;
 wire _0290_;
 wire _0291_;
 wire _0292_;
 wire _0293_;
 wire _0294_;
 wire _0295_;
 wire _0296_;
 wire _0297_;
 wire _0298_;
 wire _0299_;
 wire _0300_;
 wire _0301_;
 wire _0302_;
 wire _0303_;
 wire _0304_;
 wire _0305_;
 wire _0306_;
 wire _0307_;
 wire _0308_;
 wire _0309_;
 wire _0310_;
 wire _0311_;
 wire _0312_;
 wire _0313_;
 wire _0314_;
 wire _0315_;
 wire _0316_;
 wire _0317_;
 wire _0318_;
 wire _0319_;
 wire _0320_;
 wire _0321_;
 wire _0322_;
 wire _0323_;
 wire _0324_;
 wire _0325_;
 wire _0326_;
 wire _0327_;
 wire _0328_;
 wire _0329_;
 wire _0331_;
 wire _0332_;
 wire _0333_;
 wire _0334_;
 wire _0335_;
 wire _0336_;
 wire _0337_;
 wire _0338_;
 wire _0339_;
 wire _0340_;
 wire _0341_;
 wire _0342_;
 wire _0343_;
 wire _0344_;
 wire _0345_;
 wire _0346_;
 wire _0347_;
 wire _0348_;
 wire _0349_;
 wire _0350_;
 wire _0351_;
 wire _0352_;
 wire _0353_;
 wire _0354_;
 wire _0355_;
 wire _0356_;
 wire _0357_;
 wire _0358_;
 wire _0359_;
 wire _0360_;
 wire _0361_;
 wire _0362_;
 wire _0363_;
 wire _0364_;
 wire _0365_;
 wire _0366_;
 wire _0367_;
 wire _0368_;
 wire _0369_;
 wire _0370_;
 wire _0371_;
 wire _0372_;
 wire _0373_;
 wire _0374_;
 wire _0375_;
 wire _0376_;
 wire _0377_;
 wire _0378_;
 wire _0379_;
 wire _0380_;
 wire _0381_;
 wire _0382_;
 wire _0383_;
 wire _0384_;
 wire _0385_;
 wire _0386_;
 wire _0387_;
 wire _0388_;
 wire _0389_;
 wire _0390_;
 wire _0391_;
 wire _0392_;
 wire _0393_;
 wire _0394_;
 wire _0395_;
 wire _0396_;
 wire _0397_;
 wire _0398_;
 wire _0399_;
 wire _0400_;
 wire _0401_;
 wire _0402_;
 wire _0403_;
 wire _0404_;
 wire _0405_;
 wire _0406_;
 wire _0407_;
 wire _0408_;
 wire _0409_;
 wire _0410_;
 wire _0411_;
 wire _0412_;
 wire _0413_;
 wire _0414_;
 wire _0415_;
 wire _0416_;
 wire _0417_;
 wire _0418_;
 wire _0419_;
 wire _0420_;
 wire _0421_;
 wire _0422_;
 wire _0423_;
 wire _0424_;
 wire _0425_;
 wire _0426_;
 wire _0427_;
 wire _0428_;
 wire _0429_;
 wire _0430_;
 wire _0431_;
 wire _0432_;
 wire _0433_;
 wire _0434_;
 wire _0435_;
 wire _0436_;
 wire _0437_;
 wire _0438_;
 wire _0439_;
 wire _0440_;
 wire _0441_;
 wire _0442_;
 wire _0443_;
 wire _0444_;
 wire _0445_;
 wire _0446_;
 wire _0447_;
 wire _0448_;
 wire _0449_;
 wire _0450_;
 wire _0451_;
 wire _0452_;
 wire _0453_;
 wire _0454_;
 wire _0455_;
 wire _0456_;
 wire _0457_;
 wire _0458_;
 wire _0459_;
 wire _0460_;
 wire _0461_;
 wire _0462_;
 wire _0463_;
 wire _0464_;
 wire _0465_;
 wire _0466_;
 wire _0467_;
 wire _0468_;
 wire _0469_;
 wire _0470_;
 wire _0471_;
 wire _0472_;
 wire _0473_;
 wire _0474_;
 wire _0475_;
 wire _0476_;
 wire _0477_;
 wire _0478_;
 wire _0479_;
 wire _0480_;
 wire _0481_;
 wire _0482_;
 wire _0483_;
 wire _0484_;
 wire _0485_;
 wire _0486_;
 wire _0487_;
 wire _0488_;
 wire _0489_;
 wire _0490_;
 wire _0491_;
 wire _0492_;
 wire _0493_;
 wire _0494_;
 wire _0495_;
 wire _0496_;
 wire _0497_;
 wire _0498_;
 wire _0499_;
 wire _0500_;
 wire _0501_;
 wire _0502_;
 wire _0503_;
 wire _0504_;
 wire _0505_;
 wire _0506_;
 wire _0507_;
 wire _0508_;
 wire _0509_;
 wire _0510_;
 wire _0513_;
 wire _0514_;
 wire _0516_;
 wire _0517_;
 wire _0518_;
 wire _0519_;
 wire _0520_;
 wire _0521_;
 wire _0522_;
 wire _0523_;
 wire _0527_;
 wire _0528_;
 wire _0529_;
 wire _0530_;
 wire _0531_;
 wire _0532_;
 wire _0533_;
 wire _0534_;
 wire _0535_;
 wire _0536_;
 wire _0537_;
 wire _0538_;
 wire _0539_;
 wire _0540_;
 wire _0541_;
 wire _0542_;
 wire _0543_;
 wire _0544_;
 wire _0545_;
 wire _0546_;
 wire _0547_;
 wire _0548_;
 wire _0549_;
 wire _0550_;
 wire _0551_;
 wire net1;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net18;
 wire net19;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net25;
 wire net26;
 wire \lut_stage2[0] ;
 wire \lut_stage2[10] ;
 wire \lut_stage2[11] ;
 wire \lut_stage2[12] ;
 wire \lut_stage2[13] ;
 wire \lut_stage2[14] ;
 wire \lut_stage2[15] ;
 wire \lut_stage2[1] ;
 wire \lut_stage2[2] ;
 wire \lut_stage2[3] ;
 wire \lut_stage2[4] ;
 wire \lut_stage2[5] ;
 wire \lut_stage2[6] ;
 wire \lut_stage2[7] ;
 wire \lut_stage2[8] ;
 wire \lut_stage2[9] ;
 wire net2;
 wire stage1_valid;
 wire stage2_valid;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire \x_stage1[0] ;
 wire \x_stage1[1] ;
 wire \x_stage1[2] ;
 wire \x_stage1[3] ;
 wire \x_stage1[4] ;
 wire \x_stage1[5] ;
 wire \x_stage1[6] ;
 wire \x_stage1[7] ;

 sky130_fd_sc_hd__nand2b_1 _0571_ (.A_N(net62),
    .B(net67),
    .Y(_0013_));
 sky130_fd_sc_hd__nand3b_1 _0585_ (.A_N(\x_stage1[4] ),
    .B(net58),
    .C(net59),
    .Y(_0027_));
 sky130_fd_sc_hd__or2b_1 _0587_ (.A(net59),
    .B_N(net58),
    .X(_0029_));
 sky130_fd_sc_hd__nor2_1 _0588_ (.A(net64),
    .B(_0029_),
    .Y(_0030_));
 sky130_fd_sc_hd__nand3b_1 _0590_ (.A_N(net58),
    .B(\x_stage1[6] ),
    .C(\x_stage1[4] ),
    .Y(_0032_));
 sky130_fd_sc_hd__nor2_1 _0591_ (.A(net66),
    .B(_0032_),
    .Y(_0033_));
 sky130_fd_sc_hd__a21oi_1 _0592_ (.A1(net65),
    .A2(_0030_),
    .B1(_0033_),
    .Y(_0034_));
 sky130_fd_sc_hd__nand2b_1 _0595_ (.A_N(net67),
    .B(\x_stage1[5] ),
    .Y(_0037_));
 sky130_fd_sc_hd__o32ai_1 _0596_ (.A1(\x_stage1[3] ),
    .A2(_0013_),
    .A3(_0027_),
    .B1(_0034_),
    .B2(_0037_),
    .Y(_0038_));
 sky130_fd_sc_hd__and4bb_1 _0597_ (.A_N(net58),
    .B_N(\x_stage1[6] ),
    .C(net62),
    .D(net63),
    .X(_0039_));
 sky130_fd_sc_hd__inv_1 _0600_ (.A(\x_stage1[3] ),
    .Y(_0042_));
 sky130_fd_sc_hd__xnor2_1 _0604_ (.A(\x_stage1[0] ),
    .B(net67),
    .Y(_0046_));
 sky130_fd_sc_hd__xnor2_1 _0605_ (.A(_0042_),
    .B(_0046_),
    .Y(_0047_));
 sky130_fd_sc_hd__nor2b_1 _0606_ (.A(net71),
    .B_N(\x_stage1[3] ),
    .Y(_0048_));
 sky130_fd_sc_hd__nor2b_1 _0607_ (.A(\x_stage1[3] ),
    .B_N(\x_stage1[0] ),
    .Y(_0049_));
 sky130_fd_sc_hd__o211ai_1 _0610_ (.A1(_0048_),
    .A2(_0049_),
    .B1(net69),
    .C1(net67),
    .Y(_0052_));
 sky130_fd_sc_hd__o21ai_0 _0611_ (.A1(net69),
    .A2(_0047_),
    .B1(_0052_),
    .Y(_0053_));
 sky130_fd_sc_hd__nand2_1 _0612_ (.A(\x_stage1[0] ),
    .B(\x_stage1[3] ),
    .Y(_0054_));
 sky130_fd_sc_hd__nand2b_1 _0613_ (.A_N(\x_stage1[4] ),
    .B(\x_stage1[5] ),
    .Y(_0055_));
 sky130_fd_sc_hd__nor3_1 _0614_ (.A(_0029_),
    .B(_0054_),
    .C(_0055_),
    .Y(_0056_));
 sky130_fd_sc_hd__o21ai_0 _0617_ (.A1(net69),
    .A2(_0056_),
    .B1(net67),
    .Y(_0059_));
 sky130_fd_sc_hd__nor2b_1 _0618_ (.A(\x_stage1[4] ),
    .B_N(\x_stage1[5] ),
    .Y(_0060_));
 sky130_fd_sc_hd__nand2b_1 _0620_ (.A_N(net58),
    .B(\x_stage1[6] ),
    .Y(_0062_));
 sky130_fd_sc_hd__nor2b_1 _0622_ (.A(net70),
    .B_N(net69),
    .Y(_0064_));
 sky130_fd_sc_hd__o32ai_1 _0625_ (.A1(net66),
    .A2(_0062_),
    .A3(_0064_),
    .B1(_0029_),
    .B2(net70),
    .Y(_0067_));
 sky130_fd_sc_hd__nand2b_1 _0626_ (.A_N(net69),
    .B(net70),
    .Y(_0068_));
 sky130_fd_sc_hd__nand2_1 _0627_ (.A(net66),
    .B(net58),
    .Y(_0069_));
 sky130_fd_sc_hd__or2_2 _0629_ (.A(net66),
    .B(\x_stage1[5] ),
    .X(_0071_));
 sky130_fd_sc_hd__nand2b_1 _0630_ (.A_N(net58),
    .B(\x_stage1[4] ),
    .Y(_0072_));
 sky130_fd_sc_hd__o32ai_1 _0631_ (.A1(_0068_),
    .A2(_0055_),
    .A3(_0069_),
    .B1(_0071_),
    .B2(_0072_),
    .Y(_0073_));
 sky130_fd_sc_hd__inv_2 _0632_ (.A(net59),
    .Y(_0074_));
 sky130_fd_sc_hd__a22oi_1 _0633_ (.A1(net56),
    .A2(_0067_),
    .B1(_0073_),
    .B2(_0074_),
    .Y(_0075_));
 sky130_fd_sc_hd__o2bb2ai_1 _0634_ (.A1_N(_0039_),
    .A2_N(_0053_),
    .B1(_0059_),
    .B2(_0075_),
    .Y(_0076_));
 sky130_fd_sc_hd__nor2b_1 _0637_ (.A(net63),
    .B_N(net58),
    .Y(_0079_));
 sky130_fd_sc_hd__nand2b_1 _0638_ (.A_N(\x_stage1[3] ),
    .B(net68),
    .Y(_0080_));
 sky130_fd_sc_hd__nand2b_1 _0640_ (.A_N(net62),
    .B(net60),
    .Y(_0082_));
 sky130_fd_sc_hd__nand2b_1 _0641_ (.A_N(net60),
    .B(net62),
    .Y(_0083_));
 sky130_fd_sc_hd__nand2b_1 _0642_ (.A_N(net68),
    .B(\x_stage1[3] ),
    .Y(_0084_));
 sky130_fd_sc_hd__o22ai_1 _0643_ (.A1(_0080_),
    .A2(_0082_),
    .B1(_0083_),
    .B2(_0084_),
    .Y(_0085_));
 sky130_fd_sc_hd__a21boi_1 _0644_ (.A1(net66),
    .A2(net68),
    .B1_N(net71),
    .Y(_0086_));
 sky130_fd_sc_hd__nand4b_1 _0645_ (.A_N(net58),
    .B(net60),
    .C(net62),
    .D(net63),
    .Y(_0087_));
 sky130_fd_sc_hd__nor3_1 _0646_ (.A(net69),
    .B(_0086_),
    .C(_0087_),
    .Y(_0088_));
 sky130_fd_sc_hd__a31oi_1 _0647_ (.A1(net71),
    .A2(_0079_),
    .A3(_0085_),
    .B1(_0088_),
    .Y(_0089_));
 sky130_fd_sc_hd__or2_2 _0651_ (.A(net58),
    .B(net59),
    .X(_0093_));
 sky130_fd_sc_hd__nor2_1 _0653_ (.A(net64),
    .B(_0093_),
    .Y(_0095_));
 sky130_fd_sc_hd__nor2b_1 _0654_ (.A(net67),
    .B_N(\x_stage1[0] ),
    .Y(_0096_));
 sky130_fd_sc_hd__nand2_1 _0655_ (.A(net69),
    .B(\x_stage1[3] ),
    .Y(_0097_));
 sky130_fd_sc_hd__nand4_1 _0656_ (.A(net62),
    .B(_0095_),
    .C(_0096_),
    .D(_0097_),
    .Y(_0098_));
 sky130_fd_sc_hd__nand2_1 _0657_ (.A(net58),
    .B(\x_stage1[6] ),
    .Y(_0099_));
 sky130_fd_sc_hd__nor2_1 _0658_ (.A(net64),
    .B(_0099_),
    .Y(_0100_));
 sky130_fd_sc_hd__inv_2 _0659_ (.A(net69),
    .Y(_0101_));
 sky130_fd_sc_hd__o21ai_0 _0660_ (.A1(_0101_),
    .A2(_0013_),
    .B1(_0037_),
    .Y(_0102_));
 sky130_fd_sc_hd__nand3_1 _0661_ (.A(_0048_),
    .B(_0100_),
    .C(_0102_),
    .Y(_0103_));
 sky130_fd_sc_hd__nand3_1 _0662_ (.A(_0089_),
    .B(_0098_),
    .C(_0103_),
    .Y(_0104_));
 sky130_fd_sc_hd__nor2_1 _0663_ (.A(_0013_),
    .B(_0032_),
    .Y(_0105_));
 sky130_fd_sc_hd__nor2_1 _0664_ (.A(net69),
    .B(net66),
    .Y(_0106_));
 sky130_fd_sc_hd__or2_2 _0665_ (.A(net66),
    .B(net68),
    .X(_0107_));
 sky130_fd_sc_hd__nand2b_1 _0667_ (.A_N(net70),
    .B(net69),
    .Y(_0109_));
 sky130_fd_sc_hd__or4bb_1 _0668_ (.A(\x_stage1[5] ),
    .B(\x_stage1[4] ),
    .C_N(net58),
    .D_N(net59),
    .X(_0110_));
 sky130_fd_sc_hd__nor3_1 _0669_ (.A(_0107_),
    .B(_0109_),
    .C(_0110_),
    .Y(_0111_));
 sky130_fd_sc_hd__a21oi_1 _0670_ (.A1(_0105_),
    .A2(_0106_),
    .B1(_0111_),
    .Y(_0112_));
 sky130_fd_sc_hd__and4bb_2 _0671_ (.A_N(\x_stage1[4] ),
    .B_N(net58),
    .C(net59),
    .D(\x_stage1[5] ),
    .X(_0113_));
 sky130_fd_sc_hd__nor2b_1 _0672_ (.A(net68),
    .B_N(\x_stage1[3] ),
    .Y(_0114_));
 sky130_fd_sc_hd__inv_1 _0674_ (.A(net71),
    .Y(_0116_));
 sky130_fd_sc_hd__a2111oi_0 _0677_ (.A1(net64),
    .A2(_0084_),
    .B1(_0093_),
    .C1(_0116_),
    .D1(\x_stage1[5] ),
    .Y(_0119_));
 sky130_fd_sc_hd__a21oi_1 _0678_ (.A1(_0113_),
    .A2(net55),
    .B1(_0119_),
    .Y(_0120_));
 sky130_fd_sc_hd__and2_1 _0679_ (.A(net66),
    .B(\x_stage1[2] ),
    .X(_0121_));
 sky130_fd_sc_hd__nand2b_1 _0681_ (.A_N(net62),
    .B(net64),
    .Y(_0123_));
 sky130_fd_sc_hd__nor2_1 _0682_ (.A(_0099_),
    .B(_0123_),
    .Y(_0124_));
 sky130_fd_sc_hd__nor2_1 _0683_ (.A(stage1_valid),
    .B(net73),
    .Y(_0125_));
 sky130_fd_sc_hd__a32oi_1 _0684_ (.A1(_0068_),
    .A2(_0121_),
    .A3(_0124_),
    .B1(_0125_),
    .B2(\lut_stage2[0] ),
    .Y(_0126_));
 sky130_fd_sc_hd__nand3_1 _0685_ (.A(_0112_),
    .B(_0120_),
    .C(_0126_),
    .Y(_0127_));
 sky130_fd_sc_hd__a2111oi_0 _0686_ (.A1(net69),
    .A2(_0038_),
    .B1(_0076_),
    .C1(_0104_),
    .D1(_0127_),
    .Y(_0128_));
 sky130_fd_sc_hd__nor2_1 _0687_ (.A(net70),
    .B(net67),
    .Y(_0129_));
 sky130_fd_sc_hd__nor4b_1 _0689_ (.A(net61),
    .B(net63),
    .C(net58),
    .D_N(net60),
    .Y(_0131_));
 sky130_fd_sc_hd__nand2b_1 _0690_ (.A_N(\x_stage1[0] ),
    .B(net67),
    .Y(_0132_));
 sky130_fd_sc_hd__o211ai_1 _0691_ (.A1(net67),
    .A2(net53),
    .B1(_0132_),
    .C1(net69),
    .Y(_0133_));
 sky130_fd_sc_hd__o211ai_1 _0693_ (.A1(net69),
    .A2(_0129_),
    .B1(_0133_),
    .C1(net57),
    .Y(_0135_));
 sky130_fd_sc_hd__nand4b_1 _0695_ (.A_N(net59),
    .B(net58),
    .C(\x_stage1[4] ),
    .D(\x_stage1[5] ),
    .Y(_0137_));
 sky130_fd_sc_hd__nor2b_1 _0696_ (.A(net69),
    .B_N(net67),
    .Y(_0138_));
 sky130_fd_sc_hd__nand2_1 _0697_ (.A(net61),
    .B(net64),
    .Y(_0139_));
 sky130_fd_sc_hd__nor2_1 _0698_ (.A(_0139_),
    .B(_0029_),
    .Y(_0140_));
 sky130_fd_sc_hd__a21oi_1 _0699_ (.A1(_0109_),
    .A2(_0140_),
    .B1(net53),
    .Y(_0141_));
 sky130_fd_sc_hd__a31oi_1 _0700_ (.A1(net66),
    .A2(_0137_),
    .A3(_0138_),
    .B1(_0141_),
    .Y(_0142_));
 sky130_fd_sc_hd__nor2_2 _0701_ (.A(net66),
    .B(\x_stage1[2] ),
    .Y(_0143_));
 sky130_fd_sc_hd__nor2_1 _0702_ (.A(_0143_),
    .B(_0068_),
    .Y(_0144_));
 sky130_fd_sc_hd__a31oi_1 _0703_ (.A1(net70),
    .A2(\x_stage1[3] ),
    .A3(_0137_),
    .B1(_0144_),
    .Y(_0145_));
 sky130_fd_sc_hd__or2_2 _0704_ (.A(net71),
    .B(\x_stage1[3] ),
    .X(_0146_));
 sky130_fd_sc_hd__nor2_1 _0705_ (.A(_0093_),
    .B(_0123_),
    .Y(_0147_));
 sky130_fd_sc_hd__nor2_1 _0706_ (.A(_0029_),
    .B(_0055_),
    .Y(_0148_));
 sky130_fd_sc_hd__a211oi_1 _0707_ (.A1(_0109_),
    .A2(_0113_),
    .B1(_0147_),
    .C1(_0148_),
    .Y(_0149_));
 sky130_fd_sc_hd__nand2_1 _0709_ (.A(net62),
    .B(net60),
    .Y(_0151_));
 sky130_fd_sc_hd__nor2_1 _0710_ (.A(_0080_),
    .B(_0151_),
    .Y(_0152_));
 sky130_fd_sc_hd__nor2b_1 _0711_ (.A(net58),
    .B_N(net63),
    .Y(_0153_));
 sky130_fd_sc_hd__nand2_1 _0712_ (.A(\x_stage1[1] ),
    .B(net71),
    .Y(_0154_));
 sky130_fd_sc_hd__mux2_2 _0713_ (.A0(_0153_),
    .A1(_0079_),
    .S(_0154_),
    .X(_0155_));
 sky130_fd_sc_hd__nor2b_1 _0714_ (.A(\x_stage1[3] ),
    .B_N(net68),
    .Y(_0156_));
 sky130_fd_sc_hd__a22o_1 _0715_ (.A1(_0116_),
    .A2(_0156_),
    .B1(_0096_),
    .B2(_0097_),
    .X(_0157_));
 sky130_fd_sc_hd__a22oi_1 _0716_ (.A1(_0152_),
    .A2(_0155_),
    .B1(_0124_),
    .B2(_0157_),
    .Y(_0158_));
 sky130_fd_sc_hd__or2_2 _0717_ (.A(net69),
    .B(net70),
    .X(_0159_));
 sky130_fd_sc_hd__nor2_1 _0719_ (.A(\x_stage1[2] ),
    .B(net61),
    .Y(_0161_));
 sky130_fd_sc_hd__nor4b_1 _0720_ (.A(net70),
    .B(_0042_),
    .C(_0027_),
    .D_N(net52),
    .Y(_0162_));
 sky130_fd_sc_hd__and2_1 _0721_ (.A(net69),
    .B(net71),
    .X(_0163_));
 sky130_fd_sc_hd__nor4_1 _0722_ (.A(_0107_),
    .B(_0062_),
    .C(_0123_),
    .D(_0163_),
    .Y(_0164_));
 sky130_fd_sc_hd__o21ai_0 _0723_ (.A1(_0159_),
    .A2(_0162_),
    .B1(_0164_),
    .Y(_0165_));
 sky130_fd_sc_hd__inv_1 _0724_ (.A(net58),
    .Y(_0166_));
 sky130_fd_sc_hd__o21ai_0 _0726_ (.A1(\x_stage1[3] ),
    .A2(net60),
    .B1(net69),
    .Y(_0168_));
 sky130_fd_sc_hd__nand2b_1 _0727_ (.A_N(net60),
    .B(net64),
    .Y(_0169_));
 sky130_fd_sc_hd__o2bb2ai_1 _0728_ (.A1_N(net56),
    .A2_N(_0168_),
    .B1(_0169_),
    .B2(net62),
    .Y(_0170_));
 sky130_fd_sc_hd__nand4_1 _0729_ (.A(_0116_),
    .B(net67),
    .C(_0166_),
    .D(_0170_),
    .Y(_0171_));
 sky130_fd_sc_hd__o2111ai_1 _0730_ (.A1(_0146_),
    .A2(_0149_),
    .B1(_0158_),
    .C1(_0165_),
    .D1(_0171_),
    .Y(_0172_));
 sky130_fd_sc_hd__a31oi_1 _0731_ (.A1(_0135_),
    .A2(_0142_),
    .A3(_0145_),
    .B1(_0172_),
    .Y(_0173_));
 sky130_fd_sc_hd__or4b_1 _0732_ (.A(\x_stage1[5] ),
    .B(\x_stage1[4] ),
    .C(net59),
    .D_N(net58),
    .X(_0174_));
 sky130_fd_sc_hd__nand2_1 _0733_ (.A(\x_stage1[3] ),
    .B(net68),
    .Y(_0175_));
 sky130_fd_sc_hd__and4_1 _0734_ (.A(\x_stage1[5] ),
    .B(\x_stage1[4] ),
    .C(net58),
    .D(net59),
    .X(_0176_));
 sky130_fd_sc_hd__o21ai_0 _0736_ (.A1(net70),
    .A2(_0175_),
    .B1(_0176_),
    .Y(_0178_));
 sky130_fd_sc_hd__nand2_1 _0737_ (.A(_0174_),
    .B(_0178_),
    .Y(_0179_));
 sky130_fd_sc_hd__nand2b_1 _0738_ (.A_N(net69),
    .B(\x_stage1[3] ),
    .Y(_0180_));
 sky130_fd_sc_hd__a21oi_1 _0739_ (.A1(net67),
    .A2(_0176_),
    .B1(_0180_),
    .Y(_0181_));
 sky130_fd_sc_hd__nor4b_2 _0740_ (.A(\x_stage1[5] ),
    .B(\x_stage1[4] ),
    .C(net59),
    .D_N(net58),
    .Y(_0182_));
 sky130_fd_sc_hd__nor2_1 _0741_ (.A(net51),
    .B(_0080_),
    .Y(_0183_));
 sky130_fd_sc_hd__o21ai_0 _0742_ (.A1(_0181_),
    .A2(_0183_),
    .B1(net70),
    .Y(_0184_));
 sky130_fd_sc_hd__o21ai_0 _0743_ (.A1(\x_stage1[3] ),
    .A2(_0176_),
    .B1(net67),
    .Y(_0185_));
 sky130_fd_sc_hd__a22oi_1 _0744_ (.A1(net69),
    .A2(_0143_),
    .B1(_0064_),
    .B2(_0185_),
    .Y(_0186_));
 sky130_fd_sc_hd__or3_1 _0745_ (.A(net71),
    .B(\x_stage1[3] ),
    .C(net68),
    .X(_0187_));
 sky130_fd_sc_hd__and4bb_2 _0746_ (.A_N(\x_stage1[5] ),
    .B_N(net59),
    .C(net58),
    .D(\x_stage1[4] ),
    .X(_0188_));
 sky130_fd_sc_hd__a21oi_1 _0747_ (.A1(_0187_),
    .A2(_0188_),
    .B1(_0101_),
    .Y(_0189_));
 sky130_fd_sc_hd__nand4b_1 _0748_ (.A_N(\x_stage1[4] ),
    .B(net58),
    .C(net59),
    .D(\x_stage1[5] ),
    .Y(_0190_));
 sky130_fd_sc_hd__o21ai_0 _0749_ (.A1(\x_stage1[3] ),
    .A2(_0110_),
    .B1(_0190_),
    .Y(_0191_));
 sky130_fd_sc_hd__a21oi_1 _0750_ (.A1(_0080_),
    .A2(_0191_),
    .B1(_0068_),
    .Y(_0192_));
 sky130_fd_sc_hd__nor3_1 _0751_ (.A(net70),
    .B(_0162_),
    .C(_0188_),
    .Y(_0193_));
 sky130_fd_sc_hd__nor3_1 _0752_ (.A(_0189_),
    .B(_0192_),
    .C(_0193_),
    .Y(_0194_));
 sky130_fd_sc_hd__a31oi_1 _0753_ (.A1(_0179_),
    .A2(_0184_),
    .A3(_0186_),
    .B1(_0194_),
    .Y(_0195_));
 sky130_fd_sc_hd__nor2_1 _0755_ (.A(net69),
    .B(net70),
    .Y(_0197_));
 sky130_fd_sc_hd__nor3_1 _0756_ (.A(net62),
    .B(\x_stage1[4] ),
    .C(_0093_),
    .Y(_0198_));
 sky130_fd_sc_hd__inv_1 _0757_ (.A(stage1_valid),
    .Y(_0199_));
 sky130_fd_sc_hd__a311oi_2 _0758_ (.A1(_0143_),
    .A2(_0197_),
    .A3(_0198_),
    .B1(net73),
    .C1(_0199_),
    .Y(_0200_));
 sky130_fd_sc_hd__a21oi_1 _0759_ (.A1(\lut_stage2[0] ),
    .A2(_0125_),
    .B1(net47),
    .Y(_0201_));
 sky130_fd_sc_hd__a31oi_1 _0760_ (.A1(_0128_),
    .A2(_0173_),
    .A3(_0195_),
    .B1(_0201_),
    .Y(\_0001_[0] ));
 sky130_fd_sc_hd__nand2_1 _0761_ (.A(net69),
    .B(_0042_),
    .Y(_0202_));
 sky130_fd_sc_hd__a22oi_1 _0762_ (.A1(\x_stage1[0] ),
    .A2(_0039_),
    .B1(net52),
    .B2(_0100_),
    .Y(_0203_));
 sky130_fd_sc_hd__nor2_1 _0763_ (.A(net63),
    .B(net60),
    .Y(_0204_));
 sky130_fd_sc_hd__nand2_1 _0764_ (.A(net63),
    .B(net60),
    .Y(_0205_));
 sky130_fd_sc_hd__o2bb2ai_1 _0765_ (.A1_N(net69),
    .A2_N(_0204_),
    .B1(_0205_),
    .B2(_0116_),
    .Y(_0206_));
 sky130_fd_sc_hd__nor2_1 _0766_ (.A(net62),
    .B(net58),
    .Y(_0207_));
 sky130_fd_sc_hd__or4b_2 _0767_ (.A(net69),
    .B(net68),
    .C(net58),
    .D_N(net63),
    .X(_0208_));
 sky130_fd_sc_hd__a211oi_1 _0768_ (.A1(_0082_),
    .A2(_0083_),
    .B1(_0208_),
    .C1(net66),
    .Y(_0209_));
 sky130_fd_sc_hd__a21oi_1 _0769_ (.A1(_0206_),
    .A2(_0207_),
    .B1(_0209_),
    .Y(_0210_));
 sky130_fd_sc_hd__a21o_1 _0770_ (.A1(\x_stage1[3] ),
    .A2(_0039_),
    .B1(_0113_),
    .X(_0211_));
 sky130_fd_sc_hd__nor2_1 _0771_ (.A(_0101_),
    .B(net67),
    .Y(_0212_));
 sky130_fd_sc_hd__nand2b_1 _0772_ (.A_N(net68),
    .B(net71),
    .Y(_0213_));
 sky130_fd_sc_hd__or3b_2 _0773_ (.A(net69),
    .B(net71),
    .C_N(net68),
    .X(_0214_));
 sky130_fd_sc_hd__a211oi_1 _0774_ (.A1(_0213_),
    .A2(_0214_),
    .B1(_0110_),
    .C1(\x_stage1[3] ),
    .Y(_0215_));
 sky130_fd_sc_hd__a221oi_2 _0775_ (.A1(_0086_),
    .A2(_0211_),
    .B1(_0212_),
    .B2(_0148_),
    .C1(_0215_),
    .Y(_0216_));
 sky130_fd_sc_hd__nand2_1 _0776_ (.A(net69),
    .B(net68),
    .Y(_0217_));
 sky130_fd_sc_hd__o22a_1 _0777_ (.A1(_0101_),
    .A2(_0187_),
    .B1(_0188_),
    .B2(_0217_),
    .X(_0218_));
 sky130_fd_sc_hd__or4b_2 _0778_ (.A(\x_stage1[5] ),
    .B(\x_stage1[4] ),
    .C(net58),
    .D_N(\x_stage1[6] ),
    .X(_0219_));
 sky130_fd_sc_hd__nor2b_1 _0779_ (.A(net69),
    .B_N(net66),
    .Y(_0220_));
 sky130_fd_sc_hd__a21boi_0 _0780_ (.A1(_0219_),
    .A2(net50),
    .B1_N(_0054_),
    .Y(_0221_));
 sky130_fd_sc_hd__nor2_1 _0781_ (.A(net70),
    .B(net66),
    .Y(_0222_));
 sky130_fd_sc_hd__o21ai_0 _0782_ (.A1(_0219_),
    .A2(_0222_),
    .B1(_0138_),
    .Y(_0223_));
 sky130_fd_sc_hd__o2111ai_1 _0783_ (.A1(net53),
    .A2(_0188_),
    .B1(_0218_),
    .C1(_0221_),
    .D1(_0223_),
    .Y(_0224_));
 sky130_fd_sc_hd__o2111ai_1 _0784_ (.A1(_0202_),
    .A2(_0203_),
    .B1(_0210_),
    .C1(_0216_),
    .D1(_0224_),
    .Y(_0225_));
 sky130_fd_sc_hd__o22ai_1 _0785_ (.A1(net68),
    .A2(_0140_),
    .B1(_0175_),
    .B2(net69),
    .Y(_0226_));
 sky130_fd_sc_hd__o21ai_0 _0786_ (.A1(net66),
    .A2(_0140_),
    .B1(_0084_),
    .Y(_0227_));
 sky130_fd_sc_hd__a22oi_1 _0787_ (.A1(_0137_),
    .A2(_0114_),
    .B1(_0087_),
    .B2(net68),
    .Y(_0228_));
 sky130_fd_sc_hd__nor3_1 _0788_ (.A(net69),
    .B(net71),
    .C(net66),
    .Y(_0229_));
 sky130_fd_sc_hd__o21ai_0 _0789_ (.A1(_0137_),
    .A2(_0229_),
    .B1(_0087_),
    .Y(_0230_));
 sky130_fd_sc_hd__o221ai_1 _0790_ (.A1(net71),
    .A2(_0217_),
    .B1(_0228_),
    .B2(net69),
    .C1(_0230_),
    .Y(_0231_));
 sky130_fd_sc_hd__a221oi_1 _0791_ (.A1(net71),
    .A2(_0226_),
    .B1(_0227_),
    .B2(_0163_),
    .C1(_0231_),
    .Y(_0232_));
 sky130_fd_sc_hd__and4b_1 _0792_ (.A_N(\x_stage1[4] ),
    .B(net58),
    .C(\x_stage1[6] ),
    .D(\x_stage1[5] ),
    .X(_0233_));
 sky130_fd_sc_hd__nor3b_1 _0794_ (.A(\x_stage1[0] ),
    .B(net67),
    .C_N(net69),
    .Y(_0235_));
 sky130_fd_sc_hd__a22o_1 _0795_ (.A1(_0138_),
    .A2(_0233_),
    .B1(_0235_),
    .B2(net51),
    .X(_0236_));
 sky130_fd_sc_hd__nand2_1 _0796_ (.A(net66),
    .B(_0236_),
    .Y(_0237_));
 sky130_fd_sc_hd__a21oi_1 _0797_ (.A1(_0146_),
    .A2(_0154_),
    .B1(net68),
    .Y(_0238_));
 sky130_fd_sc_hd__nand2b_1 _0798_ (.A_N(net69),
    .B(net62),
    .Y(_0239_));
 sky130_fd_sc_hd__nand3_1 _0799_ (.A(net63),
    .B(net58),
    .C(net60),
    .Y(_0240_));
 sky130_fd_sc_hd__nor4_1 _0800_ (.A(_0143_),
    .B(_0086_),
    .C(_0239_),
    .D(_0240_),
    .Y(_0241_));
 sky130_fd_sc_hd__a21oi_1 _0801_ (.A1(_0233_),
    .A2(_0238_),
    .B1(_0241_),
    .Y(_0242_));
 sky130_fd_sc_hd__o22ai_1 _0802_ (.A1(_0217_),
    .A2(_0082_),
    .B1(_0083_),
    .B2(net69),
    .Y(_0243_));
 sky130_fd_sc_hd__or4_1 _0803_ (.A(net69),
    .B(net70),
    .C(net58),
    .D(\x_stage1[6] ),
    .X(_0244_));
 sky130_fd_sc_hd__nand4_1 _0804_ (.A(net69),
    .B(net70),
    .C(net58),
    .D(\x_stage1[6] ),
    .Y(_0245_));
 sky130_fd_sc_hd__a211oi_1 _0805_ (.A1(_0244_),
    .A2(_0245_),
    .B1(_0139_),
    .C1(_0080_),
    .Y(_0246_));
 sky130_fd_sc_hd__a31oi_1 _0806_ (.A1(_0048_),
    .A2(_0079_),
    .A3(_0243_),
    .B1(_0246_),
    .Y(_0247_));
 sky130_fd_sc_hd__nand3_1 _0807_ (.A(_0237_),
    .B(_0242_),
    .C(_0247_),
    .Y(_0248_));
 sky130_fd_sc_hd__inv_1 _0808_ (.A(net61),
    .Y(_0249_));
 sky130_fd_sc_hd__nor2_1 _0809_ (.A(net58),
    .B(\x_stage1[6] ),
    .Y(_0250_));
 sky130_fd_sc_hd__nand3_1 _0810_ (.A(_0249_),
    .B(net63),
    .C(_0250_),
    .Y(_0251_));
 sky130_fd_sc_hd__nor2_1 _0811_ (.A(_0048_),
    .B(_0086_),
    .Y(_0252_));
 sky130_fd_sc_hd__xnor2_1 _0812_ (.A(_0101_),
    .B(_0252_),
    .Y(_0253_));
 sky130_fd_sc_hd__nor3_1 _0813_ (.A(net66),
    .B(net63),
    .C(net60),
    .Y(_0254_));
 sky130_fd_sc_hd__nor2_1 _0814_ (.A(_0107_),
    .B(_0205_),
    .Y(_0255_));
 sky130_fd_sc_hd__o2111ai_1 _0815_ (.A1(_0254_),
    .A2(_0255_),
    .B1(net69),
    .C1(net62),
    .D1(net58),
    .Y(_0256_));
 sky130_fd_sc_hd__and2_1 _0816_ (.A(\x_stage1[2] ),
    .B(net61),
    .X(_0257_));
 sky130_fd_sc_hd__nand2b_1 _0817_ (.A_N(net64),
    .B(net60),
    .Y(_0258_));
 sky130_fd_sc_hd__o21ai_0 _0818_ (.A1(_0042_),
    .A2(_0258_),
    .B1(_0169_),
    .Y(_0259_));
 sky130_fd_sc_hd__nand4_1 _0819_ (.A(_0166_),
    .B(_0064_),
    .C(_0257_),
    .D(_0259_),
    .Y(_0260_));
 sky130_fd_sc_hd__o2111ai_1 _0820_ (.A1(_0251_),
    .A2(_0253_),
    .B1(_0256_),
    .C1(_0260_),
    .D1(_0158_),
    .Y(_0261_));
 sky130_fd_sc_hd__or4_1 _0821_ (.A(_0225_),
    .B(_0232_),
    .C(_0248_),
    .D(_0261_),
    .X(_0262_));
 sky130_fd_sc_hd__nand3_1 _0822_ (.A(net67),
    .B(_0250_),
    .C(net56),
    .Y(_0263_));
 sky130_fd_sc_hd__nand2_1 _0823_ (.A(net51),
    .B(_0096_),
    .Y(_0264_));
 sky130_fd_sc_hd__a21oi_1 _0825_ (.A1(_0263_),
    .A2(_0264_),
    .B1(net69),
    .Y(_0266_));
 sky130_fd_sc_hd__o21ai_0 _0826_ (.A1(_0235_),
    .A2(_0266_),
    .B1(_0042_),
    .Y(_0267_));
 sky130_fd_sc_hd__and3_1 _0828_ (.A(net68),
    .B(_0249_),
    .C(net58),
    .X(_0269_));
 sky130_fd_sc_hd__nor3_1 _0829_ (.A(net68),
    .B(_0249_),
    .C(net58),
    .Y(_0270_));
 sky130_fd_sc_hd__o221ai_1 _0830_ (.A1(net50),
    .A2(_0163_),
    .B1(_0269_),
    .B2(_0270_),
    .C1(_0204_),
    .Y(_0271_));
 sky130_fd_sc_hd__o21a_1 _0831_ (.A1(net71),
    .A2(_0263_),
    .B1(_0214_),
    .X(_0272_));
 sky130_fd_sc_hd__nor3_1 _0832_ (.A(_0093_),
    .B(_0055_),
    .C(_0229_),
    .Y(_0273_));
 sky130_fd_sc_hd__o21ai_0 _0833_ (.A1(net51),
    .A2(_0273_),
    .B1(net47),
    .Y(_0274_));
 sky130_fd_sc_hd__a31oi_1 _0834_ (.A1(_0267_),
    .A2(_0271_),
    .A3(_0272_),
    .B1(_0274_),
    .Y(_0275_));
 sky130_fd_sc_hd__a221o_1 _0835_ (.A1(\lut_stage2[1] ),
    .A2(net54),
    .B1(net47),
    .B2(_0262_),
    .C1(_0275_),
    .X(\_0001_[1] ));
 sky130_fd_sc_hd__nor2_1 _0836_ (.A(net63),
    .B(_0062_),
    .Y(_0276_));
 sky130_fd_sc_hd__nor3_1 _0837_ (.A(\x_stage1[2] ),
    .B(_0099_),
    .C(_0123_),
    .Y(_0277_));
 sky130_fd_sc_hd__a31oi_1 _0838_ (.A1(net62),
    .A2(_0156_),
    .A3(_0276_),
    .B1(_0277_),
    .Y(_0278_));
 sky130_fd_sc_hd__o221ai_1 _0839_ (.A1(_0080_),
    .A2(_0251_),
    .B1(_0190_),
    .B2(_0054_),
    .C1(_0278_),
    .Y(_0279_));
 sky130_fd_sc_hd__nand3_1 _0840_ (.A(net69),
    .B(net70),
    .C(net66),
    .Y(_0280_));
 sky130_fd_sc_hd__nand2b_1 _0841_ (.A_N(_0277_),
    .B(net69),
    .Y(_0281_));
 sky130_fd_sc_hd__and2_1 _0842_ (.A(net58),
    .B(\x_stage1[6] ),
    .X(_0282_));
 sky130_fd_sc_hd__a21oi_1 _0843_ (.A1(net70),
    .A2(_0250_),
    .B1(_0282_),
    .Y(_0283_));
 sky130_fd_sc_hd__o32ai_1 _0844_ (.A1(_0055_),
    .A2(_0202_),
    .A3(_0283_),
    .B1(_0190_),
    .B2(_0109_),
    .Y(_0284_));
 sky130_fd_sc_hd__a22o_1 _0845_ (.A1(_0222_),
    .A2(_0147_),
    .B1(_0202_),
    .B2(_0198_),
    .X(_0285_));
 sky130_fd_sc_hd__o21a_1 _0846_ (.A1(_0284_),
    .A2(_0285_),
    .B1(\x_stage1[2] ),
    .X(_0286_));
 sky130_fd_sc_hd__a31oi_1 _0847_ (.A1(_0279_),
    .A2(_0280_),
    .A3(_0281_),
    .B1(_0286_),
    .Y(_0287_));
 sky130_fd_sc_hd__nand2_1 _0848_ (.A(_0153_),
    .B(_0212_),
    .Y(_0288_));
 sky130_fd_sc_hd__o21ai_0 _0849_ (.A1(net62),
    .A2(net60),
    .B1(\x_stage1[3] ),
    .Y(_0289_));
 sky130_fd_sc_hd__a31oi_1 _0850_ (.A1(_0116_),
    .A2(net62),
    .A3(net60),
    .B1(_0289_),
    .Y(_0290_));
 sky130_fd_sc_hd__a211oi_1 _0851_ (.A1(_0042_),
    .A2(_0083_),
    .B1(_0288_),
    .C1(_0290_),
    .Y(_0291_));
 sky130_fd_sc_hd__nor2_1 _0852_ (.A(_0087_),
    .B(_0235_),
    .Y(_0292_));
 sky130_fd_sc_hd__nor2b_1 _0853_ (.A(net64),
    .B_N(net67),
    .Y(_0293_));
 sky130_fd_sc_hd__mux2i_1 _0854_ (.A0(net66),
    .A1(_0097_),
    .S(_0293_),
    .Y(_0294_));
 sky130_fd_sc_hd__nor2b_1 _0855_ (.A(\x_stage1[2] ),
    .B_N(\x_stage1[4] ),
    .Y(_0295_));
 sky130_fd_sc_hd__nor2_1 _0856_ (.A(net70),
    .B(\x_stage1[5] ),
    .Y(_0296_));
 sky130_fd_sc_hd__nand3b_1 _0857_ (.A_N(_0295_),
    .B(_0296_),
    .C(_0282_),
    .Y(_0297_));
 sky130_fd_sc_hd__a22oi_1 _0858_ (.A1(\lut_stage2[2] ),
    .A2(_0125_),
    .B1(_0222_),
    .B2(_0233_),
    .Y(_0298_));
 sky130_fd_sc_hd__o21ai_1 _0859_ (.A1(_0294_),
    .A2(_0297_),
    .B1(_0298_),
    .Y(_0299_));
 sky130_fd_sc_hd__a311o_1 _0860_ (.A1(net57),
    .A2(_0068_),
    .A3(_0292_),
    .B1(_0299_),
    .C1(_0246_),
    .X(_0300_));
 sky130_fd_sc_hd__o22a_1 _0861_ (.A1(_0175_),
    .A2(_0169_),
    .B1(_0258_),
    .B2(_0107_),
    .X(_0301_));
 sky130_fd_sc_hd__nand3_1 _0862_ (.A(_0116_),
    .B(_0121_),
    .C(_0039_),
    .Y(_0302_));
 sky130_fd_sc_hd__nor4bb_1 _0863_ (.A(net66),
    .B(net62),
    .C_N(net63),
    .D_N(net60),
    .Y(_0303_));
 sky130_fd_sc_hd__nor4bb_1 _0864_ (.A(net63),
    .B(net60),
    .C_N(net66),
    .D_N(net62),
    .Y(_0304_));
 sky130_fd_sc_hd__nor3_1 _0865_ (.A(net69),
    .B(net68),
    .C(net58),
    .Y(_0305_));
 sky130_fd_sc_hd__o21ai_1 _0866_ (.A1(_0303_),
    .A2(_0304_),
    .B1(_0305_),
    .Y(_0306_));
 sky130_fd_sc_hd__o311ai_1 _0867_ (.A1(net58),
    .A2(_0239_),
    .A3(_0301_),
    .B1(_0302_),
    .C1(_0306_),
    .Y(_0307_));
 sky130_fd_sc_hd__o21ai_0 _0868_ (.A1(_0169_),
    .A2(_0213_),
    .B1(_0258_),
    .Y(_0308_));
 sky130_fd_sc_hd__nand4_1 _0869_ (.A(net69),
    .B(_0042_),
    .C(_0207_),
    .D(_0308_),
    .Y(_0309_));
 sky130_fd_sc_hd__a2111o_1 _0870_ (.A1(_0037_),
    .A2(_0013_),
    .B1(\x_stage1[3] ),
    .C1(net64),
    .D1(_0093_),
    .X(_0310_));
 sky130_fd_sc_hd__nand3_1 _0871_ (.A(_0112_),
    .B(_0309_),
    .C(_0310_),
    .Y(_0311_));
 sky130_fd_sc_hd__nor4_1 _0872_ (.A(_0291_),
    .B(_0300_),
    .C(_0307_),
    .D(_0311_),
    .Y(_0312_));
 sky130_fd_sc_hd__nor3_1 _0873_ (.A(_0116_),
    .B(_0180_),
    .C(_0032_),
    .Y(_0313_));
 sky130_fd_sc_hd__a31oi_1 _0874_ (.A1(_0250_),
    .A2(net50),
    .A3(_0295_),
    .B1(_0313_),
    .Y(_0314_));
 sky130_fd_sc_hd__nor2b_1 _0875_ (.A(net58),
    .B_N(\x_stage1[6] ),
    .Y(_0315_));
 sky130_fd_sc_hd__nor3_1 _0876_ (.A(\x_stage1[4] ),
    .B(_0062_),
    .C(_0280_),
    .Y(_0316_));
 sky130_fd_sc_hd__a311oi_1 _0877_ (.A1(_0315_),
    .A2(net50),
    .A3(_0295_),
    .B1(_0316_),
    .C1(\x_stage1[5] ),
    .Y(_0317_));
 sky130_fd_sc_hd__a21oi_1 _0878_ (.A1(\x_stage1[5] ),
    .A2(_0314_),
    .B1(_0317_),
    .Y(_0318_));
 sky130_fd_sc_hd__nor2_1 _0879_ (.A(_0129_),
    .B(_0049_),
    .Y(_0319_));
 sky130_fd_sc_hd__nor2_1 _0880_ (.A(net69),
    .B(_0319_),
    .Y(_0320_));
 sky130_fd_sc_hd__nand2_1 _0881_ (.A(net71),
    .B(_0217_),
    .Y(_0321_));
 sky130_fd_sc_hd__a221o_1 _0882_ (.A1(net71),
    .A2(_0143_),
    .B1(_0321_),
    .B2(\x_stage1[3] ),
    .C1(_0137_),
    .X(_0322_));
 sky130_fd_sc_hd__a22oi_1 _0883_ (.A1(_0197_),
    .A2(net53),
    .B1(_0096_),
    .B2(_0233_),
    .Y(_0323_));
 sky130_fd_sc_hd__o22ai_1 _0884_ (.A1(_0320_),
    .A2(_0322_),
    .B1(_0323_),
    .B2(_0042_),
    .Y(_0324_));
 sky130_fd_sc_hd__nand2_1 _0885_ (.A(net70),
    .B(net67),
    .Y(_0325_));
 sky130_fd_sc_hd__nor2b_1 _0886_ (.A(net59),
    .B_N(net70),
    .Y(_0326_));
 sky130_fd_sc_hd__nor3_1 _0887_ (.A(_0072_),
    .B(_0013_),
    .C(_0326_),
    .Y(_0327_));
 sky130_fd_sc_hd__a21oi_1 _0888_ (.A1(_0113_),
    .A2(_0325_),
    .B1(_0327_),
    .Y(_0328_));
 sky130_fd_sc_hd__nor2_1 _0889_ (.A(_0180_),
    .B(_0328_),
    .Y(_0329_));
 sky130_fd_sc_hd__xnor2_1 _0891_ (.A(net70),
    .B(net59),
    .Y(_0331_));
 sky130_fd_sc_hd__mux2i_1 _0892_ (.A0(_0326_),
    .A1(_0331_),
    .S(net69),
    .Y(_0332_));
 sky130_fd_sc_hd__nor4_1 _0893_ (.A(net58),
    .B(_0175_),
    .C(_0055_),
    .D(_0332_),
    .Y(_0333_));
 sky130_fd_sc_hd__nor4_1 _0894_ (.A(_0318_),
    .B(_0324_),
    .C(_0329_),
    .D(_0333_),
    .Y(_0334_));
 sky130_fd_sc_hd__o21ai_0 _0895_ (.A1(\x_stage1[0] ),
    .A2(net55),
    .B1(_0080_),
    .Y(_0335_));
 sky130_fd_sc_hd__o21ai_0 _0896_ (.A1(_0116_),
    .A2(_0156_),
    .B1(_0146_),
    .Y(_0336_));
 sky130_fd_sc_hd__a221oi_1 _0897_ (.A1(_0176_),
    .A2(_0335_),
    .B1(_0336_),
    .B2(net51),
    .C1(net69),
    .Y(_0337_));
 sky130_fd_sc_hd__nand3_1 _0898_ (.A(\x_stage1[3] ),
    .B(net67),
    .C(_0176_),
    .Y(_0338_));
 sky130_fd_sc_hd__o21ai_1 _0899_ (.A1(\x_stage1[3] ),
    .A2(_0174_),
    .B1(_0338_),
    .Y(_0339_));
 sky130_fd_sc_hd__a21oi_1 _0900_ (.A1(\x_stage1[3] ),
    .A2(net51),
    .B1(_0176_),
    .Y(_0340_));
 sky130_fd_sc_hd__o32ai_1 _0901_ (.A1(net70),
    .A2(net67),
    .A3(_0340_),
    .B1(_0080_),
    .B2(_0174_),
    .Y(_0341_));
 sky130_fd_sc_hd__a211oi_1 _0902_ (.A1(net70),
    .A2(_0339_),
    .B1(_0341_),
    .C1(_0101_),
    .Y(_0342_));
 sky130_fd_sc_hd__nor2b_1 _0903_ (.A(\x_stage1[6] ),
    .B_N(net58),
    .Y(_0343_));
 sky130_fd_sc_hd__nand3_1 _0904_ (.A(_0249_),
    .B(net64),
    .C(_0343_),
    .Y(_0344_));
 sky130_fd_sc_hd__nor2_1 _0905_ (.A(_0132_),
    .B(_0344_),
    .Y(_0345_));
 sky130_fd_sc_hd__o221ai_1 _0906_ (.A1(net71),
    .A2(_0080_),
    .B1(_0146_),
    .B2(_0344_),
    .C1(_0213_),
    .Y(_0346_));
 sky130_fd_sc_hd__o22a_1 _0907_ (.A1(net69),
    .A2(_0046_),
    .B1(_0188_),
    .B2(_0148_),
    .X(_0347_));
 sky130_fd_sc_hd__o41ai_1 _0908_ (.A1(_0101_),
    .A2(_0056_),
    .A3(_0345_),
    .A4(_0346_),
    .B1(_0347_),
    .Y(_0348_));
 sky130_fd_sc_hd__o21a_1 _0909_ (.A1(_0337_),
    .A2(_0342_),
    .B1(_0348_),
    .X(_0349_));
 sky130_fd_sc_hd__a21oi_1 _0910_ (.A1(\lut_stage2[2] ),
    .A2(_0125_),
    .B1(net47),
    .Y(_0350_));
 sky130_fd_sc_hd__a41oi_1 _0911_ (.A1(_0287_),
    .A2(_0312_),
    .A3(_0334_),
    .A4(_0349_),
    .B1(_0350_),
    .Y(\_0001_[2] ));
 sky130_fd_sc_hd__xor2_1 _0912_ (.A(net66),
    .B(net61),
    .X(_0351_));
 sky130_fd_sc_hd__nand3_1 _0913_ (.A(_0074_),
    .B(_0153_),
    .C(_0351_),
    .Y(_0352_));
 sky130_fd_sc_hd__nand2_1 _0914_ (.A(_0188_),
    .B(_0229_),
    .Y(_0353_));
 sky130_fd_sc_hd__a21oi_1 _0915_ (.A1(_0352_),
    .A2(_0353_),
    .B1(\x_stage1[2] ),
    .Y(_0354_));
 sky130_fd_sc_hd__nand2_1 _0916_ (.A(net53),
    .B(net55),
    .Y(_0355_));
 sky130_fd_sc_hd__a21oi_1 _0917_ (.A1(_0352_),
    .A2(_0355_),
    .B1(_0159_),
    .Y(_0356_));
 sky130_fd_sc_hd__a2111oi_0 _0918_ (.A1(_0169_),
    .A2(_0258_),
    .B1(_0037_),
    .C1(_0166_),
    .D1(_0180_),
    .Y(_0357_));
 sky130_fd_sc_hd__a31oi_1 _0919_ (.A1(_0156_),
    .A2(net49),
    .A3(_0154_),
    .B1(net48),
    .Y(_0358_));
 sky130_fd_sc_hd__or3b_1 _0920_ (.A(_0354_),
    .B(_0356_),
    .C_N(_0358_),
    .X(_0359_));
 sky130_fd_sc_hd__o32ai_1 _0921_ (.A1(_0116_),
    .A2(_0249_),
    .A3(_0258_),
    .B1(_0013_),
    .B2(_0169_),
    .Y(_0360_));
 sky130_fd_sc_hd__and3_1 _0922_ (.A(net58),
    .B(_0106_),
    .C(_0360_),
    .X(_0361_));
 sky130_fd_sc_hd__nor2_1 _0923_ (.A(net65),
    .B(net63),
    .Y(_0362_));
 sky130_fd_sc_hd__nor3_1 _0924_ (.A(net61),
    .B(_0099_),
    .C(_0362_),
    .Y(_0363_));
 sky130_fd_sc_hd__nand3_1 _0925_ (.A(\x_stage1[0] ),
    .B(\x_stage1[2] ),
    .C(_0363_),
    .Y(_0364_));
 sky130_fd_sc_hd__and3_1 _0926_ (.A(net61),
    .B(net63),
    .C(net60),
    .X(_0365_));
 sky130_fd_sc_hd__nor3_1 _0927_ (.A(net61),
    .B(net63),
    .C(net60),
    .Y(_0366_));
 sky130_fd_sc_hd__mux2i_1 _0928_ (.A0(_0365_),
    .A1(_0366_),
    .S(net65),
    .Y(_0367_));
 sky130_fd_sc_hd__nand3_1 _0929_ (.A(net69),
    .B(\x_stage1[2] ),
    .C(net58),
    .Y(_0368_));
 sky130_fd_sc_hd__o22ai_1 _0930_ (.A1(net69),
    .A2(_0364_),
    .B1(_0367_),
    .B2(_0368_),
    .Y(_0369_));
 sky130_fd_sc_hd__a22oi_1 _0931_ (.A1(net52),
    .A2(_0204_),
    .B1(_0365_),
    .B2(\x_stage1[0] ),
    .Y(_0370_));
 sky130_fd_sc_hd__a21oi_1 _0932_ (.A1(net69),
    .A2(_0132_),
    .B1(_0096_),
    .Y(_0371_));
 sky130_fd_sc_hd__o32ai_1 _0933_ (.A1(net69),
    .A2(_0166_),
    .A3(_0370_),
    .B1(_0371_),
    .B2(_0344_),
    .Y(_0372_));
 sky130_fd_sc_hd__o21ai_0 _0934_ (.A1(_0198_),
    .A2(_0372_),
    .B1(net66),
    .Y(_0373_));
 sky130_fd_sc_hd__nor4b_1 _0935_ (.A(_0359_),
    .B(_0361_),
    .C(_0369_),
    .D_N(_0373_),
    .Y(_0374_));
 sky130_fd_sc_hd__a22oi_1 _0936_ (.A1(_0121_),
    .A2(net49),
    .B1(_0257_),
    .B2(_0276_),
    .Y(_0375_));
 sky130_fd_sc_hd__nor4_1 _0937_ (.A(net70),
    .B(\x_stage1[3] ),
    .C(\x_stage1[5] ),
    .D(_0027_),
    .Y(_0376_));
 sky130_fd_sc_hd__a221oi_1 _0938_ (.A1(_0039_),
    .A2(net55),
    .B1(_0277_),
    .B2(net57),
    .C1(_0376_),
    .Y(_0377_));
 sky130_fd_sc_hd__nor2_1 _0939_ (.A(net59),
    .B(_0049_),
    .Y(_0378_));
 sky130_fd_sc_hd__nor3_1 _0940_ (.A(_0072_),
    .B(_0013_),
    .C(_0378_),
    .Y(_0379_));
 sky130_fd_sc_hd__a31oi_1 _0941_ (.A1(net70),
    .A2(_0143_),
    .A3(_0140_),
    .B1(_0379_),
    .Y(_0380_));
 sky130_fd_sc_hd__nand2_1 _0942_ (.A(net61),
    .B(_0343_),
    .Y(_0381_));
 sky130_fd_sc_hd__nor2_1 _0943_ (.A(net70),
    .B(_0381_),
    .Y(_0382_));
 sky130_fd_sc_hd__nand2_1 _0944_ (.A(\x_stage1[2] ),
    .B(net64),
    .Y(_0383_));
 sky130_fd_sc_hd__o21ai_0 _0945_ (.A1(net64),
    .A2(_0107_),
    .B1(_0383_),
    .Y(_0384_));
 sky130_fd_sc_hd__a221oi_1 _0946_ (.A1(_0140_),
    .A2(_0121_),
    .B1(_0382_),
    .B2(_0384_),
    .C1(net69),
    .Y(_0385_));
 sky130_fd_sc_hd__a41o_1 _0947_ (.A1(net69),
    .A2(_0375_),
    .A3(_0377_),
    .A4(_0380_),
    .B1(_0385_),
    .X(_0386_));
 sky130_fd_sc_hd__o21ai_0 _0948_ (.A1(_0116_),
    .A2(_0084_),
    .B1(_0080_),
    .Y(_0387_));
 sky130_fd_sc_hd__a22oi_1 _0949_ (.A1(net71),
    .A2(_0156_),
    .B1(_0387_),
    .B2(net69),
    .Y(_0388_));
 sky130_fd_sc_hd__o21bai_1 _0950_ (.A1(_0087_),
    .A2(_0388_),
    .B1_N(_0307_),
    .Y(_0389_));
 sky130_fd_sc_hd__a31oi_1 _0951_ (.A1(net58),
    .A2(net55),
    .A3(_0365_),
    .B1(_0363_),
    .Y(_0390_));
 sky130_fd_sc_hd__o22ai_1 _0952_ (.A1(_0154_),
    .A2(_0190_),
    .B1(_0087_),
    .B2(net69),
    .Y(_0391_));
 sky130_fd_sc_hd__and3_1 _0953_ (.A(net70),
    .B(_0121_),
    .C(_0113_),
    .X(_0392_));
 sky130_fd_sc_hd__a21oi_1 _0954_ (.A1(_0121_),
    .A2(_0391_),
    .B1(_0392_),
    .Y(_0393_));
 sky130_fd_sc_hd__or3_1 _0955_ (.A(_0166_),
    .B(_0202_),
    .C(_0370_),
    .X(_0394_));
 sky130_fd_sc_hd__o21ai_0 _0956_ (.A1(net50),
    .A2(_0083_),
    .B1(_0082_),
    .Y(_0395_));
 sky130_fd_sc_hd__nand2_1 _0957_ (.A(net69),
    .B(\x_stage1[6] ),
    .Y(_0396_));
 sky130_fd_sc_hd__o21ai_0 _0958_ (.A1(net62),
    .A2(_0396_),
    .B1(_0048_),
    .Y(_0397_));
 sky130_fd_sc_hd__nand4_1 _0959_ (.A(_0166_),
    .B(_0293_),
    .C(_0395_),
    .D(_0397_),
    .Y(_0398_));
 sky130_fd_sc_hd__o2111ai_1 _0960_ (.A1(_0109_),
    .A2(_0390_),
    .B1(_0393_),
    .C1(_0394_),
    .D1(_0398_),
    .Y(_0399_));
 sky130_fd_sc_hd__nand2_1 _0961_ (.A(_0101_),
    .B(_0207_),
    .Y(_0400_));
 sky130_fd_sc_hd__nand2_1 _0962_ (.A(\lut_stage2[3] ),
    .B(net54),
    .Y(_0401_));
 sky130_fd_sc_hd__nor4b_1 _0963_ (.A(net61),
    .B(net63),
    .C(net60),
    .D_N(\x_stage1[2] ),
    .Y(_0402_));
 sky130_fd_sc_hd__o211ai_1 _0964_ (.A1(_0365_),
    .A2(_0402_),
    .B1(net58),
    .C1(_0229_),
    .Y(_0403_));
 sky130_fd_sc_hd__o311a_1 _0965_ (.A1(_0084_),
    .A2(_0205_),
    .A3(_0400_),
    .B1(_0401_),
    .C1(_0403_),
    .X(_0404_));
 sky130_fd_sc_hd__o22ai_1 _0966_ (.A1(net69),
    .A2(_0062_),
    .B1(_0029_),
    .B2(_0197_),
    .Y(_0405_));
 sky130_fd_sc_hd__nand3_1 _0967_ (.A(net56),
    .B(net55),
    .C(_0405_),
    .Y(_0406_));
 sky130_fd_sc_hd__nor2_1 _0968_ (.A(net69),
    .B(_0110_),
    .Y(_0407_));
 sky130_fd_sc_hd__o21ai_0 _0969_ (.A1(_0143_),
    .A2(_0086_),
    .B1(_0407_),
    .Y(_0408_));
 sky130_fd_sc_hd__nand4_1 _0970_ (.A(_0237_),
    .B(_0404_),
    .C(_0406_),
    .D(_0408_),
    .Y(_0409_));
 sky130_fd_sc_hd__nand2_1 _0971_ (.A(net63),
    .B(net58),
    .Y(_0410_));
 sky130_fd_sc_hd__nor3_1 _0972_ (.A(\x_stage1[6] ),
    .B(_0013_),
    .C(_0410_),
    .Y(_0411_));
 sky130_fd_sc_hd__nand2_1 _0973_ (.A(net69),
    .B(_0079_),
    .Y(_0412_));
 sky130_fd_sc_hd__a21oi_1 _0974_ (.A1(_0208_),
    .A2(_0412_),
    .B1(_0151_),
    .Y(_0413_));
 sky130_fd_sc_hd__o21ai_0 _0975_ (.A1(_0411_),
    .A2(_0413_),
    .B1(_0222_),
    .Y(_0414_));
 sky130_fd_sc_hd__nor4b_1 _0976_ (.A(_0389_),
    .B(_0399_),
    .C(_0409_),
    .D_N(_0414_),
    .Y(_0415_));
 sky130_fd_sc_hd__inv_1 _0977_ (.A(net47),
    .Y(_0416_));
 sky130_fd_sc_hd__a32oi_1 _0978_ (.A1(_0374_),
    .A2(_0386_),
    .A3(_0415_),
    .B1(_0401_),
    .B2(_0416_),
    .Y(\_0001_[3] ));
 sky130_fd_sc_hd__nor3_1 _0979_ (.A(_0116_),
    .B(\x_stage1[6] ),
    .C(_0410_),
    .Y(_0417_));
 sky130_fd_sc_hd__o21ai_0 _0980_ (.A1(_0276_),
    .A2(_0417_),
    .B1(net61),
    .Y(_0418_));
 sky130_fd_sc_hd__a21oi_1 _0981_ (.A1(net69),
    .A2(net70),
    .B1(\x_stage1[2] ),
    .Y(_0419_));
 sky130_fd_sc_hd__o21ai_1 _0982_ (.A1(_0174_),
    .A2(_0419_),
    .B1(net66),
    .Y(_0420_));
 sky130_fd_sc_hd__o21ai_0 _0983_ (.A1(\x_stage1[2] ),
    .A2(net51),
    .B1(_0420_),
    .Y(_0421_));
 sky130_fd_sc_hd__a21oi_1 _0984_ (.A1(_0156_),
    .A2(_0418_),
    .B1(_0421_),
    .Y(_0422_));
 sky130_fd_sc_hd__a21oi_1 _0985_ (.A1(_0129_),
    .A2(_0219_),
    .B1(net66),
    .Y(_0423_));
 sky130_fd_sc_hd__nor2_1 _0986_ (.A(net69),
    .B(_0423_),
    .Y(_0424_));
 sky130_fd_sc_hd__nor2_1 _0987_ (.A(_0062_),
    .B(_0139_),
    .Y(_0425_));
 sky130_fd_sc_hd__a21oi_1 _0988_ (.A1(\x_stage1[2] ),
    .A2(_0425_),
    .B1(net57),
    .Y(_0426_));
 sky130_fd_sc_hd__a211oi_1 _0989_ (.A1(_0219_),
    .A2(_0087_),
    .B1(_0424_),
    .C1(_0426_),
    .Y(_0427_));
 sky130_fd_sc_hd__nor2_1 _0990_ (.A(_0422_),
    .B(_0427_),
    .Y(_0428_));
 sky130_fd_sc_hd__o211ai_1 _0991_ (.A1(_0138_),
    .A2(_0212_),
    .B1(net56),
    .C1(_0250_),
    .Y(_0429_));
 sky130_fd_sc_hd__nor3_1 _0992_ (.A(net66),
    .B(_0147_),
    .C(_0105_),
    .Y(_0430_));
 sky130_fd_sc_hd__a21oi_1 _0993_ (.A1(net66),
    .A2(_0429_),
    .B1(_0430_),
    .Y(_0431_));
 sky130_fd_sc_hd__a21oi_1 _0994_ (.A1(net57),
    .A2(net63),
    .B1(\x_stage1[2] ),
    .Y(_0432_));
 sky130_fd_sc_hd__o21ai_0 _0995_ (.A1(net69),
    .A2(net63),
    .B1(net70),
    .Y(_0433_));
 sky130_fd_sc_hd__a32oi_1 _0996_ (.A1(_0282_),
    .A2(net52),
    .A3(_0433_),
    .B1(net54),
    .B2(\lut_stage2[4] ),
    .Y(_0434_));
 sky130_fd_sc_hd__o41ai_1 _0997_ (.A1(net61),
    .A2(_0099_),
    .A3(_0154_),
    .A4(_0432_),
    .B1(_0434_),
    .Y(_0435_));
 sky130_fd_sc_hd__a21oi_1 _0998_ (.A1(net51),
    .A2(_0222_),
    .B1(_0277_),
    .Y(_0436_));
 sky130_fd_sc_hd__nor2_1 _0999_ (.A(net69),
    .B(_0436_),
    .Y(_0437_));
 sky130_fd_sc_hd__nor3_1 _1000_ (.A(_0431_),
    .B(_0435_),
    .C(_0437_),
    .Y(_0438_));
 sky130_fd_sc_hd__nand2_1 _1001_ (.A(\x_stage1[2] ),
    .B(net61),
    .Y(_0439_));
 sky130_fd_sc_hd__xor2_1 _1002_ (.A(net61),
    .B(net63),
    .X(_0440_));
 sky130_fd_sc_hd__nor2b_1 _1003_ (.A(net65),
    .B_N(net60),
    .Y(_0441_));
 sky130_fd_sc_hd__a32oi_1 _1004_ (.A1(net61),
    .A2(_0121_),
    .A3(_0204_),
    .B1(_0440_),
    .B2(_0441_),
    .Y(_0442_));
 sky130_fd_sc_hd__o32ai_1 _1005_ (.A1(net60),
    .A2(_0410_),
    .A3(_0439_),
    .B1(_0442_),
    .B2(net58),
    .Y(_0443_));
 sky130_fd_sc_hd__a21oi_1 _1006_ (.A1(net69),
    .A2(_0443_),
    .B1(_0359_),
    .Y(_0444_));
 sky130_fd_sc_hd__and3_1 _1007_ (.A(net69),
    .B(\x_stage1[0] ),
    .C(\x_stage1[2] ),
    .X(_0445_));
 sky130_fd_sc_hd__nand2_1 _1008_ (.A(_0344_),
    .B(_0190_),
    .Y(_0446_));
 sky130_fd_sc_hd__a221oi_1 _1009_ (.A1(_0233_),
    .A2(_0419_),
    .B1(_0445_),
    .B2(_0446_),
    .C1(net66),
    .Y(_0447_));
 sky130_fd_sc_hd__nand2_1 _1010_ (.A(net62),
    .B(_0079_),
    .Y(_0448_));
 sky130_fd_sc_hd__nand2_1 _1011_ (.A(_0305_),
    .B(_0440_),
    .Y(_0449_));
 sky130_fd_sc_hd__o21ai_0 _1012_ (.A1(_0448_),
    .A2(_0217_),
    .B1(_0449_),
    .Y(_0450_));
 sky130_fd_sc_hd__a221oi_1 _1013_ (.A1(_0039_),
    .A2(_0445_),
    .B1(_0450_),
    .B2(\x_stage1[6] ),
    .C1(net57),
    .Y(_0451_));
 sky130_fd_sc_hd__o21ai_0 _1014_ (.A1(net71),
    .A2(\x_stage1[3] ),
    .B1(net68),
    .Y(_0452_));
 sky130_fd_sc_hd__a21oi_1 _1015_ (.A1(_0187_),
    .A2(_0452_),
    .B1(net69),
    .Y(_0453_));
 sky130_fd_sc_hd__a21oi_1 _1016_ (.A1(net69),
    .A2(_0387_),
    .B1(_0453_),
    .Y(_0454_));
 sky130_fd_sc_hd__mux2i_1 _1017_ (.A0(_0123_),
    .A1(_0055_),
    .S(net67),
    .Y(_0455_));
 sky130_fd_sc_hd__a32oi_1 _1018_ (.A1(_0143_),
    .A2(_0159_),
    .A3(net56),
    .B1(_0455_),
    .B2(net66),
    .Y(_0456_));
 sky130_fd_sc_hd__o32ai_1 _1019_ (.A1(_0249_),
    .A2(_0205_),
    .A3(_0454_),
    .B1(_0456_),
    .B2(net60),
    .Y(_0457_));
 sky130_fd_sc_hd__a2bb2oi_1 _1020_ (.A1_N(_0447_),
    .A2_N(_0451_),
    .B1(net58),
    .B2(_0457_),
    .Y(_0458_));
 sky130_fd_sc_hd__a21oi_1 _1021_ (.A1(\lut_stage2[4] ),
    .A2(net54),
    .B1(net47),
    .Y(_0459_));
 sky130_fd_sc_hd__a41oi_1 _1022_ (.A1(_0428_),
    .A2(_0438_),
    .A3(_0444_),
    .A4(_0458_),
    .B1(_0459_),
    .Y(\_0001_[4] ));
 sky130_fd_sc_hd__o32ai_1 _1023_ (.A1(net69),
    .A2(\x_stage1[6] ),
    .A3(_0410_),
    .B1(_0062_),
    .B2(net63),
    .Y(_0460_));
 sky130_fd_sc_hd__a21o_1 _1024_ (.A1(\x_stage1[0] ),
    .A2(_0131_),
    .B1(\x_stage1[2] ),
    .X(_0461_));
 sky130_fd_sc_hd__nand3_1 _1025_ (.A(_0249_),
    .B(_0460_),
    .C(_0461_),
    .Y(_0462_));
 sky130_fd_sc_hd__nor3_1 _1026_ (.A(net63),
    .B(_0062_),
    .C(_0257_),
    .Y(_0463_));
 sky130_fd_sc_hd__o21ai_0 _1027_ (.A1(_0411_),
    .A2(_0463_),
    .B1(net69),
    .Y(_0464_));
 sky130_fd_sc_hd__a311oi_1 _1028_ (.A1(net70),
    .A2(\x_stage1[2] ),
    .A3(_0074_),
    .B1(_0139_),
    .C1(net58),
    .Y(_0465_));
 sky130_fd_sc_hd__xor2_1 _1029_ (.A(\x_stage1[2] ),
    .B(\x_stage1[6] ),
    .X(_0466_));
 sky130_fd_sc_hd__nand2_1 _1030_ (.A(net69),
    .B(_0466_),
    .Y(_0467_));
 sky130_fd_sc_hd__a21oi_1 _1031_ (.A1(_0465_),
    .A2(_0467_),
    .B1(net65),
    .Y(_0468_));
 sky130_fd_sc_hd__a31oi_1 _1032_ (.A1(net65),
    .A2(_0462_),
    .A3(_0464_),
    .B1(_0468_),
    .Y(_0469_));
 sky130_fd_sc_hd__a21oi_1 _1033_ (.A1(_0100_),
    .A2(net52),
    .B1(_0233_),
    .Y(_0470_));
 sky130_fd_sc_hd__o22ai_1 _1034_ (.A1(net64),
    .A2(_0029_),
    .B1(_0032_),
    .B2(_0101_),
    .Y(_0471_));
 sky130_fd_sc_hd__nand3_1 _1035_ (.A(net62),
    .B(_0143_),
    .C(_0471_),
    .Y(_0472_));
 sky130_fd_sc_hd__o21ai_0 _1036_ (.A1(\x_stage1[3] ),
    .A2(_0129_),
    .B1(_0101_),
    .Y(_0473_));
 sky130_fd_sc_hd__a32o_1 _1037_ (.A1(\x_stage1[2] ),
    .A2(_0159_),
    .A3(net51),
    .B1(_0060_),
    .B2(_0250_),
    .X(_0474_));
 sky130_fd_sc_hd__a31oi_1 _1038_ (.A1(_0176_),
    .A2(_0084_),
    .A3(_0473_),
    .B1(_0474_),
    .Y(_0475_));
 sky130_fd_sc_hd__o311ai_1 _1039_ (.A1(net66),
    .A2(_0419_),
    .A3(_0470_),
    .B1(_0472_),
    .C1(_0475_),
    .Y(_0476_));
 sky130_fd_sc_hd__o32ai_1 _1040_ (.A1(\x_stage1[6] ),
    .A2(_0197_),
    .A3(_0123_),
    .B1(_0258_),
    .B2(_0249_),
    .Y(_0477_));
 sky130_fd_sc_hd__nand3_1 _1041_ (.A(\x_stage1[2] ),
    .B(_0166_),
    .C(_0477_),
    .Y(_0478_));
 sky130_fd_sc_hd__a21oi_1 _1042_ (.A1(net62),
    .A2(\x_stage1[4] ),
    .B1(net69),
    .Y(_0479_));
 sky130_fd_sc_hd__nor2_1 _1043_ (.A(\x_stage1[2] ),
    .B(_0099_),
    .Y(_0480_));
 sky130_fd_sc_hd__o21ai_0 _1044_ (.A1(_0296_),
    .A2(_0479_),
    .B1(_0480_),
    .Y(_0481_));
 sky130_fd_sc_hd__nor2_1 _1045_ (.A(_0099_),
    .B(_0013_),
    .Y(_0482_));
 sky130_fd_sc_hd__a211oi_1 _1046_ (.A1(net49),
    .A2(_0154_),
    .B1(_0482_),
    .C1(net66),
    .Y(_0483_));
 sky130_fd_sc_hd__a41oi_1 _1047_ (.A1(net66),
    .A2(_0174_),
    .A3(_0478_),
    .A4(_0481_),
    .B1(_0483_),
    .Y(_0484_));
 sky130_fd_sc_hd__o21ai_0 _1048_ (.A1(net69),
    .A2(\x_stage1[2] ),
    .B1(net65),
    .Y(_0485_));
 sky130_fd_sc_hd__a32oi_1 _1049_ (.A1(_0143_),
    .A2(_0197_),
    .A3(_0343_),
    .B1(_0485_),
    .B2(_0315_),
    .Y(_0486_));
 sky130_fd_sc_hd__nand3_1 _1050_ (.A(net61),
    .B(_0343_),
    .C(_0485_),
    .Y(_0487_));
 sky130_fd_sc_hd__o21ai_0 _1051_ (.A1(net61),
    .A2(_0486_),
    .B1(_0487_),
    .Y(_0488_));
 sky130_fd_sc_hd__nand2_1 _1052_ (.A(\x_stage1[4] ),
    .B(_0488_),
    .Y(_0489_));
 sky130_fd_sc_hd__nor4b_1 _1053_ (.A(_0469_),
    .B(_0476_),
    .C(_0484_),
    .D_N(_0489_),
    .Y(_0490_));
 sky130_fd_sc_hd__nand2_1 _1054_ (.A(\lut_stage2[5] ),
    .B(net54),
    .Y(_0491_));
 sky130_fd_sc_hd__o21ai_1 _1055_ (.A1(_0416_),
    .A2(_0490_),
    .B1(_0491_),
    .Y(\_0001_[5] ));
 sky130_fd_sc_hd__a32oi_1 _1056_ (.A1(\x_stage1[0] ),
    .A2(_0249_),
    .A3(_0079_),
    .B1(_0257_),
    .B2(_0153_),
    .Y(_0492_));
 sky130_fd_sc_hd__nor2_1 _1057_ (.A(_0074_),
    .B(_0072_),
    .Y(_0493_));
 sky130_fd_sc_hd__o22ai_1 _1058_ (.A1(net64),
    .A2(_0166_),
    .B1(_0032_),
    .B2(\x_stage1[2] ),
    .Y(_0494_));
 sky130_fd_sc_hd__a221oi_1 _1059_ (.A1(_0138_),
    .A2(_0493_),
    .B1(_0494_),
    .B2(net69),
    .C1(_0030_),
    .Y(_0495_));
 sky130_fd_sc_hd__nor2_1 _1060_ (.A(net69),
    .B(\x_stage1[2] ),
    .Y(_0496_));
 sky130_fd_sc_hd__a22oi_1 _1061_ (.A1(\x_stage1[2] ),
    .A2(_0100_),
    .B1(_0425_),
    .B2(_0496_),
    .Y(_0497_));
 sky130_fd_sc_hd__o221a_1 _1062_ (.A1(_0396_),
    .A2(_0492_),
    .B1(_0495_),
    .B2(_0249_),
    .C1(_0497_),
    .X(_0498_));
 sky130_fd_sc_hd__a21oi_1 _1063_ (.A1(\x_stage1[2] ),
    .A2(_0159_),
    .B1(net66),
    .Y(_0499_));
 sky130_fd_sc_hd__nor3_1 _1064_ (.A(_0093_),
    .B(_0139_),
    .C(_0499_),
    .Y(_0500_));
 sky130_fd_sc_hd__o22ai_1 _1065_ (.A1(_0039_),
    .A2(_0280_),
    .B1(_0500_),
    .B2(_0277_),
    .Y(_0501_));
 sky130_fd_sc_hd__nand2_1 _1066_ (.A(net63),
    .B(_0441_),
    .Y(_0502_));
 sky130_fd_sc_hd__o21bai_1 _1067_ (.A1(net52),
    .A2(_0502_),
    .B1_N(_0366_),
    .Y(_0503_));
 sky130_fd_sc_hd__a221oi_1 _1068_ (.A1(net49),
    .A2(_0445_),
    .B1(_0503_),
    .B2(net58),
    .C1(_0131_),
    .Y(_0504_));
 sky130_fd_sc_hd__o2111ai_1 _1069_ (.A1(net57),
    .A2(_0498_),
    .B1(_0501_),
    .C1(_0504_),
    .D1(_0489_),
    .Y(_0505_));
 sky130_fd_sc_hd__a22o_1 _1070_ (.A1(\lut_stage2[6] ),
    .A2(net54),
    .B1(net47),
    .B2(_0505_),
    .X(\_0001_[6] ));
 sky130_fd_sc_hd__o21ai_0 _1071_ (.A1(_0139_),
    .A2(_0485_),
    .B1(net58),
    .Y(_0506_));
 sky130_fd_sc_hd__nand2_1 _1072_ (.A(_0074_),
    .B(_0506_),
    .Y(_0507_));
 sky130_fd_sc_hd__nor2_1 _1073_ (.A(net58),
    .B(_0496_),
    .Y(_0508_));
 sky130_fd_sc_hd__o211ai_1 _1074_ (.A1(net61),
    .A2(_0508_),
    .B1(net63),
    .C1(net65),
    .Y(_0509_));
 sky130_fd_sc_hd__o211ai_1 _1075_ (.A1(_0249_),
    .A2(net58),
    .B1(\x_stage1[6] ),
    .C1(_0509_),
    .Y(_0510_));
 sky130_fd_sc_hd__a32o_1 _1076_ (.A1(net47),
    .A2(_0507_),
    .A3(_0510_),
    .B1(net54),
    .B2(\lut_stage2[8] ),
    .X(\_0001_[8] ));
 sky130_fd_sc_hd__o211ai_1 _1079_ (.A1(_0137_),
    .A2(_0485_),
    .B1(_0099_),
    .C1(stage1_valid),
    .Y(_0513_));
 sky130_fd_sc_hd__o21ai_0 _1080_ (.A1(stage1_valid),
    .A2(\lut_stage2[9] ),
    .B1(_0513_),
    .Y(_0514_));
 sky130_fd_sc_hd__nor2_1 _1081_ (.A(net73),
    .B(_0514_),
    .Y(\_0001_[9] ));
 sky130_fd_sc_hd__and2_1 _1082_ (.A(\lut_stage2[10] ),
    .B(net54),
    .X(\_0001_[10] ));
 sky130_fd_sc_hd__and2_1 _1083_ (.A(\lut_stage2[11] ),
    .B(net54),
    .X(\_0001_[11] ));
 sky130_fd_sc_hd__and2_1 _1084_ (.A(\lut_stage2[12] ),
    .B(net54),
    .X(\_0001_[12] ));
 sky130_fd_sc_hd__and2_1 _1085_ (.A(\lut_stage2[13] ),
    .B(net54),
    .X(\_0001_[13] ));
 sky130_fd_sc_hd__and2_1 _1086_ (.A(\lut_stage2[14] ),
    .B(net54),
    .X(\_0001_[14] ));
 sky130_fd_sc_hd__and2_1 _1087_ (.A(\lut_stage2[15] ),
    .B(net54),
    .X(\_0001_[15] ));
 sky130_fd_sc_hd__mux2i_1 _1089_ (.A0(net70),
    .A1(net3),
    .S(net1),
    .Y(_0516_));
 sky130_fd_sc_hd__nor2_1 _1090_ (.A(net73),
    .B(_0516_),
    .Y(\_0004_[0] ));
 sky130_fd_sc_hd__mux2i_1 _1091_ (.A0(net69),
    .A1(net4),
    .S(net1),
    .Y(_0517_));
 sky130_fd_sc_hd__nor2_1 _1092_ (.A(net73),
    .B(_0517_),
    .Y(\_0004_[1] ));
 sky130_fd_sc_hd__mux2i_1 _1093_ (.A0(\x_stage1[2] ),
    .A1(net5),
    .S(net1),
    .Y(_0518_));
 sky130_fd_sc_hd__nor2_1 _1094_ (.A(net73),
    .B(_0518_),
    .Y(\_0004_[2] ));
 sky130_fd_sc_hd__mux2i_1 _1095_ (.A0(net65),
    .A1(net6),
    .S(net1),
    .Y(_0519_));
 sky130_fd_sc_hd__nor2_1 _1096_ (.A(net73),
    .B(_0519_),
    .Y(\_0004_[3] ));
 sky130_fd_sc_hd__mux2i_1 _1097_ (.A0(net63),
    .A1(net7),
    .S(net1),
    .Y(_0520_));
 sky130_fd_sc_hd__nor2_1 _1098_ (.A(net73),
    .B(_0520_),
    .Y(\_0004_[4] ));
 sky130_fd_sc_hd__mux2i_1 _1099_ (.A0(net61),
    .A1(net8),
    .S(net1),
    .Y(_0521_));
 sky130_fd_sc_hd__nor2_1 _1100_ (.A(net73),
    .B(_0521_),
    .Y(\_0004_[5] ));
 sky130_fd_sc_hd__mux2i_1 _1101_ (.A0(\x_stage1[6] ),
    .A1(net9),
    .S(net1),
    .Y(_0522_));
 sky130_fd_sc_hd__nor2_1 _1102_ (.A(net73),
    .B(_0522_),
    .Y(\_0004_[6] ));
 sky130_fd_sc_hd__mux2i_1 _1103_ (.A0(net58),
    .A1(net10),
    .S(net1),
    .Y(_0523_));
 sky130_fd_sc_hd__nor2_1 _1104_ (.A(net73),
    .B(_0523_),
    .Y(\_0004_[7] ));
 sky130_fd_sc_hd__mux2i_1 _1108_ (.A0(net11),
    .A1(\lut_stage2[0] ),
    .S(net72),
    .Y(_0527_));
 sky130_fd_sc_hd__nor2_1 _1109_ (.A(net73),
    .B(_0527_),
    .Y(\_0000_[0] ));
 sky130_fd_sc_hd__mux2i_1 _1110_ (.A0(net18),
    .A1(\lut_stage2[1] ),
    .S(net72),
    .Y(_0528_));
 sky130_fd_sc_hd__nor2_1 _1111_ (.A(net73),
    .B(_0528_),
    .Y(\_0000_[1] ));
 sky130_fd_sc_hd__mux2i_1 _1112_ (.A0(net19),
    .A1(\lut_stage2[2] ),
    .S(net72),
    .Y(_0529_));
 sky130_fd_sc_hd__nor2_1 _1113_ (.A(net73),
    .B(_0529_),
    .Y(\_0000_[2] ));
 sky130_fd_sc_hd__mux2i_1 _1114_ (.A0(net20),
    .A1(\lut_stage2[3] ),
    .S(net72),
    .Y(_0530_));
 sky130_fd_sc_hd__nor2_1 _1115_ (.A(net73),
    .B(_0530_),
    .Y(\_0000_[3] ));
 sky130_fd_sc_hd__mux2i_1 _1116_ (.A0(net21),
    .A1(\lut_stage2[4] ),
    .S(net72),
    .Y(_0531_));
 sky130_fd_sc_hd__nor2_1 _1117_ (.A(net73),
    .B(_0531_),
    .Y(\_0000_[4] ));
 sky130_fd_sc_hd__mux2i_1 _1118_ (.A0(net22),
    .A1(\lut_stage2[5] ),
    .S(net72),
    .Y(_0532_));
 sky130_fd_sc_hd__nor2_1 _1119_ (.A(net73),
    .B(_0532_),
    .Y(\_0000_[5] ));
 sky130_fd_sc_hd__mux2i_1 _1120_ (.A0(net23),
    .A1(\lut_stage2[6] ),
    .S(net72),
    .Y(_0533_));
 sky130_fd_sc_hd__nor2_1 _1121_ (.A(net73),
    .B(_0533_),
    .Y(\_0000_[6] ));
 sky130_fd_sc_hd__mux2i_1 _1122_ (.A0(net24),
    .A1(\lut_stage2[7] ),
    .S(net72),
    .Y(_0534_));
 sky130_fd_sc_hd__nor2_1 _1123_ (.A(net73),
    .B(_0534_),
    .Y(\_0000_[7] ));
 sky130_fd_sc_hd__mux2i_1 _1124_ (.A0(net25),
    .A1(\lut_stage2[8] ),
    .S(net72),
    .Y(_0535_));
 sky130_fd_sc_hd__nor2_1 _1125_ (.A(net73),
    .B(_0535_),
    .Y(\_0000_[8] ));
 sky130_fd_sc_hd__mux2i_1 _1126_ (.A0(net26),
    .A1(\lut_stage2[9] ),
    .S(net72),
    .Y(_0536_));
 sky130_fd_sc_hd__nor2_1 _1127_ (.A(net73),
    .B(_0536_),
    .Y(\_0000_[9] ));
 sky130_fd_sc_hd__mux2i_1 _1128_ (.A0(net12),
    .A1(\lut_stage2[10] ),
    .S(net72),
    .Y(_0537_));
 sky130_fd_sc_hd__nor2_1 _1129_ (.A(net73),
    .B(_0537_),
    .Y(\_0000_[10] ));
 sky130_fd_sc_hd__mux2i_1 _1130_ (.A0(net13),
    .A1(\lut_stage2[11] ),
    .S(net72),
    .Y(_0538_));
 sky130_fd_sc_hd__nor2_1 _1131_ (.A(net73),
    .B(_0538_),
    .Y(\_0000_[11] ));
 sky130_fd_sc_hd__mux2i_1 _1132_ (.A0(net14),
    .A1(\lut_stage2[12] ),
    .S(net72),
    .Y(_0539_));
 sky130_fd_sc_hd__nor2_1 _1133_ (.A(net73),
    .B(_0539_),
    .Y(\_0000_[12] ));
 sky130_fd_sc_hd__mux2i_1 _1134_ (.A0(net15),
    .A1(\lut_stage2[13] ),
    .S(net72),
    .Y(_0540_));
 sky130_fd_sc_hd__nor2_1 _1135_ (.A(net73),
    .B(_0540_),
    .Y(\_0000_[13] ));
 sky130_fd_sc_hd__mux2i_1 _1136_ (.A0(net16),
    .A1(\lut_stage2[14] ),
    .S(net72),
    .Y(_0541_));
 sky130_fd_sc_hd__nor2_1 _1137_ (.A(net73),
    .B(_0541_),
    .Y(\_0000_[14] ));
 sky130_fd_sc_hd__mux2i_1 _1138_ (.A0(net17),
    .A1(\lut_stage2[15] ),
    .S(net72),
    .Y(_0542_));
 sky130_fd_sc_hd__nor2_1 _1139_ (.A(net73),
    .B(_0542_),
    .Y(\_0000_[15] ));
 sky130_fd_sc_hd__nor2_1 _1140_ (.A(_0199_),
    .B(net73),
    .Y(_0003_));
 sky130_fd_sc_hd__nor2b_1 _1141_ (.A(net73),
    .B_N(net1),
    .Y(_0002_));
 sky130_fd_sc_hd__or4_1 _1142_ (.A(net57),
    .B(_0099_),
    .C(_0123_),
    .D(_0419_),
    .X(_0543_));
 sky130_fd_sc_hd__o21ai_0 _1143_ (.A1(net65),
    .A2(_0074_),
    .B1(net63),
    .Y(_0544_));
 sky130_fd_sc_hd__nor3_1 _1144_ (.A(net61),
    .B(net63),
    .C(net58),
    .Y(_0545_));
 sky130_fd_sc_hd__a31oi_1 _1145_ (.A1(net61),
    .A2(net58),
    .A3(_0544_),
    .B1(_0545_),
    .Y(_0546_));
 sky130_fd_sc_hd__o21ai_0 _1146_ (.A1(net61),
    .A2(_0062_),
    .B1(_0381_),
    .Y(_0547_));
 sky130_fd_sc_hd__o21ai_0 _1147_ (.A1(_0107_),
    .A2(_0159_),
    .B1(_0188_),
    .Y(_0548_));
 sky130_fd_sc_hd__nand3_1 _1148_ (.A(stage1_valid),
    .B(_0093_),
    .C(_0548_),
    .Y(_0549_));
 sky130_fd_sc_hd__a31oi_1 _1149_ (.A1(\x_stage1[4] ),
    .A2(_0485_),
    .A3(_0547_),
    .B1(_0549_),
    .Y(_0550_));
 sky130_fd_sc_hd__nor2_1 _1150_ (.A(stage1_valid),
    .B(\lut_stage2[7] ),
    .Y(_0551_));
 sky130_fd_sc_hd__a311oi_1 _1151_ (.A1(_0543_),
    .A2(_0546_),
    .A3(_0550_),
    .B1(_0551_),
    .C1(net73),
    .Y(\_0001_[7] ));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_0__f_clk (.A(clknet_0_clk),
    .X(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_1__f_clk (.A(clknet_0_clk),
    .X(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_2__f_clk (.A(clknet_0_clk),
    .X(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_3__f_clk (.A(clknet_0_clk),
    .X(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__bufinv_16 clkload0 (.A(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__bufinv_16 clkload1 (.A(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__clkinv_4 clkload2 (.A(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[0]$_DFF_P_  (.D(\_0000_[0] ),
    .Q(net11),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[10]$_DFF_P_  (.D(\_0000_[10] ),
    .Q(net12),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[11]$_DFF_P_  (.D(\_0000_[11] ),
    .Q(net13),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[12]$_DFF_P_  (.D(\_0000_[12] ),
    .Q(net14),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[13]$_DFF_P_  (.D(\_0000_[13] ),
    .Q(net15),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[14]$_DFF_P_  (.D(\_0000_[14] ),
    .Q(net16),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[15]$_DFF_P_  (.D(\_0000_[15] ),
    .Q(net17),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[1]$_DFF_P_  (.D(\_0000_[1] ),
    .Q(net18),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[2]$_DFF_P_  (.D(\_0000_[2] ),
    .Q(net19),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[3]$_DFF_P_  (.D(\_0000_[3] ),
    .Q(net20),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[4]$_DFF_P_  (.D(\_0000_[4] ),
    .Q(net21),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[5]$_DFF_P_  (.D(\_0000_[5] ),
    .Q(net22),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[6]$_DFF_P_  (.D(\_0000_[6] ),
    .Q(net23),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[7]$_DFF_P_  (.D(\_0000_[7] ),
    .Q(net24),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[8]$_DFF_P_  (.D(\_0000_[8] ),
    .Q(net25),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \exp_out[9]$_DFF_P_  (.D(\_0000_[9] ),
    .Q(net26),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(enable),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input10 (.A(x_in[7]),
    .X(net10));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(rst),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(x_in[0]),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input4 (.A(x_in[1]),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input5 (.A(x_in[2]),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input6 (.A(x_in[3]),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input7 (.A(x_in[4]),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input8 (.A(x_in[5]),
    .X(net8));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input9 (.A(x_in[6]),
    .X(net9));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[0]$_DFF_P_  (.D(\_0001_[0] ),
    .Q(\lut_stage2[0] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[10]$_DFF_P_  (.D(\_0001_[10] ),
    .Q(\lut_stage2[10] ),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[11]$_DFF_P_  (.D(\_0001_[11] ),
    .Q(\lut_stage2[11] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[12]$_DFF_P_  (.D(\_0001_[12] ),
    .Q(\lut_stage2[12] ),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[13]$_DFF_P_  (.D(\_0001_[13] ),
    .Q(\lut_stage2[13] ),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[14]$_DFF_P_  (.D(\_0001_[14] ),
    .Q(\lut_stage2[14] ),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[15]$_DFF_P_  (.D(\_0001_[15] ),
    .Q(\lut_stage2[15] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[1]$_DFF_P_  (.D(\_0001_[1] ),
    .Q(\lut_stage2[1] ),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[2]$_DFF_P_  (.D(\_0001_[2] ),
    .Q(\lut_stage2[2] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[3]$_DFF_P_  (.D(\_0001_[3] ),
    .Q(\lut_stage2[3] ),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[4]$_DFF_P_  (.D(\_0001_[4] ),
    .Q(\lut_stage2[4] ),
    .CLK(clknet_2_2__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[5]$_DFF_P_  (.D(\_0001_[5] ),
    .Q(\lut_stage2[5] ),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[6]$_DFF_P_  (.D(\_0001_[6] ),
    .Q(\lut_stage2[6] ),
    .CLK(clknet_2_3__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[7]$_DFF_P_  (.D(\_0001_[7] ),
    .Q(\lut_stage2[7] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[8]$_DFF_P_  (.D(\_0001_[8] ),
    .Q(\lut_stage2[8] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \lut_stage2[9]$_DFF_P_  (.D(\_0001_[9] ),
    .Q(\lut_stage2[9] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output11 (.A(net11),
    .X(exp_out[0]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output12 (.A(net12),
    .X(exp_out[10]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output13 (.A(net13),
    .X(exp_out[11]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output14 (.A(net14),
    .X(exp_out[12]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output15 (.A(net15),
    .X(exp_out[13]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output16 (.A(net16),
    .X(exp_out[14]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output17 (.A(net17),
    .X(exp_out[15]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output18 (.A(net18),
    .X(exp_out[1]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output19 (.A(net19),
    .X(exp_out[2]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output20 (.A(net20),
    .X(exp_out[3]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output21 (.A(net21),
    .X(exp_out[4]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output22 (.A(net22),
    .X(exp_out[5]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output23 (.A(net23),
    .X(exp_out[6]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output24 (.A(net24),
    .X(exp_out[7]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output25 (.A(net25),
    .X(exp_out[8]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output26 (.A(net26),
    .X(exp_out[9]));
 sky130_fd_sc_hd__buf_4 place47 (.A(_0200_),
    .X(net47));
 sky130_fd_sc_hd__buf_4 place48 (.A(_0357_),
    .X(net48));
 sky130_fd_sc_hd__buf_4 place49 (.A(_0148_),
    .X(net49));
 sky130_fd_sc_hd__buf_4 place50 (.A(_0220_),
    .X(net50));
 sky130_fd_sc_hd__buf_4 place51 (.A(_0182_),
    .X(net51));
 sky130_fd_sc_hd__buf_4 place52 (.A(_0161_),
    .X(net52));
 sky130_fd_sc_hd__buf_4 place53 (.A(_0131_),
    .X(net53));
 sky130_fd_sc_hd__buf_4 place54 (.A(_0125_),
    .X(net54));
 sky130_fd_sc_hd__buf_4 place55 (.A(_0114_),
    .X(net55));
 sky130_fd_sc_hd__buf_4 place56 (.A(_0060_),
    .X(net56));
 sky130_fd_sc_hd__buf_4 place57 (.A(_0042_),
    .X(net57));
 sky130_fd_sc_hd__buf_4 place58 (.A(\x_stage1[7] ),
    .X(net58));
 sky130_fd_sc_hd__buf_4 place59 (.A(\x_stage1[6] ),
    .X(net59));
 sky130_fd_sc_hd__buf_4 place60 (.A(\x_stage1[6] ),
    .X(net60));
 sky130_fd_sc_hd__buf_4 place61 (.A(\x_stage1[5] ),
    .X(net61));
 sky130_fd_sc_hd__buf_4 place62 (.A(\x_stage1[5] ),
    .X(net62));
 sky130_fd_sc_hd__buf_4 place63 (.A(\x_stage1[4] ),
    .X(net63));
 sky130_fd_sc_hd__buf_4 place64 (.A(\x_stage1[4] ),
    .X(net64));
 sky130_fd_sc_hd__buf_4 place65 (.A(net66),
    .X(net65));
 sky130_fd_sc_hd__buf_4 place66 (.A(\x_stage1[3] ),
    .X(net66));
 sky130_fd_sc_hd__buf_4 place67 (.A(\x_stage1[2] ),
    .X(net67));
 sky130_fd_sc_hd__buf_4 place68 (.A(\x_stage1[2] ),
    .X(net68));
 sky130_fd_sc_hd__buf_12 place69 (.A(\x_stage1[1] ),
    .X(net69));
 sky130_fd_sc_hd__buf_4 place70 (.A(\x_stage1[0] ),
    .X(net70));
 sky130_fd_sc_hd__buf_4 place71 (.A(\x_stage1[0] ),
    .X(net71));
 sky130_fd_sc_hd__buf_4 place72 (.A(stage2_valid),
    .X(net72));
 sky130_fd_sc_hd__buf_4 place73 (.A(net2),
    .X(net73));
 sky130_fd_sc_hd__dfxtp_1 \stage1_valid$_DFF_P_  (.D(_0002_),
    .Q(stage1_valid),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \stage2_valid$_DFF_P_  (.D(_0003_),
    .Q(stage2_valid),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[0]$_DFF_P_  (.D(\_0004_[0] ),
    .Q(\x_stage1[0] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[1]$_DFF_P_  (.D(\_0004_[1] ),
    .Q(\x_stage1[1] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[2]$_DFF_P_  (.D(\_0004_[2] ),
    .Q(\x_stage1[2] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[3]$_DFF_P_  (.D(\_0004_[3] ),
    .Q(\x_stage1[3] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[4]$_DFF_P_  (.D(\_0004_[4] ),
    .Q(\x_stage1[4] ),
    .CLK(clknet_2_1__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[5]$_DFF_P_  (.D(\_0004_[5] ),
    .Q(\x_stage1[5] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_2 \x_stage1[6]$_DFF_P_  (.D(\_0004_[6] ),
    .Q(\x_stage1[6] ),
    .CLK(clknet_2_0__leaf_clk));
 sky130_fd_sc_hd__dfxtp_1 \x_stage1[7]$_DFF_P_  (.D(\_0004_[7] ),
    .Q(\x_stage1[7] ),
    .CLK(clknet_2_1__leaf_clk));
endmodule
