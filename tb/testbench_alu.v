`timescale 1ns/100ps

module testbench;
  reg  [31:0] inst;
//wire [31:0] imm;    
  reg [6:0] opcode;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [31:0] Op1;
  reg [31:0] Op2;
  wire [31:0] Rez;

// creating the instance of the module we want to test    
//  bcd_to_sseg - module name    
//  dut  - instance name ('dut' means 'device under test')    
rv_alu_v dut( opcode, funct3, funct7, Op1, Op2, Rez);    
// do at the beginning of the simulation    
initial         
  begin            
/*
    assisn opcode[6:0] = inst[6:0];
    // rs1 <= inst[19:15];
    // rs2 <= inst[24:20];
    // rd <= inst[11:7];
    funct3 <= inst[14:12];
    funct7 <= inst[31:25]; // */

    Op1 <= 32'h3; Op2 <= 32'h2;

    inst = 32'h50b7;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause            
    inst = 32'h0137;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause            
    inst = 32'h508193;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause            
    inst = 32'h502083;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause        
    inst = 32'hfe000ce3;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause        
    inst = 32'h77237;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause        
    inst = 32'hc0d093;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause        
    inst = 32'hff9ff2ef;    // set test signals value            
    opcode[6:0] = inst[6:0]; funct3 <= inst[14:12]; funct7 <= inst[31:25];
    #10;            // pause        

  end    // do at the beginning of the simulation    
//  print signal values on every change    
initial         
  $monitor("inst=%h op=%h f3=%h f7=%h %h %h rez=%h", inst, opcode, funct3, funct7, Op1, Op2, Rez);    
// do at the beginning of the simulation    
initial         
  $dumpvars;  //iverilog dump init
endmodule
