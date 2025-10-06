module rv_pc
#(
    parameter WIDTH = 32
)
(
    input              clk,
    input              rst_n,
    input              en,
    input              pc_load,
    input  [WIDTH-1:0] pc_next,

    input  [2:0]       hart_in,
    input  [2:0]       hart_out,
    
    output [WIDTH-1:0] pc,
    output [WIDTH-1:0] pc_plus
);
    reg [WIDTH-1:0] pc_reg [0:7];

    // read initial PCs data values
    initial
        $readmemh("rv_pc_init.txt", pc_reg);

    always @(posedge clk /* or negedge rst_n */)
        if (en) begin
            if (pc_load)
                pc_reg[hart_in] <= pc_next;
            else
                pc_reg[hart_in] <= pc_reg[hart_in] + 3'h4;
        end

    assign pc = pc_reg[hart_out];
    assign pc_plus = pc_reg[hart_out] + 3'h4;
endmodule