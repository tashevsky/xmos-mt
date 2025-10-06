module rv_alu
( 
    input      [6:0]  opcode,
    input      [31:0] Rs1,
    input      [31:0] Rs2,
    input      [2:0]  funct3,
    input      [6:0]  funct7,
    input      [31:0] imm,
    input      [31:0] pc,
    output reg [31:0] Rd,
    output reg        rg,
    output reg        addr,
    output reg [31:0] PC_next
);

    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00100_11 : begin
                rg = 1'b1;
                addr = 1'b0;
                PC_next = pc + 3'h4;
                case (funct3)
                    3'b000: Rd = Rs1 + imm;
                    3'b001: Rd = Rs1 << imm;
                    3'b010: Rd = (Rs1 < imm) ? 1 : 0;
                    3'b011: Rd = ({1'b0,Rs1}<{1'b0,imm}) ? 1 : 0;
                    3'b100: Rd = Rs1 ^ imm;
                    3'b101: Rd = (funct7[5]) ? (Rs1 >> imm) : (Rs1 >>> imm);
                    3'b110: Rd = Rs1 | imm;
                    3'b111: Rd = Rs1 & imm;
                    default: ;
                endcase
            end
            
            /// R-type instructions
            7'b01100_11 : begin
                rg = 1'b1;
                addr = 1'b0;
                PC_next = pc + 3'h4;

                case (funct3)
                    3'b000 : Rd = (funct7[5]) ? (Rs1 - Rs2) : (Rs1 + Rs2);
                    //3'b000: Rd = Rs1 + Rs2;
                    3'b001 : Rd = Rs1 << Rs2;
                    3'b010 : Rd = (Rs1<Rs2) ? 1 : 0;
                    3'b011 : Rd = ({1'b0,Rs1}<{1'b0,Rs2}) ? 1 : 0;
                    3'b100 : Rd = Rs1 ^ Rs2;
                    3'b101 : Rd = (funct7[5]) ? (Rs1 >> Rs2) : (Rs1 >>> Rs2);
                    3'b110 : Rd = Rs1 | Rs2;
                    3'b111 : Rd = Rs1 & Rs2;
                    //default : ;
                endcase
            end
            7'b00000_11 : begin
                rg = 1'b0;
                addr = 1'b1;
                PC_next = pc + 3'h4;

                case (funct3)
                    3'b000: Rd = Rs1 + imm;
                    3'b001: Rd = Rs1 + imm;
                    3'b010: Rd = Rs1 + imm;
                    //3'b011
                    3'b100: Rd = Rs1 + imm;
                    3'b101: Rd = Rs1 + imm;
                    //3'b110
                    //3'b111
                    default: ;
                endcase
            end
            7'b11001_11 : begin
                rg = 1'b1;
                addr = 1'b0; 
                PC_next = Rs1 + imm;
                Rd = pc + 3'h4;
            end

            7'b11000_11 : begin
                rg = 1'b0;
                addr = 1'b0;
                // PC_next = pc + 3'h4;
                case (funct3)
                    3'b000: PC_next = (Rs1 == Rs2) ? (pc+imm):(pc+3'h4);
                    3'b001: PC_next = (Rs1 != Rs2) ? (pc+imm):(pc+3'h4);
                    //3'b010 :
                    //3'b011 :
                    3'b100: PC_next = (Rs1 < Rs2) ? (pc+imm):(pc+3'h4);
                    3'b101: PC_next = (Rs1 > Rs2) ? (pc+imm):(pc+3'h4);
                    3'b110: PC_next = ({1'b0,Rs1} < {1'b0,Rs2}) ? (pc+imm):(pc+3'h4);
                    3'b111: PC_next = ({1'b0,Rs1} > {1'b0,Rs2}) ? (pc+imm):(pc+3'h4);
                    default : ;
                endcase
            end
            7'b01000_11 : begin
                rg = 1'b0;
                addr = 1'b1;
                PC_next = pc + 3'h4;
                case (funct3)
                    3'b000: Rd = Rs1 + imm;
                    3'b001: Rd = Rs1 + imm;
                    3'b010: Rd = Rs1 + imm;
                    //3'b011
                    //3'b100 : Rd = Rs1 + imm;
                    //3'b101 : Rd = Rs1 + imm;
                    //3'b110
                    //3'b111
                    default: ;
                endcase
            end
            7'b11001_11: begin
                rg = 1'b1;
                addr = 1'b0; 
                PC_next = pc + 3'h4;
                Rd = imm;
            end
            7'b11001_11: begin
                rg = 1'b1;
                addr = 1'b0; 
                PC_next = pc + 3'h4;
                Rd = pc + imm;
            end
            7'b11001_11: begin
                rg = 1'b1;
                addr = 1'b0; 
                PC_next = pc + imm;
                Rd = pc + 3'h4; 
            end
            default: begin
                rg = 1'b0;
                addr = 1'b0; 
                PC_next = pc + 3'h4;
            end
        endcase
    end
endmodule