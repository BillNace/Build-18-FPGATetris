module well
 #(parameter OFFSET_COL = 100,
   parameter OFFSET_ROW =  10)
 (input  logic [10:0] col,
  input  logic [10:0] row,
  output color_t      color,
  input  logic        clk,
  input  logic        reset);
  
  // draw a solid gray wall 
  // block size will be 16x16
  parameter BLOCK_SIZE = 16;

  // well is 10 blocks by 20 blocks
  parameter WELL_BLOCKS_ROW = 20;
  parameter WELL_BLOCKS_COL = 10;

  color_t ww_color;
  well_walls #(OFFSET_COL, OFFSET_ROW) ww(col, row, ww_color);
  
  assign color = ww_color;
  
  well_shifter #(OFFSET_COL + BLOCK_SIZE, OFFSET_ROW) v0(col, row, v0_color, clk, reset);
 
 
endmodule : well