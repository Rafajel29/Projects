//=========================================================================
//ECE 5746 - Simple Filter Model  
//(c) 2019 hs994,fjf46@cornell.edu
//
//Author: Haochuan Song, Frans Fourie
//Last edited: 12/05/2019
//Project: SynTech
//
//---Description------------------------------------------------
//A second order IIR filter supports low-pass or direct pass
//---I/O Description--------------------------------------------
// sta_FLT_In_DI            [24bit]    input data =  sta.OSC.Out_DO
// sta_FLT_Out_DO           [24bit]    output data
// =========================================================================

/* --------------------------------------------------------------------------------
// Module ports declaration 
// -------------------------------------------------------------------------------- */
module FLT 
#(
  // ---- The following parameters are the same for all blocks
  	parameter ADDR_WIDTH   = 5,  // number of entries in the parameter memory is equal to 2^(ADDR_WIDTH)
    parameter MEM_WIDTH    = 32,  // word length of each memory entry to store parameters
    // ---- the following parameters are FLT block specific 
    parameter IN_WIDTH    = 24,   // width of FLT inputs
    parameter OUT_WIDTH   = 24,   // width of FLT outputs
    parameter COF_WIDTH   = 32, // width of FLT coefficients
	  parameter COSIN_WIDTH = 19
)
(
  // ---- The following signals are the same for all blocks (no touchy!)
  input                         	Clk_CI,     // Clock signal
  input                         	Rst_RBI,    // Asynchronous active low reset
  input                         	WrEn_SI,    // Active high write enable
  input         [ADDR_WIDTH-1:0]	Addr_DI,    // Address of the parameter in the memory
  input         [MEM_WIDTH-1:0] 	PAR_In_DI,  // Parameter input (written from external interface)
  // ---- The following signals are FLT block specific 
  input  signed [IN_WIDTH-1:0]   	sta_FLT_In_DI,  // Input to the block (block can read from other block's output states)
  output signed [OUT_WIDTH-1:0]  	sta_FLT_Out_DO // Output of the block (state). Use signed, whenever you are dealing with samples
);

/* --------------------------------------------------------------------------------
// Common parameters for all blocks (do not change)
// -------------------------------------------------------------------------------- */

localparam MEM_DEPTH = (1 << ADDR_WIDTH);   // You can have at most 2^ADD_WIDTH parameters per block
integer i;                                  // temporary variable
// ---- Defines block parameter memory that can be written from the outside of your module
// ---- Creates a register array (memory) to hold the parameter of the block
reg  [MEM_WIDTH-1:0] parameter_memory [0:4];

// -------------------------------------------------------------------------------
// Internal parameters and signals/variables declaration in FLT
// Define the internal wires, regs and all other variables of your module
// -------------------------------------------------------------------------------- */

// ---- Assign a wire with descriptive names to each of these memory entries that hold a parameter. 
localparam  RQ_frac_WIDTH 		= 31;
localparam  alpha_frac_WIDTH 	= 31;
localparam	cos_frac_WIDTH 		= 30;
localparam  a0_frac_WIDTH 		= 31;
localparam	RFS_shift_WIDTH 	= 10;
localparam  DIV_WIDTH           = 20;
	
wire signed [COF_WIDTH-1:0] par_FLT_RQ_D;       	// 1/Q: reciprocal of quality factor of low-pass filter stored in parameter memory
wire signed [COF_WIDTH-1:0] par_FLT_f0_D;       	// cut-off frequency, stored in parameter memory
wire signed [COF_WIDTH-1:0] par_FLT_RFS_norm_D;   // 2/Fs: Normalized reciprocal of Internal Sampling Frequency, used to calculate alpha
wire signed [COF_WIDTH-1:0] par_FLT_SD_D;       	// scaling down factor corresponding to quality factor par.FLT.RQ_D
wire 	 	    [COF_WIDTH-1:0] par_FLT_type_S;       // control signal for different filter types; haven't used it so far, stored in parameter memory

