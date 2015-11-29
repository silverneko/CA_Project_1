module Data_Memory
(
	MemWrite_i,
    addr_i,
	MemRead_i,
	data_i,
	data_o
);

// Interface
input	MemWrite_i, MemRead_i;
input   [31:0]      addr_i;
input   [31:0] 		data_i;
output  [31:0]      data_o;
reg		[31:0]		data_o;

// Data memory
reg     [31:0]     memory  [0:255];


always@(MemRead_i or MemWrite_i or addr_i or data_i) begin
	if(MemWrite_i) begin
		memory[addr_i >> 2] = data_i;
	end
	else if(MemRead_i) begin
		data_o = memory[addr_i >> 2];
	end
end

endmodule

