module rv_hart_table
#(
  parameter DATA_WIDTH=4, 
  parameter ADDR_WIDTH=3
  )
( input clk,
  input [(ADDR_WIDTH-1):0] h_addr,
  output reg [(DATA_WIDTH-1):0] h_out,

//  input [(ADDR_WIDTH-1):0] d_addr,
//  output reg [(DATA_WIDTH-1):0] d_out,
//  input [(DATA_WIDTH-1):0] d_in,
  input we,
  input en
);
// ROM array
reg [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1] ;

// read ROM content from file
initial
$readmemh("hart_table.txt",rom);
/*
always @ (posedge clk)
  begin
    if (en&we) rom[d_addr] <= d_in;
  end
// */
always @ (*)
  begin
    h_out <= rom[h_addr];
    //d_out <= rom[d_addr];
  end

endmodule