/*module tb();
  parameter N_WIDTH = 10;
  parameter D_WIDTH = 10;
  parameter N_MAX = (1<<N_WIDTH);
  parameter D_MAX = (1<<D_WIDTH);
  logic [N_WIDTH-1:0] numer;
  logic [D_WIDTH-1:0] denom;
  logic [N_WIDTH-1:0] quo;
  logic [D_WIDTH-1:0] remain;

  task divide(int n, int d);
    numer <= n;
    denom <= d;
    #1 if(denom*quo + remain != numer) begin
      $display("ERROR: %-d*%-d + %-d != %-d",denom,quo,remain,numer);
    end
    else begin
      $display("SUCCESS: %-d*%-d + %-d == %-d",denom,quo,remain,numer);

    end
  endtask

  initial begin
    int n, d;
    for(int i=0; i<20; i++) begin
      n = {$random} % N_MAX;
      d = ({$random} % (D_MAX-1)) + 1;
      divide(n,d); 
    end 
  end

  div #(.N_WIDTH(N_WIDTH), .D_WIDTH(D_WIDTH)) inst(.*);

endmodule
*/


module div(numer,denom,quo,remain);
  parameter N_WIDTH = 10;
  parameter D_WIDTH = 3;
  input [N_WIDTH-1:0] numer;
  input [D_WIDTH-1:0] denom;
  output logic [N_WIDTH-1:0] quo;
  output logic [D_WIDTH-1:0] remain;

/*
           a9, a8, a7, a6, a5, a4, a3, a2, a1, a0
          |--------------------------------------
{d2,d1,d0}|n9, n8, n7, n6, n5, n4, n3, n2, n1, n0

*/

 logic [N_WIDTH-1:0][D_WIDTH:0] cmp, sub;

 always_comb begin
   cmp[N_WIDTH-1] = { {{D_WIDTH}{1'b0}}  ,numer[N_WIDTH-1]};
   for(int i=N_WIDTH-1; i>0; i--) begin
     sub[i] = cmp[i] - {1'b0,denom};
     quo[i] = ~sub[i][D_WIDTH];
     if(~sub[i][D_WIDTH]) cmp[i-1] = {sub[i][D_WIDTH-1:0],numer[i-1]};
     else cmp[i-1] = {cmp[i][D_WIDTH-1:0],numer[i-1]};
   end
   sub[0] = cmp[0] - {1'b0,denom};
   quo[0] = ~sub[0][D_WIDTH];
   remain = (quo[0]) ? sub[0][D_WIDTH-1:0] : cmp[0][D_WIDTH-1:0];
 end


endmodule
