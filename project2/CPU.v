module CPU
(
	clk_i,
	rst_i,
	start_i,
   
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

//
// to Data Memory interface		
//
input	[256-1:0]	mem_data_i; 
input				mem_ack_i; 	
output	[256-1:0]	mem_data_o; 
output	[32-1:0]	mem_addr_o; 	
output				mem_enable_o; 
output				mem_write_o; 

//
// add your project1 here!

// Ports
wire	[31:0]  inst;

wire	[31:0] 	pcAdd4, pc_i, Jump_addr, Branch_addr;
assign 	Jump_addr = {Add_PC.data_o[31:28], inst[25:0], 2'b00};

// IF
MUX32 MUX_PC_Jump(
	.data1_i	(MUX_PC_Branch.data_o),
	.data2_i	(Jump_addr),
	.select_i	(Control.Jump_o),
	.data_o		(pc_i)
);

ALU Data_Eq(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (Registers.RTdata_o),
    .ALUCtrl_i  (3'b110), // substract
    .data_o     (),
    .Zero_o     (/*  */)
);

MUX32 MUX_PC_Branch(
	.data1_i    (pcAdd4), // 0
    .data2_i    (Branch_addr), // 1
    .select_i   (Control.Branch_o & Data_Eq.Zero_o), // data equals and instruction is `beq`
    .data_o     ()
);

Adder Add_PC_Branch(
	.data1_i	(IF_ID.PC4_o),
	.data2_i	({Signed_Extend.data_o[29:0], 2'b00}),
	.data_o		(Branch_addr)
);

Adder Add_PC(
    .data1_i   	(PC.pc_o),
    .data2_i  	(32'b100),
    .data_o     (pcAdd4)
);

// IF

IF_ID IF_ID(
    .stall_i (dcache.p1_stall_o),
    .Flush_i (MUX_PC_Branch.select_i | MUX_PC_Jump.select_i),
    .Clock_i (clk_i),
    .IFID_i  (Hazard_Detection.IFID_o),
    .PC4_i   (pcAdd4),
    .Inst_i  (Instruction_Memory.instr_o),
    .PC4_o   (/* I think this is for exception control module */),
    .Inst_o  (inst)
);

// ID
Control Control(
    .Op_i       (inst[31:26]),
    .Jump_o		(), // only there three signals
    .Branch_o	(), // don't need to be
    .ExtOp_o	(), // pipelined
    .RegDst_o   (),
    .MemRead_o	(),
    .MemtoReg_o	(),
    .ALUOp_o    (),
    .MemWrite_o	(),
    .ALUSrc_o   (),
    .RegWrite_o ()
);

Signed_Extend Signed_Extend(
    .data_i     (inst[15:0]),
    .ExtOp_i	(Control.ExtOp_o),
    .data_o     (/*  */)
);

Hazard_Detection Hazard_Detection(
    .IFIDRegRs_i    (inst[25:21]),
    .IFIDRegRt_i    (inst[20:16]),
    .IDEXMemRead_i  (ID_EX.M_o[1]),
    .IDEXRegRt_i    (ID_EX.RegRt_o),
    .pcWrite_o      (),
    .IFID_o         (),
    .MuxSelect_o    ()
);

MUX32 ID_EX_Flush(
    .data1_i    ({24'b0, Control.RegWrite_o, Control.MemtoReg_o, Control.MemRead_o, Control.MemWrite_o, Control.ALUSrc_o, Control.ALUOp_o, Control.RegDst_o}),
                            /* WB[1]               WB[0]               M[1]                M[0]                 EX[3]           EX[2:1]            EX[0] */ 
    .data2_i    (32'b0),
    .select_i   (Hazard_Detection.MuxSelect_o),
    .data_o     ()
);

assign  {ID_EX.WB_i, ID_EX.M_i, ID_EX.EX_i} = ID_EX_Flush.data_o[7:0];
// ID

ID_EX ID_EX(
    .stall_i (dcache.p1_stall_o),
    .Clock_i     (clk_i),
    .WB_i        (),
    .M_i         (),
    .EX_i        (),
    .Data1_i     (Registers.RSdata_o),
    .Data2_i     (Registers.RTdata_o),
    .Immediate_i (Signed_Extend.data_o),
    .RegRs_i     (inst[25:21]),
    .RegRt_i     (inst[20:16]),
    .RegRd_i     (inst[15:11]),
    .WB_o        (/*  */),
    .M_o         (/*  */),
    .EX_o        (/*  */),
    .Data1_o     (/*  */),
    .Data2_o     (/*  */),
    .Immediate_o (/*  */),
    .RegRs_o     (/*  */),
    .RegRt_o     (/*  */),
    .RegRd_o     (/*  */)
);

// EX
ALU ALU(
    .data1_i    (MUX_ForwardA2.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (ID_EX.Immediate_o[5:0]),
    .ALUOp_i    (ID_EX.EX_o[2:1]),
    .ALUCtrl_o  ()
);

Forwarding_Unit Forwarding_Unit(
    .EXRegRs_i      (ID_EX.RegRs_o),
    .EXRegRt_i      (ID_EX.RegRt_o),
    .MEMRegRd_i     (EX_MEM.RegRd_o),
    .MEMRegWrite_i  (EX_MEM.WB_o[1]),
    .WBRegRd_i      (MEM_WB.RegRd_o),
    .WBRegWrite_i   (MEM_WB.WB_o[1]),
    .ForwardA_o     (),
    .ForwardB_o     ()
);

MUX32 MUX_ForwardA1(
  .data1_i  (ID_EX.Data1_o),
  .data2_i  (EX_MEM.ALU_o),
  .select_i (Forwarding_Unit.ForwardA_o[1]),
  .data_o   ()
);

MUX32 MUX_ForwardA2(
  .data1_i  (MUX_ForwardA1.data_o),
  .data2_i  (MUX_Regdata.data_o),
  .select_i (Forwarding_Unit.ForwardA_o[0]),
  .data_o   ()
);

MUX32 MUX_ForwardB1(
  .data1_i  (ID_EX.Data2_o),
  .data2_i  (EX_MEM.ALU_o),
  .select_i (Forwarding_Unit.ForwardB_o[1]),
  .data_o   ()
);

MUX32 MUX_ForwardB2(
  .data1_i  (MUX_ForwardB1.data_o),
  .data2_i  (MUX_Regdata.data_o),
  .select_i (Forwarding_Unit.ForwardB_o[0]),
  .data_o   ()
);

MUX32 MUX_ALUSrc(
    .data1_i    (MUX_ForwardB2.data_o),
    .data2_i    (ID_EX.Immediate_o),
    .select_i   (ID_EX.EX_o[3]),
    .data_o     ()
);

MUX5 MUX_RegDst(
    .data1_i    (ID_EX.RegRt_o),
    .data2_i    (ID_EX.RegRd_o),
    .select_i   (ID_EX.EX_o[0]),
    .data_o     ()
);
// EX

EX_MEM EX_MEM(
    .stall_i (dcache.p1_stall_o),
    .Clock_i     (clk_i),
    .WB_i        (ID_EX.WB_o),
    .M_i         (ID_EX.M_o),
    .ALU_i       (ALU.data_o),
    .RegRd_i     (MUX_RegDst.data_o),
    .WriteData_i (MUX_ForwardB2.data_o),
    .WB_o        (/*  */),
    .M_o         (/*  */),
    .ALU_o       (/*  */),
    .RegRd_o     (/*  */),
    .WriteData_o (/*  */)
);

// MEM
//data cache
dcache_top dcache
(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data_o), 
	.mem_addr_o(mem_addr_o), 	
	.mem_enable_o(mem_enable_o), 
	.mem_write_o(mem_write_o), 
	
	// to CPU interface	
	.p1_data_i(EX_MEM.WriteData_o), 
	.p1_addr_i(EX_MEM.ALU_o), 	
	.p1_MemRead_i(EX_MEM.M_o[1]), 
	.p1_MemWrite_i(EX_MEM.M_o[0]), 
	.p1_data_o(), 
	.p1_stall_o()
);
// MEM

MEM_WB MEM_WB(
    .stall_i (dcache.p1_stall_o),
    .Clock_i (clk_i),
    .WB_i    (EX_MEM.WB_o),
    .MEM_i   (dcache.p1_data_o),
    .ALU_i   (EX_MEM.ALU_o),
    .RegRd_i (EX_MEM.RegRd_o),
    .WB_o    (/*  */),
    .MEM_o   (/*  */),
    .ALU_o   (/*  */),
    .RegRd_o (/*  */)
);

// WB

MUX32 MUX_Regdata(
	.data1_i	(MEM_WB.ALU_o),
	.data2_i	(MEM_WB.MEM_o),
	.select_i	(MEM_WB.WB_o[0]),
	.data_o		()
);
// WB

//


PC PC
(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(dcache.p1_stall_o),
	.pcEnable_i(Hazard_Detection.pcWrite_o),
	.pc_i(pc_i),
	.pc_o()
);

Instruction_Memory Instruction_Memory(
	.addr_i(PC.pc_o), 
	.instr_o()
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MEM_WB.RegRd_o), 
    .RDdata_i   (MUX_Regdata.data_o),
    .RegWrite_i (MEM_WB.WB_o[1]), 
    .RSdata_o   (), 
    .RTdata_o   () 
);

endmodule