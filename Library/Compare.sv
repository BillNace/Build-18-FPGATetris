module compare
  #(parameter 	W = 8)
  (output logic AltB, AeqB, AgtB,
   input  logic [W-1:0] a, b);

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