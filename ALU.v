module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input	[31:0]	data1_i, data2_i;
input	[2:0]	ALUCtrl_i;
output	[31:0]	data_o;
output	Zero_o;

reg	[31:0]	data_o;
reg Zero_o;

`define op_add	3'b010
`define op_mul	3'b011
`define	op_subs 3'b110
`define	op_or 	3'b001
`define op_and	3'b000
`define	op_solt	3'b111

always@(data1_i or data2_i or ALUCtrl_i) begin
	case(ALUCtrl_i)
		`op_add:	data_o = data1_i + data2_i;
		`op_mul:	data_o = data1_i * data2_i;
		`op_subs:	data_o = data1_i - data2_i;
		`op_or:		data_o = data1_i | data2_i;
		`op_and:	data_o = data1_i & data2_i;
		`op_solt:	begin
			if(data1_i < data2_i)
				data_o = 32'b1;
			else
				data_o = 32'b0;
		end
	endcase
	if(data_o == 32'b0)
		Zero_o = 1;
	else
		Zero_o = 0;
end

endmodule