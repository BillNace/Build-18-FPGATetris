`default_nettype none
// This Block is responsivle for Non-Graphics logic for GOL object
// Contains:
//   GOL state instantiation
//   Curs location
//   Minimap location / size
//
// EDITING STATE 
//   Clear GOL state
//   Randomize GOL state
//   Set fill/delete curs
//
//
// RUNNING STATE
//   outputs pulses of "change_state" based off of gen_speed
//   


// assuming sizes of 128 64, 32, 16 and 8
module gol_ctrl(
  clk, rst_b,
  abs_cursR, abs_cursC,
  run_mode, // 1= running, 0 = edit
  ctrl_cmds,
  wAddrR, wAddrC,
  write_en,
  write_data,
  change_state);

  parameter K = 7;
  input clk, rst_b;
  input [K-1:0] abs_cursR, abs_cursC;
  input CTRL_CMDS ctrl_cmds;
  input run_mode; // 1= running, 0 = edit
  output logic [K-1:0] wAddrR;
  output logic [K-1:0] wAddrC;
  output logic write_en;
  output logic write_data;
  output logic change_state;

// COMMANDS
  logic clear_cmd;
  logic rand_cmd;
  logic set_curs; // set cursor color to "curs_wish"
  logic curs_wish; // white->0, black->1
  logic one_gen; // enter is pressed to advance to next generation
  logic pattern_mode; //
  logic next_pattern; // displays next pattern if pattern_en
  logic inc_speed, dec_speed;

  logic clear_en;
  logic clear_data;
  logic random_en;
  logic random_data;
  logic [K-1:0] walkthrough_addrR;
  logic [K-1:0] walkthrough_addrC;
  logic walkthrough_done;

  logic pattern_en;
  logic pattern_data;
  logic [K-1:0] pattern_addrR;
  logic [K-1:0] pattern_addrC;

// FSM inputs/outputs
//  logic run_mode // run=1,edit=0
  logic clear_start;
  logic clear_done;
  logic random_start;
  logic random_done;
//  logic pattern_mode;
  logic pattern_start;
  logic pattern_done;
//  logic clear_en;
//  logic random_en;
//  logic pattern_en;
// FSM done

  logic change_state_run;

  assign change_state = one_gen | change_state_run ;

  // cmd interface assigns  
  assign clear_cmd = ctrl_cmds.clear_cmd;
  assign rand_cmd = ctrl_cmds.rand_cmd;
  assign set_curs = ctrl_cmds.set_curs; 
  assign curs_wish = ctrl_cmds.curs_wish; 
  assign one_gen = ctrl_cmds.one_gen; 
  assign pattern_mode = ctrl_cmds.pattern_mode; 
  assign next_pattern = ctrl_cmds.next_pattern; 
  assign inc_speed = ctrl_cmds.inc_speed;
  assign dec_speed = ctrl_cmds.dec_speed;



// FSM related assigns
  assign clear_start = clear_cmd;
  assign random_start = rand_cmd;
  assign pattern_start = next_pattern;
  assign clear_done = walkthrough_done;
  assign random_done = walkthrough_done;

// FSM done

// TODO check these assigns for priorities
// assigns for writing to gol_logic
  assign write_en = clear_en | random_en | pattern_en | set_curs ;
  assign wAddrR = set_curs ? abs_cursR : 
                  (pattern_en ? pattern_addrR : walkthrough_addrR) ;
  assign wAddrC = set_curs ? abs_cursC :
                  (pattern_en ? pattern_addrC : walkthrough_addrC) ;
  assign write_data = set_curs ? curs_wish : (clear_en ? 1'b0 : 
                      (random_en ? random_data : 1'b1 ));

//Module Instantiations
  ctrl_fsm ctrl_fsm1(.*);
  next_gen_ctrl next_gen_ctrl1(.*);
  addr_walkthrough #(K) walkthrough(.clk, .rst_b,
                                    .en(clear_en|random_en),
                                    .addrR(walkthrough_addrR),
                                    .addrC(walkthrough_addrC),
                                    .done(walkthrough_done)
                                    );
  random_gen random_gen1(.*);
  pattern_gen #(K) pattern_gen1(.*); 


/* TODO Assertions 
  enables are never asserted simultaniously.

*/

endmodule

// Determines how often to change generation
// TODO next_gen rate. at a constant rate ATM
module next_gen_ctrl(
  input clk, rst_b,
  input run_mode,  //run==1,edit==0
  input inc_speed,
  input dec_speed,
  output logic change_state_run);

  logic speed_state;
  logic [19:0] count, count_next;
  assign change_state_run = (count==20'h0);
  assign count_next = run_mode ? (count + 1'b1) : 20'h1;

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) count <= 20'h1;
    else count <= count_next;
  end

endmodule

// expects en to be set until the clock after done.
module addr_walkthrough(clk, rst_b, en, addrR, addrC, done);
  parameter K = 7;
  input clk, rst_b;
  input en;
  output logic [K-1:0] addrR;
  output logic [K-1:0] addrC;
  output logic done;

  logic [2*K-1:0] count;  

  assign addrR = count[2*K-1:K];
  assign addrC = count[K-1:0];
  assign done = (count == (~{{2*K}{1'b0}}) );

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) count <= 'h0;
    else if(en) begin
      count <= count + 1'b1;
    end
  end

//TODO Assertion check (walkthrough)
// while ~enable, count ==0

endmodule

// Xor shift register 
module random_gen(clk, rst_b, random_en, random_data);
  parameter SEED = 1;
  input clk, rst_b;
  input random_en;
  output random_data;

  logic [17:0] shift_reg;
  logic msb;

  assign random_data = shift_reg[17];
  // Check wikipedia for values  (x^18 + x^11 + 1)
  assign msb = shift_reg[17] ^ shift_reg[10] ^ shift_reg[0];

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) shift_reg <= SEED;
    else if(random_en) shift_reg <= {msb, shift_reg[17:1]};
    else shift_reg <= shift_reg ;
  end

endmodule

// TODO impliment pattern_gen.
module pattern_gen(clk, rst_b, pattern_en, pattern_data,
                   pattern_done, pattern_addrR, pattern_addrC);
  parameter K = 6;
  input clk, rst_b;
  input pattern_en;
  output pattern_data;
  output pattern_done;
  output [K-1:0] pattern_addrR;
  output [K-1:0] pattern_addrC;

  assign pattern_data = 1'b0;
  assign pattern_done = pattern_en;
  assign pattern_addrR = 'h0;
  assign pattern_addrC = 'h0;

endmodule

module ctrl_fsm(
  input clk, rst_b,
  input run_mode, // run=1,edit=0
  input clear_start,
  input clear_done,
  input random_start,
  input random_done,
  input pattern_mode,
  input pattern_start,
  input pattern_done,
  output clear_en,
  output random_en,
  output pattern_en);
 

  enum [2:0] {RUN,
              EDIT,
              CLEAR,
              RANDOM,
              PATTERN_MODE,
              CLEAR_PATTERN,
              PATTERN} CS, NS;

  assign clear_en = (CS == CLEAR || CS == CLEAR_PATTERN);
  assign random_en = (CS == RANDOM);
  assign pattern_en = (CS == PATTERN);


  //next state logic
  always_comb begin
    case(CS)
      RUN: begin
        NS = run_mode ? RUN : EDIT ;
      end
      EDIT: begin
        NS = run_mode ? RUN : 
             (clear_start ? CLEAR :
             ( random_start ? RANDOM :
             ( pattern_mode ? PATTERN_MODE : EDIT)));
      end
      CLEAR: begin
        NS = clear_done ? EDIT : CLEAR ;
      end
      RANDOM: begin
        NS = random_done ? EDIT : RANDOM ;
      end
      PATTERN_MODE: begin
        NS = pattern_start ? CLEAR_PATTERN : (~pattern_mode ? EDIT : PATTERN_MODE);
      end
      CLEAR_PATTERN: begin
        NS = clear_done ? PATTERN : CLEAR_PATTERN ;
      end
      PATTERN: begin
        NS = pattern_done ? PATTERN_MODE : PATTERN ;
      end
    endcase

  end

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) CS <= EDIT ;
    else CS <= NS ;
  end

endmodule
