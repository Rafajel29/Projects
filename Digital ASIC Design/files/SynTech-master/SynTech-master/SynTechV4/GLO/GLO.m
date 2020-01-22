% =========================================================================
% ECE 5746 - This block models inputs to the synthesizer
% (c) 2019 studer@cornell.edu
% =========================================================================

function sta = GLO(par,sta)

sta.GLO.FSOut_DO = par.GLO.FSOut_DI;  % output sampling rate [Hz]
sta.GLO.OSR_DO = par.GLO.OSR_DI; % oversampling ratio (OSR)
sta.GLO.FSInt_DO = par.GLO.FSInt_DI;  % internal sampling rate [Hz]
sta.GLO.RFSInt_DO = par.GLO.RFSInt_DI; % reciprocal of internal sampling rate [s]
                
end



