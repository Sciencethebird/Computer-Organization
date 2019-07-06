//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:        0511105
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(funct_i, ALUOp_i)begin
    case(ALUOp_i)
        3'b010: begin // r type
            case(funct_i)
                    6'b100000:  ALUCtrl_o <= 4'b0010; //add 2
                    6'b100010:  ALUCtrl_o <= 4'b0110; // sub 6
                    6'b100100:  ALUCtrl_o <= 4'b0000; //and 
                    6'b100101:  ALUCtrl_o <= 4'b0001; // or
                    6'b101010:  ALUCtrl_o <= 4'b0111; // slt
             endcase       
        end
        3'b100: ALUCtrl_o <= 4'b0010; // addi
        3'b101: ALUCtrl_o <= 4'b0111; // slti
        3'b001: ALUCtrl_o <= 4'b0110; // beq
    endcase       
    $display("alu ctrl %d", ALUCtrl_o);
end
endmodule     





                    
                    