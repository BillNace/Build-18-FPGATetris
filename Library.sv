module compare
  #(parameter 	w = 8)
  (output logic AltB, AeqB, AgtB,
   input  logic [w-1:0] a, b);

	assign AeqB = (a == b);
  assign AltB = (a < b);
  assign AgtB = (a > b);

endmodule: compare

module test_compare();

  logic AltB, AeqB, AgtB;
  logic [1:0] a, b;
  logic [2:0] acnt, bcnt;
  
  compare #(2) dut(.*);
  
  initial begin
    $monitor("A:%b B:%b ->> AltB(%b) AeqB(%b) AgtB(%b)", a, b, AltB, AeqB, AgtB);
    for (acnt = 0; acnt <= 3'b011; acnt++) 
      for (bcnt = 0; bcnt <= 3'b011; bcnt++) begin
        #1 a = acnt[1:0]; b = bcnt[1:0];
        end
    #1 $finish;
  end
endmodule : test_compare

module counter
  #(parameter 	w = 4)
   (input  logic clk, clear,
    input  logic enable,
    output logic [w-1:0] q);

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

module ShiftReg_PISO_Right 
  #(parameter w = 8)
  (output logic ser_out,
   input  logic [w-1:0] d,
   input  logic clk, load, enable);

  logic [w-1:0] q;

  assign ser_out = q[0];

  always_ff @(posedge clk)
  begin
    if (load)
      q <= d;
    else if (enable)
      begin
        q <= {1'b0, q[w-1:1]};
      end
  end

endmodule : ShiftReg_PISO_Right

module test_ShiftReg();

  logic q, clk, ld, sh;
  logic [7:0] d;
  
  ShiftReg_PISO_Right dut (q, d, clk, ld, sh);
  
  initial begin
    $monitor($time, , "D:%b Q:%b, clk:%b, LD:%b, EN:%b", d, q, clk, ld, sh);
    d = 8'b0; ld = 0; sh = 0;
    #4 d = 8'b10110000;
       ld = 1;
    #4 ld = 0;
    #4 sh = 1;
    #20 $finish;
  end
    
  initial begin
    clk = 0;
    forever #1 clk = ~ clk;
  end

endmodule : test_ShiftReg

module mux8
  #(parameter W = 8)
  (output logic [W-1:0] out,
   input  logic [W-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
	input  logic [2:0] select);
	
  always_comb begin
    casex(select)
      3'b000: out = in0;
      3'b001: out = in1;
      3'b010: out = in2;
      3'b011: out = in3;
      3'b100: out = in4;
      3'b101: out = in5;
      3'b110: out = in6;
      3'b111: out = in7;
    endcase
  end
  
endmodule: mux8

module mux2
  #(parameter W = 8)
  (output logic [W-1:0] out,
   input  logic [W-1:0] in0, in1,
	input  logic         select);

  assign out = (select) ? in1 : in0;
  
endmodule : mux2

module test_mux2();

  logic [7:0] in0, in1, out;
  logic       select;
  
  mux2 dut(out, in0, in1, select);
  
  initial begin
    in0 = 8'hCA;
	 in1 = 8'hFE;
	 select = 0;
	 #5
	 if (out == 8'hCA) $display("Passed 1");
	 select = 1;
	 #5
	 if (out == 8'hFE) $display("Passed 2");
	 $stop;
  end
  
endmodule : test_mux2

module is_in_box
  #(parameter START_X = 10,
	 parameter STOP_X  = 25,
    parameter START_Y = 20,
	 parameter STOP_Y  = 45,
	 parameter WIDTH   = 11)
  (input  logic [WIDTH-1:0] x,
   input  logic [WIDTH-1:0] y,
	 output logic             is_in);
	
  always_comb begin
    if ((x >= START_X) && 
	     (x <= STOP_X)  &&
		  (y >= START_Y) &&
		  (y <= STOP_Y))
      is_in = 1;
    else
      is_in = 0;
  end
  
endmodule : is_in_box

module test_is_in_box();

  logic [10:0] x, y;
  logic        is_in;
  
  is_in_box dut1(x, y, is_in);
  
  initial begin
    x = 11'd0; y = 11'd0; 
	  #5;
 	  if (~is_in) $display("Passed 1");
	  x = 11'd10;
	  #5;
	  if (~is_in) $display("Passed 2");
	  y = 11'd27;
	  #5
	  if ( is_in) $display("Passed 3");
	  #5
    $stop;
  end
  
  
endmodule : test_is_in_box
