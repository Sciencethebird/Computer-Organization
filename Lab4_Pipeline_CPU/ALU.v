//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer: 0511105 ??     
//----------------------------------------------
//Date:     2019/05/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    	src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);		// Zero is true if result is 0
always @(ctrl_i, src1_i, src2_i) begin

	case (ctrl_i)
		0: result_o <= src1_i & src2_i;
		1: result_o <= src1_i | src2_i;
		2: result_o <= src1_i + src2_i;
		6: result_o <= src1_i - src2_i;
		7: result_o <= (src1_i < src2_i) ? 1 : 0;
		8: result_o <= src1_i * src2_i;
		12: result_o <= ~(src1_i | src2_i);	// nor
		
	    default: result_o <= 0;
	   
	endcase
	
end
endmodule





                    
                    