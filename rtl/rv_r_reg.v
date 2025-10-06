//`define WIDTH 256
module rv_r_reg
#(
    parameter WIDTH = 256
)
(
    input                    clk,
    input                    rst_n,
    input                    en,
    input      [WIDTH - 1:0] r_in,
    output reg [WIDTH - 1:0] r_out
);
    // reg [WIDTH-1:0] r_reg;

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r_out <= 0;
        else
            if(en)
                r_out <= r_in;
    end
endmodule