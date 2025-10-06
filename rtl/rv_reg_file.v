module rv_reg_file
#(
    parameter DATA_WIDTH = 32
)
(
    input                         clk,

    input      [4:0]              rs1,
    input      [4:0]              rs2,
    input      [4:0]              rd,

    output reg [DATA_WIDTH - 1:0] Rs1_out,
    output reg [DATA_WIDTH - 1:0] Rs2_out,
    input      [DATA_WIDTH - 1:0] Rd_input,

    input                         we,
    input                         en,

    input      [2:0]              hart_in,
    input      [2:0]              hart_out
);
    // x0 - x31 array
    reg [DATA_WIDTH - 1:0] mem [0:31][0:7];

    wire x0_preserve_flag = rd != 5'b0;

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin: x0_init
            mem[0][i] = 32'b0;
        end
    end

    always @(posedge clk) begin
        if (en & we & x0_preserve_flag)
            mem[rd][hart_out] <= Rd_input;
        
        Rs1_out <= mem[rs1][hart_out];
        Rs2_out <= mem[rs2][hart_out];
    end
endmodule