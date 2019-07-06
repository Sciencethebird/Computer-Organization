//Subject:     CO project 2 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:    0511105       
//----------------------------------------------
//Date:     2019/05/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_4to1(
               data0_i,
               data1_i,
               data2_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [2-1:0]     select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;
//reg     [size-1:0] data_o;

//Main function

//assign data_o = (select_i == 0) ? data0_i : data1_i;

always@(data0_i, data1_i, data2_i ,select_i) begin
  	case (select_i)
		0: data_o <= data0_i;
		1: data_o <= data1_i;
		2: data_o <= data2_i;	
	    default: data_o <= data0_i;
     endcase
end 

//assign data_o = ( select_i == 0 )? data0_i : ( select_i == 1 )? data1_i : ( select_i == 2 )? data2_i: data2_i;
endmodule      
  
  
 