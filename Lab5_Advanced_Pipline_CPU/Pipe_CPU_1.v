`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire [32-1:0]	next_pc;
wire [32-1:0]	curr_pc;
wire [32-1:0]	curr_pc_plus_4;
wire [32-1:0]    branch_pc;

wire PCSrc;

/**** IF stage ****/
wire[32-1: 0] instr_o;
wire [32-1:0] pc_id;
///instruction parts
wire [6-1:0]	op_code; //    [31:25]
wire [5-1:0]	rs_addr; //      [25:21]
wire [5-1:0]	rt_addr; //      [20:16]
wire [5-1:0]	rd_addr; //[15:11]
wire [5-1:0]	shamt; //   [10:6]
wire [6-1:0]	func; //      [5:0]

/**** ID stage ****/
wire[32-1: 0] rs_data;
wire[32-1: 0] rt_data;
wire[32-1: 0] sign_extend_o;

//wb 
wire[2-1: 0] WB_id;
wire[3-1: 0] M_id;
wire[5-1: 0] EX_id;//RegDst, ALUOp(3), ALUSrc
//control signal


/**** EX stage ****/
wire[2-1: 0] WB_ex;
wire[3-1: 0] M_ex;

wire RegDst;
wire [3-1:0]  ALUOp;
wire ALUSrc;
wire [32-1:0] pc_ex;
wire [32-1:0] rs_data_ex;
wire [32-1:0] rt_data_ex;
wire [32-1:0] sign_extend_ex;
wire [5-1:0] rt_addr_ex;
wire [5-1:0] rd_addr_ex;
wire [5-1:0] rs_addr_ex;

wire [32-1:0] sign_shifted;
wire [32-1:0] pc_ex_added;
wire [32-1:0] ALU_mux;
//control signal
wire zero_ex;
wire[32-1:0] result_ex;
wire[5-1:0] reg_dst_ex;	
wire [32-1:0] ALU_ctrl;

/**** MEM stage ****/
wire M_branch;
wire MemRead;
wire MemWrite;
wire zero_mem;
wire [2-1:0] WB_mem;
wire [5-1:0] reg_dst_mem;
wire[32-1:0] pc_mem;
wire[32-1:0] result_mem;
wire[32-1:0] rt_data_mem;
//control signal
wire[32-1:0] mem_data;
wire RegWrite;
wire MemtoReg;
wire [32-1:0] mem_data_o;
wire [32-1:0] result_mem_o;
wire [5-1:0]   reg_dst_o;
/**** WB stage ****/
wire [32-1:0] result_out;
//control signal

// Forwarding Signals
wire [32-1:0]Rs_forward_MUX;
wire [32-1:0]Rt_forward_MUX;
wire [2-1:0] forwardRs;
wire [2-1:0] forwardRt;

// hazard detection unit

wire [2+3+5-1:0] IDEX_control;
wire PCWrite;
wire IFIDWrite;
wire IDFlush;
wire IFFlush;
wire EXFlush;
wire [2+3-1:0] EXMEM_control;
/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32) )Mux0( //// PC Source
    .data0_i(curr_pc_plus_4),
    .data1_i(pc_mem),
    .select_i(zero_mem & M_branch),//M_branch & zero_mem), ///  under construction....
    .data_o(next_pc)
);



ProgramCounter PC( /// v
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_write(PCWrite), // PCWrite 
    .pc_in_i(next_pc),
    .pc_out_o(curr_pc)
);

Hazard_Detection_Unit HDU(
  .IFID_RsRt({rs_addr, rt_addr}), //10
  .IDEX_Rt(rt_addr_ex), //5
  .M(M_ex), //3
  .PCSrc(zero_mem & M_branch),///???1
  
  .IDFlush(IDFlush), //
  .EXFlush(EXFlush), //
  .IFFlush(IFFlush), //
  .PCWrite(PCWrite),//
  .IFIDWrite(IFIDWrite)
);

Instruction_Memory IM( ///v
    .addr_i(curr_pc),
    .instr_o(instr_o) //{op_code, rs_addr, rt_addr, rd_addr, shamt, func}
);

			
Adder Add_pc(
    .src1_i(32'd4),
    .src2_i(curr_pc),
    .sum_o(curr_pc_plus_4)
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i), 
    .rst_i(rst_i & !IFFlush),
    .write_i(IFIDWrite),
    .data_i({curr_pc_plus_4, instr_o}),
    .data_o({pc_id, {op_code, rs_addr, rt_addr, rd_addr, shamt, func} })
                            //31:26,   25:21,    20:16,    15:11,     10:6,    5:0
);



//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(rs_addr),
    .RTaddr_i(rt_addr),
    .RDaddr_i(reg_dst_o),
    .RDdata_i(result_out),    /// uc
    .RegWrite_i(RegWrite), /// uc
    .RSdata_o(rs_data),
    .RTdata_o(rt_data)
);

Decoder Control(
    .instr_op_i(op_code),
    
	.RegWrite_o(WB_id[1]),
	.MemtoReg_o(WB_id[0]),
	
	.ALUSrc_o(EX_id[0]),
	.ALU_op_o({EX_id[3], EX_id[2], EX_id[1]}),
	.RegDst_o(EX_id[4]),
	
	.Branch_o(M_id[2]),
	.MemRead_o(M_id[1]),
	.MemWrite_o(M_id[0]),
	
	.Jump_o(),
	.Jal_o(),
	.Jr_o()
);

Sign_Extend Sign_Extend(
    .data_i({rd_addr, shamt, func}),
    .data_o(sign_extend_o)
);	


MUX_2to1 #(.size(2+3+5) )Mux_IDEX_control( //// IDFLush
    .data0_i({WB_id, M_id,  EX_id}),
    .data1_i(0),
    .select_i(IDFlush),//IDFlush),
    .data_o(IDEX_control)
);


Pipe_Reg #(.size(2+3+5+32+32+32+32+5+5+5)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .write_i(1),
    .data_i( {IDEX_control,
                 pc_id,   //32
                 rs_data,  //32
                 rt_data,  //32
                 sign_extend_o, //32
                 rt_addr, //5
                 rd_addr, //5
                 rs_addr //5
                 } ),
              
    .data_o({WB_ex, 
                 M_ex, 
                 {RegDst, ALUOp, ALUSrc},  
                 pc_ex,
                 rs_data_ex,
                 rt_data_ex, 
                 sign_extend_ex, 
                 rt_addr_ex, 
                 rd_addr_ex,
                 rs_addr_ex })
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(sign_extend_ex),
    .data_o(sign_shifted)
);



ALU ALU(
    .src1_i(Rs_forward_MUX),
	.src2_i(ALU_mux),
	.ctrl_i(ALU_ctrl),
	.result_o(result_ex),
	.zero_o(zero_ex)
);
		

ALU_Ctrl ALU_Control(
          .funct_i(sign_extend_ex[5:0]),
          .ALUOp_i(ALUOp),
          .ALUCtrl_o(ALU_ctrl),
	      .Jr()
);

MUX_2to1 #(.size(32)) Mux1( /// ALUSrc
               .data0_i(Rt_forward_MUX),
               .data1_i(sign_extend_ex),
               .select_i(ALUSrc),
               .data_o(ALU_mux)
);
	

MUX_2to1 #(.size(5)) Mux2( ///RegDst
               .data0_i(rt_addr_ex),
               .data1_i(rd_addr_ex),
               .select_i(RegDst),
               .data_o(reg_dst_ex)
);


Adder Add_pc_branch(
       	.src1_i(pc_ex),
	    .src2_i(sign_shifted),
	    .sum_o(pc_ex_added)
);

MUX_2to1 #(.size(2+3)) Mux_EXMEM_control( ///EXflush
               .data0_i({WB_ex, M_ex}),
               .data1_i(0),
               .select_i(EXFlush),//EXFlush),
               .data_o(EXMEM_control)
);

Pipe_Reg #(.size(2+3+32+1+32+32+5)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .write_i(1),
    .data_i({EXMEM_control,
                pc_ex_added, //32
                zero_ex,// zero_ex, 
                result_ex,
                Rt_forward_MUX,//rt_data_ex, 
                reg_dst_ex }),      
    .data_o({WB_mem, {M_branch, MemRead, MemWrite}, pc_mem, zero_mem, result_mem, rt_data_mem, reg_dst_mem })
);


//Instantiate the components in MEM stage

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(result_mem),
    .data_i(rt_data_mem),
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite),
    .data_o(mem_data)
);



Pipe_Reg #(.size(2+32+32+5)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .write_i(1), // this reg does not need this port
    .data_i({WB_mem, mem_data, result_mem, reg_dst_mem}),    
    .data_o({{RegWrite, MemtoReg}, mem_data_o, result_mem_o, reg_dst_o})
);


//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3(
               .data0_i(result_mem_o),
               .data1_i(mem_data_o),
               .select_i(MemtoReg),
               .data_o(result_out)
);



Forwarding_Unit FU(
    .IDEX_Rs(rs_addr_ex),
    .IDEX_Rt(rt_addr_ex),
    .EXMEM_WB(WB_mem),
    .MEMWB_WB({RegWrite, MemtoReg}),
    .EXMEM_Rd(reg_dst_mem),
    .MEMWB_Rd(reg_dst_o),
    
    .Rs_forward(forwardRs),
    .Rt_forward(forwardRt)
);


MUX_4to1 #(.size(32)) RsMux(
               .data0_i(rs_data_ex),
               .data1_i(result_mem),
               .data2_i(result_out),
               .select_i(forwardRs),
               .data_o(Rs_forward_MUX)
);

MUX_4to1 #(.size(32)) RtMux(
               .data0_i(rt_data_ex),
               .data1_i(result_mem),
               .data2_i(result_out),
               .select_i(forwardRt),
               .data_o(Rt_forward_MUX)
);


/****************************************
signal assignment
****************************************/

endmodule

