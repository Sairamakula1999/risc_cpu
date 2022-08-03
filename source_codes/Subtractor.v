`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2022 13:10:58
// Design Name: 
// Module Name: Subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ksa_sub(
  input  wire        c0,
  input  wire [31:0] i_a,
  input  wire [31:0] i_b,
  output wire [31:0] o_s,
  output wire        o_carry
);

wire [31:0] p1, g1; wire  c1;// all ps and c's are redundant can be removed
wire [30:0] p2; wire [31:0] g2, ps1; wire   c2;
wire [28:0] p3; wire [31:0] g3, ps2; wire   c3;
wire [24:0] p4; wire [31:0] g4, ps3; wire   c4;
wire [16:0] p5; wire [31:0] g5, ps4; wire   c5;
wire [31:0] p6, g6; wire  c6;// here p6= p1 and c6 =c0

// layer1;
assign c1 = c0;
genvar i;
generate for(i=0; i<32; i=i+1)
   begin 
        pg pgi(i_a[i], ~i_b[i], p1[i], g1[i]);
   end
endgenerate 

// layer2;
assign c2 = c1;
assign ps1=p1;
grey gc_0(c1, p1[0], g1[0], g2[0]);
generate for(i=1; i<32; i=i+1)
   begin 
        black bci(p1[i-1],g1[i-1], p1[i], g1[i], g2[i], p2[i-1]);
   end
endgenerate 

// layer3;
assign c3 = c2;
assign ps2=ps1;
assign g3[0]=g2[0];
grey gc1_0(c2, p2[0], g2[1], g3[1]);
grey gc1_1(g2[0], p2[1], g2[2], g3[2]);
generate for(i=2; i<31; i=i+1)
   begin 
        black bc1i(p2[i-2],g2[i-1], p2[i], g2[i+1], g3[i+1], p3[i-2]);
   end
endgenerate 

// layer4;
assign c4 = c3;
assign ps3=ps2;
assign g4[2:0]=g3[2:0];
grey gc2_0(c3, p3[0], g3[3], g4[3]);
grey gc2_1(g3[0], p3[1], g3[4], g4[4]);
grey gc2_3(g3[1], p3[2], g3[5], g4[5]);
grey gc2_4(g3[2], p3[3], g3[6], g4[6]);
generate for(i=4; i<29; i=i+1)
   begin 
        black bc2i(p3[i-4],g3[i-1], p3[i], g3[i+3], g4[i+3], p4[i-4]);
   end
endgenerate 

// layer5;
assign c5 = c4;
assign ps4=ps3;
assign g5[6:0]=g4[6:0];
grey gc3_0(c4, p4[0], g4[7], g5[7]);
grey gc3_1(g4[0], p4[1], g4[8], g5[8]);
grey gc3_2(g4[1], p4[2], g4[9], g5[9]);
grey gc3_3(g4[2], p4[3], g4[10], g5[10]);
grey gc3_4(g4[3], p4[4], g4[11], g5[11]);
grey gc3_5(g4[4], p4[5], g4[12], g5[12]);
grey gc3_6(g4[5], p4[6], g4[13], g5[13]);
grey gc3_7(g4[6], p4[7], g4[14], g5[14]);
generate for(i=8; i<25; i=i+1)
   begin 
        black bc2i(p4[i-8],g4[i-1], p4[i], g4[i+7], g5[i+7], p5[i-8]);
   end
endgenerate 

// layer6;
assign c6 = c5;
assign p6=ps4;
assign g6[14:0]=g5[14:0];
grey gc4_0(c5, p5[0], g5[15], g6[15]);
generate for(i=16; i<32; i=i+1)
   begin 
        grey gc4_i(g5[i-16], p5[i-15], g5[i], g6[i]);
   end
endgenerate 

// layer7;
assign o_carry=g6[31];
assign o_s[0]=c6^p6[0];
assign o_s[31:1]=g6[30:0]^p6[31:1];

endmodule

