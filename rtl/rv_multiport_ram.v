module rv_multiport_ram
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)
(
    input                         clk,

    // [RO] PORT_A
    input      [DATA_WIDTH - 1:0] port_a_addr,
    output reg [DATA_WIDTH - 1:0] port_a_out,

    // [RW] PORT_B
    input      [DATA_WIDTH - 1:0] port_b_addr,
    input      [DATA_WIDTH - 1:0] port_b_in,
    input                         port_b_we,
    output reg [DATA_WIDTH - 1:0] port_b_out
);
    // Memory block
    reg [DATA_WIDTH - 1:0] mem [0:2**ADDR_WIDTH - 1];

    // Init ROM content from file
    initial
        $readmemh("rom.txt", mem, 0, 39);

    // Truncate memory address bits    
    wire [ADDR_WIDTH - 1:0] port_a_addr_trunc = port_a_addr [ADDR_WIDTH - 1:0];
    wire [ADDR_WIDTH - 1:0] port_b_addr_trunc = port_b_addr [ADDR_WIDTH - 1:0];

    // SYNC_MEM Multiport Inferred Block
    always @(posedge clk) begin
        // PORT_A
        port_a_out <= mem[port_a_addr_trunc];

        // PORT_B
        if (port_b_we)
            mem[port_b_addr] <= port_b_in;
        else
            port_b_out <= mem[port_b_addr_trunc];
    end
endmodule