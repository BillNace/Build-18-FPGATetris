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
	 parameter color_t COLOR_UP    = COLOR_BLUE_BEV_UP,
	 parameter color_t COLOR_DOWN  = COLOR_BLUE_BEV_DOWN,
	 parameter color_t COLOR_LEFT  = COLOR_BLUE_BEV_LEFT,
	 parameter color_t COLOR_RIGHT = COLOR_BLUE_BEV_RIGHT,
	 parameter WIDTH   = 11)
	(input  logic [WIDTH-1:0] x,
    input  logic [WIDTH-1:0] y,
	 output color_t           color);
	   
  always_comb begin
    if ((x < START_X) || (x > STOP_X) || (y < START_Y) || (y > STOP_Y)) // outside the box
	   color = COLOR_NONE;
	 else if ((y == START_Y) && (x < STOP_X)) // Top line of top bevel
      color = COLOR_UP;
    else if ((y == START_Y + 1) && (x > START_X) && (x < STOP_X - 1))
      color = COLOR_UP;	 
	 else if ((y == START_Y + 2) && (x > START_X + 1) && (x < STOP_X - 2))
	   color = COLOR_UP;
	 else if ((y == STOP_Y) && (x > START_X) && (x <= STOP_X)) // bottom bevel
	   color = COLOR_DOWN;
	 else if ((y == STOP_Y - 1) && (x > START_X + 1) && (x < STOP_X))
	   color = COLOR_DOWN;
	 else if ((y == STOP_Y - 2) && (x > START_X + 2) && (x < STOP_X - 1))
	   color = COLOR_DOWN;
	 else if ((x == START_X) && (y > START_Y) && (y <= STOP_Y)) // left bevel
	   color = COLOR_LEFT;
	 else if ((x == START_X + 1) && (y > START_Y + 1) && (y < STOP_Y))
	   color = COLOR_LEFT;
	 else if ((x == START_X + 2) && (y > START_Y + 2) && (y < STOP_Y - 1))
	   color = COLOR_LEFT;
	 else if ((x == STOP_X) && (y >= START_Y) && (y < STOP_Y))
	   color = COLOR_RIGHT;
	 else if ((x == STOP_X - 1) && (y > START_Y) && (y < STOP_Y - 1))
	   color = COLOR_RIGHT;
	 else if ((x == STOP_X - 2) && (y > START_Y + 1) && (y < STOP_Y - 2))
	   color = COLOR_RIGHT;
	 else 
	   color = COLOR;
  end
  	 
endmodule : bevelled_block