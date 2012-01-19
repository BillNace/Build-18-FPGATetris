module counter
  #(parameter 	W = 4)
   (input  logic clk, clear,
    input  logic enable,
    output logic [W-1:0] q);

  always_ff @(posedge clk) 
    begin
      if (clear)
        q <= 0;
      else if (enable) 
        q <= q+1;
    end

endmodule: counter

module test_counter();

  logic clk, clear, enable;
  logic [3:0] q;
  
  counter dut (.*);
  
  initial begin
    clk = 0;
    forever #1 clk = ~ clk;
  end
  
  initial begin
    $monitor($time,,"CLR:%b EN:%b Q:%b", clear, enable, q);
    clear = 0; enable = 0; 
    #4 clear = 1;
    #5 clear = 0;
    #5 enable = 1;
    #40 $finish;
  end
  
endmodule : test_counter

// Asynchronous load, synchronous enable
module counter_loadable
  #(parameter 	W = 4)
   (input  logic clk, load,
    input  logic enable,
	 input  logic [W-1:0] d,
    output logic [W-1:0] q);

  always_ff @(posedge clk, posedge load) 
    begin
      if (load)
        q <= d;
      else if (enable) 
        q <= q+1;
    end

endmodule: counter_loadable