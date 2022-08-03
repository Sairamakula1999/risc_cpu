module mem(input clk,input reset,input Branch_s3,input MemWrite_s3,input MemtoReg_s3,input MemRead_s3,input [4:0]write_reg_s3,
        input RegWrite_s3,input [31:0]ALU_result_s3,input [31:0]read_data2_s3,output MemtoReg_s4,output [31:0]read_data3_s4,
        output [31:0]ALU_result_s4,output RegWrite_s4,output [4:0]write_reg_s4,input zero_s3,output pcSrc);
        wire [31:0]read_data3;
        data_memory dm(reset,MemWrite_s3,MemRead_s3,ALU_result_s3,read_data2_s3,read_data3);
        
        and pc(pcSrc, zero_s3, Branch_s3);
        
        dff4 d4(clk,MemtoReg_s3,MemtoReg_s4,read_data3,read_data3_s4,ALU_result_s3,ALU_result_s4,RegWrite_s3,RegWrite_s4,write_reg_s3,write_reg_s4);

endmodule

module data_memory (input reset,input MemWrite,input MemRead,input [31:0]ALU_output,input [31:0]read_data2,output reg [31:0]read_data);
reg [31:0]mem[0:31];
reg [31:0]i;

always @(*) begin 
    if(reset)begin 
    for(i = 0; i < 31 ; i = i+1) begin
		mem[i] = 0;
		end
	end
     if(MemRead) begin 
          read_data = mem[ALU_output];
     end
     if(MemWrite) begin 
          mem[ALU_output] = read_data2;
     end
end
endmodule

module dff4 (input clk,input MemtoReg_s3,output reg MemtoReg_s4,input [31:0]read_data3,output reg [31:0]read_data3_s4,
             input [31:0]ALU_result_s3,output reg [31:0]ALU_result_s4,input RegWrite_s3,output reg RegWrite_s4,input [4:0] write_reg_s3,output reg [4:0] write_reg_s4);

always @(posedge clk) begin 
     MemtoReg_s4<=MemtoReg_s3;
     read_data3_s4<=read_data3;
     ALU_result_s4<=ALU_result_s3;
     RegWrite_s4<=RegWrite_s3;
     write_reg_s4<=write_reg_s3;

end
endmodule