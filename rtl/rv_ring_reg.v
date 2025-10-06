module rv_ring_reg
#(
parameter WIDTH=7
)
(
  input clk,
  input rst_n,
  output  [WIDTH-1:0] L_en
);

reg [WIDTH-1:0] ring;
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      ring   <= 8'b00000001;
    else
      ring <= {ring[WIDTH-2:0],ring[WIDTH-1]};
    end
assign L_en = ring;
  
endmodule