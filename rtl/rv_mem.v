module rv_mem
#(
    parameter DATA_WIDTH = 32, 
    parameter ADDR_WIDTH = 10
)
(
    input                     clk,

    // Instruction Memory
    input  [DATA_WIDTH - 1:0] i_addr,
    output [DATA_WIDTH - 1:0] code_out,

    // Data Memory
    input                     we,
    input                     en,
    input  [DATA_WIDTH - 1:0] d_addr,
    input  [DATA_WIDTH - 1:0] d_in,
    output [DATA_WIDTH - 1:0] d_out
);
    wire d_write_ena = we & en;

    rv_multiport_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram (
        .clk(clk),
        // PORT_A
        .port_a_addr(i_addr),
        .port_a_out(code_out),
        // PORT_B
        .port_b_addr(d_addr),
        .port_b_out(d_out),
        .port_b_in(d_in),
        .port_b_we(d_write_ena)
    );
endmodule