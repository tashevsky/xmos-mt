`timescale 1ns/100ps

module testbench_multiport_ram;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 10;

    reg clk;

    // [RO] PORT_A
    reg  [DATA_WIDTH - 1:0] port_a_addr;
    wire [DATA_WIDTH - 1:0] port_a_out;

    // [RW] PORT_B
    reg  [DATA_WIDTH - 1:0] port_b_addr;
    reg  [DATA_WIDTH - 1:0] port_b_in;
    reg                     port_b_we;
    wire [DATA_WIDTH - 1:0] port_b_out;

    rv_multiport_ram dut(
        .clk(clk),
        .port_a_addr(port_a_addr),
        .port_a_out(port_a_out),
        .port_b_addr(port_b_addr),
        .port_b_we(port_b_we),
        .port_b_in(port_b_in),
        .port_b_out(port_b_out)
    );

    initial begin
        clk = 1'b0;
        port_a_addr = 0;
        port_b_addr = 0;
        port_b_in = 'hx;
        port_b_we = 0;

        $monitor("[PORT_A] ADDR=%h DATA=%h\n", port_a_addr, port_a_out,
            "[PORT_B] ADDR=%h DATA_IN=%h DATA_OUT=%h WE_LINE=%b", 
             port_b_addr, port_b_in, port_b_out, port_b_we);

        $dumpvars;

        forever begin
            if (clk) $display("Next cycle");
            #1 clk = ~clk;
        end
    end

    initial begin
        port_a_addr = 0;
        port_b_addr = 'h4;
        port_b_in = 'hC;
        port_b_we = 1'b1;
        #2;

        port_a_addr = 'h4;
        port_b_addr = 20;
        port_b_in = 'hx;
        port_b_we = 1'b0;

        #2;
        $finish;
    end
endmodule