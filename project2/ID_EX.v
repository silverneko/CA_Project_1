module ID_EX(
    stall_i,
    Clock_i,
    WB_i,
    M_i,
    EX_i,
    Data1_i,
    Data2_i,
    Immediate_i,
    RegRs_i,
    RegRt_i,
    RegRd_i,
    WB_o,
    M_o,
    EX_o,
    Data1_o,
    Data2_o,
    Immediate_o,
    RegRs_o,
    RegRt_o,
    RegRd_o
);

input				   stall_i;
input Clock_i;
input [1:0] WB_i;
input [1:0] M_i;
input [3:0] EX_i;
input [4:0] RegRs_i, RegRt_i, RegRd_i;
input [31:0] Data1_i, Data2_i, Immediate_i;

output [1:0] WB_o;
output [1:0] M_o;
output [3:0] EX_o;
output [4:0] RegRs_o, RegRt_o, RegRd_o;
output [31:0] Data1_o, Data2_o, Immediate_o;

reg [1:0] WB_o;
reg [1:0] M_o;
reg [3:0] EX_o;
reg [4:0] RegRs_o, RegRt_o, RegRd_o;
reg [31:0] Data1_o, Data2_o, Immediate_o;

initial begin
    WB_o = 0;
    M_o = 0;
    EX_o = 0;
    Data1_o = 0;
    Data2_o = 0;
    Immediate_o = 0;
    RegRs_o = 0;
    RegRt_o = 0;
    RegRd_o = 0;
end

always@(posedge Clock_i)
begin
    if(stall_i) begin
    end else begin
    WB_o <= WB_i;
    M_o <= M_i;
    EX_o <= EX_i;
    Data1_o <= Data1_i;
    Data2_o <= Data2_i;
    Immediate_o <= Immediate_i;
    RegRs_o <= RegRs_i;
    RegRt_o <= RegRt_i;
    RegRd_o <= RegRd_i;
    end
end

endmodule