        case (funct3)
            3'h0: begin 
                if (funct7 == 7'h20) begin Rez = Op1 - Op2; end
                else begin Rez = Op1 + Op2; end
                end
            3'h1: begin Rez = Op1 << Op2; end
            3'h2: begin Rez = (Op1 < Op2) ? 32'h1 : 32'h0; end
            3'h3: begin Rez = ({1'b0,Op1} < {1'b0,Op2}) ? 32'h1 : 32'h0; end
            3'h4: begin Rez = Op1 << Op2; end
            3'h5: begin  
                if (funct7 == 7'h20) begin Rez = Op1 >>> Op2; end
                else begin Rez = Op1 >> Op2; end
                end
            3'h6: begin Rez = Op1 | Op2; end
            3'h7: begin Rez = Op1 & Op2; end
            default: begin Rez = Op2; end
        endcase
