/* ================================================================================
// Flip-flop template
// Author: Seyed Hadi Mirfarshbafan
// Date: 10/22/2019
// Project: SynTech
// ---- Description ---------------------------------------------------------------
// Positive-edge triggered FF with asynchronous reset and write enable
// ---- Input/Output specifications -----------------------------------------------
// D_DI     input data signal of FF
// Q_DO     output data signal of FF
// WrEn_SI  write enable signal (writes when active high)
// ================================================================================ */

module FF
#(
  parameter DATA_WIDTH = 10   // Number of bits for data
)
(   
  input                       Clk_CI,  // Clock signal
  input                       Rst_RBI, // Asynchronous active low reset
  input                       WrEn_SI, // Active High Write enable

  input      [DATA_WIDTH-1:0] D_DI,    // Input data to FF
   
  output reg [DATA_WIDTH-1:0] Q_DO     // Output data of FF
);

always @(posedge Clk_CI or negedge Rst_RBI)
  if(~Rst_RBI)
    Q_DO <= 0;
  else if(WrEn_SI)
    Q_DO <= D_DI;

endmodule
