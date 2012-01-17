`ifndef DEFINES
`define DEFINES
`default_nettype none

`define GREY(a) ({a,a,a})
`define WHITE 24'hff_ff_ff
`define BLACK 24'h00_00_00
`define RED 24'hff_00_00
`define GREEN 24'h00_ff_00
`define BLUE 24'h00_00_ff

`define SETTYPEMATIC 8'hF3
`define SPEED128 8'b0_01_00000
`define SPEED64 8'b0_01_00010
`define SPEED32 8'b0_01_00101
`define SPEED16 8'b0_01_01010
`define SPEED8 8'b0_01_10001
`define SPEEDDEFAULT `SPEED8

`define DQFF(q,d,rst_val) \
  always_ff @(posedge clk, negedge rst_b) begin \
    if(~rst_b) q <= rst_val; \
    else q <= d; \
  end
/*
EDIT MODE
  if space, goto RUN MODE
  if arrow keys, move cursor
  if l_lshift + arrow keys, move window
  if z + down, zoom out
  if z + up, zoom in
  if enter, step one generation
  if C_key, clear board
  if R_key, randomize board
  if P_key, Pattern mode and get first pattern
  if arrow key (up/down) and Pattern mode, clear + get next_pattern
  if s + up/down, speed up/down
  if H key held down show help screen (Maybe???)
  if ESC, quit game and go to main menu

RUN MODE
  if space, goto EDIT MODE
  if arrow keys, move window
  if z + down, zoom out
  if z + up, zoom in
  if s + up/down, speed up/down
  if H key held down show help screen (Maybe???)
  if ESC, quit game and go to main menu

*/


/* NOTES
-in EDIT mode, make sure pattern_mode is deasserted if going to run_mode
*/


// for each key, key[0] is the press pulse and key[1] is release pulse
typedef struct packed {
  logic [1:0] space;
  logic [1:0] up;
  logic [1:0] down;
  logic [1:0] left;
  logic [1:0] right;
  logic [1:0] lshift;
  logic [1:0] z;
  logic [1:0] enter;
  logic [1:0] c;
  logic [1:0] r;
  logic [1:0] p;
  logic [1:0] plus;
  logic [1:0] h;
  logic [1:0] s;
  logic [1:0] esc;
  logic [1:0] f;
  logic [1:0] d;

} KEYS;

typedef struct packed {
  // main to ctrl
  logic clear_cmd;
  logic rand_cmd;
  logic pattern_mode;
  logic next_pattern;
  logic set_curs;
  logic curs_wish;
  logic one_gen;
  logic inc_speed;
  logic dec_speed;
} CTRL_CMDS;

typedef struct packed {
  // main to win/curs
  logic move_up;
  logic move_down;
  logic move_left;
  logic move_right;
  logic move_mode;
  logic zoom_in;
  logic zoom_out;
} WC_CMDS;

`endif
