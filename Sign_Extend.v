module Signed_Extend(
    data_i,
	ExtOp_i,
    data_o
);

input	[15:0]	data_i;
input			ExtOp_i;
output 	[31:0]	data_o;

reg 	[31:0]	data_o;

always@(data_i or ExtOp_i) begin
	if(ExtOp_i)
		data_o = {{16{data_i[15]}}, data_i};
	else
		data_o = {16'b0, data_i};
end

endmodule