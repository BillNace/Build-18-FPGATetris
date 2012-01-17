`default_nettype none

//`include "defines.svh"

module gol_object(
  clk, rst_b, abs_ptrR, abs_ptrC, run_mode, win_numCells,
  ctrl_cmds, wc_cmds, gol_rgb, gol_gfx_en);

  parameter K = 6; //64x64 board
  parameter INIT_WINR = 7'h0;
  parameter INIT_WINC = 7'h0;
  parameter INIT_CURSR = 7'h4;
  parameter INIT_CURSC = 7'h4;
  input clk, rst_b;
  input [9:0] abs_ptrR, abs_ptrC;
  input run_mode;
  input [7:0] win_numCells;
  input CTRL_CMDS ctrl_cmds;
  input WC_CMDS wc_cmds;

  output [23:0] gol_rgb;
  output gol_gfx_en;

  logic dsp_gfx_en;
  logic mm_gfx_en;
  logic [23:0] dsp_rgb;
  logic [23:0] mm_rgb;



  // Wires between gol_ctrl and gol_logic
  logic write_en, change_state;
  logic [K-1:0] wAddrR, wAddrC;
  logic write_data;

  // Wires between gol_logic and gol_gfx
  logic [K-1:0] rAddrR, rAddrC;
  logic read_data;
  logic dsp_read_en, mm_read_en;
  logic [K-1:0] dsp_cell_addrR, dsp_cell_addrC;
  logic [K-1:0] mm_cell_addrR, mm_cell_addrC;
  logic cell_state;

  // Wires between win_and_curs and gol_gfx
  logic [K-1:0] winR, winC;
  logic [K-1:0] abs_cursR, abs_cursC;

  gol_logic #(K) gol_logic(.*);
  win_and_curs 
    #(K) 
    win_and_curs1(.*);

  gol_ctrl #(K) gol_ctrl1(.*);
  gol_display_gfx #(K) gol_display_gfx1(.*);
  gol_minimap_gfx #(K) gol_minimap_gfx1(.*);

  // "MUX"es 
  assign cell_state = read_data ;
  assign rAddrR = (dsp_read_en) ? dsp_cell_addrR : mm_cell_addrR ;
  assign rAddrC = (dsp_read_en) ? dsp_cell_addrC : mm_cell_addrC ;
  assign gol_rgb = (dsp_gfx_en) ? dsp_rgb : mm_rgb ;
  assign gol_gfx_en = dsp_gfx_en | mm_gfx_en ;

/* TODO ASSERTIONS
 * dsp_read_en -> ~mm_read_en
 * dsp_gfx_en -> ~mm_gfx_en
 *
 */


endmodule
