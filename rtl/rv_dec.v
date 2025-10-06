module rv_dec
(
    input  [31:0]    inst,

    output reg [6:0] opcode,
    output reg [4:0] rs1,
    output reg       rs1_en,
    output reg [4:0] rs2,
    output reg       rs2_en,
    output reg [4:0] rd,
    output reg       rd_wr,
    output reg [2:0] funct3,
    output reg       f3_en,
    output reg [6:0] funct7,
    output reg       f7_en,
    output reg       mem_en,
    output reg       mem_wr,
    output reg       csr_en,
    output reg       csr_wr,
    output reg       pc_load
);
    always @(*) begin
        opcode [6:0] = inst[6:0];
        rs1          = inst[19:15];
        rs2          = inst[24:20];
        rd           = inst[11:7];
        funct3       = inst[14:12];
        funct7       = inst[31:25];
    end
    
    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00000_11: begin
                // load data from mem
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b1;
                f3_en   = 1'b1;
                f7_en   = 1'b0;
                mem_en  = 1'b1;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            7'b00011_11: begin
                // fence
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b1;
                f3_en   = 1'b1;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            7'b00100_11: begin
                // reg with immediate operations
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b1;
                f3_en   = 1'b1;
                f7_en   = 1'b1;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            7'b01100_11: begin
                // reg with reg operations
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b1;
                f3_en   = 1'b1;
                f7_en   = 1'b1;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            7'b11100_11: begin
                // mret - system return
                rs1_en = 1'b0;
                rs2_en = 1'b0;
                rd_wr  = 1'b0;
                f3_en  = 1'b1;
                f7_en  = 1'b0;
                mem_en = 1'b0;
                mem_wr = 1'b0;

                csr_en = (funct3 == 3'b000);
                csr_wr = (funct3 == 3'b000);

                pc_load = 1'b0;
            end
            7'b11001_11: begin
                // Relative (rs1) jump and link in register
                rs1_en  = 1'b1;
                rs2_en  = 1'b0;
                rd_wr   = 1'b1;
                f3_en   = 1'b0;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b1;
            end

            /// J-type instructions
            7'b11011_11: begin
                // pc relative jump and link in register
                rs1_en  = 1'b0;
                rs2_en  = 1'b0;
                rd_wr   = 1'b1;
                f3_en   = 1'b0;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b1;
            end

            /// S-type instructions
            7'b01000_11: begin
                // store register value in memory
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b0;
                f3_en   = 1'b1;
                f7_en   = 1'b0;
                mem_en  = 1'b1;
                mem_wr  = 1'b1;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            
            // U-type instructions
            7'b01101_11: begin
                // load upper immediate
                rs1_en  = 1'b0;
                rs2_en  = 1'b0;
                rd_wr   = 1'b1;
                f3_en   = 1'b0;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            7'b00101_11: begin
                // add upper immediate to PC
                rs1_en  = 1'b0;
                rs2_en  = 1'b0;
                rd_wr   = 1'b1;
                f3_en   = 1'b0;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
            
            /// B-type instructions
            7'b11000_11: begin
                // conditional PC relative branch - PC+imm
                rs1_en  = 1'b1;
                rs2_en  = 1'b1;
                rd_wr   = 1'b0;
                f3_en   = 1'b1;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b1; // must be 'AND' with compatator output signal
            end
            default: begin
                rs1_en  = 1'b0;
                rs2_en  = 1'b0;
                rd_wr   = 1'b0;
                f3_en   = 1'b0;
                f7_en   = 1'b0;
                mem_en  = 1'b0;
                mem_wr  = 1'b0;
                csr_en  = 1'b0;
                csr_wr  = 1'b0;
                pc_load = 1'b0;
            end
        endcase
    end
endmodule