typedef enum logic[5:0] {
  COLOR_NONE  = 6'd0, 
  COLOR_BLUE             = 6'd5, // J piece colors
  COLOR_BLUE_BEV_UP      = 6'd6, 
  COLOR_BLUE_BEV_DOWN    = 6'd7, 
  COLOR_BLUE_BEV_LEFT    = 6'd8, 
  COLOR_BLUE_BEV_RIGHT   = 6'd9,
  COLOR_LBLUE            = 6'd10, // I piece colors
  COLOR_LBLUE_BEV_UP     = 6'd11,
  COLOR_LBLUE_BEV_DOWN   = 6'd12, 
  COLOR_LBLUE_BEV_LEFT   = 6'd13, 
  COLOR_LBLUE_BEV_RIGHT  = 6'd14,
  COLOR_ORANGE           = 6'd16, // L piece colors
  COLOR_ORANGE_BEV_UP    = 6'd17,
  COLOR_ORANGE_BEV_DOWN  = 6'd18, 
  COLOR_ORANGE_BEV_LEFT  = 6'd19, 
  COLOR_ORANGE_BEV_RIGHT = 6'd20,
  COLOR_YELLOW           = 6'd21, // 0 piece colors
  COLOR_YELLOW_BEV_UP    = 6'd22,
  COLOR_YELLOW_BEV_DOWN  = 6'd23, 
  COLOR_YELLOW_BEV_LEFT  = 6'd24, 
  COLOR_YELLOW_BEV_RIGHT = 6'd25,
  COLOR_GREEN            = 6'd26, // S piece colors
  COLOR_GREEN_BEV_UP     = 6'd27,
  COLOR_GREEN_BEV_DOWN   = 6'd28, 
  COLOR_GREEN_BEV_LEFT   = 6'd29, 
  COLOR_GREEN_BEV_RIGHT  = 6'd30,
  COLOR_PURPLE           = 6'd31, // T piece colors
  COLOR_PURPLE_BEV_UP    = 6'd32,
  COLOR_PURPLE_BEV_DOWN  = 6'd33, 
  COLOR_PURPLE_BEV_LEFT  = 6'd34, 
  COLOR_PURPLE_BEV_RIGHT = 6'd35,
  COLOR_RED              = 6'd36, // Z piece colors
  COLOR_RED_BEV_UP       = 6'd37,
  COLOR_RED_BEV_DOWN     = 6'd38, 
  COLOR_RED_BEV_LEFT     = 6'd39, 
  COLOR_RED_BEV_RIGHT    = 6'd40,
  COLOR_BLACK            = 6'd41,
  COLOR_BLACK_BEV_UP     = 6'd42,
  COLOR_BLACK_BEV_DOWN   = 6'd43,
  COLOR_BLACK_BEV_LEFT   = 6'd44,
  COLOR_BLACK_BEV_RIGHT  = 6'd45
  } color_t;
  
typedef enum logic [3:0] {
  CELL_BLACK  = 4'd0,
  CELL_BLUE   = 4'd1,
  CELL_LBLUE  = 4'd2,
  CELL_ORANGE = 4'd3,
  CELL_YELLOW = 4'd4,
  CELL_GREEN  = 4'd5,
  CELL_PURPLE = 4'd6,
  CELL_RED    = 4'd7,
  CELL_WHITE  = 4'hF
  } cell_color_t;
