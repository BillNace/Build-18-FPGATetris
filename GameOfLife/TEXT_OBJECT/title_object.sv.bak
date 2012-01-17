// Displays the Title 
`default_nettype none

module title_object(
  clk, rst_b, abs_ptrR, abs_ptrC, tit_pix_val,
  tit_gfx_en, tit_char_num, tit_pixR, tit_pixC, tit_get_char_val, tit_rgb);
  
  input clk, rst_b;
  input [9:0] abs_ptrR, abs_ptrC;
  input [23:0] tit_pix_val; // result of asserting get_char_val (probably some delay)
  output [5:0] tit_char_num; //refer to defines.svh for mapping
  output [2:0] tit_pixR, tit_pixC; // pixel location in 
  output tit_get_char_val;
  output [23:0] tit_rgb;
  output tit_gfx_en;
  
  

  logic [9:0] tit_loc; //Col position of first bit of title (scrolling potential)

  logic [3:0][5:0] tit_arr;
  logic [3:0] char_loc;
  logic char_en;
  logic [9:0] adj_ptrC;

  logic [5:0] ptrR; // inside [0:63]
  logic [9:0] ptrC; // inside [0:992]
  logic [10:0] ptrR_low, ptrC_low;
  logic ptrR_high_en, ptrC_high_en;
  logic tit_en_p0, tit_en_p1, tit_en_p2;
  
/* Setup equations
 *  0x10 < ptrR < 0x80
 *  0x10 < ptrC < 0x3f0
 */
  assign ptrR_low = {1'b0,abs_ptrR} - 11'h20;
  assign ptrC_low = {1'b0,abs_ptrC} - 11'h20;
  assign ptrR_high_en = (10'h60 > abs_ptrR);
  assign ptrC_high_en = (10'h260 > abs_ptrC);
  assign tit_en_p0 = ~ptrR_low[10] & ~ptrC_low[10] &
                      ptrR_high_en & ptrC_high_en;
  assign ptrR = ptrR_low[5:0];
  assign ptrC = ptrC_low[9:0];

// calculate which character ptr is on.
  assign adj_ptrC = ptrC - tit_loc;
  assign char_loc = adj_ptrC[9:6];
  
  assign tit_pixR = ptrR[5:3];
  assign tit_pixC = adj_ptrC[5:3];
  assign tit_char_num = tit_arr[char_loc];
  assign tit_get_char_val = (char_loc <= 4'hC);
  assign tit_rgb = tit_pix_val;

  assign tit_arr = 'h0; // TODO fill in with "GAME OF LIFE" (12 chars)
  

endmodule