assign  par_FLT_RQ_D = parameter_memory[0];       // par_FLT_RQ_D is the name of the first entry of the parameter memory according to the block diagram
assign  par_FLT_f0_D = parameter_memory[1];
assign  par_FLT_RFS_norm_D = parameter_memory[2];
assign  par_FLT_SD_D = parameter_memory[3];
assign  par_FLT_type_S = parameter_memory[4];

// ---- FLT block specific wires and registers
// -- Wires in combinational logic
wire signed [COSIN_WIDTH-1:0] sin_out_D;  			     // output of sine block
wire signed [COF_WIDTH-1:0]   constant2_D;  		     // 1/(2Q); right shift 1bit to par_FLT_DQ_D
wire signed [COF_WIDTH-1:0]   alpha_D;    			     // alpha, intermediate parameters used to calculate transfer function coefficients
wire signed [COF_WIDTH-1:0]   a2_minus_D; 			     // -a2
wire signed [DIV_WIDTH-1:0]   a0_D;     				     // a0
wire signed [DIV_WIDTH-1:0]   a0_inv_D;   			     // 1/a0
wire signed [16-1:0]          omega0_normalized_D;	 // sin(pi*omega), called nomalized
wire signed	[COSIN_WIDTH-1:0]	cos_out_D;				     // output of cos(pi*omega0)
wire signed [COSIN_WIDTH:0] a1_minus_D;				       // -a1
wire signed [COSIN_WIDTH:0] b1_D;					           // b1
wire signed	[COSIN_WIDTH:0] b0_D;					           // b0
wire signed [COSIN_WIDTH:0] b2_D;					           // b2 = b0

wire signed [2*COF_WIDTH-1:0] omega0_normalized_tmp_D;	// 64bit temporary result for omega0
wire signed [COSIN_WIDTH+1:0]	sin_out_tmp_D;				    // 21bit temporary result for sin_out_D
wire signed [COSIN_WIDTH+1:0]	cos_out_tmp_D;				    // 21bit temporary result for cos_out_D
wire signed [COF_WIDTH+COSIN_WIDTH:0]   alpha_tmp_D;    // 64bit temporary result for alpha
wire signed [2*DIV_WIDTH-1:0]   a0_inv_tmp_D;     			// 64bit temporary result for 1/a0
wire signed [COF_WIDTH-1:0] 	  a0_rem_D;		  			    // remainder of 1/a0
wire 							              a0_divby0_D;	  			  // to see if the dividor is 0

// -- Wires in sequencial logic
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldIn0_D;				// FFx0,32b
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldIn1_D;				// FFx1,32b
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldIn2_D;				// FFx2,32b
wire signed	[COF_WIDTH-1:0]		xb0_D;							    // xb0,32b
wire signed	[COF_WIDTH-1:0]		xb1_D;							    // xb1,32b
wire signed	[COF_WIDTH-1:0]		xb2_D;							    // xb2,32b
wire signed	[COF_WIDTH-1:0]		sumx2x1_D;					    // sumx2x1, 32b
wire signed [COF_WIDTH-1:0]		sumx0_D;						    // sumx0, 32b
wire signed [COF_WIDTH-1:0]		sumy2y1_D;						  // sumy2y1,32b
wire signed [COF_WIDTH-1:0]		sumy0_D;						    // sumy0,32b
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldSample0_D;	  // FFy0,32b
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldSample1_D;		// FFy1,32b
wire signed	[COF_WIDTH-1:0] 	sta_FLT_OldSample2_D;		// FFy2,32b
wire signed	[COF_WIDTH-1:0]		ya1_D;							    // ya1,32b
wire signed	[COF_WIDTH-1:0]		ya2_D;							    // ya2,32b

