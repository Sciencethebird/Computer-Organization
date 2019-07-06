`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  0511105 Jimmy Le
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg cout;

wire          adder_temp;
wire          src1_temp;
wire          src2_temp;




mux_2 a( .d({!src1,src1}) , .select(A_invert), .q(src1_temp));
mux_2 b( .d({!src2,src2}) , .select(B_invert), .q(src2_temp));
//FA_1bit  ya(.A(src1_temp), .B(src2_temp), .Cin(cin), .S(adder_temp), .Cout(cout));


always@( src1_temp or src2_temp or operation or cin or less) ///remember to add cin*****
begin
    
    case(operation)
        0:begin 
                result = src1_temp & src2_temp;
                cout = 0;
             end
        1: begin
                result = src1_temp | src2_temp;
                cout = 0;
            end
        2: begin
                result = src1_temp ^ src2_temp ^ cin; 
                cout =  (src1_temp & src2_temp) | (cin & src1_temp) | (cin & src2_temp);
            end
        3:  begin
                result = less;
                cout = 0;
             end
 
    endcase
end

endmodule
