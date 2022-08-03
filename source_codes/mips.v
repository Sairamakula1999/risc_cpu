`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2022 14:49:51
// Design Name: 
// Module Name: mips// Project Name: 
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

module pipelined_mipstest(input clk,input reset,output write_data_s4);
//wire [4:0]instruction_s2_a,instruction_s2_b;

//initial pc = 0;
//------------------------------------  stage 1
wire [31:0] pc_out1_s1,pc_out1_s3,instruction_s1;
wire Branch_s3,pcSrc;
Instruction_fetch kk(reset,clk,pcSrc,pc_out1_s3,pc_out1_s1,instruction_s1);



//------------------------------------  stage 2

wire RegDst_s2,ALUSrc_s2,MemtoReg_s2,RegWrite_s2,MemRead_s2,MemWrite_s2,ALUOp1_s2,ALUOp0_s2,Branch_s2,RegWrite_s4;
wire [31:0] pc_out1_s2, extended_32_s2,read_data1_s2, read_data2_s2,write_data_s4;
wire [4:0] dest_for_I_s2,dest_for_R_s2,write_reg_s4,source_s2;
Instruction_decode id(clk,reset,instruction_s1,write_data_s4,write_reg_s4,RegWrite_s4,RegDst_s2,ALUSrc_s2,MemtoReg_s2,
        RegWrite_s2,MemRead_s2,MemWrite_s2,Branch_s2,ALUOp1_s2,ALUOp0_s2,pc_out1_s1,pc_out1_s2,extended_32_s2,
        dest_for_I_s2,dest_for_R_s2,read_data1_s2,read_data2_s2,source_s2);


//------------------------------------  stage 3

wire [31:0] ALU_result_s3,read_data2_s3;
wire MemWrite_s3,MemtoReg_s3,MemRead_s3,RegWrite_s3,zero_s3;
wire [4:0]write_reg_s3;
execution ex(clk,reset,dest_for_I_s2,dest_for_R_s2,source_s2,write_reg_s4,write_data_s4,RegWrite_s4,extended_32_s2,
        read_data1_s2,read_data2_s2,pc_out1_s2,RegDst_s2,ALUSrc_s2,
        MemtoReg_s2,RegWrite_s2,MemRead_s2,MemWrite_s2,ALUOp1_s2,ALUOp0_s2,Branch_s2,ALU_result_s3,read_data2_s3,
        MemWrite_s3,MemtoReg_s3,MemRead_s3,RegWrite_s3,Branch_s3,write_reg_s3,pc_out1_s3,zero_s3);


//-------------------------------------   stage 4
wire MemtoReg_s4;

wire [31:0] read_data3_s4,ALU_result_s4;
mem m(clk,reset,Branch_s3,MemWrite_s3,MemtoReg_s3,MemRead_s3,write_reg_s3,RegWrite_s3,ALU_result_s3,read_data2_s3,MemtoReg_s4,
        read_data3_s4,ALU_result_s4,RegWrite_s4,write_reg_s4,zero_s3,pcSrc);

//-----------------------------------    stage 5

mux3 wb(read_data3_s4,ALU_result_s4,MemtoReg_s4,write_data_s4);
endmodule


//----------------------------------------- Stage 5

module mux3 (input [31:0]read_data,input [31:0]ALU_output,input MemtoReg,output [31:0]write_data);
assign write_data = (MemtoReg)?read_data:ALU_output;
endmodule

