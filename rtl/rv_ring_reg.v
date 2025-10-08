module rv_ring_reg
#(
    parameter WIDTH = 7
)
(
    input               clk,
    input               rst_n,
    output [WIDTH - 1:0] L_en
);
    reg [WIDTH-1:0] ring;

    wire head = ring [WIDTH - 1];
    wire [WIDTH - 2:0] tail = ring [WIDTH - 2:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ring <= 8'b00000001;
        else
            ring <= {tail, head};
    end
    
    assign L_en = ring;
endmodule