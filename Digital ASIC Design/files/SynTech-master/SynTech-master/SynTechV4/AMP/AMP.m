% =========================================================================
% ECE 5746 - Simple Amplitude Envelope Model
% (c) 2019 studer@cornell.edu
% =========================================================================

function sta = AMP(par,sta)

% block reads from FLT and multiplies with ENV output
sta.AMP.Out_DO = sta.FLT.Out_DO*sta.ENV.Out_DO*sta.INP.Vol_DO; 

end