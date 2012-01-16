module tetris (
  output logic [7:0]  tetris_red,
  output logic [7:0]  tetris_green, 
  output logic [7:0]  tetris_blue, 
  input  logic [10:0] col, 
  input  logic [10:0] row, 
  input  logic        CLOCK_50,
  input  logic [3:0]  KEY);
  
  assign tetris_red   = row[10:3]; //temp
  assign tetris_green = row[10:3];
  assign tetris_blue  = col[10:3];
  
endmodule: tetris
