module rv_csr
#(
    parameter DATA_WIDTH = 32, 
    parameter ADDR_WIDTH = 12
)
(
    input                         clk,
    input                         rst_n,
    input                         en,

    // CSR_PORT_A [W]
    input      [ADDR_WIDTH - 1:0] csr_addr_in,
    input      [DATA_WIDTH - 1:0] csr_in,
    input                         csr_wr,

    // CSR_PORT_B [R]
    input      [ADDR_WIDTH - 1:0] csr_addr_out,
    output reg [DATA_WIDTH - 1:0] csr_out
);
    // According to the RISC-V ISA Standard, CSR Block size is 4K.
    localparam RISCV_CSR_MBLOCK_SIZE = 4096;
    
    // CSR Internal Values Block
    reg [DATA_WIDTH - 1:0] csr_memory_block [0:RISCV_CSR_MBLOCK_SIZE - 1];

    // CSR Permissions (Protection) Block
    reg /* one-bit protection */ csr_protection_block [0:RISCV_CSR_MBLOCK_SIZE - 1];

    // Initialize CSR registers
    initial begin
        $readmemb("csr_map.txt", csr_memory_block, 0, RISCV_CSR_MBLOCK_SIZE - 1);
    end

    // Initialize CSR protection flags
    initial begin
        $readmemb("csr_protection.txt", csr_protection_block, 0, RISCV_CSR_MBLOCK_SIZE - 1);
    end

    // Illegal Instruction Flag is raised on invalid CSR write
    (* noprune *) reg illegal_instruction_flag;
   
    // CSR Read/Write Protection Bit
    reg csr_rw_bit;

    // HPM Cycle Counter (mcycle CSR)
    wire [31:0] hpm_mcycle_counter_ret;

    rv_hpm_mcycle hpm_mcycle_counter (
        .clk(clk),
        .rst_n(rst_n),
        .clk_cnt(hpm_mcycle_counter_ret)
    );

    reg [DATA_WIDTH - 1:0] csr_mblock_out;

    always @(posedge clk) begin
        if (en) begin
            // CSR Write
            if (csr_wr) begin
                // Select CSR
                csr_rw_bit <= csr_protection_block[csr_addr_in];

                // Check Write Permissions
                if (~csr_rw_bit) begin
                    illegal_instruction_flag <= 1'b1;
                end
                else begin
                    illegal_instruction_flag <= 1'b0;
                    csr_memory_block[csr_addr_in] <= csr_in;
                end
            end

            csr_mblock_out <= csr_memory_block[csr_addr_out];
        end
    end

    always @(*) begin
        if (en) begin
            case (csr_addr_out)
                // mcycle CSR
                12'hB00:
                    csr_out = hpm_mcycle_counter_ret;
                
                // another CSR
                default:
                    csr_out = csr_mblock_out;
            endcase
        end
    end
endmodule