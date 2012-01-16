`default_nettype none
module tb();
  parameter K = 6;
  parameter kPow = 1<<K;
  bit clk, rst_b;
  bit write_en, change_state;
  bit  [K-1:0] wAddrR, wAddrC;
  bit  [K-1:0] rAddrR, rAddrC;
  bit write_data;
  bit read_data;

  initial begin
    clk = 1'b0;
    rst_b = 1'b1;
    #1s rst_b = 1'b0;
    #1s rst_b = 1'b1;
    #3s;
    forever clk = #5s ~clk;
  end

  initial begin
    write_en <= 0;
    change_state <= 0;
    write_data <= 0;
    @(posedge clk);
    for(int i=0; i<20; i+=5) begin
      writeShape({0+i,1+i,1+i,2+i,2+i}, {1,0,1,1,2});
    end
    @(posedge clk);
    readAll();
    change_state <= 1'b1;
    repeat(6001) @(posedge clk);
    change_state <=1'b0;
    readAll();
/*
    for(int i=0; i<600; i++) begin
      change_state <= 1'b1;
      @(posedge clk);
      change_state <= 1'b0;
      readAll();
    end
*/    @(negedge clk);
    $finish;
  end

  task writeAll(input val);
    for(int i=0; i<kPow; i++) begin
      for(int j=0; j<kPow; j++) begin
        @(posedge clk);
        write_en <= 1'b1;
        wAddrR <= i;
        wAddrC <= j;
        write_data <= val;
        @(posedge clk);
        write_en <=1'b0;
        @(posedge clk);
      end
    end
  endtask

  task writeAddr(int r, int c, bit val);
    wAddrR <= r;
    wAddrC <= c;
    write_data <= val;
    write_en <= 1'b1;
    @(posedge clk);
    write_en <= 1'b0;
    @(posedge clk);
  endtask

  task writeGlider();
    int rmap[4:0], cmap[4:0];
    rmap = {1,2,2,3,3};
    cmap = {2,0,2,1,2};
    @(posedge clk);
    for(int i=0; i<5; i++) begin
      writeAddr(rmap[i],cmap[i],1'b1);
    end
  endtask
 
  task writeShape(int rmap[], int cmap[]);
    @(posedge clk);
    for(int i=0; i<rmap.size(); i++) begin
      writeAddr(rmap[i],cmap[i],1'b1);
    end
   

  endtask  

  task readAll();
    string borders; 
    string s;
    borders = "+";
    for(int i=0; i<kPow; i++) begin
      $sformat(borders,"%s-+",borders);
    end

    for(int i=0; i<kPow; i++) begin
      s = "|";
      $display(borders);
      for(int j=0; j<kPow; j++) begin
        rAddrR <= i;
        rAddrC <= j;
        @(posedge clk);
        $sformat(s,"%s%s|",s,read_data? "X" : " ");
      end
      $display(s);
    end
    $display(borders);
    $display("\n");
  endtask

  gol_logic #(K) inst(.*);

endmodule
