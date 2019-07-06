//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0511105   
//----------------------------------------------
//Date:        2019/5/23
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
	clk_i,
	rst_i
	);
		
//I/O port
input				clk_i;
input				rst_i;

//Internal Signles
wire [32-1:0]	next_pc;
wire [32-1:0]	curr_pc;
wire [32-1:0]	curr_pc_plus_4;

///instruction parts
wire [6-1:0]	op_code;
wire [5-1:0]	rs_addr;
wire [5-1:0]	rt_addr;
wire [5-1:0]	rd_addr;
wire [5-1:0]	shamt;
wire [6-1:0]	func;


wire		reg_dst;
wire		reg_write;
wire		branch;

///added for lab3
wire	jump;
wire	memread;
wire	memwrite;
wire	memtoreg;
wire    jr;
wire    jal;
wire    jr_init;
wire	if_R_type;

wire [5-1:0]	write_addr;
wire [5-1:0]    reg_write_mux;
wire [32-1:0]	write_data_mem;
wire [32-1:0]	rs_data;
wire [32-1:0]	rt_data;
///added for lab3
wire [32-1:0]   ifbranch;
wire [32-1:0]   ifjump;
wire [32-1:0]   write_data_reg;  ///write results on reg
wire [32-1:0]   mem_readdata;  
wire [32-1:0]   result;
wire [32-1:0]   reg_writedata_src;
///
wire [3-1:0]	alu_op;
wire		alu_src;

wire [4-1:0]	alu_ctrl;

wire [32-1:0]	sign_extended_out;

wire [32-1:0]	alu_input_2;

wire		zero;

wire [32-1:0]	shifter_out;
wire [32-1:0]	adder2_out;


wire		and_out;


//Greate componentes
ProgramCounter PC(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.pc_in_i(next_pc),
		.pc_out_o(curr_pc)
);
	
Adder Adder1(
		.src1_i(32'd4),
		.src2_i(curr_pc),
		.sum_o(curr_pc_plus_4)
		);
	
Instr_Memory IM(
		.pc_addr_i(curr_pc),
		.instr_o( {op_code, rs_addr, rt_addr, rd_addr, shamt, func} )
		);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
		.data0_i(rt_addr),
		.data1_i(rd_addr),
		.select_i(reg_dst),
		.data_o(reg_write_mux)///
		);	
///for jal
MUX_2to1 #(.size(5)) MUX_ifjal_addr(
		.data0_i(reg_write_mux),
		.data1_i(5'd31),
		.select_i(jal),
		.data_o(write_addr)
		);		
Reg_File Registers(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(rs_addr),
		.RTaddr_i(rt_addr),
		.RDaddr_i(write_addr), //WriteRegister
		.RDdata_i(write_data_reg), //WriteData
		.RegWrite_i(reg_write),
		.RSdata_o(rs_data),
		.RTdata_o(rt_data)
		);
	
Decoder Decoder(
		.instr_op_i(op_code),
		.RegWrite_o(reg_write),
		.ALU_op_o(alu_op),
		.ALUSrc_o(alu_src),
		.RegDst_o(reg_dst),
		.Branch_o(branch),

		/// added for lab3
		.Jump_o(jump),   
		.MemRead_o(memread),  
		.MemWrite_o(memwrite), 
		.MemtoReg_o(memtoreg),
		.Jal_o(jal),
		.Jr_o(if_R_type)
		);

ALU_Ctrl AC(
		.funct_i(func),
		.ALUOp_i(alu_op),
		.ALUCtrl_o(alu_ctrl),
		.Jr(jr)
		);
	
Sign_Extend SE(
		.data_i( {rd_addr, shamt, func} ), ///for i_type instructions
		.data_o(sign_extended_out)
		);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
		.data0_i(rt_data),
		.data1_i(sign_extended_out),
		.select_i(alu_src),
		.data_o(alu_input_2)
		);	
		
ALU ALU(
		.src1_i(rs_data),
		.src2_i(alu_input_2),
		.ctrl_i(alu_ctrl),
		.result_o(result),
		.zero_o(zero)
		);
//// added for lab3
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(result), 	/// from ALU,for sw, address in memory
	.data_i(rt_data),      /// store data from reg to memory(sw)
	.MemRead_i(memread),   /// for lw
	.MemWrite_i(memwrite),  /// for sw
	.data_o(mem_readdata)       /// read data from memory (lw) and store to reg
	);

///added for lab3	
MUX_2to1 #(.size(32)) MUX_reg_writedata_src( ///data src for writing reg
		.data0_i(result), ///r-type result
		.data1_i(mem_readdata),
		.select_i(memtoreg),
		.data_o(reg_writedata_src)
);
///for jal
MUX_2to1 #(.size(32)) write_reg_ifjal( ///data src for writing reg
		.data0_i(reg_writedata_src),
		.data1_i(curr_pc_plus_4),
		.select_i(jal),
		.data_o(write_data_reg)
);



Adder Adder2(    ///for branch
		.src1_i(curr_pc_plus_4),
		.src2_i(shifter_out),
		.sum_o(adder2_out)
		);
		
Shift_Left_Two_32 Shifter( /// for branch
		.data_i(sign_extended_out),
		.data_o(shifter_out)
		);

and AND_1 (and_out, branch, zero);
		
MUX_2to1 #(.size(32)) MUX_ifbranch(
		.data0_i(curr_pc_plus_4),
		.data1_i(adder2_out),
		.select_i(and_out),
		.data_o(ifbranch)
		);	
///added for lab3
MUX_2to1 #(.size(32)) MUX_ifjump(
		.data0_i(ifbranch),
		.data1_i({curr_pc_plus_4[31:28], rs_addr, rt_addr, rd_addr, shamt, func, 2'b00}),
		.select_i(jump),
		.data_o(ifjump)
		);

///jr MUX

MUX_2to1 #(.size(32)) MUX_ifjr(
		
		.data0_i(ifjump),
		.data1_i(rs_data),
		.select_i(jr_init),
		.data_o(next_pc)
		);

MUX_2to1 #(.size(1)) MUX_jr_init(	
		.data0_i(1'b0),
		.data1_i(jr),
		.select_i(if_R_type),
		.data_o(jr_init)
		);
//display("next pc %d", 
endmodule
		  


