module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input 	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;

reg	[2:0]	ALUCtrl_o;

`define r_type		2'b11
`define op_or		2'b10
`define op_add		2'b00
`define	op_subs		2'b01

always@(funct_i or ALUOp_i) begin
	case(ALUOp_i)
		`op_add:	begin
			ALUCtrl_o = 3'b010;
		end
		`op_subs:	begin
			ALUCtrl_o = 3'b110;
		end
		`op_or:		begin
			ALUCtrl_o = 3'b001;
		end
		`r_type:	begin
			case(funct_i)
				6'b100000:	ALUCtrl_o = 3'b010;
				6'b100010:	ALUCtrl_o = 3'b110;
				6'b100100:	ALUCtrl_o = 3'b000;
				6'b100101:	ALUCtrl_o = 3'b001;
				6'b101010:	ALUCtrl_o = 3'b111;
				6'b011000:	ALUCtrl_o = 3'b011;
			endcase
		end
	endcase
end

endmodule