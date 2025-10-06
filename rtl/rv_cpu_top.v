module rv_cpu_top
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)
(
    input                     clk,
    input                     rst,
    // input  [ADDR_WIDTH - 1:0] Data_In,
    output [DATA_WIDTH - 1:0] Data_out
);
    // CPU modules 

    //===============================================================
    wire [63:0] tmr_out;
    rv_timer tmr(
        .clk(clk),
        .rst(rst),
        .timer(tmr_out)
    );
    //===============================================================
    rv_hart_table hart_table(
        .clk(clk),
        .h_addr(tmr_out[2:0]),
        .h_out(hart0_out)
    );
    // ==============================================================
    wire [3:0] hart0_out;
    /*
    wire [3:0] hart0_out;
    rv_hart_reg H0(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .h_in(hart0_in),
    //.h_out(hart0_out)
    .h_out()
    ); */
    
    wire [3:0] hart1_out;
    rv_hart_reg H1(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart0_out),
        .h_out(hart1_out)
    );
    
    wire [3:0] hart2_out;
    rv_hart_reg H2(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart1_out),
        .h_out(hart2_out)
    );
    
    wire [3:0] hart3_out;
    rv_hart_reg H3(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart2_out),
        .h_out(hart3_out)
    );
    
    wire [3:0] hart4_out;
    rv_hart_reg H4(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart3_out),
        .h_out(hart4_out)
    );

    wire [3:0] hart5_out;
    rv_hart_reg H5(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart4_out),
        .h_out(hart5_out)
    );
    
    wire [3:0] hart6_out;
    rv_hart_reg H6(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .h_in(hart5_out),
        .h_out(hart6_out)
    );

    // ==============================================================
    
    // L0_R1
    wire [31:0]l0r1_PC;
    wire [31:0]l0r1_PCplus;
    wire [31:0]r1l1_PC;
    wire [31:0]r1l1_PCplus;

    rv_pc pc(
        .clk(clk),
        .rst_n(rst),
        //.en(hart0_out[3]),
        .en(hart6_out[3]),
        //  .en(1'b1),
        .pc_load(r6l6_PC_load),
        .pc_next(r6l6_Rez),
        .pc(l0r1_PC),
        .pc_plus(l0r1_PCplus),
        .hart_in(hart6_out[2:0]),
        //.hart_out(hart0_out[2:0])
        .hart_out(hart0_out[2:0])
    );

    wire [255:0] r1_in;
    assign r1_in = {l0r1_PC, l0r1_PCplus, 192'h0}; 
    wire [255:0] r1_out;
    wire [191:0] r1_null;
    assign {r1l1_PC, r1l1_PCplus, r1_null} = r1_out; 

    rv_r_reg R1(
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[0]),
        .en(1'b1),
        .r_in(r1_in),
        .r_out(r1_out)
    );

    // R1_L1
    wire [31:0] l1r2_iw;
    wire [31:0] l1r2_PC;
    wire [31:0] l1r2_PCplus;

    rv_mem mem(
        .clk(clk),
        .i_addr(r1l1_PC>>2),
        //.i_addr(l0r1_PC>>2),
        .code_out(l1r2_iw),
        .d_addr(r5l5_Rez>>2),
        .d_out(l5r6_Mem_data),
        .d_in(r5l5_Rs2_reg),
        .we(r5l5_mem_wr),
        .en(hart5_out[3])
        //.en(1'b1)
    );

    // L1_R2
    wire [31:0]r2l2_iw;
    wire [31:0]r2l2_PC;
    wire [31:0]r2l2_PCplus;

    wire [255:0] r2_in;
    wire [255:0] r2_out;
    assign r2_in = {l1r2_iw, r1l1_PC, r1l1_PCplus, 160'h0};
    //assign r2_in = {l1r2_iw, l0r1_PC, l0r1_PCplus, 160'h0};
    wire [159:0] r2_null;
    assign {r2l2_iw, r2l2_PC, r2l2_PCplus, r2_null} = r2_out;

    rv_r_reg R2 (
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[1]),
        .en(1'b1),
        .r_in(r2_in),
        .r_out(r2_out)
    );

    // L2_R3
    wire [4:0] l2r3_rs1;
    wire [4:0] l2r3_rs2;
    wire [6:0] l2r3_op;
    wire [2:0] l2r3_fn3;
    wire [6:0] l2r3_fn7;
    wire [4:0] l2r3_rd;
    wire l2r3_rd_wr;
    wire l2r3_mem_wr;
    wire l2r3_csr_wr;
    wire [31:0] l2r3_imm;
    wire [31:0] l2r3_PC;
    wire [31:0] l2r3_PCplus;

    rv_dec_pipe decoder (
        .inst(r2l2_iw),
        .opcode(l2r3_op),
        .rs1(l2r3_rs1),
        .rs1_en(),
        .rs2(l2r3_rs2),
        .rs2_en(),
        .rd(l2r3_rd),
        .rd_wr(l2r3_rd_wr),
        .funct3(l2r3_fn3),
        .f3_en(),
        .funct7(l2r3_fn7),
        .f7_en(),
        .mem_en(),
        .mem_wr(l2r3_mem_wr),
        .csr_en(),
        .csr_wr(l2r3_csr_wr),
        .pc_load(),
        .pipe_rst(~hart2_out[3])
    );
    
    rv_imm immed (
        .inst(r2l2_iw),
        .imm(l2r3_imm)
    );
    wire [4:0] r3l3_rs1;
    wire [4:0] r3l3_rs2;
    wire [6:0] r3l3_op;
    wire [2:0] r3l3_fn3;
    wire [6:0] r3l3_fn7;
    wire [4:0] r3l3_rd;
    wire r3l3_rd_wr;
    wire r3l3_mem_wr;
    wire r3l3_csr_wr;
    wire [31:0] r3l3_imm;
    wire [31:0] r3l3_PC;
    wire [31:0] r3l3_PCplus;

    wire [255:0] r3_in;
    wire [255:0] r3_out;
    assign r3_in = {l2r3_rs1, l2r3_rs2, l2r3_op, l2r3_fn3, l2r3_fn7, l2r3_rd, l2r3_rd_wr,
        l2r3_mem_wr, l2r3_csr_wr, l2r3_imm,  r2l2_PC, r2l2_PCplus, 125'h0};
    wire [124:0] r3_null;
    assign {r3l3_rs1, r3l3_rs2, r3l3_op, r3l3_fn3, r3l3_fn7, r3l3_rd, r3l3_rd_wr,
        r3l3_mem_wr, r3l3_csr_wr, r3l3_imm,  r3l3_PC, r3l3_PCplus, r3_null} = r3_out;

    rv_r_reg R3 (
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[2]),
        .en(1'b1),
        .r_in(r3_in),
        .r_out(r3_out)
    );

    //L3_R4
    wire [31:0] l3r4_Rs1_reg;
    wire [31:0] l3r4_Rs2_reg;
    wire [31:0] l3r4_CSR;

    rv_reg_file reg_file (
        .clk(~clk),
        .rs1(r3l3_rs1),
        .rs2(r3l3_rs2),
        .rd(r6l6_rd),
        .Rs1_out(l3r4_Rs1_reg),
        .Rs2_out(l3r4_Rs2_reg),
        .Rd_input(Rd_reg),
        .we(r6l6_rd_wr),
        .en(hart6_out[3]),
        .hart_in(hart6_out[2:0]),
        .hart_out(hart3_out[2:0])
        //  .hart_in(hart3_out[2:0]),
        // .hart_out(hart6_out[2:0])
        //.en(1'b1)
    );

    rv_csr csr (
        .clk(~clk),
        .csr_addr_out(r3l3_imm[11:0]),
        .csr_addr_in(r6l6_imm[11:0]),
        .csr_in(r6l6_Rez),
        .csr_out(l3r4_CSR),
        .csr_wr(r6l6_csr_wr),
        .en(hart6_out[3])
        //.en(1'b1)
    );

    assign Data_out = l3r4_CSR; // CSR;
    wire [31:0] r4l4_Rs1_reg;
    wire [31:0] r4l4_Rs2_reg;
    wire [6:0] r4l4_op;
    wire [2:0] r4l4_fn3;
    wire [6:0] r4l4_fn7;
    wire [4:0] r4l4_rd;
    wire r4l4_rd_wr;
    wire r4l4_mem_wr;
    wire r4l4_csr_wr;
    wire [31:0] r4l4_imm;
    wire [31:0] r4l4_PC;
    wire [31:0] r4l4_PCplus;
    wire [31:0] r4l4_CSR;

    wire [255:0] r4_in;
    wire [255:0] r4_out;
    assign r4_in = {l3r4_Rs1_reg, l3r4_Rs2_reg, r3l3_op, r3l3_fn3, r3l3_fn7, r3l3_rd, r3l3_rd_wr,
        r3l3_mem_wr, r3l3_csr_wr, r3l3_imm,  r3l3_PC, r3l3_PCplus, l3r4_CSR, 39'h0};
    wire [38:0] r4_null;
    assign {r4l4_Rs1_reg, r4l4_Rs2_reg, r4l4_op, r4l4_fn3, r4l4_fn7, r4l4_rd, r4l4_rd_wr,
        r4l4_mem_wr, r4l4_csr_wr, r4l4_imm,  r4l4_PC, r4l4_PCplus, r4l4_CSR, r4_null} = r4_out;

    rv_r_reg R4(
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[3]),
        .en(1'b1),
        .r_in(r4_in),
        .r_out(r4_out)
    );

    // L4
    wire [31:0] Op1;
    wire [31:0] Op2;

    rv_ops_mux ops_mux(
        .opcode(r4l4_op),
        .funct3(r4l4_fn3),
        .funct7(r4l4_fn7),
        .Rs1(r4l4_Rs1_reg),
        .Rs2(r4l4_Rs2_reg),
        .imm(r4l4_imm),
        .PC(r4l4_PC),
        .CSR(r4l4_CSR),
        .Op1(Op1),
        .Op2(Op2)
    );

    rv_cmp cmp(
        .opcode(r4l4_op),
        .funct3(r4l4_fn3),
        .Rs1(r4l4_Rs1_reg),
        .Rs2(r4l4_Rs2_reg),
        .pc_new(l4r5_PC_load)
    );

    rv_alu_v alu_v(
        .opcode(r4l4_op),
        .funct3(r4l4_fn3),
        .funct7(r4l4_fn7),
        .Op1(Op1),
        .Op2(Op2),
        .Rez(l4r5_Rez)
    );

    wire [31:0] l4r5_Rez;
    wire l4r5_PC_load;
    wire [31:0] r5l5_Rez;
    wire [31:0] r5l5_Rs2_reg;
    wire [6:0] r5l5_op;
    wire [2:0] r5l5_fn3;
    wire [6:0] r5l5_fn7;
    wire [4:0] r5l5_rd;
    wire r5l5_rd_wr;
    wire r5l5_mem_wr; 
    wire r5l5_csr_wr;
    wire [31:0] r5l5_imm;
    wire [31:0] r5l5_PC;
    wire [31:0] r5l5_PCplus;
    wire r5l5_PC_load;

    //L5
    wire [255:0] r5_in;
    wire [255:0] r5_out;
    assign r5_in = {l4r5_Rez, r4l4_Rs2_reg, r4l4_op, r4l4_fn3, r4l4_fn7, r4l4_rd, r4l4_rd_wr,
        r4l4_mem_wr, r4l4_csr_wr, r4l4_imm,  r4l4_PC, r4l4_PCplus, l4r5_PC_load, 70'h0};
    wire [69:0] r5_null;
    assign {r5l5_Rez, r5l5_Rs2_reg, r5l5_op, r5l5_fn3, r5l5_fn7, r5l5_rd, r5l5_rd_wr,
        r5l5_mem_wr, r5l5_csr_wr, r5l5_imm,  r5l5_PC, r5l5_PCplus, r5l5_PC_load, r5_null} = r5_out;

    rv_r_reg R5(
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[4]),
        .en(1'b1),
        .r_in(r5_in),
        .r_out(r5_out)
    );

    // L6
    wire [31:0] l5r6_Mem_data;
    wire [31:0] r6l6_Mem_data;
    wire [31:0] r6l6_Rez;
    wire [31:0] r6l6_Rs2_reg;
    wire [6:0] r6l6_op;
    wire [2:0] r6l6_fn3;
    wire [6:0] r6l6_fn7;
    wire [4:0] r6l6_rd;
    wire r6l6_rd_wr;
    wire r6l6_mem_wr;
    wire r6l6_csr_wr; 
    wire [31:0] r6l6_imm;
    wire [31:0] r6l6_PC;
    wire [31:0] r6l6_PCplus;
    wire r6l6_PC_load;

    wire [255:0] r6_in;
    wire [255:0] r6_out;
    assign r6_in = {l5r6_Mem_data, r5l5_Rez,  r5l5_op, r5l5_fn3, r5l5_fn7, r5l5_rd, r5l5_rd_wr,
        r5l5_mem_wr, r5l5_csr_wr, r5l5_imm,  r5l5_PC, r5l5_PCplus, r5l5_PC_load, 70'h0};
    
    wire [69:0] r6_null;
    assign {r6l6_Mem_data, r6l6_Rez, r6l6_op, r6l6_fn3, r6l6_fn7, r6l6_rd, r6l6_rd_wr,
        r6l6_mem_wr, r6l6_csr_wr, r6l6_imm,  r6l6_PC, r6l6_PCplus, r6l6_PC_load, r6_null} = r6_out;

    rv_r_reg R6 (
        .clk(clk),
        .rst_n(rst),
        //.en(en_level[5]),
        .en(1'b1),
        .r_in(r6_in),
        .r_out(r6_out)
    );
    
    // L7
    wire [31:0] Rd_reg;

    rv_rez_mux rez_mux (
        .opcode(r6l6_op),
        .funct3(r6l6_fn3),
        .funct7(r6l6_fn7),
        .Rez(r6l6_Rez),
        .Pc_plus(r6l6_PCplus),
        .Mem_data(r6l6_Mem_data),
        .Imm(r6l6_imm),
        .Rd(Rd_reg)
    );
endmodule