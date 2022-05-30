module logged_sync
(
  input  wire  [1:0]  InputChkDis,
  input  wire         Y_RST_b,
  input  wire         A_RST_b,
  input  wire         A_CLK,
  input  wire         Y_CLK,
  input  wire         A,
  input  wire         clr_Y,
  output wire         Y_sync_back,
  output wire         Y
);

  reg                 A_log;
  wire                A_log_D;
//wire                Y_sync_back;
  wire                Y_sync_back_n;
  
  syncx_arst  u_sync0 
  ( 
  .D            (clk_Y),  
  .InputChkDis  (Y|InputChkDis[1]), 
  .RSTB         (A_RST_b),
  .CK           (A_CLK),
  .Q            (Y_sync_back)
  );
  
  //assign Y_sync_back_n = !y_sync_back;                      //BEHAVIOR
  fch_INVX1 u_inv  ( .A (Y_sync_back), .Y (Y_sync_back_n));   //cell
  //assign A_log_D = A || (A_log && Y_sync_back_n);
  fch_AO21  u_ao21 (.A1 (A_log), .A2 (Y_sync_back_n), .B (A), .Z(A_log_D));  
  //always@(poedge A_CLK or negedge A_RST_b) 
  //begin
    //if(!A_RST_b) A_log <= 1'b0;
    //else         A_log <= A_log_D;
  //end
 fch_SDFFRX1 u_ff(.D(A_log_D), .RN(A_RST_b), .CK(A_CLK), .SI(1'b0), .SE(1'b0), .Q(A_log)):
 
   syncx_arst  u_sync1 
  ( 
  .D            (A_log),  
  .InputChkDis  (Y|InputChkDis[0]), 
  .RSTB         (Y_RST_b),
  .CK           (Y_CLK),
  .Q            (Y)
  );
 
 endmodule
