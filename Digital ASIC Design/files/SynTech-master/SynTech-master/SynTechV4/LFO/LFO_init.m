% =========================================================================
% ECE 5746 - Simple LFO Model (INITIALIZATION)
% (c) 2019 studer@cornell.edu
% =========================================================================

function [par,sta] = LFO_init(par,sta)

FixP_out = {0,23,'s'}; % {I,F,'s'} where 's' is signed
FixP_par = {0,32,'u'};
QType_out = 'WrpTrc_NoWarn'; % we wrap and truncate
    
% LFO parameters
par.LFO.Freq_DI = 20; % LFO base frequency in Hz 
par.LFO.Rst_Mode_S = 0; % 0 for frequency mod, 1 for freq reset on keypress
par.LFO.Wave_S = 2; % 0 for cos, 1 for sawtooth, 2 for rand
par.LFO.Max_Min_I = RealRESIZE(0.032258, FixP_par, QType_out); % to be reassigned
par.GLO.FSInt_D_DI = RealRESIZE(0.0000026041666667, FixP_par, QType_out);

% set parameters for OSC
par.INP.LFOmod = 1000; % how much modulation on frequency 

% all state variables used by this block must be initialized
sta.LFO.Out_DO = 0; % this one can be accessed by other blocks
sta.LFO.Inc_D = 0;
sta.LFO.Pos_D = 0;
sta.LFO.Key_DP = 0; %
sta.LFO.Prev_DP = 0;
sta.LFO.Prev_Rand_DP = [1 1 0 0 1 1 0 1 1 1 0 0 1 1 0 1];

end