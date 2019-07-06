//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0511105
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output            RegWrite_o;
output [3-1:0] ALU_op_o;
output            ALUSrc_o;
output            RegDst_o;
output            Branch_o;
 
//Internal Signals
reg  [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter



//Main function
always @ (instr_op_i ) begin
  $display("decoder %b", instr_op_i);
  $display("decoder out %d", ALU_op_o);
    case(instr_op_i)
        6'b000000: begin //textbook p.257 R-format
            ALU_op_o    <=  3'b010;
            ALUSrc_o     <= 0;
            RegWrite_o <= 1;
            RegDst_o    <= 1;
            Branch_o     <= 0;
         end
         6'b001000: begin // addi
            ALU_op_o    <=  3'b100;
            ALUSrc_o     <= 1;
            RegWrite_o <= 1;
            RegDst_o    <= 0;
            Branch_o     <= 0;
            
         end
         6'b001010: begin // slti
            ALU_op_o    <=  3'b101;
            ALUSrc_o     <= 1;
            RegWrite_o <= 1;
            RegDst_o    <= 0;
            Branch_o     <= 0;
         end
         6'b000100: begin //beq
            ALU_op_o    <=  3'b001;
            ALUSrc_o     <= 0;
            RegWrite_o  <= 0;
            RegDst_o     <= 0;
            Branch_o      <= 1;
         end

     endcase
    
end
endmodule





                    
                    