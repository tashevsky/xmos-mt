module rv_timer
#(
    parameter DATA_WIDTH=64
)
(
    input                     clk,
    input                     rst,
    output [DATA_WIDTH - 1:0] timer
);
    reg [(DATA_WIDTH-1):0] cnt;

    always@(posedge clk or negedge rst) begin
        if (!rst)
            cnt <= 64'h0;
        else
            cnt <= cnt + 1'b1;
    end
    
    assign timer = cnt;
endmodule