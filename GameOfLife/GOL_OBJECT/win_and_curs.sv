`default_nettype none
//  Holds cursrent state of win_numcells/winR/winC and curs
//  takes in commands:
//    increase/decrease window size (by a power of 2)
//      affects win_numcells/winR/winC and curs
//      zoom_in -> curs <= curs/2;
//      zoom out -> curs <= curs*2;
//      window_loc depends on curs
//
//    move window up/down/left/right
//      affects winR/winC
//      for now just move curs along for the ride.
//
//    move curs up/down/left/right
//      affects winR/winC and curs
//      if(at_border) move window/done move curs
//      else done move window/move curs
//
//   R==Y
//   C==X
// TODO need posedge detect on "run_mode" and set curs to the center of the screen
module win_and_curs(clk, rst_b, run_mode, wc_cmds,
                    winR, winC, win_numCells, abs_cursC, abs_cursR);
  parameter K = 4;
  parameter INIT_WINR = 4'h0;
  parameter INIT_WINC = 4'h0;
  parameter INIT_CURSR = 4'h4;
  parameter INIT_CURSC = 4'h4;
  input clk, rst_b;
  input WC_CMDS wc_cmds;
  input run_mode; // run==1, edit==0;
  input [7:0] win_numCells;

// Current state variables;
  output logic [K-1:0] winR; // between 0 and 128
  output logic [K-1:0] winC; // between 0 and 128 
  output logic [K-1:0] abs_cursC, abs_cursR;

  logic run_mode_f; //flopped run_mode

  // CMDS
  logic move_up; // Should be a pulse
  logic move_down; 
  logic move_left;
  logic move_right;
  logic move_mode; //curs==0, win==1
  logic zoom_in; // zooms in based on curs
  logic zoom_out; // zooms out based on curs

// Internal logic variables
  logic [K-1:0] cursR, cursC;

  logic [K-1:0] next_winR;
  logic [K-1:0] next_winC;
  logic [K-1:0] next_cursR;
  logic [K-1:0] next_cursC;

  logic [K-1:0] winR_zoom;
  logic [K-1:0] winC_zoom;
  logic [K-1:0] cursR_zoom;
  logic [K-1:0] cursC_zoom;

  logic curs_mode;
  logic win_mode;

  logic [K-1:0] leftup_border, rightdown_border;
  logic at_left_border;
  logic at_right_border;
  logic at_up_border;
  logic at_down_border;

  logic inc_winR;
  logic inc_winC;
  logic dec_winR;
  logic dec_winC;
  logic inc_cursR;
  logic inc_cursC;
  logic dec_cursR;
  logic dec_cursC;

  logic zoom_en;

  // CMD assigns
  assign move_up = wc_cmds.move_up; 
  assign move_down = wc_cmds.move_down; 
  assign move_left = wc_cmds.move_left;
  assign move_right = wc_cmds.move_right;
  assign move_mode = wc_cmds.move_mode; 
  assign zoom_in = wc_cmds.zoom_in; 
  assign zoom_out = wc_cmds.zoom_out; 


  // output assigns 
  assign abs_cursR = cursR[K-1:0] + winR[K-1:0];
  assign abs_cursC = cursC[K-1:0] + winC[K-1:0];

  // leftup = win_numcells/4.  downright = win_numcells*3/4
  assign leftup_border = {2'b00,win_numCells[K-1:2]};
  assign rightdown_border = {1'b0,win_numCells[K-1:1]} + {2'b00,win_numCells[K-1:2]};
  assign at_left_border = (cursC == leftup_border);
  assign at_right_border = (cursC + 1'b1 == rightdown_border);
  assign at_up_border = (cursR == leftup_border);
  assign at_down_border = (cursR + 1'b1 == rightdown_border);

  assign curs_mode = ~move_mode;
  assign win_mode = move_mode;

  // TODO verify inc/dec curs/win logic
  assign inc_winR = (curs_mode & at_down_border & move_down) |
                    (win_mode & move_down);
  assign inc_winC = (curs_mode & at_right_border & move_right) |
                    (win_mode & move_right);
  assign dec_winR = (curs_mode & at_up_border & move_up) |
                    (win_mode & move_up);
  assign dec_winC = (curs_mode & at_left_border & move_left) |
                    (win_mode & move_left);

  assign inc_cursR = (curs_mode & move_down & ~at_down_border);
  assign inc_cursC = (curs_mode & move_right & ~at_right_border);
  assign dec_cursR = (curs_mode & move_up & ~at_up_border);
  assign dec_cursC = (curs_mode & move_left & ~at_left_border);

  // Window / cursor next state logic
  always_comb begin
    case({inc_cursR, dec_cursR})
      2'b00 : next_cursR = cursR;
      2'b01 : next_cursR = cursR - 1'b1;
      2'b10 : next_cursR = cursR + 1'b1;
      2'b11 : next_cursR = cursR; // SHOULD NEVER OCCUR
    endcase
    case({inc_cursC, dec_cursC})
      2'b00 : next_cursC = cursC;
      2'b01 : next_cursC = cursC - 1'b1;
      2'b10 : next_cursC = cursC + 1'b1;
      2'b11 : next_cursC = cursC; // SHOULD NEVER OCCUR
    endcase
    case({inc_winR, dec_winR})
      2'b00 : next_winR = winR;
      2'b01 : next_winR = winR - 1'b1;
      2'b10 : next_winR = winR + 1'b1;
      2'b11 : next_winR = winR; // SHOULD NEVER OCCUR
    endcase
    case({inc_winC, dec_winC})
      2'b00 : next_winC = winC;
      2'b01 : next_winC = winC - 1'b1;
      2'b10 : next_winC = winC + 1'b1;
      2'b11 : next_winC = winC; // SHOULD NEVER OCCUR
    endcase
  end


  assign zoom_en = zoom_in | zoom_out;
  // comb logic for zoom curs and window
  // TODO upgrade zoom (currently only zooms out/in from center)
  always_comb begin
    if(zoom_in) begin
      cursR_zoom = {1'b0,cursR[K-1:1]}; // divide by 2
      cursC_zoom = {1'b0, cursC[K-1:1]}; // divide by 2
      winR_zoom = winR + {2'b00,win_numCells[K-1:2]};
      winC_zoom = winC + {2'b00,win_numCells[K-1:2]};
    end
    else if(zoom_out) begin
      cursR_zoom = {cursR[K-2:0],1'b0}; // multipy by 2
      cursC_zoom = {cursC[K-2:0],1'b0}; // multiply by 2
      winR_zoom = winR - {1'b0,win_numCells[K-1:1]};
      winC_zoom = winC - {1'b0,win_numCells[K-1:1]};
    end
    else begin
      winR_zoom = winR;
      winC_zoom = winC;
      cursR_zoom = cursR;
      cursC_zoom = cursC;
    end

  end
/* TODO ASSERTION CHECKS
  move_up/move_down/move_left/move_right, only 1 or 0 asserted
    These should also only be 1 cycle pulses.
  numCells/4  <= curs <= 3*numCells/4
  winR <= cursLocR < winR + win_numCells
  inc & dec never asserted together (4).
  num_cells <= max & >= min
*/
  `DQFF(run_mode_f,run_mode,1'b0)


  // register logic for window_related
  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) begin
      winR <= INIT_WINR;
      winC <= INIT_WINC;
    end
    else begin
      winR <= (zoom_en) ? winR_zoom : next_winR;
      winC <= (zoom_en) ? winC_zoom : next_winC;
    end
  end
  
  // register logic for curs_related
  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) begin
      cursR <= INIT_CURSR;
      cursC <= INIT_CURSC;
    end
    else if(run_mode & ~run_mode_f) begin // posedge run_mode
      cursR <= win_numCells[K:1]; // center of window
      cursC <= win_numCells[K:1];
    end
    else begin
      cursR <= (zoom_en) ? cursR_zoom : next_cursR;
      cursC <= (zoom_en) ? cursC_zoom : next_cursC;
    end

  end


endmodule
