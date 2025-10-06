`include "rv_imm.v"
`timescale 10ns/1ns
/*
  input [31:0] inst,
  output reg [31:0] imm
*/ 
module testbench; // input and output test signals
reg  [31:0] inst;
wire [31:0] imm;    
// creating the instance of the module we want to test    
//  bcd_to_sseg - module name    
//  dut  - instance name ('dut' means 'device under test')    
rv_imm dut( inst, imm );    
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
  $monitor("inst=%h imm=%h", inst, imm);    
// do at the beginning of the simulation    
initial         
  $dumpvars;  //iverilog dump init
endmodule
