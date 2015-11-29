module Control(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input	[5:0]	Op_i;
output	RegDst_o;
output	[1:0]	ALUOp_o;
output	ALUSrc_o;
output 	RegWrite_o;

reg	RegDst_o;
reg	[1:0]	ALUOp_o;
reg ALUSrc_o;
reg RegWrite_o;

`define	r_type	6'b000000
`define	add_i	6'b001000

always@(Op_i) begin
	case(Op_i)
		`r_type	: begin
			RegDst_o = 1;
			ALUOp_o  = 2'b11;
			ALUSrc_o = 0;
			RegWrite_o = 1;
		end
		`add_i	: begin
			RegDst_o = 0;
			ALUOp_o  = 2'b00;
			ALUSrc_o = 1;
			RegWrite_o = 1;
		end
		default	: begin
		end
	endcase
end

endmodule