module Fowarding_Unit(
    EXRegRs_i,
    EXRegRt_i,
    MEMRegRd_i,
    MEMRegWrite_i,
    WBRegRd_i,
    WBRegWrite_i,
    FowardA_o,
    FowardB_o
);

input [4:0] EXRegRs_i, EXRegRt_i, MEMRegRd_i, WBRegRd_i;
input MEMRegWrite_i, WBRegWrite_i;

output [1:0] FowardA_o, FowardB_o;

reg [1:0] FowardA_o, FowardB_o;

always@(EXRegRs_i, MEMRegRd_i, MEMRegWrite_i, WBRegRd_i, WBRegWrite_i)
begin
    if(MEMRegWrite_i && MEMRegRd_i != 0 && MEMRegRd_i == EXRegRs_i)
        FowardA_o = 2'b10;
    else if(WBRegWrite_i && WBRegRd_i != 0 && WBRegRd_i == EXRegRs_i)
        FowardA_o = 2'b01;
    else
        FowardA_o = 2'b00;
end

always@(EXRegRt_i, MEMRegRd_i, MEMRegWrite_i, WBRegRd_i, WBRegWrite_i)
begin
    if(MEMRegWrite_i && MEMRegRd_i != 0 && MEMRegRd_i == EXRegRt_i)
        FowardB_o = 2'b10;
    else if(WBRegWrite_i && WBRegRd_i != 0 && WBRegRd_i == EXRegRt_i)
        FowardB_o = 2'b01;
    else
        FowardB_o = 2'b00;
end

endmodule;