module gol_top(clk, rst_b, abs_ptrR, abs_ptrC, game_of_life_rgb);
  parameter K = 5;
  input clk, rst_b;
  input [9:0] abs_ptrR, abs_ptrC;
  output [23:0] game_of_life_rgb;

  KEYS keys;
  CTRL_CMDS ctrl_cmds;
  WC_CMDS wc_cmds;
  logic run_mode;
  logic [7:0] win_numCells;
  logic [15:0] ps2_pkt_HD;
  logic send_ps2_pkt;

  logic [23:0] gol_rgb, text_rgb;
  logic gol_gfx_en, text_gfx_en;

  logic game_of_life_en;

  logic [7:0] ps2_pkt_DH;
  logic rec_ps2_pkt;

  assign ps2_pkt_DH = 8'h0;
  assign rec_ps2_pkt = 1'b0;

  assign game_of_life_rgb = gol_gfx_en ? gol_rgb : (text_gfx_en ? text_rgb : `GREEN);
  assign game_of_life_en = gol_gfx_en | text_gfx_en ;

  ps2_parse ps2_parse1(.*);
  text_object text_object1(.*);
  main_ctrl main_ctrl1(.*);
  gol_object #(.K(K)) gol_object1(.*);
  

endmodule
