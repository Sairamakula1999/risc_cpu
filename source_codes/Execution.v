module execution(inout clk,input reset,input [4:0]dest_for_I_s2,input [4:0]dest_for_R_s2,input [4:0]source_s2,input [4:0] write_reg_s4,
        input [31:0] write_data_s4,input RegWrite_s4,input [31:0]extended_32_s2,
        input [31:0]read_data1_s2,input [31:0] read_data2_s2,input [31:0] pc_out1_s2,input RegDst_s2,input ALUSrc_s2,
        input MemtoReg_s2,input RegWrite_s2,input MemRead_s2,input MemWrite_s2,input ALUOp1_s2,input ALUOp0_s2,
        input Branch_s2, output [31:0] ALU_result_s3,output [31:0]read_data2_s3,output MemWrite_s3,output MemtoReg_s3,
        output MemRead_s3,output RegWrite_s3,output Branch_s3,output [4:0]write_reg_s3,output [31:0]pc_out1_s3,output zero_s3);
wire [3:0]ALUCtrl;
wire [31:0] pc_out1_ss,alu_in2,add_in2,ALU_result,alu1,alu2;
wire [4:0] write_reg;
wire pc_carry;
wire[1:0] fwa,fwb;
ALU_control ac(extended_32_s2[5:0],ALUOp1_s2,ALUOp0_s2,ALUCtrl);
forward f1(source_s2,dest_for_I_s2,reset,write_reg_s3,RegWrite_s3,fwa,fwb,write_reg_s4,RegWrite_s4);
muxfa mfa1(read_data1_s2,ALU_result_s3,write_data_s4,fwa,alu1);
muxfa mfa2(read_data2_s2,ALU_result_s3,write_data_s4,fwb,alu2);
mux1 m1(dest_for_I_s2,dest_for_R_s2,RegDst_s2,write_reg);
shift_left slt(extended_32_s2[29:0],add_in2);
ksa_add kkkk(0,pc_out1_s2,add_in2,pc_out1_ss, pc_carry);
mux2 m2(alu2,extended_32_s2,ALUSrc_s2,alu_in2);
ALU alu(alu1,alu_in2,ALUCtrl,ALU_result,zero);
dff3 d3(clk,ALU_result,alu2,Branch_s2,MemWrite_s2,MemtoReg_s2,MemRead_s2,ALU_result_s3,read_data2_s3,MemWrite_s3,
        MemtoReg_s3,MemRead_s3,RegWrite_s2,RegWrite_s3,Branch_s3,write_reg,write_reg_s3,pc_out1_ss,pc_out1_s3,zero,zero_s3);
endmodule



module mux1(input [4:0]a,input [4:0]b,input sel,output [4:0]c);
assign c = (sel)?b:a;
endmodule

module ALU_control (input [5:0]a,input ALUOp1,input ALUOp0,output [3:0]ALUCtrl);
assign ALUCtrl = (({ALUOp1,ALUOp0}==2'b10))?((a == 6'b100000)?4'b0010:(a == 6'b100010)?4'b0110:(a == 6'b100100)?4'b0000:(a==6'b100101)?4'b0001:(a == 6'b011011)?4'b0100:4'b0011):({ALUOp1,ALUOp0}==2'b01)?4'b0110:4'b0010;
endmodule


module mux2 (input [31:0]read_data2,input [31:0]extended32,input ALUSrc,output [31:0]alu_in2);

assign alu_in2 = (ALUSrc)?extended32:read_data2;

endmodule
 

module shift_left(input [29:0]in,output [31:0] out);
assign out={in[29:0],2'b00};
endmodule



module forward(input [4:0]source_s2,input [4:0]dest_for_I_s2,input reset,input [4:0]write_reg_s3,input RegWrite_s3,output reg [1:0]fwda,output reg [1:0]fwdb,input [4:0]write_reg_s4,input RegWrite_s4);
//
always @(write_reg_s3,source_s2,dest_for_I_s2) begin 
//add reset to entire forward block as it remains off during reset -- added
fwda = 0;
fwdb = 0;

if((RegWrite_s3 ==1) && (write_reg_s3 !=0) &&(write_reg_s3 == source_s2) )begin 
    fwda = 2'b10;
end 
else if((RegWrite_s4 ==1) && (write_reg_s4 !=0) &&(write_reg_s4 == source_s2) && !((RegWrite_s3 ==1) && (write_reg_s3 !=0) &&(write_reg_s3 == source_s2) ))begin 
    fwda = 2'b01;
end 
if((RegWrite_s3 ==1) && (write_reg_s3 !=0) &&(write_reg_s3 == dest_for_I_s2) )begin 
    fwdb = 2'b10;
end 
else if((RegWrite_s3 ==1) && (write_reg_s3 !=0) &&(write_reg_s4 == dest_for_I_s2) && !((RegWrite_s3 ==1) && (write_reg_s3 !=0) &&(write_reg_s3 == dest_for_I_s2) ) )begin 
    fwdb = 2'b01;
end 

end
endmodule

module muxfa (input [31:0]read_data_s2,input [31:0]ALU_result_s3,input [31:0] write_data_s4,input [1:0]fw,output reg  [31:0]aluin);
always @(*) begin 
if(fw==2)
aluin = ALU_result_s3;
else if(fw==1)
aluin = write_data_s4;
else 
aluin = read_data_s2;
end
endmodule

module dff3 (input clk,input [31:0]ALU_result,input [31:0]read_data2_s2,input Branch_s2, input MemWrite_s2,input MemtoReg_s2,
        input MemRead_s2,output reg [31:0]ALU_result_s3,output reg [31:0]read_data2_s3,output reg  MemWrite_s3,
        output reg MemtoReg_s3,output reg MemRead_s3,input RegWrite_s2,output reg RegWrite_s3,output reg Branch_s3,
        input [4:0] write_reg,output reg [4:0] write_reg_s3,input [31:0] pc_out1_ss,output reg [31:0] pc_out1_s3,input zero,output reg zero_s3);

always @(posedge clk) begin 
     ALU_result_s3<=ALU_result;
     zero_s3<=zero;
     read_data2_s3<=read_data2_s2;
     pc_out1_s3<=pc_out1_ss;
     MemWrite_s3<=MemWrite_s2;
     MemtoReg_s3<=MemtoReg_s2;
     MemRead_s3<=MemRead_s2;
     RegWrite_s3<=RegWrite_s2;
     Branch_s3<=Branch_s2;
     write_reg_s3<=write_reg;
     //$monitorb("________________________________________________________",ALU_result);
end
endmodule
