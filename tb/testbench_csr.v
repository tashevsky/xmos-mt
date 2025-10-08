`timescale 1ns/100ps

module testbench_csr;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 12;

    reg clk;
    reg rst_n;
    reg en;

    // CSR_PORT_A [W]
    reg [ADDR_WIDTH - 1:0] csr_addr_in;
    reg [DATA_WIDTH - 1:0] csr_in;
    reg csr_wr;

    // CSR_PORT_B [R]
    reg  [ADDR_WIDTH - 1:0] csr_addr_out;
    wire [DATA_WIDTH - 1:0] csr_out;
                             
    rv_csr dut(
        // CTL
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        // CSR_PORT_A [W]
        .csr_addr_in(csr_addr_in),
        .csr_in(csr_in),
        // CSR_PORT_B [R]
        .csr_addr_out(csr_addr_out),
        .csr_out(csr_out)
    );

    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        en = 1'b1;

        csr_addr_in = 0;
        csr_in = 0;
        csr_wr = 0;
        csr_addr_out = 0;

        $monitor("[CSR_WR] ADDR=%h DATA=%h WE=%b\n", csr_addr_in, csr_in, csr_wr,
            "[CSR_RD] ADDR=%h DATA_OUT=%h", 
             csr_addr_out, csr_out);

        $dumpvars;

        forever begin
            if (clk) $display("Next cycle");
            #1 clk = ~clk;
        end
    end

    initial begin
        #2; rst_n = 1; #2;

        // Test mcycle
        csr_addr_out = 'hB00;
        #10;
        
        // Test misa
        csr_addr_out = 'h300;
        #4;
        $finish;
    end
endmodule