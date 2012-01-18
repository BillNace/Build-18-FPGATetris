module ShiftReg_PISO_Right 
  #(parameter W = 8)
  (output logic ser_out,
   input  logic [W-1:0] d,
   input  logic clk, load, enable);

  logic [W-1:0] q;

  assign ser_out = q[0];

  always_ff @(posedge clk)
  begin
    if (load)
      q <= d;
    else if (enable)
      begin
        q <= {1'b0, q[W-1:1]};
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