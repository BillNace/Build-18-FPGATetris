// THINGS TO DISPLAY 
// generation number
// number of alive cells ?? (if I have time)
// speed level

module stats_object(
  clk, rst_b, abs_ptrR, abs_ptrC, sts_pix_val,
  sts_gfx_en, sts_char_num, sts_pixR, sts_pixC, sts_get_char_val, sts_rgb);
  
  input clk, rst_b;
  input [9:0] abs_ptrR, abs_ptrC;
  input [23:0] sts_pix_val; // result of asserting get_char_val (probably some delay)
  output sts_gfx_en;
  output [5:0] sts_char_num; //refer to defines.svh for mapping
  output [2:0] sts_pixR, sts_pixC; // pixel location in 
  output sts_get_char_val;
  output [23:0] sts_rgb;
  
  logic [8:0] ptrR; // inside [0:352]
  logic [8:0] ptrC; // inside [0:320]
  logic [10:0] ptrR_low, ptrC_low;
  logic ptrR_high_en, ptrC_high_en;
  logic sts_en_p0, sts_en_p1, sts_en_p2;
  
/* Setup equations
 *  0x190 < ptrR < 0x2f0
 *  0x260 < ptrC < 0x3f0
 */
  assign ptrR_low = {1'b0,abs_ptrR} - 11'h120;
  assign ptrC_low = {1'b0,abs_ptrC} - 11'h1C0;
  assign ptrR_high_en = (10'h1C0 > abs_ptrR);
  assign ptrC_high_en = (10'h260 > abs_ptrC);
  assign sts_en_p0 = ~ptrR_low[10] & ~ptrC_low[10] &
                      ptrR_high_en & ptrC_high_en;
  assign ptrR = ptrR_low[8:0];
  assign ptrC = ptrC_low[8:0];

  // need data structure to store characters and lines
  assign sts_pixR = ptrR[5:3];
  assign sts_pixC = ptrC[5:3];
  assign sts_char_num = {ptrR[8:6],ptrC[8:6]};
  assign sts_get_char_val = sts_en_p0;
  assign sts_rgb = sts_pix_val;

  

endmodule

