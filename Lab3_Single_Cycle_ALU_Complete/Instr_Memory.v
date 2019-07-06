//Subject:     CO project 2 - Instruction Memory
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:    0511105 ??     
//----------------------------------------------
//Date:   2018/05/27     
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Instr_Memory(
    	pc_addr_i,
	instr_o
	);
 
//I/O ports
input  [32-1:0]  pc_addr_i;
output [32-1:0]	 instr_o;

//Internal Signals
reg    [32-1:0]	 instr_o;
integer          i;

//32 words Memory
reg    [32-1:0]  Instr_Mem [0:32-1];

//Parameter
    
//Main function
always @(pc_addr_i) begin
	instr_o = Instr_Mem[pc_addr_i/4];
	//$display("%d th instruction memory output: %b pc = %d", pc_addr_i/4, instr_o, pc_addr_i);
		
end
    
//Initial Memory Contents
initial begin
    for ( i=0; i<32; i=i+1 )
	    Instr_Mem[i] = 32'b0;
    $readmemb("C:/Users/Sciencethebird/Desktop/Verilog/CO_Lab3_0511105_2019/CO_Lab3/test/CO_P3_test_data2.txt", Instr_Mem);  //Read instruction from "CO_P3_test_data1.txt"   
        //for ( i=0; i<5; i=i+1 )
	//$display("%d th instruction memory output: %b", i, instr_Mem[i]);	
end
endmodule





                    
                    