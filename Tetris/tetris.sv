module tetris (
  output logic [7:0]  tetris_red,
  output logic [7:0]  tetris_green, 
  output logic [7:0]  tetris_blue, 
  input  logic [10:0] col, 
  input  logic [10:0] row, 
  input  logic        CLOCK_50,
  input  logic [3:0]  KEY);
  
  logic [23:0] ww_color;
  well_walls ww(col, row, ww_color);
  
  logic [23:0] total_color;
  assign total_color  = ww_color;
  assign tetris_red   = total_color[23:16];
  assign tetris_green = total_color[15:8];
  assign tetris_blue  = total_color[7:0];
  
endmodule: tetris
