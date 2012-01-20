module gameclock
 #(parameter WIDTH = 23)
  (output logic CLK_game,
   input  logic CLK_50M,
   input  logic rst);
	
	// a 1/8 second clock (8Hz) is a divide by 6_250_000 which is 2^22.5
	// A divide by 2^22 clock would be 11.92 Hz clock
  logic [WIDTH-1:0] q;

  assign CLK_game = q[WIDTH-1];

  always_ff @(posedge CLK_50M, posedge rst) begin
    if (rst)
      q <= 0;
    else
      q <= q + 1;
  end
	 
endmodule : gameclock
  
module test_gameclock;

  logic clk_in, clk_out, rst;

  gameclock #(3) dut(clk_out, clk_in, rst);
    
  initial begin
    clk_in = 0;
    rst    = 1;
    #1 rst = 0;
	 #200 $finish;
  end
  
  initial forever begin
    #1
	 clk_in = ~clk_in;
  end
  
endmodule : test_gameclock