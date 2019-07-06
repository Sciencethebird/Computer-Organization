//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:    0511105   
//----------------------------------------------
//Date:     2019/05/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Forwarding_Unit(
    IDEX_Rs,
    IDEX_Rt,
    EXMEM_WB,
    MEMWB_WB,
    EXMEM_Rd,
    MEMWB_Rd,
    
    Rs_forward,
    Rt_forward
);
               
//I/O ports
input[5-1:0]    IDEX_Rs;
input[5-1:0]    IDEX_Rt;
input[2-1:0]    EXMEM_WB;
input[2-1:0]    MEMWB_WB;
input[5-1:0]    EXMEM_Rd;
input[5-1:0]    MEMWB_Rd;

output reg  [2-1:0] Rs_forward;
output reg  [2-1:0] Rt_forward;

//Internal Signals
//reg     [32-1:0] data_o;

always@(IDEX_Rs, IDEX_Rt, EXMEM_WB, MEMWB_WB, EXMEM_Rd, MEMWB_Rd) begin

    //$display("Rs: %b\nRt: %b\nEXMEM_Rd: %b\nEXMEM_WB: %b",IDEX_Rs, IDEX_Rt, EXMEM_Rd, EXMEM_WB);
  
       
        if(  EXMEM_WB[1] && EXMEM_Rd != 0 && EXMEM_Rd == IDEX_Rs) begin
                    Rs_forward <= 2'b01;
                    //$display("f1");
            end 
        if(  EXMEM_WB[1] && EXMEM_Rd != 0 && EXMEM_Rd == IDEX_Rt) begin          
                    Rt_forward <= 2'b01;
                    //$display("f2");
            end
        if(MEMWB_WB[1] && MEMWB_Rd != 0 && MEMWB_Rd == IDEX_Rs) begin
                    Rs_forward <= 2'b10;
                    //$display("f3");
            end
        if(MEMWB_WB[1] && MEMWB_Rd != 0 && MEMWB_Rd == IDEX_Rt) begin
                    Rt_forward <= 2'b10;
                    //$display("f4");
            end
     
         /// super important for normalcase   
         if(MEMWB_Rd != IDEX_Rs && EXMEM_Rd != IDEX_Rs) begin
                    Rs_forward <= 2'b00;
                    //$display("norm1");
            end
         if(MEMWB_Rd != IDEX_Rt && EXMEM_Rd != IDEX_Rt) begin
                    Rt_forward <= 2'b00;
                    //$display("norm2");
            end
            
end 
          
endmodule      
     