module Build18FPGATetris(
  input  logic        CLOCK_50,
  input  logic        CLOCK2_50,
  input  logic        CLOCK3_50,
  output logic  [8:0] LEDG,
  output logic [17:0] LEDR,
  input  logic  [3:0] KEY,
  input  logic [17:0] SW,
  output logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
  output logic        LCD_BLON,
  inout  logic  [7:0] LCD_DATA,
  output logic        LCD_EN, LCD_ON, LCD_RS, LCD_RW,
  inout  logic        PS2_CLK, PS2_CLK2, PS2_DAT, PS2_DAT2,
  output logic  [7:0] VGA_B,
  output logic        VGA_BLANK_N,
  output logic        VGA_CLK,
  output logic  [7:0] VGA_G,
  output logic        VGA_HS,
  output logic  [7:0] VGA_R,
  output logic        VGA_SYNC_N,
  output logic        VGA_VS,
  input  logic        AUD_ADCDAT,
  inout  logic        AUD_ADCLRCK, AUD_BCLK,
  output logic        AUD_DACDAT,
  inout  logic        AUD_DACLRCK,
  output logic        AUD_XCK,
  output logic        I2C_SCLK, //I2C for Audio
  inout  logic        I2C_SDAT
);

  logic [10:0] row, col;
  // Testing...
  assign HEX7 = 7'b0000000;
  assign HEX6 = 7'b1111001;
  assign HEX5 = 7'b1000111;
  assign HEX4 = 7'b1000111;
  assign HEX3 = 7'b1001000;
  assign HEX2 = 7'b0001000;
  assign HEX1 = 7'b1000110;
  assign HEX0 = 7'b0000110;

  // Connecting VGA module to module outputs
  logic [9:0] VGA10_R, VGA10_G, VGA10_B;
  assign VGA_R = VGA10_R[9:2];
  assign VGA_G = VGA10_G[9:2];
  assign VGA_B = VGA10_B[9:2];
  
  // Generate inputs to VGA module
  logic [9:0] red, green, blue;
  mux8 #(8) mux_red(  .out(red[9:2]),
                      .in0(testbars_red), .in1(gol_red), .in2(snake_red), .in3(tetris_red), 
							 .in4(8'h60), .in5(8'h80), .in6(8'hC0), .in7(8'hFF),
						    .select(SW[2:0]));
  assign red[1:0] = 2'b00;
  mux8 #(8) mux_green(.out(green[9:2]),
                      .in0(testbars_green), .in1(gol_green), .in2(snake_green), .in3(tetris_green), 
							 .in4(8'h60), .in5(8'h80), .in6(8'hC0), .in7(8'hFF),
						    .select(SW[2:0]));
  assign green[1:0] = 2'b00;
  mux8 #(8) mux_blue( .out(blue[9:2]),
                      .in0(testbars_blue), .in1(gol_blue), .in2(snake_blue), .in3(tetris_blue), 
							 .in4(8'h60), .in5(8'h80), .in6(8'hC0), .in7(8'hFF),
						    .select(SW[2:0]));
  assign blue[1:0] = 2'b00;


  logic [7:0] testbars_red, testbars_green, testbars_blue;

  assign testbars_red[7]   =   col >= 10'd320;
  assign testbars_green[7] = ((col >= 10'd160) && (col < 10'd320)) || ((col >= 10'd480) && (col < 10'd640));
  assign testbars_blue[7]  = ((col >= 10'd80)  && (col < 10'd160)) || ((col >= 10'd240) && (col < 10'd320)) || 
                    ((col >= 10'd400) && (col < 10'd480)) || ((col >= 10'd560) && (col < 10'd640));
  
  logic [7:0] tetris_red, tetris_green, tetris_blue;
  tetris t(tetris_red, tetris_green, tetris_blue, col, row, CLOCK_50, KEY);
  
  logic [7:0] gol_red, gol_green, gol_blue;
  logic [23:0] game_of_life_rgb;
  assign gol_red = game_of_life_rgb[23:16];
  assign gol_green = game_of_life_rgb[15:8];
  assign gol_blue  = game_of_life_rgb[7:0];

//  gol_top(.clk(CLOCK50), .rst_b(KEY[0]), 
//          .abs_ptrR(row[9:0]), .abs_ptrC(col[9:0]),
//          .game_of_life_rgb);


  logic [7:0] snake_red, snake_green, snake_blue;
  assign snake_red   = 8'hFF;  // Snake module goes here
  assign snake_green = 8'h00;
  assign snake_blue  = 8'h00;
  
  VGA vga( 
    .iRed(red),
    .iGreen(green),
    .iBlue(blue),
    .oCurrent_X(col),
    .oCurrent_Y(row),
    .oVGA_R(VGA10_R),
    .oVGA_G(VGA10_G),
    .oVGA_B(VGA10_B),
    .oVGA_HS(VGA_HS),
    .oVGA_VS(VGA_VS),
    .oVGA_BLANK(VGA_BLANK_N),
    .oVGA_CLOCK(VGA_CLK),
    .iCLK_50M(CLOCK_50),
    .iRST_N(SW[17]) );

endmodule: Build18FPGATetris
