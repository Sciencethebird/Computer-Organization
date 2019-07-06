//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0511105
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_addr;
wire [32-1:0] pc_plus_4;
wire [32-1:0] shift_2;
wire [32-1:0] Adder_to_Mux;
wire [32-1:0] PC_src;

wire [32-1:0] instr;
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [32-1:0] Mux_to_ALU;
wire [32-1:0] result;
wire [32-1:0] se;

wire[5-1:0] Mux_to_Reg;

wire zero;
//decoder wires
wire	 RegWrite;
wire	 [3-1:0]ALU_op;
wire	 ALUSrc;
wire	 RegDst;
wire	 Branch;

wire [4-1:0] ALUCtrl;


///instruction parts
wire [6-1:0]	op_code;
wire [5-1:0]	rs_addr;
wire [5-1:0]	rt_addr;
wire [5-1:0]	rd_addr;
wire [5-1:0]	shamt;
wire [6-1:0]	func;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_src) ,   
	    .pc_out_o(pc_addr) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_addr),     
	    .sum_o(pc_plus_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_addr),  
	    .instr_o({op_code, rs_addr, rt_addr, rd_addr, shamt, func})    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt_addr), //rt
        .data1_i(rd_addr), //rd
        .select_i(RegDst),
        .data_o(Mux_to_Reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,    
	     
        .RSaddr_i(rs_addr) ,   //rs
        .RTaddr_i(rt_addr) ,   //rt
        .RDaddr_i(Mux_to_Reg) ,  //from Mux
        
        .RDdata_i(result), 
        
        .RegWrite_i(RegWrite), // write control signal
        
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(op_code), 
	    .RegWrite_o(RegWrite), // control signal
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(func),   //funct 
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i({rd_addr, shamt, func}),
        .data_o(se)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(se),
        .select_i(ALUSrc),
        .data_o(Mux_to_ALU)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	    .src2_i(Mux_to_ALU),
	    .ctrl_i(ALUCtrl),
	    .result_o(result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(pc_plus_4),     
	    .src2_i(shift_2),     
	    .sum_o(Adder_to_Mux)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se),
        .data_o(shift_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_plus_4),
        .data1_i(Adder_to_Mux),
        .select_i(Branch & zero),
        .data_o(PC_src)
        );	

endmodule
		  


