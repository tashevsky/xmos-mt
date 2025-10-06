        case (funct3)
            3'h0: begin Rez = Op1; end
            3'h1: begin Rez = Op1; end
            3'h2: begin Rez = Op1 | Op2; end
            3'h3: begin Rez = Op1 & (~Op2); end
            3'h4: begin Rez = Op1; end
            3'h5: begin Rez = Op1; end
            3'h6: begin Rez = Op1 | Op2; end
            3'h7: begin Rez = Op1 & (~Op2); end
            default: begin Rez = Op1; end
        endcase
