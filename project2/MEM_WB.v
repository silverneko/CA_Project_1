module MEM_WB(
    stall_i,
    Clock_i,
    WB_i,
    MEM_i,
    ALU_i,
    RegRd_i,
    WB_o,
    MEM_o,
    ALU_o,
    RegRd_o
);

input				   stall_i;
input Clock_i;
input [1:0] WB_i;
input [4:0] RegRd_i;
input [31:0] MEM_i, ALU_i;

output [1:0] WB_o;
output [4:0] RegRd_o;
output [31:0] MEM_o, ALU_o;

reg [1:0] WB_o;
reg [4:0] RegRd_o;
reg [31:0] MEM_o, ALU_o;

initial begin
    WB_o = 0;
    RegRd_o = 0;
    MEM_o = 0;
    ALU_o = 0;
end

always@(posedge Clock_i)
begin
    if(stall_i) begin
    end else begin
    WB_o <= WB_i;
    RegRd_o <= RegRd_i;
    MEM_o <= MEM_i;
    ALU_o <= ALU_i;
    end
end

endmodule