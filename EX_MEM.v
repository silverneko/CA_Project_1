module EX_MEM(
    Clock_i,
    WB_i,
    M_i,
    ALU_i,
    RegRd_i,
    WriteData_i,
    WB_o,
    M_o,
    ALU_o,
    RegRd_o,
    WriteData_o
);

input Clock_i;
input [1:0] WB_i;
input [2:0] M_i;
input [4:0] RegRd_i;
input [31:0] ALU_i, WriteData_i;

output [1:0] WB_o;
output [2:0] M_o;
output [4:0] RegRd_o;
output [31:0] ALU_o, WriteData_o;

reg [1:0] WB_o;
reg [2:0] M_o;
reg [4:0] RegRd_o;
reg [31:0] ALU_o, WriteData_o;

initial begin
    WB_o = 0;
    M_o = 0;
    RegRd_o = 0;
    ALU_o = 0;
    WriteData_o = 0;
end

always@(posedge Clock_i)
begin
    WB_o <= WB_i;
    M_o <= M_i;
    RegRd_o <= RegRd_i;
    ALU_o <= ALU_i;
    WriteData_o <= WriteData_i;
end

endmodule