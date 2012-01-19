module gameclock
  (input  logic CLK_50M,
   output logic CLK_game);
	
	// a 1/8 second clock (8Hz) is a divide by 6_250_000 which is 2^22.5
	// A divide by 2^22 clock would be 11.92 Hz clock
  logic [22:0] q;

  assign CLK_game = q[22];

  always_ff @(posedge CLK_50M) begin
    q <= q + 1;
  end
	 
endmodule : gameclock
  
  