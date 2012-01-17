`default_nettype none
module gol_logic(
  clk, rst_b,
  write_en, change_state,
  wAddrR, wAddrC,
  rAddrR, rAddrC,
  write_data,
  read_data);
  parameter K = 6;
  parameter kPow = 1<<K;// internal signals
  input clk, rst_b;
  input write_en, change_state;
  input [K-1:0] wAddrR, wAddrC;
  input [K-1:0] rAddrR, rAddrC;
  input write_data;
  output logic read_data;

  logic [kPow-1:0] d_u, u_d, l_r, r_l;

  cellSquare #(K) 
    cellTOP(.u_in(d_u), .d_in(u_d), .l_in(r_l), .r_in(l_r),
           .ul_in(d_u[0]), .ur_in(d_u[kPow-1]), .dl_in(u_d[0]), .dr_in(u_d[kPow-1]),
           .write_en(write_en), .change_state, .clk, .rst_b,
           .rAddrR({rAddrR,1'b0}), .rAddrC({rAddrC,1'b0}),
           .wAddrR({wAddrR,1'b0}), .wAddrC({wAddrC,1'b0}),
           .read_data, .write_data,
           .u_out(u_d), .d_out(d_u), .l_out(l_r), .r_out(r_l)
           );

endmodule


module cellSquare(
  u_in, d_in, l_in, r_in,
  ul_in, ur_in, dl_in, dr_in,
  write_en, change_state, clk, rst_b,
  rAddrR, rAddrC,
  wAddrR, wAddrC,
  write_data, read_data,
  u_out, d_out, l_out, r_out);

  parameter K = 6;
  parameter kPow  = 1<<K;
  input [kPow-1:0] u_in, d_in, l_in, r_in;
  input ul_in, ur_in, dl_in, dr_in;
  input  write_en, change_state, clk, rst_b;
  input [K:0] rAddrR, rAddrC;
  input [K:0] wAddrR, wAddrC;
  input write_data;
  output logic read_data;
  output logic [kPow-1:0] u_out, d_out, l_out, r_out;


  generate
    if(K==0) begin
      k_is0 cell_inst(.*); 
    end
    else begin
      k_greater0 #(K) cell_inst(.*);
    end
  endgenerate


endmodule

module k_is0(
  u_in, d_in, l_in, r_in,
  ul_in, ur_in, dl_in, dr_in,
  write_en, change_state, clk, rst_b,
  rAddrR, rAddrC,
  wAddrR, wAddrC,
  write_data, read_data,
  u_out, d_out, l_out, r_out);

  input u_in, d_in, l_in, r_in;
  input ul_in, ur_in, dl_in, dr_in;
  input write_en, change_state, clk, rst_b;
  input rAddrR, rAddrC;
  input wAddrR, wAddrC;
  input write_data;
  output logic read_data;
  output logic u_out, d_out, l_out, r_out;



  logic [1:0] cnt0_0, cnt0_1, cnt0_2, cnt0_3;
  logic [2:0] cnt1_0, cnt1_1;
  logic [3:0] cnt;
  logic CS, NS;
  
    always_comb begin
      cnt0_0 = {1'b0, u_in} + {1'b0, ul_in};
      cnt0_1 = {1'b0, l_in} + {1'b0, dl_in};
      cnt0_2 = {1'b0, d_in} + {1'b0, dr_in};
      cnt0_3 = {1'b0, r_in} + {1'b0, ur_in};

      cnt1_0 = {1'b0, cnt0_0} + {1'b0, cnt0_1};
      cnt1_1 = {1'b0, cnt0_2} + {1'b0, cnt0_3};

      cnt = {1'b0, cnt1_0} + {1'b0, cnt1_1};
      read_data = CS;
      u_out = CS;
      d_out = CS;
      l_out = CS;
      r_out = CS;
    end
  always_comb begin
    if(write_en) NS = write_data;
    else if(change_state) NS =  (cnt==3'h3) | (CS & (cnt==3'h2)) ;
    else NS = CS;
  end

  always_ff @(posedge clk, negedge rst_b) begin
    if(~rst_b) CS <= 1'b0; 
    else CS <= NS;
  end

endmodule

// k >=1
module k_greater0(
  u_in, d_in, l_in, r_in,
  ul_in, ur_in, dl_in, dr_in,
  write_en, change_state, clk, rst_b,
  rAddrR, rAddrC,
  wAddrR, wAddrC,
  write_data, read_data,
  u_out, d_out, l_out, r_out);

  parameter K = 6;
  parameter kPow = 1<<K;
  input [kPow-1:0] u_in, d_in, l_in, r_in;
  input ul_in, ur_in, dl_in, dr_in;
  input  write_en, change_state, clk, rst_b;
  input [K:0] rAddrR, rAddrC;
  input [K:0] wAddrR, wAddrC;
  input write_data;
  output logic read_data;
  output logic [kPow-1:0] u_out, d_out, l_out, r_out;


  logic [kPow/2-1:0] cell00_01, cell00_10;
  logic [kPow/2-1:0] cell01_00, cell01_11;
  logic [kPow/2-1:0] cell10_00, cell10_11;
  logic [kPow/2-1:0] cell11_01, cell11_10;
  
  logic cell00_11, cell11_00;
  logic cell01_10, cell10_01;

  logic read_data00, read_data01, read_data10, read_data11;
  logic we00, we01, we10, we11;

//check assignments here.
  always_comb begin
    cell00_11 = cell00_10[0];
    cell10_01 = cell10_00[0];
    cell11_00 = cell11_01[kPow/2-1];
    cell01_10 = cell01_11[kPow/2-1];
  end

  always_comb begin
    we00 = 1'b0;
    we01 = 1'b0;
    we10 = 1'b0;
    we11 = 1'b0;
    if(write_en) begin
      case({wAddrR[K],wAddrC[K]})
        2'b00: we00 = 1'b1;
        2'b01: we01 = 1'b1;
        2'b10: we10 = 1'b1;
        2'b11: we11 = 1'b1;
      endcase
    end
    case({rAddrR[K],rAddrC[K]})
      2'b00: read_data = read_data00;
      2'b01: read_data = read_data01;
      2'b10: read_data = read_data10;
      2'b11: read_data = read_data11;
    endcase
  end

  cellSquare #(.K(K-1)) 
    cell00(.u_in(u_in[kPow-1:kPow/2]), .d_in(cell10_00), .l_in(l_in[kPow-1:kPow/2]), .r_in(cell01_00),
           .ul_in(ul_in), .ur_in(u_in[kPow/2-1]), .dl_in(l_in[kPow/2-1]), .dr_in(cell11_00),
           .write_en(we00), .change_state, .clk, .rst_b,
           .rAddrR(rAddrR[K-1:0]), .rAddrC(rAddrC[K-1:0]),
           .wAddrR(wAddrR[K-1:0]), .wAddrC(wAddrC[K-1:0]),
           .read_data(read_data00), .write_data,
           .u_out(u_out[kPow-1:kPow/2]), .d_out(cell00_10), .l_out(l_out[kPow-1:kPow/2]), .r_out(cell00_01)
           );

  cellSquare #(.K(K-1)) 
    cell01(.u_in(u_in[kPow/2-1:0]), .d_in(cell11_01), .l_in(cell00_01), .r_in(r_in[kPow-1:kPow/2]),
           .ul_in(u_in[kPow/2]), .ur_in(ur_in), .dl_in(cell10_01), .dr_in(r_in[kPow/2-1]),
           .write_en(we01), .change_state, .clk, .rst_b,
           .rAddrR(rAddrR[K-1:0]), .rAddrC(rAddrC[K-1:0]),
           .wAddrR(wAddrR[K-1:0]), .wAddrC(wAddrC[K-1:0]),
           .read_data(read_data01), .write_data,
           .u_out(u_out[kPow/2-1:0]), .d_out(cell01_11), .l_out(cell01_00), .r_out(r_out[kPow-1:kPow/2])
           );


  cellSquare #(.K(K-1)) 
    cell10(.u_in(cell00_10), .d_in(d_in[kPow-1:kPow/2]), .l_in(l_in[kPow/2-1:0]), .r_in(cell11_10),
           .ul_in(l_in[kPow/2]), .ur_in(cell01_10), .dl_in(dl_in), .dr_in(d_in[kPow/2-1]),
           .write_en(we10), .change_state, .clk, .rst_b,
           .rAddrR(rAddrR[K-1:0]), .rAddrC(rAddrC[K-1:0]),
           .wAddrR(wAddrR[K-1:0]), .wAddrC(wAddrC[K-1:0]),
           .read_data(read_data10), .write_data,
           .u_out(cell10_00), .d_out(d_out[kPow-1:kPow/2]), .l_out(l_out[kPow/2-1:0]), .r_out(cell10_11)
           );


  cellSquare #(.K(K-1)) 
    cell11(.u_in(cell01_11), .d_in(d_in[kPow/2-1:0]), .l_in(cell10_11), .r_in(r_in[kPow/2-1:0]),
           .ul_in(cell00_11), .ur_in(r_in[kPow/2]), .dl_in(d_in[kPow/2]), .dr_in(dr_in),
           .write_en(we11), .change_state, .clk, .rst_b,
           .rAddrR(rAddrR[K-1:0]), .rAddrC(rAddrC[K-1:0]),
           .wAddrR(wAddrR[K-1:0]), .wAddrC(wAddrC[K-1:0]),
           .read_data(read_data11), .write_data,
           .u_out(cell11_01), .d_out(d_out[kPow/2-1:0]), .l_out(cell11_10), .r_out(r_out[kPow/2-1:0])
           );

endmodule
