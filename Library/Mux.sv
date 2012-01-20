module mux32
  #(parameter W = 8)
  (output logic [W-1:0] out,
   input  logic [W-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, 
   input  logic [W-1:0] in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31,
   input  logic [4:0] select);
   
  always_comb
    unique case (select)
      5'd0: out = in0;
      5'd1: out = in1;
      5'd2: out = in2;
      5'd3: out = in3;
      5'd4: out = in4;
      5'd5: out = in5;
      5'd6: out = in6;
      5'd7: out = in7;
      5'd8: out = in8;
      5'd9: out = in9;
      5'd10: out = in10;
      5'd11: out = in11;
      5'd12: out = in12;
      5'd13: out = in13;
      5'd14: out = in14;
      5'd15: out = in15;
      5'd16: out = in16;
      5'd17: out = in17;
      5'd18: out = in18;
      5'd19: out = in19;
      5'd20: out = in20;
      5'd21: out = in21;
      5'd22: out = in22;
      5'd23: out = in23;
      5'd24: out = in24;
      5'd25: out = in25;
      5'd26: out = in26;
      5'd27: out = in27;
      5'd28: out = in28;
      5'd29: out = in29;
      5'd30: out = in30;
      5'd31: out = in31;
    endcase

endmodule : mux32

module demux32
  #(parameter W = 8)
  (input  logic [W-1:0] in,
   input  logic [4:0] select,
   output logic [W-1:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, 
   output logic [W-1:0] out9, out10, out11, out12, out13, out14, out15, out16, 
   output logic [W-1:0] out17, out18, out19, out20, out21, out22, out23, out24, 
   output logic [W-1:0] out25, out26, out27, out28, out29, out30, out31);
   
  logic [W-1:0] zero = 'd0;
  
  assign out0 = (select  == 5'd0) ? in : zero;
  assign out1 = (select  == 5'd1) ? in : zero;
  assign out2 = (select  == 5'd2) ? in : zero;
  assign out3 = (select  == 5'd3) ? in : zero;
  assign out4 = (select  == 5'd4) ? in : zero;
  assign out5 = (select  == 5'd5) ? in : zero;
  assign out6 = (select  == 5'd6) ? in : zero;
  assign out7 = (select  == 5'd7) ? in : zero;
  assign out8 = (select  == 5'd8) ? in : zero;
  assign out9 = (select  == 5'd9) ? in : zero;
  assign out10 = (select == 5'd10) ? in : zero;
  assign out11 = (select == 5'd11) ? in : zero;
  assign out12 = (select == 5'd12) ? in : zero;
  assign out13 = (select == 5'd13) ? in : zero;
  assign out14 = (select == 5'd14) ? in : zero;
  assign out15 = (select == 5'd15) ? in : zero;
  assign out16 = (select == 5'd16) ? in : zero;
  assign out17 = (select == 5'd17) ? in : zero;
  assign out18 = (select == 5'd18) ? in : zero;
  assign out19 = (select == 5'd19) ? in : zero;
  assign out20 = (select == 5'd20) ? in : zero;
  assign out21 = (select == 5'd21) ? in : zero;
  assign out22 = (select == 5'd22) ? in : zero;
  assign out23 = (select == 5'd23) ? in : zero;
  assign out24 = (select == 5'd24) ? in : zero;
  assign out25 = (select == 5'd25) ? in : zero;
  assign out26 = (select == 5'd26) ? in : zero;
  assign out27 = (select == 5'd27) ? in : zero;
  assign out28 = (select == 5'd28) ? in : zero;
  assign out29 = (select == 5'd29) ? in : zero;
  assign out30 = (select == 5'd30) ? in : zero;
  assign out31 = (select == 5'd31) ? in : zero;

endmodule : demux32

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