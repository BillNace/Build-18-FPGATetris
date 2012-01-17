`default_nettype none
// GOL display:
//   GFX enable conditions:
//   When enable conditions match,
//     Read appropriate GOL cell and drive appropriate color
//     Superimpose appropriate gridlines on top of GOL Cell (Grey 127,127,127) 
//     If on cursor location and ~run_mode, superimpose cursor pixels on top of
//       appropriate GOL Cell pixels
//     Equations for cellAddrR, cellAddrC:
//     cellAddrR = windowLocR + windowSize*ptrR/640
//     cellAddrC = windowLocC + windowSize*ptrC/640
//     pixelAddrR = ptrR % cellSize;
//     pixelAddrC = ptrC % cellSize;
//
//   
//
//

// Sets up and calculates which GOL cell the ptrs correspond to
// outputs cell address and pixel loc within cell

// make sure that a is 8 bits


module gol_display_gfx(
  run_mode, abs_ptrR, abs_ptrC, winR, winC,
  win_numCells, abs_cursC, abs_cursR, cell_state,
  dsp_read_en, dsp_cell_addrC, dsp_cell_addrR, dsp_rgb, dsp_gfx_en);

  parameter K = 6;
  input run_mode; // display cursor if run_mode==0
  input [9:0] abs_ptrR, abs_ptrC;
  input [K-1:0] winR, winC;
  input [7:0] win_numCells;
  input [K-1:0] abs_cursC, abs_cursR;
  input cell_state;

  output logic dsp_read_en;
  output logic [K-1:0] dsp_cell_addrR, dsp_cell_addrC;
  output logic [23:0] dsp_rgb;
  output logic dsp_gfx_en; //  enable when rgb is correct

  logic dsp_en_p0, dsp_en_p1, dsp_en_p2;

  logic [9:0] ptrR, ptrC;
  logic [10:0] ptrR_low, ptrC_low;
  logic ptrR_high_en, ptrC_high_en;

  logic [K-1:0] cell_addrC, cell_addrR;
  logic [6:0] pix_addrR, pix_addrC; // 640/8 = 80 -> 7 bits
  logic curs_en;

/* This section adjuts the absolute ptrs
 * determines if the pointer corresponds to this block
 *
 * setup equations
 *     0x70 <= ptrR < 0x2F0 &&
 *     0x10 <= ptrC < 0x290
 */
  assign ptrR_low = {1'b0,abs_ptrR} - 11'h80;
  assign ptrC_low = {1'b0,abs_ptrC} - 11'h20;
  assign ptrR_high_en = (10'h180 > abs_ptrR);
  assign ptrC_high_en = (10'h120 > abs_ptrC);

  // enabled if none of the overflow bits are set from subtraction
  assign dsp_en_p0 = ~ptrR_low[10] & ~ptrC_low[10] & 
                     ptrR_high_en & ptrC_high_en;

  assign ptrR = ptrR_low[9:0];
  assign ptrC = ptrC_low[9:0];
  // TODO pipe these eventually appropriately
  assign dsp_gfx_en = dsp_en_p0;
  assign dsp_read_en = dsp_en_p0;


  assign dsp_cell_addrR = cell_addrR;
  assign dsp_cell_addrC = cell_addrC;
// This block calculates  cell_addr and pix_addr
  cell_calculator #(K) cell_calculator1(.*);  


// calculate if this cell is the cursor.
  assign curs_en = ~run_mode & // in EDIT mode
                    (cell_addrR == abs_cursR) & //and cell_addr == curs
                    (cell_addrC == abs_cursC); //both are absolute locations

/* This section takes in curs_en, pix_addr, cell_state, win_numCells
 * and outputs an rgb value
 */
  always_comb begin
    if( (pix_addrR == 7'h0) || (pix_addrC == 7'h0)) dsp_rgb = `GREY(8'h7f);
    else begin
      dsp_rgb = (cell_state) ? `BLACK : `WHITE ;
      if(curs_en) begin// TODO specify a border of red opposed to all red
        dsp_rgb = `RED;
      end
    end
  end


/* TODO ASSERTION CHECKS
  dsp_read_en -> (0 <= ptrR/C < 640 always)
  ~run_mode -> (every time ptrs cycle, curs_en is enabled at least once)
*/
endmodule

// TODO cell_calculator ( combinational for now)
/* cellWidth = 256/win_numCells
 * cell_addrR = winR + ptrR / cellWidth
 * pix_addrR = ptrR % cellWidth
 */
module cell_calculator(win_numCells, winR, winC, ptrR, ptrC,
                       cell_addrR, cell_addrC, pix_addrR, pix_addrC);
  
  parameter K = 6;
  input [7:0] win_numCells;
  input [K-1:0] winR, winC;
  input [9:0] ptrR, ptrC;
  output logic [K-1:0] cell_addrR, cell_addrC;
  output logic [6:0] pix_addrR, pix_addrC;
  
  logic [6:0] cell_width;

  logic [9:0] cell_addrR_pre, cell_addrC_pre;

  
  always_comb begin
    case(win_numCells[5:3])
      3'b1?? : cell_width = 7'b0001000; //256/32
      3'b01? : cell_width = 7'b0010000; //256/16
      3'b001 : cell_width = 7'b010000; //256/8
      default :   cell_width = 7'b0100000; //DEFAULT
    endcase
  end

  assign cell_addrR = winR + cell_addrR_pre[K-1:0];
  assign cell_addrC = winR + cell_addrC_pre[K-1:0];

  div #(10,7) divR(ptrR,cell_width,cell_addrR_pre,pix_addrR);
  div #(10,7) divC(ptrC,cell_width,cell_addrC_pre,pix_addrC);


endmodule

