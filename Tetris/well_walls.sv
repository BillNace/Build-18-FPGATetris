module well_walls
 #(parameter OFFSET_COL = 100,
   parameter OFFSET_ROW =  10)
 (input  logic [10:0] col,
  input  logic [10:0] row,
  output color_t color);
  
  // draw a solid gray wall 
  // block size will be 16x16
  parameter BLOCK_SIZE = 16;

  // well is 10 blocks by 20 blocks
  parameter WELL_BLOCKS_ROW = 20;
  parameter WELL_BLOCKS_COL = 10;
    
  logic is_on, on_left, on_right, on_bottom;
  
  is_in_box #(OFFSET_COL, 
              OFFSET_COL + BLOCK_SIZE,
              OFFSET_ROW, 
				  OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW), 
				  'd11) left_wall(col, row, on_left);
				  
  is_in_box #(OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 1)), 
              OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 2)),
              OFFSET_ROW, 
				  OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW), 
				  'd11) right_wall(col, row, on_right);

  is_in_box #(OFFSET_COL, 
              OFFSET_COL + (BLOCK_SIZE * (WELL_BLOCKS_COL + 2)),
              OFFSET_ROW + (BLOCK_SIZE * WELL_BLOCKS_ROW) + 1, 
				  OFFSET_ROW + (BLOCK_SIZE * (WELL_BLOCKS_ROW + 1)) + 1, 
				  'd11) bottom_wall(col, row, on_bottom);
				  
  
  
  assign is_on = on_left | on_right | on_bottom;
  assign color = (is_on) ? COLOR_RED : COLOR_NONE;
  
endmodule: well_walls

module test_well_walls();
  logic [10:0] col, row;
  color_t color;
  
  well_walls dut(col, row, color);
  
  
  initial begin
    col = 11'd99; row = 11'd25; // Next to, but outside of left wall
	 #5
	 if (color == COLOR_NONE) $display("Passed 1");
	 col = 11'd100;              // On the left edge of the left wall
	 #5
	 if (color == COLOR_RED ) $display("Passed 2");
	 col = 11'd101;
	 #5
	 if (color == COLOR_RED ) $display("Passed 3");
	 col = 11'd120;              // on the right edge of the left wall
	 #5
	 if (color == COLOR_RED ) $display("Passed 4");
	 col = 11'd121;              // just outside -- to the right of the left wall
	 #5
	 if (color == COLOR_NONE) $display("Passed 5");
	 
    $stop;
  end

endmodule : test_well_walls
