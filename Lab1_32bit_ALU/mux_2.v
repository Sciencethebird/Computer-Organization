`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  0511105 Jimmy Le
// 
// Create Date: 2019/03/26 01:37:07
// Design Name: 
// Module Name: mux_2
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


module mux_2(input[2-1:0] d, input select, output reg q);

always@(d or select)
begin
    case(select)
       0: q = d[0];
       1: q = d[1];
    endcase
end
endmodule
