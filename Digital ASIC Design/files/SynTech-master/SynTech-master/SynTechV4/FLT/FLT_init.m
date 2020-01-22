% =========================================================================
% ECE 5746 - Simple Filter Model (INITIALIZATION)
% (c) 2019 hs994,fjf46@cornell.edu
%
% Author: Haochuan Song, Frans Fourie
% Last edited: 10/23/2019
% Project: SynTech
%
% ---Description----------------------------
% Initialize a second order IIR filter 
% ---I/O specifications-----------------------
% sta.FLT.In_DI                     input data
% sta.FLT.Out_DO                output data 
%----parameter specifications-----------------
% par_FLT_RQ_D;				 1/Q: reciprocal of quality factor of low-pass filter stored in parameter memory
% par_FLT_f0_D;				 cut-off frequency, stored in parameter memory
% par_FLT_RFS_norm_D; 		 2/Fs: Normalized reciprocal of Internal Sampling Frequency, used to calculate alpha
% par_FLT_SD_D;				 scaling down factor corresponding to quality factor par.FLT.RQ_DI 
% par_FLT_type_S;			 control signal for different filter types; haven't used it so far, stored in parameter memory
%
% =========================================================================

function [par,sta] = FLT_init(par,sta)

% FLT parameters
par.FLT.f0_D = 500;   %cut-off frequency of low-pass filter
Q = 1;             % quality factor of low-pass filter
par.FLT.RQ_D = 1/Q; % Reciprocal of Q, which is going to be used in the FLT.m
%-------------------------------------------------------------------------------------
% 2/Reciprocal of Internal Sampling Frequency, which is going to be used in the FLT.m
% 2e10 here is to fully utilize the dynamic range, otherwise it will suffer
% a lot from qunatization error bc par.GLO.FSInt_DI is too large 
par.FLT.RFS_norm_D = (2/par.GLO.FSInt_DI)*2^10;
%------------------------------------------------------------------------------------
par.FLT.type_S = 1; %type 1 indicates low pass filter
par.FLT.SD_D = 1/(1+(Q/13)); % scaling down factor; stored in the memory


% all state variables used by this block must be initialized
sta.FLT.In_DI = 0;
sta.FLT.OldIn_D = zeros(1,3);         % size = [1 3] input memory
sta.FLT.Out_DO = 0;
sta.FLT.OldSample_D = zeros(1,3); % keep old output sample, size = [1 3] output memory

end