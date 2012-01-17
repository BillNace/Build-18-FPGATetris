module well_walls(
  input  logic [10:0] col,
  input  logic [10:0] row,
  output logic [23:0] color);
  
  // draw a solid gray wall 
  // block size will be 20x20
  parameter BLOCK_SIZE = 20;
  // well is 10 blocks by 20 blocks
  parameter WELL_BLOCKS_ROW = 20;
  parameter WELL_BLOCKS_COL = 10;
  // well_offset_x specifies how many columns before the well wall starts
  parameter WELL_OFFSET_COL = 100;
  parameter WELL_OFFSET_ROW = 10;
  
  parameter WELL_COLOR = 24'hCC_CC_CC; // grey
  
  logic on_left, on_right, on_bottom;
  
  is_in_box #(WELL_OFFSET_COL, 
              WELL_OFFSET_COL + BLOCK_SIZE,
              WELL_OFFSET_ROW, 
				  WELL_OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW), 
				  'd11) left_wall(col, row, on_left);
				  
  is_in_box #(WELL_OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 1)), 
              WELL_OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 2)),
              WELL_OFFSET_ROW, 
				  WELL_OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW), 
				  'd11) right_wall(col, row, on_right);

  is_in_box #(WELL_OFFSET_COL, 
              WELL_OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 2)),
              WELL_OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW) + 1, 
				  WELL_OFFSET_ROW + (BLOCK_SIZE * (WELL_BLOCKS_ROW + 1)) + 1, 
				  'd11) bottom_wall(col, row, on_bottom);
				  
  
  mux2 #(24) show_color(color, 24'b0, WELL_COLOR, is_on);
  
  assign is_on = on_left | on_right | on_bottom;
  
endmodule: well_walls

module test_well_walls();
  logic [10:0] col, row;
  logic [23:0] color;
  
  parameter GREY = 24'hCC_CC_CC;
  parameter BLACK = 24'h0;
  
  well_walls dut(col, row, color);
  
  
  initial begin
    col = 11'd99; row = 11'd25; // Next to, but outside of left wall
	 #5
	 if (color == BLACK) $display("Passed 1");
	 col = 11'd100;              // On the left edge of the left wall
	 #5
	 if (color == GREY) $display("Passed 2");
	 col = 11'd101;
	 #5
	 if (color == GREY) $display("Passed 3");
	 col = 11'd120;              // on the right edge of the left wall
	 #5
	 if (color == GREY) $display("Passed 4");
	 col = 11'd121;              // just outside -- to the right of the left wall
	 #5
	 if (color == BLACK) $display("Passed 5");
	 
    $stop;
  end

endmodule : test_well_walls
