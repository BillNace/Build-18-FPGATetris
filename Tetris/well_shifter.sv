module well_shifter
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
  
  color_t d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19;
  color_t q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19;
  logic   s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19;
  logic   load0, load1, load2, load3, load4, load5, load6, load7, load8, load9, load10, load11, load12, load13, load14, load15, load16, load17, load18, load19;
  logic   clear0, clear1, clear2, clear3, clear4, clear5, clear6, clear7, clear8, clear9, clear10, clear11, clear12, clear13, clear14, clear15, clear16, clear17, clear18, clear19;
  color_t color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12, color13, color14, color15, color16, color17, color18, color19;
  color_t in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19;
  logic [4:0] addr;
  logic read_status, shift;
  color_t in_color;
  
  
  well_cell #(OFFSET_COL, OFFSET_ROW)                      c0(col, row, d0,  q0,  s0,  load0,  clear0,  clk, reset, color0);
  well_cell #(OFFSET_COL, OFFSET_ROW + BLOCK_SIZE)         c1(col, row, d1,  q1,  s1,  load1,  clear1,  clk, reset, color1); 
  well_cell #(OFFSET_COL, OFFSET_ROW + 2 * BLOCK_SIZE)     c2(col, row, d2,  q2,  s2,  load2,  clear2,  clk, reset, color2); 
  well_cell #(OFFSET_COL, OFFSET_ROW + 3 * BLOCK_SIZE)     c3(col, row, d3,  q3,  s3,  load3,  clear3,  clk, reset, color3);
  well_cell #(OFFSET_COL, OFFSET_ROW + 4 * BLOCK_SIZE)     c4(col, row, d4,  q4,  s4,  load4,  clear4,  clk, reset, color4);
  well_cell #(OFFSET_COL, OFFSET_ROW + 5 * BLOCK_SIZE)     c5(col, row, d5,  q5,  s5,  load5,  clear5,  clk, reset, color5);
  well_cell #(OFFSET_COL, OFFSET_ROW + 6 * BLOCK_SIZE)     c6(col, row, d6,  q6,  s6,  load6,  clear6,  clk, reset, color6);
  well_cell #(OFFSET_COL, OFFSET_ROW + 7 * BLOCK_SIZE)     c7(col, row, d7,  q7,  s7,  load7,  clear7,  clk, reset, color7);
  well_cell #(OFFSET_COL, OFFSET_ROW + 8 * BLOCK_SIZE)     c8(col, row, d8,  q8,  s8,  load8,  clear8,  clk, reset, color8);
  well_cell #(OFFSET_COL, OFFSET_ROW + 9 * BLOCK_SIZE)     c9(col, row, d9,  q9,  s9,  load9,  clear9,  clk, reset, color9);
  well_cell #(OFFSET_COL, OFFSET_ROW + 10 * BLOCK_SIZE)   c10(col, row, d10, q10, s10, load10, clear10, clk, reset, color10);
  well_cell #(OFFSET_COL, OFFSET_ROW + 11 * BLOCK_SIZE)   c11(col, row, d11, q11, s11, load11, clear11, clk, reset, color11);
  well_cell #(OFFSET_COL, OFFSET_ROW + 12 * BLOCK_SIZE)   c12(col, row, d12, q12, s12, load12, clear12, clk, reset, color12);
  well_cell #(OFFSET_COL, OFFSET_ROW + 13 * BLOCK_SIZE)   c13(col, row, d13, q13, s13, load13, clear13, clk, reset, color13);
  well_cell #(OFFSET_COL, OFFSET_ROW + 14 * BLOCK_SIZE)   c14(col, row, d14, q14, s14, load14, clear14, clk, reset, color14);
  well_cell #(OFFSET_COL, OFFSET_ROW + 15 * BLOCK_SIZE)   c15(col, row, d15, q15, s15, load15, clear15, clk, reset, color15);
  well_cell #(OFFSET_COL, OFFSET_ROW + 16 * BLOCK_SIZE)   c16(col, row, d16, q16, s16, load16, clear16, clk, reset, color16);
  well_cell #(OFFSET_COL, OFFSET_ROW + 17 * BLOCK_SIZE)   c17(col, row, d17, q17, s17, load17, clear17, clk, reset, color17);
  well_cell #(OFFSET_COL, OFFSET_ROW + 18 * BLOCK_SIZE)   c18(col, row, d18, q18, s18, load18, clear18, clk, reset, color18);
  well_cell #(OFFSET_COL, OFFSET_ROW + 18 * BLOCK_SIZE)   c19(col, row, d19, q19, s19, load19, clear19, clk, reset, color19); 
  
  mux32 #(1) rs(read_status, s0,  s1,  s2,  s3,   s4,   s5,   s6,   s7,   s8,   s9,   s10,  s11,  s12,  s13,  s14,  s15,  s16, 
                             s17, s18, s19, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, addr);
  demux32 #($size(color_t)) wv(in_color, addr, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19);
  
  mux2 #($size(color_t))  mc0(d1, q0, in0, shift),
                          mc1(d2, q1, in1, shift),
                          mc2(d3, q2, in2, shift),
                          mc3(d4, q3, in3, shift),
                          mc4(d5, q4, in4, shift),
                          mc5(d6, q5, in5, shift),
                          mc6(d7, q6, in6, shift),
                          mc7(d8, q7, in7, shift),
                          mc8(d9, q8, in8, shift),
                          mc9(d10, q9, in9, shift),
                          mc10(d11, q10, in10, shift),
                          mc11(d12, q11, in11, shift),
                          mc12(d13, q12, in12, shift),
                          mc13(d14, q13, in13, shift),
                          mc14(d15, q14, in14, shift),
                          mc15(d16, q15, in15, shift),
                          mc16(d17, q16, in16, shift),
                          mc17(d18, q17, in17, shift),
                          mc18(d19, q18, in18, shift);


  logic [5:0] intermediate_color;
  assign intermediate_color = color0 | color1 | color2 | color3 | color4 | color5 | color6 | color7 | color8 | color9 | color10 | color11 | color12 | color13 | color14 | color15 | color16 | color17 | color18 | color19;
  assign color = color_t'(intermediate_color);
  
  enum {stateA, stateB, stateC} current_state, next_state;
  
  always_ff @(posedge clk, posedge reset) begin
    if (reset)
      current_state <= stateA;
    else
      current_state <= next_state;
  end
  
  always_comb begin
    load0 = 0; clear0 = 0; load1 = 0; clear1 = 0; load2 = 0; clear2 = 0; load3 = 0; clear3 = 0; load4 = 0; clear4 = 0; load5 = 0; clear5 = 0; 
    load6 = 0; clear6 = 0; load7 = 0; clear7 = 0; load8 = 0; clear8 = 0; load9 = 0; clear9 = 0; load10 = 0; clear10 = 0; load11 = 0; clear11 = 0; 
    load12 = 0; clear12 = 0; load13 = 0; clear13 = 0; load14 = 0; clear14 = 0; load15 = 0; clear15 = 0; load16 = 0; clear16 = 0; load17 = 0; clear17 = 0; 
    load18 = 0; clear18 = 0; load19 = 0; clear19 = 0;
    unique case (current_state)
      stateA : begin
               in_color = COLOR_GREEN;
               addr    = 5'd7;
               load7   = 1'b1;
               shift   = 1'b0;
               next_state = stateB;
               end
      stateB : begin
               in_color = COLOR_PURPLE;
               addr    = 5'd18;
               load18  = 1'b1;
               shift   = 1'b0;
               next_state = stateC;
               end
      stateC : begin
		         in_color = COLOR_RED;
					addr     = 5'd19;
					load19   = 1'b1;
					shift    = 1'b0;
               next_state = stateC;
               end
    endcase
  end
  
endmodule : well_shifter

module well_cell
 #(parameter OFFSET_COL = 100,
   parameter OFFSET_ROW =  10)
 (input  logic [10:0] col,
  input  logic [10:0] row,
  input  color_t      d,
  output color_t      q,      // base color
  output logic        status, // isNotEmpty?
  input  logic        load, clear, clk, reset,
  output color_t      color); // bevelled
  
  // draw a solid gray wall 
  // block size will be 16x16
  parameter BLOCK_SIZE = 16;
  
  assign status = (q != COLOR_NONE) & (q != COLOR_BLACK);

  paintable_block #(OFFSET_COL, OFFSET_COL + BLOCK_SIZE - 1,
                    OFFSET_ROW, OFFSET_ROW + BLOCK_SIZE - 1) (.col(col), .row(row), 
                                                        .desired_color(q), .draw_it(1'b1), 
                                          .color(color));  
  
  always_ff @(posedge clk, posedge reset) begin
    if (reset)
      q <= COLOR_NONE;
	 else if (clear)
	   q <= COLOR_NONE;
    else if (load)
      q <= d;
  end
  
endmodule : well_cell