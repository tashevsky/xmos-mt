module rv_hpm_mcycle (
    input         clk,
    input         rst_n,

    output [31:0] clk_cnt
);
    reg [31:0] cnt;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 32'b0;
        else
            cnt <= cnt + 1;
    end

    assign clk_cnt = cnt;
endmodule