module Control(
    Op_i,
    RegDst_o,
	Jump_o,
	Branch_o,
	MemRead_o,
	MemtoReg_o,
	ExtOp_o,
    ALUOp_o,
	MemWrite_o,
    ALUSrc_o,
    RegWrite_o
);

input	[5:0]	Op_i;
output	RegDst_o, Jump_o, Branch_o, MemRead_o, MemtoReg_o, MemWrite_o, ALUSrc_o, RegWrite_o, ExtOp_o;
output	[1:0]	ALUOp_o;

reg RegDst_o, Jump_o, Branch_o, MemRead_o, MemtoReg_o, MemWrite_o, ALUSrc_o, RegWrite_o, ExtOp_o;
reg	[1:0]	ALUOp_o;

`define	r_type	6'b000000
`define	ori		6'b001101
`define	addi	6'b001000
`define j		6'b000010
`define beq		6'b000100
`define lw 		6'b100011
`define sw 		6'b101011

always@(Op_i) begin
	case(Op_i)
		`r_type	: begin
			RegDst_o = 1;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemWrite_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			ALUOp_o  = 2'b11;
		end
		`ori	: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemWrite_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			ExtOp_o = 0;
			ALUOp_o  = 2'b10;
		end
		`addi	: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemWrite_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			ExtOp_o = 1;
			ALUOp_o  = 2'b00;
		end
		`j		: begin
			RegWrite_o = 0;
			MemWrite_o = 0;
			Branch_o = 0;
			Jump_o = 1;
		end
		`beq	: begin
			ALUSrc_o = 0;
			RegWrite_o = 0;
			MemWrite_o = 0;
			Branch_o = 1;
			Jump_o = 0;
			ALUOp_o  = 2'b01;
		end
		`lw		: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemWrite_o = 0;
			Branch_o = 0;
			Jump_o = 0;
			ExtOp_o = 1;
			ALUOp_o  = 2'b00;
		end
		`sw		: begin
			ALUSrc_o = 1;
			RegWrite_o = 0;
			MemWrite_o = 1;
			Branch_o = 0;
			Jump_o = 0;
			ExtOp_o = 1;
			ALUOp_o  = 2'b00;
		end
	endcase
end

endmodule