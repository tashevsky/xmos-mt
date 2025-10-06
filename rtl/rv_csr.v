module rv_csr
#(
    parameter DATA_WIDTH = 32, 
    parameter ADDR_WIDTH = 12,
    parameter CSR_size = 32
)
(
    input                         clk,
    input      [ADDR_WIDTH - 1:0] csr_addr_in,
    input      [DATA_WIDTH - 1:0] csr_in,
    input      [ADDR_WIDTH - 1:0] csr_addr_out,
    output reg [DATA_WIDTH - 1:0] csr_out,
    input                         csr_wr,
    input                         en
);
    // csr register file
    reg [ADDR_WIDTH - 1:0] csr_reg [0:CSR_size - 1];

    always @(posedge clk) begin
        case (csr_addr_in)
            32'h0: begin
                if (csr_wr & en) begin
                    csr_reg[0] <= csr_in;
                end 
            end

            default: begin
                csr_reg[1] <= 32'h555;
            end
        endcase

        case (csr_addr_out)
            32'h0: begin
                csr_out <= csr_reg[0];
            end

            default: begin
                csr_out <= 32'hAAA;
            end
        endcase
    end
endmodule