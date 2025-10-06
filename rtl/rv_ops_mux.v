module rv_ops_mux
#(
    parameter WIDTH = 32
)
( 
    input      [6:0]  opcode,
    input      [2:0]  funct3,
    input      [6:0]  funct7,
    input      [31:0] Rs1,
    input      [31:0] Rs2,
    input      [31:0] imm,
    input      [31:0] PC,
    input      [31:0] CSR,
    output reg [31:0] Op1,
    output reg [31:0] Op2
);
    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00000_11: begin
                // load data from mem
                Op1 = Rs1;
                Op2 = imm;
            end
            7'b00011_11: begin
                // fence
                Op1 = Rs1;
                Op2 = CSR;
            end
            7'b00100_11: begin
                Op1 = Rs1;
                Op2 = imm;
            end
            7'b01100_11: begin
                // reg with reg operations
                Op1 = Rs1;
                Op2 = Rs2;
            end
            7'b11100_11: begin
                // mret - system return
                case (funct3)
                    3'h2: begin
                        Op1 = Rs1;
                        Op2 = CSR;
                    end
                    3'h3: begin
                        Op1 = Rs1;
                        Op2 = CSR;
                    end
                    3'h6: begin
                        Op1 = CSR;
                        Op2 = imm;
                    end
                    3'h7: begin
                        Op1 = CSR;
                        Op2 = imm;
                    end
                    default: begin
                        Op1 = Rs1;
                        Op2 = CSR;
                    end
                endcase
            end
            7'b11001_11: begin
                // Relative (rs1) jump and link in register
                case (funct3)
                    3'h0: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    default: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                endcase
            end

            /// J-type instructions
            7'b11011_11: begin
                // pc relative jump and link in register
                Op1 = PC;
                Op2 = imm;
            end
            
            /// S-type instructions
            7'b01000_11: begin
                // store register value in memory
                case (funct3)
                    3'h0: begin
                        Op1 = Rs1;
                        Op2 = imm;
                    end
                    3'h1: begin
                        Op1 = Rs1;
                        Op2 = imm;
                    end
                    3'h2: begin
                        Op1 = Rs1;
                        Op2 = imm;
                    end
                    default: begin
                        Op1 = Rs1;
                        Op2 = imm;
                    end
                endcase
            end
            
            /// U-type instructions
            7'b01101_11: begin
                // load upper immediate
                Op1 = Rs1;
                Op2 = imm;
            end
            7'b00101_11: begin
                // add upper immediate to PC
                case (funct3)
                    3'h0: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    default: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                endcase
            end

            /// B-type instructions
            7'b11000_11 : begin
                // conditional PC relative branch - PC+imm
                case (funct3)
                    3'h0: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    3'h1: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    3'h4: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    3'h5: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    3'h6: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    3'h7: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                    default: begin
                        Op1 = PC;
                        Op2 = imm;
                    end
                endcase
            end

            default: begin
                // ???
                Op1 = Rs1;
                Op2 = Rs2;
            end
        endcase
    end
endmodule