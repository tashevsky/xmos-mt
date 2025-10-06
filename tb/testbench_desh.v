`include "rv_desh.v"
`timescale 10ns/1ns
/*
  input [31:0] inst,
  output reg [6:0] opcode,
  output reg [4:0] rs1,
  output reg rs1_en,
  output reg [4:0] rs2,
  output reg rs2_en,
  output reg [4:0] rd,
  output reg rd_en,
  output reg [2:0] funct3,
  output reg f3_en,
  output reg [6:0] funct7,
  output reg f7_en
  output reg mem_en,
  output reg mem_wr,
  output reg csr_en,
  output reg csr_wr,
  output reg pc_load
*/ 
module testbench; // input and output test signals
reg  [31:0] inst;
  wire [6:0] opcode;
  wire [4:0] rs1;
  wire rs1_en;
  wire [4:0] rs2;
  wire rs2_en;
  wire [4:0] rd;
  wire rd_en;
  wire [2:0] funct3;
  wire f3_en;
  wire [6:0] funct7;
  wire f7_en;
  wire mem_en;
  wire mem_wr;
  wire csr_en;
  wire csr_wr;
  wire pc_load;
  
// creating the instance of the module we want to test    
//  dut  - instance name ('dut' means 'device under test')    
rv_desh dut( inst, opcode, rs1, rs1_en, rs2, rs2_en, rd, rd_en, funct3, f3_en, funct7, f7_en,
  mem_en, mem_wr, csr_en, csr_wr, pc_load );    
// do at the beginning of the simulation    
initial         
  begin            
    inst = 32'h50b7;    // set test signals value            
    #10;            // pause            
    inst = 32'h0137;    // set test signals value            
    #10;            // pause            
    inst = 32'h508193;    // set test signals value            
    #10;            // pause            
    inst = 32'h502083;    // set test signals value            
    #10;            // pause        
    inst = 32'hfe000ce3;    // set test signals value            
    #10;            // pause        
    inst = 32'h77237;    // set test signals value            
    #10;            // pause        
    inst = 32'hc0d093;    // set test signals value            
    #10;            // pause        
    inst = 32'hff9ff2ef;    // set test signals value            
    #10;            // pause        

  end    // do at the beginning of the simulation    
//  print signal values on every change    
initial         
  $monitor("inst=%h op=%b %h %h %h %h %h %h %h %h %h %h", inst, opcode, rs1_en, rs2_en, rd_en, f3_en, f7_en, mem_en, mem_wr, csr_en, csr_wr, pc_load);    
// do at the beginning of the simulation    
initial         
  $dumpvars;  //iverilog dump init
endmodule
