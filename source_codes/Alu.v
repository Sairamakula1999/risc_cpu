`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2022 13:06:42
// Design Name: 
// Module Name: Alu
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


module ALU(input [31:0] A,input [31:0] B,input [3:0] sel,output reg [31:0] out1,output reg zero);
wire carra;
wire carrs;
wire [31:0]out,out2,out3,outa;
ksa_add ks(0,A,B,out2,carra);
ksa_sub ks1(1,A,B,out3,carrs);
booth_multiplier aa(outa, A[15:0], B[15:0]);
always@(out2,out3,outa,A,B,sel)
begin
case(sel)
4'b0010: out1=out2;//add
4'b0110:out1=out3;//sub
4'b0100:out1=outa;//booth
4'b0000:out1=A&B;
4'b0001: out1=A|B;
default:out1=out2;
endcase
zero=0;
if(out3==32'h00000000)
zero=1;
end

endmodule
