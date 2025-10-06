// TODO: REFACTOR THIS ENTIRE MODULE
module rv_imm
(
    input      [31:0] inst,
    output reg [31:0] imm
);
    wire [6:0] opcode;
    wire [19:0] sign;
    // wire zero;

    assign opcode[6:0] = inst[6:0];
    
    assign sign = {
        /// R U SERIOUS??
        inst[31],inst[31],inst[31],inst[31],inst[31],//inst[31],
        inst[31],inst[31],inst[31],inst[31],inst[31],//inst[31],
        inst[31],inst[31],inst[31],inst[31],inst[31],//inst[31],
        inst[31],inst[31],inst[31],inst[31],inst[31]//,inst[31]
    };

    //assign zero = 1'b0;

    always @(*) begin
        case (opcode)
            /// I-type instructions
            7'b00000_11: begin
                imm = {sign,inst[31:20]};
            end
            7'b00011_11: begin
                imm = {sign,inst[31:20]};
            end
            7'b00100_11: begin
                imm = {sign,inst[31:20]};
            end
            7'b11100_11: begin
                imm = {sign,inst[31:20]};
            end
            7'b11001_11: begin
                imm = {sign,inst[31:20]};
            end
            
            /// J-type instructions
            7'b11011_11: begin
                imm = {sign[19:8],inst[19:12],inst[20],inst[30:25],inst[24:21],1'b0};
            end

            /// S-type instructions
            7'b01000_11: begin
                imm = {sign,inst[31:25],inst[11:7]}; 
            end

            /// U-type instrucitons
            7'b01101_11: begin
                imm = {inst[31:12],12'b0};
            end
            7'b00101_11: begin 
                imm = {inst[31],inst[30:20],inst[19:12],12'b0};
            end

            /// B-type instructions
            7'b11000_11 : begin
                imm = {sign,inst[7],inst[30:25],inst[11:8],1'b0};
            end

            default: begin
                imm = 32'h00;
            end
        endcase
    end
endmodule