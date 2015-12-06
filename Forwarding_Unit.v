module Forwarding_Unit(
    EXRegRs_i,
    EXRegRt_i,
    MEMRegRd_i,
    MEMRegWrite_i,
    WBRegRd_i,
    WBRegWrite_i,
    ForwardA_o,
    ForwardB_o
);

input [4:0] EXRegRs_i, EXRegRt_i, MEMRegRd_i, WBRegRd_i;
input MEMRegWrite_i, WBRegWrite_i;

output [1:0] ForwardA_o, ForwardB_o;

reg [1:0] ForwardA_o, ForwardB_o;

always@(EXRegRs_i, MEMRegRd_i, MEMRegWrite_i, WBRegRd_i, WBRegWrite_i)
begin
    if(MEMRegWrite_i && MEMRegRd_i != 0 && MEMRegRd_i == EXRegRs_i)
        ForwardA_o = 2'b10;
    else if(WBRegWrite_i && WBRegRd_i != 0 && WBRegRd_i == EXRegRs_i)
        ForwardA_o = 2'b01;
    else
        ForwardA_o = 2'b00;
end

always@(EXRegRt_i, MEMRegRd_i, MEMRegWrite_i, WBRegRd_i, WBRegWrite_i)
begin
    if(MEMRegWrite_i && MEMRegRd_i != 0 && MEMRegRd_i == EXRegRt_i)
        ForwardB_o = 2'b10;
    else if(WBRegWrite_i && WBRegRd_i != 0 && WBRegRd_i == EXRegRt_i)
        ForwardB_o = 2'b01;
    else
        ForwardB_o = 2'b00;
end

endmodule;