wire signed [IN_WIDTH-1:0]				sta_FLT_IN_REG_D;	// to align the clock together
wire signed [IN_WIDTH+COF_WIDTH-1:0]  	sta_FLT_In_SD_tmp_D;// 24+32 = 56bit temporary result for scaling down
wire signed [COF_WIDTH+COSIN_WIDTH:0]	xb0_tmp_D;			// 52bit temporary result for xb0
wire signed [COF_WIDTH+COSIN_WIDTH:0]	xb1_tmp_D;			// 52bit temporary result for xb1
wire signed [COF_WIDTH+COSIN_WIDTH:0]	xb2_tmp_D;			// 52bit temporary result for xb2
wire signed [2*COF_WIDTH-1:0]			ya0_tmp_D;			// 64bit temporary result for xb0
wire signed [COF_WIDTH+COSIN_WIDTH:0]  ya1_tmp_D;			// 52bit temporary result for xb1  Check calculation for clarification
wire signed [2*COF_WIDTH-1:0]			ya2_tmp_D;			// 64bit temporary result for xb2
wire signed [COF_WIDTH:0]				sumy0_tmp_D;		// 33bit temporary result for sumy0

reg a0_enable_S;   // when to start sequintial divider
wire a0_valid_S;    // when the division is finished
wire signed [COSIN_WIDTH-1:0] cos_out_REG_D;
wire signed [COF_WIDTH-1:0]   a2_minus_REG_D;            // -a2_REG
	
/* --------------------------------------------------------------------------------
// Register Transfer Level (RTL) description of parameter memory (do not change)
// -------------------------------------------------------------------------------- */

// ---- Description of the parameter memory (same for all blocks)
always @(posedge Clk_CI or negedge Rst_RBI)
begin                              // begin the memory control block
  if (!Rst_RBI) begin  // Reset all the parameters upon Rst_RBI being deasserted low
     parameter_memory[0] = 32'b0000_1100_1100_1100_1100_1100_1100_1100;
	 parameter_memory[1] = 500;
	 parameter_memory[2] = 32'b0000_0000_1010_1101_1010_1011_1001_1111;
	 parameter_memory[3] = 4;
	 parameter_memory[4] = 1;
  end else if (WrEn_SI) begin
    parameter_memory[Addr_DI] = PAR_In_DI; // Write parameter to memory if WrEn_SI is asserted high
  end
end                                        // end the memory control block

/* --------------------------------------------------------------------------------
// Register Transfer Level (RTL) description of FLT specific code
// -------------------------------------------------------------------------------- */

// ------------------------------------------------------------------------------------------
// *******************Coefficients calculation Begin*****************************************
// ------------------------------------------------------------------------------------------
assign omega0_normalized_tmp_D = par_FLT_f0_D * par_FLT_RFS_norm_D;						// 64bit = [s,31,0] * [s,0,31] = [s,32,31]; note that par_FLT_RFS_norm_D has times 2^10
assign omega0_normalized_D = {omega0_normalized_tmp_D[63],omega0_normalized_tmp_D[39:25]};	// in the 64b result, 41bits are fraction; truancate to 16b = {[sign bit]:[39:25]}
/* Instance of DW_sincos----------------------------------------------------
sin_out_D = sin (pi * omega0_normalized_D)
------------------------------------------------------------------------------*/
// calculate a1_minus_D, b1_D, b2_D
// calculate -a1
DW_sincos #(
	.A_width(16), 
	.WAVE_width(COSIN_WIDTH+2),  // 21b = {s,1,19} 1 sign bit, 1 integer bit, 18 fraction bits with 1 error
	.arch(0), 
	.err_range(1)) 
