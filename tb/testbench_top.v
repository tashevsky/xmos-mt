`timescale 1ns/100ps

module testbench;
   reg        clk;
   reg        rst_n;
   wire [31:0] D_out;
   integer    seq_len;
   
   rv_cpu_top top
   (
         // Inputs
         .clk(clk),
         .rst(rst_n),
         // Outputs
         .Data_out(D_out)
   ); 
   
   initial begin
      clk = 0;
      rst_n  = 1'b0;
      forever #2 clk = ~clk;
   end

   task async_rst;
      begin
         $display("---------- Start async_reset at %0t ns ----------\n",$time);
         #13 rst_n  = 1'b0;
         #14 rst_n  = 1'b1;
         $display("---------- Finish async_reset at %0t ns ----------\n",$time);
      end
   endtask // async_rst
 
   initial begin
      $dumpvars();
      $monitor("Time= %0t ns\t LFSR= %d",$time,D_out);
      rst_n    = 1'b0;
      seq_len  = 0;
      async_rst();
      //#20
      //Max len sequence detect
      forever 
      begin
        @(negedge clk)
          begin
             seq_len = seq_len+1;
             if(seq_len == 10'd100)begin
                $display("---------- Sequence lenght =%0d ----------\n",seq_len);        
                $finish;
             end
          end
      end
   end
   
endmodule // testbench
