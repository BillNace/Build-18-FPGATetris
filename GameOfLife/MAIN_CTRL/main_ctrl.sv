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

/* State information this block hold
  run_mode
  pattern_mode


*/

/* NOTES
-in EDIT mode, make sure pattern_mode is deasserted if going to run_mode
-calculate how fast to move cursor based off of windowsize
  bigger window -> faster cursor (by factor of 2 (or less))
*/

`define NEXT_PRESSED(keys,val) \
  keys[1] ? 1'b0 : (keys[0] ? 1'b0 : val)
// for each key, key[0] is the press pulse and key[1] is release pulse
module main_ctrl(
  clk, rst_b, keys, ctrl_cmds, wc_cmds, 
  run_mode, win_numCells, ps2_pkt_HD, send_ps2_pkt);

  parameter ZOOM_MIN = 8'b0000_1000;
  parameter ZOOM_MAX = 8'b0001_0000; 
  input clk, rst_b;
  input KEYS keys;
  output CTRL_CMDS ctrl_cmds;
  output WC_CMDS wc_cmds;
  output logic run_mode;
  output logic [7:0] win_numCells;
  output logic [15:0] ps2_pkt_HD;
  output logic send_ps2_pkt;

  logic zoom_in_en, zoom_out_en;
  logic [7:0] win_numCells_zoom;

  //run_mode
  logic pattern_mode_next;
  logic space_pressed, space_pressed_next;
  logic p_pressed, p_pressed_next;
  logic s_pressed, s_pressed_next;
  logic z_pressed, z_pressed_next;
  logic lshift_pressed, lshift_pressed_next;
  logic run_mode_next;
  logic en_move;

  // TODO optimize these next assigns... 
  assign space_pressed_next = `NEXT_PRESSED(keys.space,space_pressed);
  `DQFF(space_pressed, space_pressed_next,1'b0)

  assign run_mode_next = (~space_pressed & keys.space[0]) ? ~run_mode : run_mode ;
  `DQFF(run_mode,run_mode_next,1'b0)

  //clear_cmd
  `DQFF(ctrl_cmds.clear_cmd, keys.c[0], 'h0)

  //rand_cmd
  `DQFF(ctrl_cmds.rand_cmd, keys.r[0], 'h0)

  //pattern_mode only during EDIT
  assign pattern_mode_next = `NEXT_PRESSED(keys.p,ctrl_cmds.pattern_mode);
  `DQFF(ctrl_cmds.pattern_mode,pattern_mode_next, 1'b0)
  //next_pattern only assert if pattern_mode
  `DQFF(ctrl_cmds.next_pattern, (keys.plus[0] & ctrl_cmds.pattern_mode), 'h0)

  //set cursor if f or d
  `DQFF(ctrl_cmds.set_curs, (keys.f[0] | keys.d[0]), 'h0)

  //curs wish ... 1 if f, 0 if d
  `DQFF(ctrl_cmds.curs_wish, keys.f[0], 'h0)

  //one_gen 
  `DQFF(ctrl_cmds.one_gen, keys.enter[0], 'h0)

  assign s_pressed_next = `NEXT_PRESSED(keys.s,s_pressed);
  `DQFF(s_pressed,s_pressed_next,1'b0)

  // inc/dec speed
  `DQFF(ctrl_cmds.inc_speed, (s_pressed & keys.up[0]), 'h0)
  `DQFF(ctrl_cmds.dec_speed, (s_pressed & keys.down[0]), 'h0)

  // lshift key
  assign lshift_pressed_next = `NEXT_PRESSED(keys.lshift,lshift_pressed);
  `DQFF(lshift_pressed,lshift_pressed_next,1'b0)
  
  //move mode TODO RETARDLY SETTING THIS
  `DQFF(wc_cmds.move_mode, lshift_pressed, 'h0)

  //zoom in/out
  assign z_pressed_next = `NEXT_PRESSED(keys.z,z_pressed);
  `DQFF(z_pressed,z_pressed_next,1'b0)

  assign zoom_in_en = z_pressed & keys.up[0] & (win_numCells != ZOOM_MIN);
  assign zoom_out_en = z_pressed & keys.down[0] & (win_numCells != ZOOM_MAX);
  assign win_numCells_zoom = zoom_in_en ? {1'b0,win_numCells[7:1]} : 
                            (zoom_out_en ? {win_numCells[6:0],1'b0} : win_numCells);
  `DQFF(win_numCells,win_numCells_zoom,ZOOM_MIN)
  `DQFF(wc_cmds.zoom_in, zoom_in_en, 'h0)
  `DQFF(wc_cmds.zoom_out, zoom_out_en, 'h0)

  assign en_move = ~z_pressed & ~s_pressed;
  // arrow keys move
  `DQFF(wc_cmds.move_up, (en_move & keys.up[0]), 'h0)
  `DQFF(wc_cmds.move_down, (en_move & keys.down[0]), 'h0)
  `DQFF(wc_cmds.move_left, (en_move & keys.left[0]), 'h0)
  `DQFF(wc_cmds.move_right, (en_move & keys.right[0]), 'h0)


  // set speed of keyboard based on win_numCells;
  always_comb begin
    case(win_numCells_zoom)
      8'b1000_0000 : ps2_pkt_HD[7:0] = `SPEED128;
      8'b0100_0000 : ps2_pkt_HD[7:0] = `SPEED64;
      8'b0010_0000 : ps2_pkt_HD[7:0] = `SPEED32;
      8'b0001_0000 : ps2_pkt_HD[7:0] = `SPEED16;
      8'b0000_1000 : ps2_pkt_HD[7:0] = `SPEED8;
      default : ps2_pkt_HD = `SPEEDDEFAULT;
    endcase
    ps2_pkt_HD[15:8] = `SETTYPEMATIC;
  end
  assign send_ps2_pkt = zoom_in_en | zoom_out_en ;



/* assertions
  run_mode -> ~pattern_mode
*/

endmodule

