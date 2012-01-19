module is_in_box
  #(parameter START_X = 10,
	  parameter STOP_X  = 25,
    parameter START_Y = 20,
	  parameter STOP_Y  = 45,
	  parameter WIDTH   = 11)
  (input  logic [WIDTH-1:0] x,
   input  logic [WIDTH-1:0] y,
	 output logic             is_in);
	
  always_comb begin
    if ((x >= START_X) && 
	     (x <= STOP_X)  &&
		   (y >= START_Y) &&
		   (y <= STOP_Y))
      is_in = 1;
    else
      is_in = 0;
  end
  
endmodule : is_in_box

module test_is_in_box();

  logic [10:0] x, y;
  logic        is_in;
  
  is_in_box dut1(x, y, is_in);
  
  initial begin
    x = 11'd0; y = 11'd0; 
	  #5;
 	  if (~is_in) $display("Passed 1");
	  x = 11'd10;
	  #5;
	  if (~is_in) $display("Passed 2");
	  y = 11'd27;
	  #5
	  if ( is_in) $display("Passed 3");
	  #5
    $stop;
  end
  
  
endmodule : test_is_in_box

module bevelled_block
  #(parameter START_X = 120,
	 parameter STOP_X  = 135,
    parameter START_Y = 20,
	 parameter STOP_Y  = 35,
	 parameter color_t COLOR = COLOR_BLUE,
	 parameter BUS_WIDTH   = 11)
	(input  logic   [BUS_WIDTH-1:0] col, row,
	 output color_t                 color);
	   
  always_comb begin
    if ((col < START_X) || (col > STOP_X) || (row < START_Y) || (row > STOP_Y)) // outside the boundaries
	   color = COLOR_NONE;
	 else if ((row == START_Y) && (col < STOP_X)) // Top line of top bevel
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
    else if ((row == START_Y + 1) && (col > START_X) && (col < STOP_X - 1))
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
	 else if ((row == START_Y + 2) && (col > START_X + 1) && (col < STOP_X - 2))
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
	 else if ((row == STOP_Y) && (col > START_X) && (col <= STOP_X)) // bottom bevel
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((row == STOP_Y - 1) && (col > START_X + 1) && (col < STOP_X))
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((row == STOP_Y - 2) && (col > START_X + 2) && (col < STOP_X - 1))
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((col == START_X) && (row > START_Y) && (row <= STOP_Y)) // left bevel
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == START_X + 1) && (row > START_Y + 1) && (row < STOP_Y))
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == START_X + 2) && (row > START_Y + 2) && (row < STOP_Y - 1))
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == STOP_X) && (row >= START_Y) && (row < STOP_Y))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else if ((col == STOP_X - 1) && (row > START_Y) && (row < STOP_Y - 1))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else if ((col == STOP_X - 2) && (row > START_Y + 1) && (row < STOP_Y - 2))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else 
	   color = COLOR;
  end
  	 
endmodule : bevelled_block

