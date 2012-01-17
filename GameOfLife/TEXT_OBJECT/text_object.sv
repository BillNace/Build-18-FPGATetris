module text_object(
  clk, rst_b, abs_ptrR, abs_ptrC,
  text_rgb, text_gfx_en);

  input clk, rst_b;
  input [9:0] abs_ptrR, abs_ptrC;
  output [23:0] text_rgb;
  output text_gfx_en;

  logic [23:0] tit_rgb;
  logic tit_gfx_en;
  logic tit_get_char_val;
  logic [5:0] tit_char_num;
  logic [2:0] tit_pixR, tit_pixC;
  logic [23:0] tit_pix_val;


  logic [23:0] sts_rgb;
  logic sts_gfx_en;
  logic sts_get_char_val;
  logic [5:0] sts_char_num;
  logic [2:0] sts_pixR, sts_pixC;
  logic [23:0] sts_pix_val;

  logic [5:0] char_num;
  logic [2:0] pixR, pixC;
  logic [23:0] pix_val;

  assign text_rgb = (tit_gfx_en) ? tit_rgb : sts_rgb ;
  assign text_gfx_en = tit_gfx_en | sts_gfx_en;
  
  assign char_num = (tit_get_char_val) ? tit_char_num : sts_char_num ;
  assign pixR = (tit_get_char_val) ? tit_pixR : sts_pixR ;
  assign pixC = (tit_get_char_val) ? tit_pixC : sts_pixC ;
  assign tit_pix_val = pix_val;
  assign sts_pix_val = pix_val;

  title_object title_object1(.*);
  stats_object stats_object1(.*);

// GET CHAR
  assign pix_val = {1'b0,char_num,1'b1,
                    1'b1,char_num,1'b0,
                    1'b1,char_num,1'b1};

endmodule
