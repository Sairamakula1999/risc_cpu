`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2022 09:35:02
// Design Name: 
// Module Name: Instruction_fetch
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


module Instruction_fetch(input reset,input clk,input pcSrc,input [31:0] pc_out1_s3,output [31:0] pc_out1_s1,output [31:0] instruction_s1);
wire [31:0] pc,pc_out1,instruction;


initialise_pcselect i(reset, clk,pc,pc_out1,pc_out1_s3,pcSrc);
instruction_mem im(reset,pc,instruction);
add1 a1(pc,pc_out1);
dff1 d1(clk,pc_out1,instruction,pc_out1_s1,instruction_s1);
endmodule

module initialise_pcselect (input reset ,input clk,output reg [31:0]pc,input [31:0]pc_out1,input [31:0] pc_out1_s3,input pcSrc);

always @(posedge clk) begin 
if(reset==1) pc=32'h00;
else 
    pc=pcSrc?pc_out1_s3:pc_out1;

end
endmodule

module instruction_mem(input reset,input [31:0]address,output reg [31:0]instruction);

reg  [0:31]mem[31:0];
reg [31:0]i;
always@(*) begin 
    for(i=0;i<32;i=i+1)
    begin
    if(i==0)
    mem[0] = 32'b000000_00010_00011_00100_00000_100000;//add r4 r3 r2
    else if(i==4)
    mem[4] = 32'b000000_00100_00001_00100_00000_100010;//sub r4 r4 r1
    else if(i==8)
    mem[8] = 32'b000000_00100_00011_00010_00000_011011;//mult r2 r4 r3
    else if(i==12)
    mem[12] = 32'b000101_00001_00001_00000_00000_000000;//beq r1 r1
    else if(i==16)
    mem[16] = 32'b100011_00110_00110_00000_00000_0001010;//addi r6 6(#34)
    else if(i==20)
    mem[20] = 32'b000000_00011_00010_00011_00000_0001010;//and r3 r3 r2
    else if(i==24)
    mem[24] = 32'b000100_00100_00010_00000_00000_000001;// st r4 r2
    else if(i==28)
    mem[28] = 32'b101011_00100_00010_00000_00000_000001;// lw r4 r2
    else
    mem[i]=32'h00000000;
    end
     instruction = mem[address];
end

endmodule

module add1(input [31:0]pc,output [31:0]pc_out1);

assign pc_out1 = pc+4;

endmodule

module dff1 (input clk,input [31:0]pc_out1,input [31:0]instruction,output reg [31:0]pc_out1_s1,output reg [31:0]instruction_s1);

always @(posedge clk) begin 
    pc_out1_s1 <= pc_out1;
    instruction_s1 <= instruction;
end

endmodule