FLT_cos (
	.A(omega0_normalized_D),
	.SIN_COS(1'b1), // 0 for sine 1 for cosine
	.WAVE(cos_out_tmp_D) // {s,1,19}
);
assign cos_out_REG_D = {cos_out_tmp_D[20],cos_out_tmp_D[18:1]}; // 19b = {s,0,18}
// pipelining, make a1_minus_D, b0_D, b1_D, b2_D output with a0_inv_D at the same time
FF #(
  .DATA_WIDTH ( COSIN_WIDTH )
)
FF_cos_OUT
(
  .Clk_CI  ( Clk_CI         ),
  .Rst_RBI ( Rst_RBI        ),
  .WrEn_SI ( a0_valid_S     ),
  .D_DI    ( cos_out_REG_D  ),
  .Q_DO    ( cos_out_D      )
);
assign a1_minus_D = {cos_out_D[18:0],1'b0};         // 20b = {s,1,18}

// calculate b1_D
assign b1_D = 20'b0_1_00_0000_0000_0000_0000 - {1'b0,cos_out_D}; 	// 20b: {s,1,18} - {s,1,18} = {s,1,18}											// 19b: {s,0,18}
// calculate b0_D, b2_D
assign b0_D = b1_D;		// b0 = b1/2: move the decimal to the left; 20b:{s,0,19}
assign b2_D = b1_D;		// b2 = b0 {s,0,19}


// calculate a2_minus_D, a0_inv_D
DW_sincos #(
	.A_width(16), 
	.WAVE_width(COSIN_WIDTH+2),  // 21b = {s,1,19} 1 sign bit, 1 integer bit, 18 fraction bits with 1 error
	.arch(0), 
	.err_range(1)) 
