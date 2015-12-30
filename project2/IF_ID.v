module IF_ID(
    Flush_i,
    Clock_i,
    IFID_i,
    PC4_i,
    Inst_i,
    PC4_o,
    Inst_o
);

input Flush_i, Clock_i, IFID_i;
input [31:0] PC4_i, Inst_i;
output [31:0] PC4_o, Inst_o;

reg [31:0] PC4_o, Inst_o;

initial begin
    PC4_o = 0;
    Inst_o = 0;
end

always@(posedge Clock_i)
begin
    if(Flush_i)
    begin
        PC4_o = 0;
        Inst_o = 0;
    end
    else if(IFID_i)
    begin
        PC4_o <= PC4_i;
        Inst_o <= Inst_i;
    end
end

endmodule