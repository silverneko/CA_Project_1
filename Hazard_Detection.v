module Hazard_Detection(
    IFIDRegRs_i,
    IFIDRegRt_i,
    IDEXMemRead_i,
    IDEXRegRt_i,
    pcWrite_o,
    IFID_o,
    MuxSelect_o
);

input IDEXMemRead_i;
input [4:0] IFIDRegRs_i, IFIDRegRt_i, IDEXRegRt_i;
output pcWrite_o, IFID_o, MuxSelect_o;

reg pcWrite_o, IFID_o, MuxSelect_o;

always@(IFIDRegRs_i, IFIDRegRt_i, IDEXMemRead_i, IDEXRegRt_i)
begin
    if(IDEXMemRead_i && (IDEXRegRt_i == IFIDRegRs_i || IDEXRegRt_i == IFIDRegRt_i))
    begin
        pcWrite_o = 0;
        IFID_o = 0;
        MuxSelect_o = 1;
    end
    else
    begin
        pcWrite_o = 1;
        IFID_o = 1;
        MuxSelect_o = 1;
    end
end


endmodule