% =========================================================================
% ECE 5746 - Simple Amplitude Envelope Model (INITIALIZATION)
% (c) 2019 studer@cornell.edu
% =========================================================================

function [par,sta] = ENV_init(par,sta)

% ENV parameters
%resizing
FixP_out = {0,31,'s'}; % {I,F,'s'} where 's' is signed
FixP_par = {0,23,'s'};
FixP_recip = {7,24,'s'};
QType_out = 'WrpTrc_NoWarn';
% all state variables used by this block must be initialized
sta.ENV.pos = RealRESIZE(0, FixP_out,QType_out);
sta.ENV.inc = RealRESIZE(0,FixP_out,QType_out);
sta.ENV.prevKey = RealRESIZE(0,{1,0,'u'}, QType_out);

sta.ENV.Out_DO = RealRESIZE(0,FixP_out, QType_out); % ENV block output

par.ENV.a = RealRESIZE(0.02, FixP_par, QType_out);
par.ENV.d = RealRESIZE(0.01,FixP_par, QType_out);
par.ENV.r = RealRESIZE(0.02,FixP_par, QType_out);
par.ENV.aY = RealRESIZE(1,FixP_par, 'SatTrc_NoWarn');
par.ENV.dY = RealRESIZE(0.8,FixP_par, QType_out);
par.ENV.rY = RealRESIZE(0,FixP_par, QType_out);

par.ENV.aRec = RealRESIZE(1/par.ENV.a,FixP_recip, QType_out);
par.ENV.dRec = RealRESIZE(1/par.ENV.d,FixP_recip, QType_out);
par.ENV.rRec = RealRESIZE(1/par.ENV.r,FixP_recip, QType_out);

par.ENV.glofsi = RealRESIZE(sta.GLO.RFSInt_DO,FixP_out, QType_out);

%write the in text file
end