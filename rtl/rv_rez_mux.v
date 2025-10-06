module rv_rez_mux
#(
parameter WIDTH=32
)
( 
  input      [6:0]       opcode,
  input      [2:0]       funct3,
  input      [6:0]       funct7,
  input      [WIDTH-1:0] Rez,
  input      [WIDTH-1:0] Pc_plus,
  input      [WIDTH-1:0] Mem_data,
  input      [WIDTH-1:0] Imm,
  output reg [WIDTH-1:0] Rd
);
    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00000_11: begin
                // load data from mem
                Rd = Rez;
            end
            7'b00011_11 : begin
                // fence
                Rd = Rez;
            end
            7'b00100_11: begin
                // reg with immediate operations
                Rd = Rez;
            end
            7'b00100_11: begin
                // reg with reg operations
                Rd = Rez;
            end
            7'b11100_11: begin
                // mret - system return
                Rd = Rez;
            end
            7'b11001_11: begin
                // Relative (rs1) jump and link in register
                Rd = Pc_plus;
            end

            /// J-type instructions
            7'b11011_11: begin
                // pc relative jump and link in register
                Rd = Pc_plus;
            end
            
            /// S-type instructions
            7'b01000_11: begin
                // store register value in memory
                Rd = Rez;
            end

            /// U-type instructions
            7'b01101_11: begin
                // load upper immediate
                Rd = Imm;
            end
            7'b00101_11: begin
                // add upper immediate to PC
                Rd = Rez;
            end
            
            /// B-type instructions
            7'b11000_11: begin
                // conditional PC relative branch - PC+imm
                Rd = Rez;
            end

            default: begin
                Rd = Rez;
            end
        endcase
    end
endmodule