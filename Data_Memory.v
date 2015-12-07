module Data_Memory
(
  Clock_i,
	MemWrite_i,
    addr_i,
	MemRead_i,
	data_i,
	data_o
);

// Interface
input   Clock_i;
input	  MemWrite_i, MemRead_i;
input   [31:0]      addr_i;
input   [31:0] 		data_i;
output  [31:0]      data_o;
reg		[31:0]		data_o;

// Data memory
reg     [7:0]     memory  [0:31];


always@(MemWrite_i or MemRead_i or addr_i or data_i) begin
	if(MemWrite_i) begin
		{memory[addr_i + 3], memory[addr_i + 2], memory[addr_i + 1], memory[addr_i]} = data_i;
	end
	else if(MemRead_i) begin
		data_o = {memory[addr_i + 3], memory[addr_i + 2], memory[addr_i + 1], memory[addr_i]};
	end
end

endmodule

