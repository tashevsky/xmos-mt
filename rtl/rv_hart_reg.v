//`define WIDTH 256
module rv_hart_reg
#(
  parameter WIDTH=4
  )
(
  input clk,
  input rst,
  input en,
  input  [WIDTH - 1:0] h_in,
  output reg [WIDTH - 1:0] h_out
);

// reg [WIDTH-1:0] r_reg;
always@(posedge clk or negedge rst)
  begin
    if(!rst)
      h_out <= 0;
    else
      if(en) begin h_out <= h_in; end
    end

endmodule