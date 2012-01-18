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