module VGA(
  input  logic  [9:0]  iRed,    // Host Side
  input  logic  [9:0]  iGreen,
  input  logic  [9:0]  iBlue,
  output logic [10:0]  oCurrent_X,
  output logic [10:0]  oCurrent_Y,
  output logic [21:0]  oAddress,
  output logic         oRequest,
  output logic  [9:0]  oVGA_R,  // VGA Side
  output logic  [9:0]  oVGA_G,
  output logic  [9:0]  oVGA_B,
  output logic         oVGA_HS,
  output logic         oVGA_VS,
  output logic         oVGA_BLANK,
  output logic         oVGA_CLOCK,
  input  logic         iCLK_50M,  // Control inputs
  input  logic         iRST_N
);



// Internal Registers
logic   [10:0] H_Cont;
logic   [10:0] V_Cont;
logic          clk_25M;
////////////////////////////////////////////////////////////
// Horizontal Parameter
parameter H_FRONT = 16;
parameter H_SYNC = 96;
parameter H_BACK = 48;
parameter H_ACT = 640;
parameter H_BLANK = H_FRONT+H_SYNC+H_BACK;
parameter H_TOTAL = H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
// Vertical Parameter
parameter V_FRONT = 11;
parameter V_SYNC = 2;
parameter V_BACK = 31;
parameter V_ACT = 480;
parameter V_BLANK = V_FRONT+V_SYNC+V_BACK;
parameter V_TOTAL = V_FRONT+V_SYNC+V_BACK+V_ACT;
////////////////////////////////////////////////////////////

assign oVGA_BLANK = ~((H_Cont<H_BLANK)||(V_Cont<V_BLANK));
assign oVGA_CLOCK = ~iCLK_50M;
assign oVGA_R  = iRed;
assign oVGA_G  = iGreen;
assign oVGA_B  = iBlue;
assign oAddress = oCurrent_Y*H_ACT+oCurrent_X;
assign oRequest = ((H_Cont>=H_BLANK && H_Cont<H_TOTAL) &&
       (V_Cont>=V_BLANK && V_Cont<V_TOTAL));
assign oCurrent_X = (H_Cont>=H_BLANK) ? H_Cont-H_BLANK : 11'h0 ;
assign oCurrent_Y = (V_Cont>=V_BLANK) ? V_Cont-V_BLANK : 11'h0 ;

// Horizontal Generator: Refer to the pixel clock
always_ff @(posedge clk_25M or negedge iRST_N)
begin
 if(!iRST_N)
 begin
  H_Cont  <= 0;
  oVGA_HS  <= 1;
 end
 else
 begin
  if(H_Cont<H_TOTAL)
  H_Cont <= H_Cont+1'b1;
  else
  H_Cont <= 0;
  // Horizontal Sync
  if(H_Cont==H_FRONT-1)   // Front porch end
  oVGA_HS <= 1'b0;
  if(H_Cont==H_FRONT+H_SYNC-1) // Sync pulse end
  oVGA_HS <= 1'b1;
 end
end

// Vertical Generator: Refer to the horizontal sync
always_ff @(posedge oVGA_HS or negedge iRST_N)
begin
 if(!iRST_N)
 begin
  V_Cont  <= 0;
  oVGA_VS  <= 1;
 end
 else
 begin
  if(V_Cont<V_TOTAL)
  V_Cont <= V_Cont+1'b1;
  else
  V_Cont <= 0;
  // Vertical Sync
  if(V_Cont==V_FRONT-1)   // Front porch end
  oVGA_VS <= 1'b0;
  if(V_Cont==V_FRONT+V_SYNC-1) // Sync pulse end
  oVGA_VS <= 1'b1;
 end
end

always_ff @(posedge iCLK_50M) begin
  clk_25M <= ~clk_25M;
end

endmodule: VGA