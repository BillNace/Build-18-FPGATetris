module tetris (
  output logic [7:0]  tetris_red,
  output logic [7:0]  tetris_green, 
  output logic [7:0]  tetris_blue, 
  input  logic [10:0] col, 
  input  logic [10:0] row, 
  input  logic        CLOCK_50,
  input  logic        reset,
  input  logic [3:0]  KEY,
  output logic [17:0] LEDR);
  
  color_t well_color, test_block1, test_block2, test_block3, test_block4, p1, p2;
  well #(50, 120) w(col, row, well_color, CLOCK_50, reset);
  bevelled_block                     j1(col, row, test_block1);
  bevelled_block #(120, 135, 36, 51) j2(col, row, test_block2);
  bevelled_block #(136, 151, 36, 51) j3(col, row, test_block3);
  bevelled_block #(152, 167, 36, 51) j4(col, row, test_block4);
  
  color_t paint_choice;
  assign paint_choice = (KEY[0]) ? COLOR_RED : COLOR_ORANGE;
  
  paintable_block #(67, 82, 120, 135) l1(col, row, paint_choice, KEY[1], p1);
  
  logic [10:0] x_pos, y_pos;
  logic clk;
  assign x_pos = 11'd120;
  gameclock gc(clk, CLOCK_50, reset);
  counter_loadable #(11)(clk, ~KEY[3], 1'b1, 11'd75, y_pos);
  assign LEDR[10:0] = y_pos;
  assign LEDR[17:11] = 7'b1011000;
  
  movable_block #(COLOR_GREEN) o1(col, row, x_pos, y_pos, p2);
  
  color_pallette cp(tetris_red, tetris_green, tetris_blue, 
                    well_color, 
                    test_block1, test_block2, test_block3, test_block4,
						  p1, p2);
  
endmodule: tetris

module color_pallette
  (output logic [7:0] red, green, blue,
   input  color_t well_color, test_block, test_block2, test_block3, test_block4,
	input  color_t p1, p2);
  
  logic [5:0] total_color;
  logic [23:0] color_24bit;
  assign {red, green, blue}   = color_24bit;
  
  assign total_color = well_color | test_block | test_block2 | test_block3 | test_block4 | p1 | p2;
  
  always_comb begin
    case (total_color)
      COLOR_NONE    : color_24bit = 24'd0;
      COLOR_BLUE            : color_24bit = 24'h0000F0;
      COLOR_BLUE_BEV_DOWN   : color_24bit = 24'h000078;
      COLOR_BLUE_BEV_UP     : color_24bit = 24'hADADF2;
      COLOR_BLUE_BEV_LEFT   : color_24bit = 24'h0000b7;
      COLOR_BLUE_BEV_RIGHT  : color_24bit = 24'h0000d8;
      COLOR_LBLUE           : color_24bit = 24'h00f0f0; // I piece colors
      COLOR_LBLUE_BEV_UP    : color_24bit = 24'hb3fbfb;
      COLOR_LBLUE_BEV_DOWN  : color_24bit = 24'h007878; 
      COLOR_LBLUE_BEV_LEFT  : color_24bit = 24'h00d8d8; 
      COLOR_LBLUE_BEV_RIGHT : color_24bit = 24'h00d8d8;
      COLOR_ORANGE          : color_24bit = 24'hf0a000; // L piece colors
      COLOR_ORANGE_BEV_UP   : color_24bit = 24'hfbe3b3;
      COLOR_ORANGE_BEV_DOWN : color_24bit = 24'h785000; 
      COLOR_ORANGE_BEV_LEFT : color_24bit = 24'hd89000; 
      COLOR_ORANGE_BEV_RIGHT: color_24bit = 24'hd89000;
      COLOR_YELLOW          : color_24bit = 24'hf0f000; // 0 piece colors
      COLOR_YELLOW_BEV_UP   : color_24bit = 24'hfbfbb3;
      COLOR_YELLOW_BEV_DOWN : color_24bit = 24'h787800; 
      COLOR_YELLOW_BEV_LEFT : color_24bit = 24'hd8d800; 
      COLOR_YELLOW_BEV_RIGHT: color_24bit = 24'hd8d800;
      COLOR_GREEN           : color_24bit = 24'h00f000; // S piece colors
      COLOR_GREEN_BEV_UP    : color_24bit = 24'hb3fbb3;
      COLOR_GREEN_BEV_DOWN  : color_24bit = 24'h007800; 
      COLOR_GREEN_BEV_LEFT  : color_24bit = 24'h00d800; 
      COLOR_GREEN_BEV_RIGHT : color_24bit = 24'h00d800;
      COLOR_PURPLE          : color_24bit = 24'ha000f0; // T piece colors
      COLOR_PURPLE_BEV_UP   : color_24bit = 24'he3b3fb;
      COLOR_PURPLE_BEV_DOWN : color_24bit = 24'h500078; 
      COLOR_PURPLE_BEV_LEFT : color_24bit = 24'h9000d8; 
      COLOR_PURPLE_BEV_RIGHT: color_24bit = 24'h9000d8;
      COLOR_RED             : color_24bit = 24'hf00000; // Z piece colors
      COLOR_RED_BEV_UP      : color_24bit = 24'hfbb3b3;
      COLOR_RED_BEV_DOWN    : color_24bit = 24'h780000; 
      COLOR_RED_BEV_LEFT    : color_24bit = 24'hd80000; 
      COLOR_RED_BEV_RIGHT   : color_24bit = 24'hd80000;
      COLOR_BLACK           : color_24bit = 24'd0;
      COLOR_BLACK_BEV_UP    : color_24bit = 24'd0;
      COLOR_BLACK_BEV_DOWN  : color_24bit = 24'd0;
      COLOR_BLACK_BEV_LEFT  : color_24bit = 24'd0;
      COLOR_BLACK_BEV_RIGHT : color_24bit = 24'd0;

      default : color_24bit = 24'd0;
    endcase
  end
  
endmodule : color_pallette
