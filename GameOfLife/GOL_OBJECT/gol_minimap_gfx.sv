`default_nettype none
//
// Flow minimap:
//   GFX enable conditions:
//     128 < rPtr < 512 &&
//     640 < cPtr < 768
//   Two Distinct Regions: "Non-Window" and "Window"
//   When enable conditions match,
//     Read appropriate GOL cell,
//       if in Window region display black or white
//       if in non-window region, display darkgrey or light grey
//       if on window border, display window color

// make sure that a is 8 bits
`define GREY(a) ({a,a,a})
`define WHITE 24'hff_ff_ff
`define BLACK 24'h00_00_00
`define RED 24'hff_00_00
`define BLUE 24'h00_00_ff

module gol_minimap_gfx(run_mode, abs_ptrR, abs_ptrC, winR, winC,
                       win_numCells, abs_cursC, abs_cursR, cell_state,
                       mm_read_en, mm_cell_addrC, mm_cell_addrR, mm_rgb, mm_gfx_en);

  parameter K = 6;
  input run_mode; // display cursor if run_mode==0
  input [9:0] abs_ptrR, abs_ptrC;
  input [K-1:0] winR, winC;
  input [7:0] win_numCells;
  input [K-1:0] abs_cursC, abs_cursR;
  input cell_state;

  output logic mm_read_en;
  output logic [K-1:0] mm_cell_addrC, mm_cell_addrR;
  output logic [23:0] mm_rgb;
  output logic mm_gfx_en; //  enable when rgb is correct

  logic [7:0] ptrR, ptrC; // minimap is 256x256 pixels
  logic [10:0] ptrR_low, ptrC_low;
  logic ptrR_high_en, ptrC_high_en;

  logic mm_en_p0, mm_en_p1, mm_en_p2;

  logic [K-1:0] cell_addrR, cell_addrC;
  logic [K:0] adj_cellR, adj_cellC;

  logic curs_en;
  logic [K:0] adj_borderR, adj_borderC;
  logic in_display;
  logic on_border;

/* This section adjuts the absolute ptrs
 * determines if the pointer corresponds to this block
 *
 * setup equations
 *  0x70  < rPtr < 0x170 &&
 *  0x260 < cPtr < 0x3B0
 */
  assign ptrR_low = {1'b0,abs_ptrR} - 11'h80;
  assign ptrC_low = {1'b0,abs_ptrC} - 11'h1C0;
  assign ptrR_high_en = (10'h100 > abs_ptrR);
  assign ptrC_high_en = (10'h240 > abs_ptrC);
  assign mm_en_p0 = ~ptrR_low[10] & ~ptrC_low[10] &
                    ptrR_high_en & ptrC_high_en;
  assign ptrR = ptrR_low[7:0];
  assign ptrC = ptrC_low[7:0];
  assign mm_gfx_en = mm_en_p0;
  assign mm_read_en = mm_en_p0;


// This block calculates  cell_addr
  assign cell_addrR = ptrR[7:8-K];
  assign cell_addrC = ptrC[7:8-K];
  assign mm_cell_addrR = cell_addrR;
  assign mm_cell_addrC = cell_addrC;

// calculate if this cell is the cursor.
  assign curs_en = ~run_mode && // in EDIT mode
                    (cell_addrR == abs_cursR) && //and cell_addr == curs
                    (cell_addrC == abs_cursC); //both are absolute locations

/* This section takes in curs_en, cell_state, win_numCells
 * and outputs an rgb value
 */
  assign adj_cellR = (cell_addrR < winR) ? {1'b1,cell_addrR} : {1'b0,cell_addrR} ;
  assign adj_cellC = (cell_addrC < winC) ? {1'b1,cell_addrC} : {1'b0,cell_addrC} ;
  assign adj_borderR = {1'b0,winR} + win_numCells[K:0];
  assign adj_borderC = {1'b0,winC} + win_numCells[K:0];
  assign in_display = (adj_cellR < adj_borderR) &&
                      (adj_cellC < adj_borderC);
 
  assign on_border = (adj_cellR == winR && ptrR[7-K:0] == {{8-K}{1'b0}}) ||
                     (adj_cellC == winC && ptrC[7-K:0] == {{8-K}{1'b0}}) ||
                     ((adj_cellR == adj_borderR - 1'b1) && ptrR[7-K:0] == {{8-K}{1'b1}}) ||
                     ((adj_cellC == adj_borderC - 1'b1) && ptrR[7-K:0] == {{8-K}{1'b1}});

  always_comb begin
    if(curs_en) mm_rgb = `RED;
    else if(on_border) mm_rgb = `BLUE;
    else begin
      if(in_display) mm_rgb = cell_state ? `BLACK : `WHITE ;
      else mm_rgb = cell_state ? `BLACK : `GREY(8'h7f) ;
    end
  end


/* TODO ASSERTION CHECKS
  on_border -> in_display
*/
endmodule
