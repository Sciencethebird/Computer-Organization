`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 0511105 Jimmy Le
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire   [32-1:0] result;
wire   [32-1:0] result_t;
reg             zero;
reg             cout;
reg             overflow;

wire   [32-1:0] c;
wire    [2-1:0] op; 
wire  A_invert, B_invert;
wire [32-1:0] temp_diff;

reg [32-1:0] ans_temp; //add by me

assign {A_invert, B_invert} = {ALU_control[3], ALU_control[2]};
assign  op = {ALU_control[1], ALU_control[0]};	
assign result = ans_temp;
assign temp_diff = src1 - src2;


alu_top A0 (.src1(src1[0]), .src2(src2[0]), .less(temp_diff[31]), .A_invert(A_invert), .B_invert(B_invert), .cin(B_invert), .operation(op), .result(result_t[0]), .cout(c[0]));
alu_top A1 (.src1(src1[1]), .src2(src2[1]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[0]),     .operation(op), .result(result_t[1]), .cout(c[1]));
alu_top A2 (.src1(src1[2]), .src2(src2[2]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[1]),     .operation(op), .result(result_t[2]), .cout(c[2]));
alu_top A3 (.src1(src1[3]), .src2(src2[3]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[2]),     .operation(op), .result(result_t[3]), .cout(c[3]));
                                                                                                                                              
alu_top A4 (.src1(src1[4]), .src2(src2[4]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[3]),     .operation(op), .result(result_t[4]), .cout(c[4]));
alu_top A5 (.src1(src1[5]), .src2(src2[5]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[4]),     .operation(op), .result(result_t[5]), .cout(c[5]));
alu_top A6 (.src1(src1[6]), .src2(src2[6]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[5]),     .operation(op), .result(result_t[6]), .cout(c[6]));
alu_top A7 (.src1(src1[7]), .src2(src2[7]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[6]),     .operation(op), .result(result_t[7]), .cout(c[7]));
    
alu_top A8 (.src1(src1[8]),  .src2(src2[8]),  .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[7]),      .operation(op), .result(result_t[8]), .cout(c[8]));
alu_top A9 (.src1(src1[9]),  .src2(src2[9]),  .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[8]),      .operation(op), .result(result_t[9]), .cout(c[9]));
alu_top A10 (.src1(src1[10]), .src2(src2[10]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[9]),     .operation(op), .result(result_t[10]), .cout(c[10]));
alu_top A11 (.src1(src1[11]), .src2(src2[11]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[10]),     .operation(op), .result(result_t[11]), .cout(c[11]));

alu_top A12 (.src1(src1[12]), .src2(src2[12]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[11]),     .operation(op), .result(result_t[12]), .cout(c[12]));
alu_top A13 (.src1(src1[13]), .src2(src2[13]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[12]),     .operation(op), .result(result_t[13]), .cout(c[13]));
alu_top A14 (.src1(src1[14]), .src2(src2[14]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[13]),     .operation(op), .result(result_t[14]), .cout(c[14]));
alu_top A15 (.src1(src1[15]), .src2(src2[15]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[14]),     .operation(op), .result(result_t[15]), .cout(c[15]));

alu_top A16 (.src1(src1[16]), .src2(src2[16]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[15]),     .operation(op), .result(result_t[16]), .cout(c[16]));
alu_top A17 (.src1(src1[17]), .src2(src2[17]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[16]),     .operation(op), .result(result_t[17]), .cout(c[17]));
alu_top A18 (.src1(src1[18]), .src2(src2[18]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[17]),     .operation(op), .result(result_t[18]), .cout(c[18]));
alu_top A19 (.src1(src1[19]), .src2(src2[19]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[18]),     .operation(op), .result(result_t[19]), .cout(c[19]));

alu_top A20 (.src1(src1[20]), .src2(src2[20]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[19]),     .operation(op), .result(result_t[20]), .cout(c[20]));
alu_top A21 (.src1(src1[21]), .src2(src2[21]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[20]),     .operation(op), .result(result_t[21]), .cout(c[21]));
alu_top A22 (.src1(src1[22]), .src2(src2[22]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[21]),     .operation(op), .result(result_t[22]), .cout(c[22]));
alu_top A23 (.src1(src1[23]), .src2(src2[23]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[22]),     .operation(op), .result(result_t[23]), .cout(c[23]));

alu_top A24 (.src1(src1[24]), .src2(src2[24]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[23]),     .operation(op), .result(result_t[24]), .cout(c[24]));
alu_top A25 (.src1(src1[25]), .src2(src2[25]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[24]),     .operation(op), .result(result_t[25]), .cout(c[25]));
alu_top A26 (.src1(src1[26]), .src2(src2[26]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[25]),     .operation(op), .result(result_t[26]), .cout(c[26]));
alu_top A27 (.src1(src1[27]), .src2(src2[27]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[26]),     .operation(op), .result(result_t[27]), .cout(c[27]));

alu_top A28 (.src1(src1[28]), .src2(src2[28]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[27]),     .operation(op), .result(result_t[28]), .cout(c[28]));
alu_top A29 (.src1(src1[29]), .src2(src2[29]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[28]),     .operation(op), .result(result_t[29]), .cout(c[29]));
alu_top A30 (.src1(src1[30]), .src2(src2[30]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[29]),     .operation(op), .result(result_t[30]), .cout(c[30]));
alu_top A31 (.src1(src1[31]), .src2(src2[31]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(c[30]),     .operation(op), .result(result_t[31]), .cout(c[31]));




always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
     
      
       //$display("%b cout",cout );
	end
	else begin //rst_n = 1
	      
	    ans_temp <= result_t;
	    zero <=!(result_t[0]   |  result_t[1]   |  result_t[2]  |  result_t[3]  |  result_t[4]  |  result_t[5]  |  result_t[6]  |  result_t[7]  |  result_t[8]   |  result_t[9]  |   
	                      result_t[10] | result_t[11] |  result_t[12]  |  result_t[13]  |  result_t[14]  |  result_t[15]  |  result_t[16]  |  result_t[17]  |  result_t[18]  |  result_t[19]  |  
	                      result_t[20] | result_t[21] |  result_t[22]  |  result_t[23]  |  result_t[24]  |  result_t[25]  |  result_t[26]  |  result_t[27]  |  result_t[28]  |  result_t[29]  |  
	                      result_t[30] |   result_t[31]) ;
	 
	  //$display("src1 %h, src2 %h, result %h , bi %h, carray  %h", src1, src2, result, zero , B_invert, c);
       cout <= c[31];
	   overflow <= c[31] ^ c[30];
	end
end


endmodule
