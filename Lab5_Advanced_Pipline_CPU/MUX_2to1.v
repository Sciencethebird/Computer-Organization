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
     
module MUX_2to1(
               data0_i,
               data1_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o; 

//Internal Signals
//reg     [size-1:0] data_o;
//reg     [size-1:0] data_o;

//Main function
assign data_o = (select_i == 0) ? data0_i : data1_i;

endmodule      
          
                    
          