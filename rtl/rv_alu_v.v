module rv_alu_v
#(
    parameter WIDTH=32
)
( 
    input      [6:0]  opcode,
    input      [2:0]  funct3,
    input      [6:0]  funct7,
    input      [31:0] Op1,
    input      [31:0] Op2,
    output reg [31:0] Rez
);
    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00000_11: begin
                // load data from mem
                Rez = Op1 + Op2;
            end
            7'b00011_11: begin
                // fence
                Rez = Op1;
            end
            7'b00100_11: begin
                // reg with immediate operations

                // TODO: REMOVE INCLUDE-COPY
                `include "alu_op_base.v"
            end
            7'b01100_11: begin
                // reg with reg operations
                $display("OP-REG");

                // TODO: REMOVE INCLUDE-COPY
                `include "alu_op_base.v"
            end
            7'b11100_11: begin
                // mret - system return
                $display("RET_SYST or CSR");

                // TODO: REMOVE INCLUDE-COPY
                `include "alu_op_CSR.v"
            end
            7'b11001_11: begin
                // Relative (rs1) jump and link in register

                Rez = Op1 + Op2;
            end

            /// J-type instructions
            7'b11011_11: begin
                // pc relative jump and link in register
                Rez = Op1 + Op2;
            end

            /// S-type insructions
            7'b01000_11: begin
                // store register value in memory
                Rez = Op1 + Op2;
            end

            /// U-type instruction
            7'b01101_11: begin
                // load upper immediate
                Rez = Op1;
            end
            7'b00101_11: begin
                // add upper immediate to PC
                Rez = Op1 + Op2;
                end

            /// B-type instruction
            7'b11000_11: begin
                // conditional PC relative branch - PC+imm
                Rez = Op1 + Op2;
            end
            
            default: begin
                Rez = Op1;
            end
        endcase
    end
endmodule