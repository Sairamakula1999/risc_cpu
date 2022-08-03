`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2022 13:12:46
// Design Name: 
// Module Name: Booth_multiplier
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


module booth_multiplier(PRODUCT, A, B);
  parameter N=16;//16-bit
  output reg signed [2*N-1:0] PRODUCT;//32-bit
  input signed [N-1:0] A, B;//each 16-bit
  
  reg [1:0] temp;
  integer i;
  reg e;
  reg [N-1:0] B1;

  always @(A,B)
  begin
    
    PRODUCT = 32'd0;
    e = 1'b0;
    B1 = -B;
    
    for (i=0; i<N; i=i+1)
    begin
      temp = { A[i], e };
      case(temp)
        2'd2 : PRODUCT[2*N-1:N] = PRODUCT[2*N-1:N] + B1;//lets A=011110=>first two 10, here msb=1 assuming -ve, -B it continues till 0 
        2'd1 : PRODUCT[2*N-1:N] = PRODUCT[2*N-1:N] + B; // if 0 comes +B is added it becomes positive else remains -ve
      endcase
      // for radix 4 consider X2i+1,X2i=> here *2 then X2i,X2i-1 here like prev one
      PRODUCT = PRODUCT >> 1;
      PRODUCT[2*N-1] = PRODUCT[2*N-2];
      e=A[i];     
    end
  end
  
endmodule