FLT_sin (
	.A(omega0_normalized_D),
	.SIN_COS(1'b0), // 0 for sine 1 for cosine
	.WAVE(sin_out_tmp_D) // {s,1,19}
);
wire signed [COSIN_WIDTH-1:0] sin_out_REG_D;
assign sin_out_REG_D = {sin_out_tmp_D[20],sin_out_tmp_D[18:1]}; // {s,0,18}
FF #(
  .DATA_WIDTH ( COSIN_WIDTH )
)
FF_sin_OUT
(
  .Clk_CI  ( Clk_CI         ),
  .Rst_RBI ( Rst_RBI        ),
  .WrEn_SI ( 1'b1           ),
  .D_DI    ( sin_out_REG_D  ),
  .Q_DO    ( sin_out_D      )
);

// this is for par_FLT_RQ = 0.1---------------------------------------
// calculate -a2
assign constant2_D = par_FLT_RQ_D >>> 1;                 // right shift 1 bit: (1/Q)/2, {s,0,31}
assign alpha_tmp_D = constant2_D * sin_out_D;            // 51bit: alpha = (sin(omega0)/2Q):  [s,3,28]*[s,0,18] = [s,4,46]
assign alpha_D = {alpha_tmp_D[50],alpha_tmp_D[45:15]};   // 32bit {s,0,31}  // truancate to 32bit: Q = 10, alpha is in soooo small,{s,0,31} <= {s,0,31(60:30)}
//assign a2_minus_D = alpha_D + (1<<alpha_frac_WIDTH);   // -a2 = alpha - 1 = alpha + (-1) is in close to +0, after -1, greater than -1,{s,0,31}
assign a2_minus_REG_D = {1'b1,alpha_D[COF_WIDTH-2:0]};       // same operation as alpha_D + (1<<31)
// pipelining, make a2_minus_D output with a0_inv_D at the same time
FF #(
  .DATA_WIDTH ( COF_WIDTH )
)
FF_a2_minus
(
  .Clk_CI  ( Clk_CI         ),
  .Rst_RBI ( Rst_RBI        ),
  .WrEn_SI ( a0_valid_S     ),
  .D_DI    ( a2_minus_REG_D  ),
  .Q_DO    ( a2_minus_D      )
);

// calculate 1/a0 = a0_inv
assign a0_D = {1'b0,1'b1,alpha_D[COF_WIDTH-2:COF_WIDTH-19]};                        	//20bit {s,1,18} a0 = alpha +1
//-------------------------------------------------------------------		
wire signed [DIV_WIDTH-1:0] a0_inv_REG_D;   
assign a0_inv_REG_D = {a0_inv_tmp_D[39],a0_inv_tmp_D[19:1]};      // truancate to 20bit = {sign bit, [19-1]bit}, so a0_inv_REG_D {s,0,19}

always @(posedge Clk_CI or negedge Rst_RBI)
begin
  if(~Rst_RBI)
    a0_enable_S <= 1'b0;
  else if (WrEn_SI == 1)
    a0_enable_S <= 1'b1;
  else
    a0_enable_S <= 1'b0;
end
DW_div_seq #(
  .a_width(DIV_WIDTH*2), 
  .b_width(DIV_WIDTH), 
  .tc_mode(1), 
  .num_cyc(15)      // 15 clks to finish the divider
)
FLT_div_a0_inv ( 
  .clk(Clk_CI), 
  .rst_n(Rst_RBI), 
  .hold(1'b0), // always not hold
  .start(a0_enable_S), 
  .a(40'b0100_0000_0000_0000_0000_0000_0000_0000_0000_0000), 
  .b(a0_D),
  .complete(a0_valid_S), 
  .divide_by_0(),
  .quotient(a0_inv_tmp_D), 
  .remainder() 
);

FF #(
  .DATA_WIDTH ( DIV_WIDTH )
)
FF_DIV_OUT
(
  .Clk_CI  ( Clk_CI           ),
  .Rst_RBI ( Rst_RBI          ),
  .WrEn_SI ( a0_valid_S       ),
  .D_DI    ( a0_inv_REG_D     ),
  .Q_DO    ( a0_inv_D   )
);
// ------------------------------------------------------------------------------------------
// *******************Coefficients calculation Done!*****************************************
// ------------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------------
// *******************Sequencial logic calculation Begin!*****************************************
// sclae input down and calculate xb0---------------
FF #(
  .DATA_WIDTH ( IN_WIDTH )
)
FF_FLT_IN
(
  .Clk_CI  ( Clk_CI       		),
  .Rst_RBI ( Rst_RBI      		),
  .WrEn_SI ( 1'b1         		),
  .D_DI    ( sta_FLT_In_DI  	),
  .Q_DO    ( sta_FLT_IN_REG_D  	)
);	
assign sta_FLT_In_SD_tmp_D = sta_FLT_IN_REG_D * par_FLT_SD_D;		// {s,0,23}*{s,0,31}={s,1,54}
assign sta_FLT_OldIn0_D = {sta_FLT_In_SD_tmp_D[IN_WIDTH+COF_WIDTH-1],sta_FLT_In_SD_tmp_D[IN_WIDTH+COF_WIDTH-3:IN_WIDTH-1]}; //{s(55),0,31(53:23)}
assign xb0_tmp_D = sta_FLT_OldIn0_D * b0_D; 						// {s,0,31}*{s,0,19}={s,1,50}
assign xb0_D = {xb0_tmp_D[51],xb0_tmp_D[49:19]};					// {s,0,31}

// calculate xb1------------------------------------------
FF #(
  .DATA_WIDTH ( COF_WIDTH )
)
FF_x1
(
  .Clk_CI  ( Clk_CI       		),
  .Rst_RBI ( Rst_RBI      		),
  .WrEn_SI ( 1'b1         		),
  .D_DI    ( sta_FLT_OldIn0_D  	),
  .Q_DO    ( sta_FLT_OldIn1_D  	)
);	
assign xb1_tmp_D = b1_D * sta_FLT_OldIn1_D;					// {s,1,18}*{s,0,31}={s,2,49}
assign xb1_D = {xb1_tmp_D[51],xb1_tmp_D[48:18]};			// {s,0,31}

// calculate xb2------------------------------------------
FF #(
  .DATA_WIDTH ( COF_WIDTH )
)
FF_x2
(
  .Clk_CI  ( Clk_CI       		),
  .Rst_RBI ( Rst_RBI      		),
  .WrEn_SI ( 1'b1         		),
  .D_DI    ( sta_FLT_OldIn1_D  	),
  .Q_DO    ( sta_FLT_OldIn2_D  	)
);	
assign xb2_tmp_D = b2_D * sta_FLT_OldIn2_D;					// {s,0,19}*{s,0,31}={s,1,50}
assign xb2_D = {xb2_tmp_D[51],xb2_tmp_D[49:19]};	// {s,0,31}

// calculate sum of input loop------------------------------------------
assign sumx2x1_D = xb1_D + xb2_D;							// {s,0,31}
assign sumx0_D = sumx2x1_D + xb0_D;							// {s,0,31}

// calculate sum of output loop------------------------------------------
//assign sumy0_tmp_D = (sumx0_D>>>1) + (sumy2y1_D<<1);                   // {s,1,31}={s,1,31}+{s,1,31}
wire signed [COF_WIDTH:0] sumx0_RS_D;                                    // sumx0:{s,0,31} -> sumx0_RS_D:{s,1,31}
wire signed [COF_WIDTH:0] sumy2y1_LS_D;                                  // sumy2y2_D:{s,1,30} -> sumy2y1_LS_D:{s,1,31}
assign sumx0_RS_D = sumx0_D[COF_WIDTH-1]?{1'b1,sumx0_D}:{1'b0,sumx0_D};  // sign extension to make a 33-bit {s,1,31}
assign sumy2y1_LS_D = sumy2y1_D<<1;								                       // left shift 1bit to make a 33-bit {s,1,31}
assign sumy0_tmp_D = sumx0_RS_D + sumy2y1_LS_D;

assign sumy0_D = sumy0_tmp_D[COF_WIDTH:1];						                   // {s,1,30}
assign ya0_tmp_D = a0_inv_D * sumy0_D;							                     // {s,2,49} = {s,0,19}*{s,1,30}
assign sta_FLT_OldSample0_D = {ya0_tmp_D[51],ya0_tmp_D[48:18]};	         // {s,0,31(60:30)}
assign sta_FLT_Out_DO = sta_FLT_OldSample0_D[31:8];				               // {s,0,23}

// calculate ya1------------------------------------------
FF #(
  .DATA_WIDTH ( COF_WIDTH )
)
FF_y1
(
  .Clk_CI  ( Clk_CI       			),
  .Rst_RBI ( Rst_RBI      			),
  .WrEn_SI ( 1'b1         			),
  .D_DI    ( sta_FLT_OldSample0_D  	),
  .Q_DO    ( sta_FLT_OldSample1_D  	)
);	
assign ya1_tmp_D = a1_minus_D * sta_FLT_OldSample1_D;			// {s,2,49} = {s,1,18}*{s,0,31}
assign ya1_D = {ya1_tmp_D[51],ya1_tmp_D[49:19]}; 				// {s,1,30(60:30)} 

// calculate ya2------------------------------------------
FF #(
  .DATA_WIDTH ( COF_WIDTH )
)
FF_y2
(
  .Clk_CI  ( Clk_CI       			),
  .Rst_RBI ( Rst_RBI      			),
  .WrEn_SI ( 1'b1         			),
  .D_DI    ( sta_FLT_OldSample1_D  	),
  .Q_DO    ( sta_FLT_OldSample2_D  	)
);	
assign ya2_tmp_D = a2_minus_D * sta_FLT_OldSample2_D;			// {s,1,62} = {s,0,31}*{s,0,31}
assign ya2_D = ya2_tmp_D[63:32]; 								// {s,1,30}  

// calculate sum of output loop-----------------------------
assign sumy2y1_D = ya2_D + ya1_D;								// {s,1,30} = {s,1,30}+{s,1,30}


// ------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------
// *******************Sequencial logic calculation Done!*****************************************
// ------------------------------------------------------------------------------------------

/* --------------------------------------------------------------------------------
// Done!
// -------------------------------------------------------------------------------- */

endmodule