module movable_block
  #(parameter color_t COLOR = COLOR_BLUE,
    parameter WIDTH = 16,
	 parameter HEIGHT = 16,
    parameter BUS_WIDTH   = 11)
	(input  logic [BUS_WIDTH-1:0] col, row,
	 input  logic [BUS_WIDTH-1:0] x_pos, y_pos, 
	 output color_t           color);
	   
  logic [BUS_WIDTH-1:0] start_x, stop_x, start_y, stop_y;
  assign start_x = x_pos;
  assign stop_x  = x_pos + WIDTH - 1;
  assign start_y = y_pos;
  assign stop_y  = y_pos + HEIGHT - 1;
  
  always_comb begin
    if ((col < start_x) || (col > stop_x) || (row < start_y) || (row > stop_y)) // outside the box
	   color = COLOR_NONE;
	 else if ((row == start_y) && (col < stop_x)) // Top line of top bevel
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
    else if ((row == start_y + 1) && (col > start_x) && (col < stop_x - 1))
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
	 else if ((row == start_y + 2) && (col > start_x + 1) && (col < stop_x - 2))
      color = color_t'(int'(COLOR) + 1);  // COLOR_UP
	 else if ((row == stop_y) && (col > start_x) && (col <= stop_x)) // bottom bevel
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((row == stop_y - 1) && (col > start_x + 1) && (col < stop_x))
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((row == stop_y - 2) && (col > start_x + 2) && (col < stop_x - 1))
      color = color_t'(int'(COLOR) + 2);  // COLOR_DOWN
	 else if ((col == start_x) && (row > start_y) && (row <= stop_y)) // left bevel
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == start_x + 1) && (row > start_y + 1) && (row < stop_y))
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == start_x + 2) && (row > start_y + 2) && (row < stop_y - 1))
      color = color_t'(int'(COLOR) + 3);  // COLOR_LEFT
	 else if ((col == stop_x) && (row >= start_y) && (row < stop_y))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else if ((col == stop_x - 1) && (row > start_y) && (row < stop_y - 1))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else if ((col == stop_x - 2) && (row > start_y + 1) && (row < stop_y - 2))
      color = color_t'(int'(COLOR) + 4);  // COLOR_RIGHT
	 else 
	   color = COLOR;
  end
  	 
endmodule : movable_block

module paintable_block
  #(parameter START_X = 120,
	 parameter STOP_X  = 135,
    parameter START_Y = 20,
	 parameter STOP_Y  = 35,
	 parameter BUS_WIDTH   = 11)
	(input  logic   [BUS_WIDTH-1:0] col, row,
	 input  color_t                 desired_color,  // a base color, not bevelled
	 input  logic                   draw_it,        // an enable, only draw if asserted
	 output color_t                 color);
	   
  always_comb begin
    if (~draw_it || ((col < START_X) || (col > STOP_X) || (row < START_Y) || (row > STOP_Y)))
	   color = COLOR_NONE;
	 else if ((row == START_Y) && (col < STOP_X)) // Top line of top bevel
      color = color_t'(int'(desired_color) + 1);  // COLOR_UP
    else if ((row == START_Y + 1) && (col > START_X) && (col < STOP_X - 1))
      color = color_t'(int'(desired_color) + 1);  // COLOR_UP
	 else if ((row == START_Y + 2) && (col > START_X + 1) && (col < STOP_X - 2))
      color = color_t'(int'(desired_color) + 1);  // COLOR_UP
	 else if ((row == STOP_Y) && (col > START_X) && (col <= STOP_X)) // bottom bevel
      color = color_t'(int'(desired_color) + 2);  // COLOR_DOWN
	 else if ((row == STOP_Y - 1) && (col > START_X + 1) && (col < STOP_X))
      color = color_t'(int'(desired_color) + 2);  // COLOR_DOWN
	 else if ((row == STOP_Y - 2) && (col > START_X + 2) && (col < STOP_X - 1))
      color = color_t'(int'(desired_color) + 2);  // COLOR_DOWN
	 else if ((col == START_X) && (row > START_Y) && (row <= STOP_Y)) // left bevel
      color = color_t'(int'(desired_color) + 3);  // COLOR_LEFT
	 else if ((col == START_X + 1) && (row > START_Y + 1) && (row < STOP_Y))
      color = color_t'(int'(desired_color) + 3);  // COLOR_LEFT
	 else if ((col == START_X + 2) && (row > START_Y + 2) && (row < STOP_Y - 1))
      color = color_t'(int'(desired_color) + 3);  // COLOR_LEFT
	 else if ((col == STOP_X) && (row >= START_Y) && (row < STOP_Y))
      color = color_t'(int'(desired_color) + 4);  // COLOR_RIGHT
	 else if ((col == STOP_X - 1) && (row > START_Y) && (row < STOP_Y - 1))
      color = color_t'(int'(desired_color) + 4);  // COLOR_RIGHT
	 else if ((col == STOP_X - 2) && (row > START_Y + 1) && (row < STOP_Y - 2))
      color = color_t'(int'(desired_color) + 4);  // COLOR_RIGHT
	 else 
	   color = desired_color;
  end
  	 
endmodule : paintable_block
