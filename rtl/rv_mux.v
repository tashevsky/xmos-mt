module rv_mux
#(
    parameter WIDTH=32
)
(
    input              addr,
    input  [WIDTH-1:0] MemData,
    input  [WIDTH-1:0] RegData,
    output [WIDTH-1:0] Rd
);
    assign Rd = addr ? MemData : RegData;
endmodule