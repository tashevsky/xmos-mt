`timescale 1ns/100ps

module testbench;
    reg clk;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    wire [31:0] Rs1_out;
    wire [31:0] Rs2_out;
    reg [31:0] Rd_input;
    reg we;

    rv_reg_file dut(
        clk,
        rs1,
        rs2,
        rd,
        Rs1_out,
        Rs2_out,
        Rd_input,
        we
    );    
    
    integer i;

    initial begin
        clk = 1'b0; rs1 = 5'h00; rs2 = 5'h01; rd = 5'h02; we=1'b0;
        #10;
        i = 0;
        rs1 <= #i 5'h00; rs2 <= #i 5'h01; rd <= #i 5'h02; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20;
        rs1 <= #i 5'h01; rs2 <= #i 5'h01; rd <= #i 5'h01; Rd_input <= #i 32'h77; we <= #i 1'b0; i = i + 20; //we = 1'b1;
        rs1 <= #i 5'h02; rs2 <= #i 5'h01; rd <= #i 5'h02; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20; //we = 1'b1;
        rs1 <= #i 5'h03; rs2 <= #i 5'h02; rd <= #i 5'h03; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20;
        rs1 <= #i 5'h04; rs2 <= #i 5'h04; rd <= #i 5'h04; Rd_input <= #i 32'h01; we <= #i 1'b1; i = i + 20; 
        rs1 <= #i 5'h05; rs2 <= #i 5'h04; rd <= #i 5'h05; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20; //we = 1'b0;
        rs1 <= #i 5'h00; rs2 <= #i 5'h01; rd <= #i 5'h06; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20; 
        rs1 <= #i 5'h00; rs2 <= #i 5'h01; rd <= #i 5'h07; Rd_input <= #i 32'h01; we <= #i 1'b0; i = i + 20;

        for(i=0; i < 80; i = i+1)
            #10 clk = ~clk;
    end

    initial
        $monitor("Rs1=%h Rs2=%h ",
                Rs2_out, Rs2_out);    
    initial         
        $dumpvars;  //iverilog dump init
endmodule