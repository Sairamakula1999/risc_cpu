
module Instruction_decode(input clk,input reset,input [31:0]instruction_s1, input [31:0]write_data_s4,input [4:0] write_reg_s4,
        input  RegWrite_s4,output RegDst_s2,output ALUSrc_s2,output  MemtoReg_s2,output RegWrite_s2,output MemRead_s2,
        output  MemWrite_s2,output  Branch_s2,output ALUOp1_s2,output ALUOp0_s2,input [31:0]pc_out1_s1,
        output [31:0]pc_out1_s2,output [31:0]extended_32_s2,output [4:0]dest_for_I_s2,output [4:0]dest_for_R_s2,
        output [31:0]read_data1_s2,output [31:0]read_data2_s2,output [4:0]source_s2 );
 wire RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0;
 wire [31:0]extended_32,read_data1,read_data2;
 wire [4:0]rs_s2,rt_s2;

control ctrl(instruction_s1[31:26],RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0);
Register_mem rm(reset,instruction_s1[25:21],instruction_s1[20:16],write_reg_s4,write_data_s4,read_data1,read_data2,RegWrite_s4);
sign_extend snext(instruction_s1[15:0],extended_32);
dff2 d2(clk,RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0,
         RegDst_s2,ALUSrc_s2,MemtoReg_s2,RegWrite_s2,MemRead_s2,MemWrite_s2,Branch_s2,ALUOp1_s2,ALUOp0_s2,pc_out1_s1,pc_out1_s2,extended_32,extended_32_s2,
        instruction_s1[25:21],instruction_s1[20:16],instruction_s1[15:11],dest_for_I_s2,dest_for_R_s2,read_data1,read_data2,read_data1_s2,read_data2_s2,source_s2);                         
endmodule

module control (input [31:26]instruction,output reg RegDst,output reg  ALUSrc,output reg MemtoReg,output reg RegWrite, 
                output reg MemRead,output reg MemWrite,output reg Branch,output reg ALUOp1,output reg ALUOp0);

always @(instruction) begin 
case(instruction[31:26])

6'b000000: begin // R
		RegDst  =1;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead  = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp1 = 1;
		ALUOp0 = 0;
	end
6'b100011: begin // I
		RegDst  =0;
		ALUSrc = 1;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead  = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp1 = 0;
		ALUOp0 = 0;
	end
6'b101011: begin //load
		RegDst  =0;
		ALUSrc = 1;
		MemtoReg = 1;
		RegWrite = 1;
		MemRead  = 1;
		MemWrite = 0;
		Branch = 0;
		ALUOp1 = 0;
		ALUOp0 = 0;
	end
6'b000100: begin //store
		RegDst  =0;// wont matter x
		ALUSrc = 1;
		MemtoReg = 0;// wont matter x
		RegWrite = 0;
		MemRead  = 0;
		MemWrite = 1;
		Branch = 0;
		ALUOp1 = 0;
		ALUOp0 = 0;
	end
6'b000101: begin //jump or branch
		RegDst  =0;// wont matter x
		ALUSrc = 0;// wont matter x
		MemtoReg = 0;// wont matter x
		RegWrite = 0;
		MemRead  = 0;
		MemWrite = 0;
		Branch = 1;//0
		ALUOp1 = 0;
		ALUOp0 = 1;
          //jmp=1
	end
default: begin // R
		RegDst  =1;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead  = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp1 = 1;
		ALUOp0 = 0;
	end
endcase
end

endmodule

module Register_mem (input reset,input [4:0]read_reg1,input [4:0]read_reg2,input [4:0]write_reg_s4,
                     input [31:0]write_data,output reg [31:0]read_data1,output reg [31:0]read_data2,input RegWrite);

reg [31:0]reg_mem[31:0];
reg [31:0]i;
always @(*) begin 
     if(reset)begin 
     for (i = 0; i < 32; i=i+1) 
        reg_mem[i] = i;
     end
     read_data1 = reg_mem[read_reg1];
     read_data2 = reg_mem[read_reg2]; 
     if(RegWrite) begin
             reg_mem[write_reg_s4 ] = write_data;
     end
end

endmodule

module sign_extend(input [15:0]a,output [31:0]b);

assign b = {{16{a[15]}},a};

endmodule

module dff2(input clk,
         input RegDst,input ALUSrc,input MemtoReg,input RegWrite,input MemRead,input MemWrite,input Branch,
	input ALUOp1,input ALUOp0,output reg RegDst_s2,output reg  ALUSrc_s2,output reg  MemtoReg_s2,
        output reg  RegWrite_s2,output reg  MemRead_s2,output reg  MemWrite_s2,output reg  Branch_s2,output  reg ALUOp1_s2,
        output reg  ALUOp0_s2,input  [31:0]pc_out1_s1,output reg [31:0]pc_out1_s2,input [31:0] extended_32,output reg  [31:0] extended_32_s2,
        input [4:0] source,input [4:0]dest_for_I,input [4:0]dest_for_R,output reg [4:0]dest_for_I_s2,output reg [4:0]dest_for_R_s2,
        input [31:0] read_data1,input [31:0] read_data2,output reg [31:0] read_data1_s2,output reg [31:0] read_data2_s2,output reg [4:0]source_s2);

always @(posedge clk) begin 
     RegDst_s2<=RegDst;
     ALUSrc_s2<=ALUSrc;
     MemtoReg_s2<=MemtoReg;
     RegWrite_s2<=RegWrite;
     MemRead_s2<=MemRead;
     MemWrite_s2<=MemWrite;
     Branch_s2<=Branch;
     ALUOp1_s2<=ALUOp1;
     ALUOp0_s2<=ALUOp0;
     extended_32_s2<=extended_32;
     dest_for_I_s2 <=dest_for_I;
     dest_for_R_s2<=dest_for_R;
     read_data1_s2<=read_data1;
     read_data2_s2<=read_data2;
     pc_out1_s2<=pc_out1_s1;
     source_s2<=source;
end

endmodule
