module CPU
(
    clk_i,
    start_i
);

// Ports
input               clk_i;
input               start_i;

wire	[31:0] inst_addr, inst;

wire	[4:0]	RSaddr, RTaddr, RDaddr;
assign	RSaddr = inst[25:21];
assign	RTaddr = inst[20:16];

wire	[15:0]	imme;
assign	imme = inst[15:0];

wire	[31:0] 	pcAdd4, pc_i, Jump_addr, Branch_addr;
assign 	Jump_addr = {Add_PC.data_o[31:28], inst[25:0], 2'b00};

wire 	PCSrc;
assign 	PCSrc = Control.Branch_o & ALU.Zero_o;

Control Control(
    .Op_i       (inst[31:26]),
    .Jump_o		(), // only there three signals
    .Branch_o	(), // don't need to be
    .ExtOp_o	(), // pipelined
    .RegDst_o   (MUX_RegDst.select_i),
    .MemRead_o	(),
    .MemtoReg_o	(),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .MemWrite_o	(),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);

MUX32 MUX_PC_Jump(
	.data1_i	(MUX_PC_Branch.data_o),
	.data2_i	(Jump_addr),
	.select_i	(Control.Jump_o),
	.data_o		(pc_i)
);

MUX32 MUX_PC_Branch(
	.data1_i    (pcAdd4), // 0
    .data2_i    (Branch_addr), // 1
    .select_i   (PCSrc),
    .data_o     ()
);

Adder Add_PC_Branch(
	.data1_i	(IF_ID.pc_o),
	.data2_i	({Signed_Extend.data_o[29:0], 2'b00}),
	.data_o		(Branch_addr)
);

Adder Add_PC(
    .data1_i   	(inst_addr),
    .data2_i  	(32'b100),
    .data_o     (pcAdd4)
);

PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .pcWrite_i  (/*  */),
    .pc_i       (pc_i),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (RSaddr),
    .RTaddr_i   (RTaddr),
    .RDaddr_i   (RDaddr), 
    .RDdata_i   (MUX_Regdata.data_o),
    .RegWrite_i (/*  */), 
    .RSdata_o   (/*  */), 
    .RTdata_o   (/*  */) 
);

Data_Memory Data_Memory(
	.MemWrite_i	(Control.MemWrite_o),
    .addr_i		(ALU.data_o),
	.MemRead_i	(Control.MemRead_o),
	.data_i		(Registers.RTdata_o),
	.data_o		()
);

MUX32 MUX_Regdata(
	.data1_i	(ALU.data_o),
	.data2_i	(Data_Memory.data_o),
	.select_i	(Control.MemtoReg_o),
	.data_o		()
);

MUX5 MUX_RegDst(
    .data1_i    (RTaddr),
    .data2_i    (inst[15:11]),
    .select_i   (/*  */),
    .data_o     (RDaddr)
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Signed_Extend.data_o),
    .select_i   (/*  */),
    .data_o     (/*  */)
);

Signed_Extend Signed_Extend(
    .data_i     (imme),
	.ExtOp_i	(Control.ExtOp_o),
    .data_o     (/*  */)
);

ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (/*  */),
    .Zero_o     (/*  */)
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (/*  */),
    .ALUCtrl_o  (/*  */)
);

Fowarding_Unit Fowarding_Unit(
    .EXRegRs_i      (/*  */),
    .EXRegRt_i      (/*  */),
    .MEMRegRd_i     (/*  */),
    .MEMRegWrite_i  (/*  */),
    .WBRegRd_i      (/*  */),
    .WBRegWrite_i   (/*  */),
    .FowardA_o      (/*  */),
    .FowardB_o      (/*  */)
);

IF_ID IF_ID(
    .Flush_i (/*  */),
    .Clock_i (clk_i),
    .IFID_i  (/*  */),
    .PC4_i   (pcAdd4),
    .Inst_i  (Instruction_Memory.instr_o),
    .PC4_o   (/* I think this is for exception control module */),
    .Inst_o  (inst)
);

MUX32 ID_EX_Flush(
    .data1_i    ({Control.RegWrite_o, Control.MemtoReg_o, Control.MemRead_o, Control.MemWrite_o, Control.ALUSrc_o, Control.ALUOp_o, Control.RegDst_o}),
                /* WB[1]               WB[0]               M[1]                M[0]                 EX[3]           EX[2:1]            EX[0] */ 
    .data2_i    (32'b0),
    .select_i   (/* Flush or not */),
    .data_o     ({ID_EX.WB_i, ID_EX.M_i, ID_EX.EX_i})
);

ID_EX ID_EX(
    .Clock_i     (clk_i),
    .WB_i        (),
    .M_i         (),
    .EX_i        (),
    .Data1_i     (/*  */),
    .Data2_i     (/*  */),
    .Immediate_i (/*  */),
    .RegRs_i     (/*  */),
    .RegRt_i     (/*  */),
    .RegRd_i     (/*  */),
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

EX_MEM EX_MEM(
    .Clock_i     (clk_i),
    .WB_i        (/*  */),
    .M_i         (/*  */),
    .ALU_i       (/*  */),
    .RegRd_i     (/*  */),
    .WriteData_i (/*  */),
    .WB_o        (/*  */),
    .M_o         (/*  */),
    .ALU_o       (/*  */),
    .RegRd_o     (/*  */),
    .WriteData_o (/*  */)
);

MEM_WB MEM_WB(
    .Clock_i (clk_i),
    .WB_i    (/*  */),
    .MEM_i   (/*  */),
    .ALU_i   (/*  */),
    .RegRd_i (/*  */),
    .WB_o    (/*  */),
    .MEM_o   (/*  */),
    .ALU_o   (/*  */),
    .RegRd_o (/*  */)
);

endmodule

