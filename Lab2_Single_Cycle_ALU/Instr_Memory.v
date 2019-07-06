//Subject:     CO project 2 - Instruction Memory
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:        0511105
//----------------------------------------------
//Date:        
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
    $display("PC%d", pc_addr_i);	
	instr_o = Instr_Mem[pc_addr_i/4];
end
    
//Initial Memory Contents
initial begin
    for ( i=0; i<32; i=i+1 )
	    Instr_Mem[i] = 32'b0;
    $readmemb("C:/Users/Sciencethebird/Desktop/Verilog/CO_Lab2_0511105/CO_Lab2/code/CO_P2_test_data2.txt", Instr_Mem);  //Read instruction from "CO_P2_test_data1.txt"   
	//for(i = 0; i<16; i=i+1)
	   //$display("%b", Instr_Mem[i]);	
end
endmodule





                    
                    