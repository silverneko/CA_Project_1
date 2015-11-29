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
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'b100),
    .data_o     (/*  */)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
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
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (/*  */), 
    .RSdata_o   (/*  */), 
    .RTdata_o   (/*  */) 
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
    .data_o     (/*  */)
);

ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (/*  */),
    .Zero_o     (/* xxx */)
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (/*  */),
    .ALUCtrl_o  (/*  */)
);

endmodule

