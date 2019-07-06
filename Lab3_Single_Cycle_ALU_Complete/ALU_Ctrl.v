//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:  0511105  
//----------------------------------------------
//Date:    2019/05/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
	  Jr
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;  
output     Jr;  
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg         Jr;
//Parameter

       
//Select exact operation
always @(funct_i, ALUOp_i) begin
	case (ALUOp_i)
		3'b010: begin // R-format
			case (funct_i)
				6'b100000: begin
						 ALUCtrl_o <= 4'b0010; // add 2 0010 for add
						 Jr <= 0;
					   end
				6'b100011: begin 
						ALUCtrl_o <= 4'b0110; // subu 6
						Jr <= 0;
					   end
				6'b100100: begin 
						ALUCtrl_o <= 4'b0000; // and  0
						Jr <= 0;
					   end
				6'b100101: begin
						ALUCtrl_o <= 4'b0001; // or   1	
						Jr <= 0;
					   end
				6'b101010: begin
 						ALUCtrl_o <= 4'b0111; // slt  7
						Jr <= 0;
					   end
				6'b001000: begin
						Jr <= 1; ///jr ctrl
						ALUCtrl_o <= 4'b0000;
			
				end
				default: Jr <= 0;
			endcase
			end
		3'b100: ALUCtrl_o <= 4'b0010; // addi	
		3'b101: ALUCtrl_o <= 4'b0111; // sltiu 
		3'b001: ALUCtrl_o <= 4'b0110; // beq
		3'b000: ALUCtrl_o <= 4'b0010; // lw, sw
		default: Jr <= 0;
	endcase
end

endmodule     





                    
                    