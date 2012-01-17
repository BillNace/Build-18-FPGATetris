
module gol_object_tb();
  CTRL_CMDS ctrl_cmds;
  WC_CMDS wc_cmds;
  logic clk, rst_b, run_mode;
  logic [9:0] abs_ptrR, abs_ptrC;
  logic [23:0] gol_rgb;
  logic gol_gfx_en;
  logic [7:0] win_numCells;

  initial begin
    clk = 1'b0;
    rst_b = 1'b1;
    abs_ptrR = 10'h0;
    abs_ptrC = 10'h0;
    run_mode = 1'b0;
    #1 rst_b = 1'b0;
    #1 rst_b = 1'b1;
    #3;
    forever #5 clk = ~clk;
  end
  
  initial begin
    for(int i=0; i<1; i++) begin
      cycle_ptrs();
    end
    $finish;
  end


  gol_object #(6) inst(.*);

  task cycle_ptrs();
    logic [19:0] cnt
    cnt <= 20'h0;
    @(posedge clk);
    while(cnt <= 20'hC_0000) begin
      //$display(cnt);
      @(posedge clk);
      abs_ptrR <= cnt[19:10];
      abs_ptrC <= cnt[9:0];
      cnt <= cnt + 1'b1;
    end
  endtask

endmodule

