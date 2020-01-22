% =========================================================================
% ECE 5746 - This block models global parameters (INITIALIZATION)
% (c) 2019 studer@cornell.edu
% =========================================================================

function [par,sta] = GLO_init(par,sta)

% set up global parameters in a field
par.GLO.FSOut_DI = RealRESIZE(48000,{32,0,'u'},'WrpTrc'); % output sampling rate [Hz]
par.GLO.OSR_DI = RealRESIZE(8,{32,0,'u'},'WrpTrc'); % oversampling ratio (OSR)
par.GLO.FSInt_DI = RealRESIZE(par.GLO.OSR_DI*par.GLO.FSOut_DI,{32,0,'u'},'WrpTrc'); % internal sampling rate [Hz]
par.GLO.RFSInt_DI = RealRESIZE(1/par.GLO.FSInt_DI,{0,32,'u'},'WrpTrc'); % reciprocal of internal sampling rate [s]

% GLO states 
sta.GLO.FSOut_DO = par.GLO.FSOut_DI;  % output sampling rate [Hz]
sta.GLO.OSR_DO = par.GLO.OSR_DI; % oversampling ratio (OSR)
sta.GLO.FSInt_DO = par.GLO.FSInt_DI;  % internal sampling rate [Hz]
sta.GLO.RFSInt_DO = par.GLO.RFSInt_DI; % reciprocal of internal sampling rate [s]

end