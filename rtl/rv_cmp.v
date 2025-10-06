module rv_cmp
(
    input      [6:0]  opcode,
    input      [2:0]  funct3,
    input      [31:0] Rs1,
    input      [31:0] Rs2,
    output reg        pc_new
);
    always @(*) begin
        case (opcode)
            7'b11011_11: begin
                pc_new = 1'b1;
            end
            7'b11001_11: begin
                pc_new = 1'b1;
            end
            7'b11100_11: begin
                pc_new = 1'b1;
            end
            7'b11000_11: begin
                // Relative (rs1) jump and link in register
                case (funct3)
                    3'h0: begin
                        pc_new = Rs1 == Rs2;
                    end
                    3'h1: begin
                        pc_new = Rs1 != Rs2;
                    end
                    3'h4: begin
                        pc_new = Rs1 < Rs2;
                    end
                    3'h5: begin
                        pc_new = Rs1 >= Rs2;
                    end
                    3'h6: begin
                        pc_new = {1'b0,Rs1} < {1'b0,Rs2};
                    end
                    3'h7: begin
                        pc_new = {1'b0,Rs1} >= {1'b0,Rs2};
                    end
                    default: begin
                        pc_new = 1'b0;
                    end
                endcase
            end
            default: begin
                pc_new = 1'b0;
            end
        endcase
    end
endmodule