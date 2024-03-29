`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    write_i,
    clk_i,
    rst_i,
    data_i,
    data_o
    
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input write_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if (write_i)
        data_o <= data_i;
         //$display("safgsdfgsdfgsdfgsfdgsdfg%b", rst_i);
         //$display("%b\n", data_o);
end

endmodule	