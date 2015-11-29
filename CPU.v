module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire	[31:0] inst_addr, inst;

assign inst_addr = PC.pc_o;
assign inst = Instruction_Memory.instr_o;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (MUX_RegDst.select_i),
	.Jump_o		(),
	.Branch_o	(),
	.MemRead_o	(),
	.MemtoReg_o	(),
	.ExtOp_o	(),
    .ALUOp_o    (ALU_Control.ALUOp_i),
	.MemWrite_o	(),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);

assign Jump_addr = {Add_PC.data_o[31:28], inst[25:0], 2'b00};

MUX32 MUX_PC_Jump(
	.data1_i	(MUX_PCSrc.data_o),
	.data2_i	(Jump_addr),
	.select_i	(Control.Jump_o),
	.data_o		()
);

assign PCSrc = Control.Branch_o & ALU.Zero_o;

MUX32 MUX_PCSrc(
	.data1_i    (Add_PC.data_o), // 0
    .data2_i    (Add_PC_Branch.data_o), // 1
    .select_i   (PCSrc),
    .data_o     (/*  */)
);

Adder Add_PC_Branch(
	.data1_i	(Add_PC.data_o),
	.data2_i	(Signed_Extend.data_o),
	.data_o		()
);

Adder Add_PC(
    .data1_i   	(inst_addr),
    .data2_i  	(32'b100),
    .data_o     (/*  */)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (MUX_PC_Jump.data_o),
    .pc_o       (/*  */)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (/*  */)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o), 
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
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (/*  */),
    .data_o     (/*  */)
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Signed_Extend.data_o),
    .select_i   (/*  */),
    .data_o     (/*  */)
);

Signed_Extend Signed_Extend(
    .data_i     (inst[15:0]),
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

endmodule

