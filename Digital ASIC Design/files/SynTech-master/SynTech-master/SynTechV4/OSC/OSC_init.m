% =========================================================================
% ECE 5746 - Simple Cosine Wave Oscillator Model (INITIALIZATION)
% (c) 2019 studer@cornell.edu
% =========================================================================

function [par,sta] = OSC_init(par,sta)
par.OSC.LFOmod_DI = 5;

%All parameters
par.OSC.Thld_SI = [0,0,0]; %Thld for square wave
par.OSC.Mode_SI = [1,0,0]; % controls the position reset 1-reset 0-no reset
par.OSC.Shape_SI = [0,0,0]; % control the wave shape: 0-sawtooth, 1-triangle, 2-square
par.OSC.Deltaf_DI = [0,0,0]; % increase the waves' frequency
par.OSC.Multf_DI = [1,1,1]; % multiply the waves' frequency
par.OSC.Weight_SI = [1,0,0]; % assignt weight to each wave

par.OSC.Thld_SI(1) = RealRESIZE(par.OSC.Thld_SI(1),{0,23,'s'},'WrpTrc_NoWarn');
par.OSC.Thld_SI(2) = RealRESIZE(par.OSC.Thld_SI(2),{0,23,'s'},'WrpTrc_NoWarn');
par.OSC.Thld_SI(3) = RealRESIZE(par.OSC.Thld_SI(3),{0,23,'s'},'WrpTrc_NoWarn');

par.OSC.Deltaf_DI(1) = RealRESIZE(par.OSC.Deltaf_DI(1),{15,16,'s'},'WrpTrc_NoWarn');
par.OSC.Deltaf_DI(2) = RealRESIZE(par.OSC.Deltaf_DI(2),{15,16,'s'},'WrpTrc_NoWarn');
par.OSC.Deltaf_DI(3) = RealRESIZE(par.OSC.Deltaf_DI(3),{15,16,'s'},'WrpTrc_NoWarn');

par.OSC.Multf_DI(1) = RealRESIZE(par.OSC.Multf_DI(1),{4,28,'u'},'WrpTrc_NoWarn');
par.OSC.Multf_DI(2) = RealRESIZE(par.OSC.Multf_DI(2),{4,28,'u'},'WrpTrc_NoWarn');
par.OSC.Multf_DI(3) = RealRESIZE(par.OSC.Multf_DI(3),{4,28,'u'},'WrpTrc_NoWarn');

par.OSC.Weight_SI(1) = RealRESIZE(par.OSC.Weight_SI(1),{4,27,'s'},'WrpTrc_NoWarn');
par.OSC.Weight_SI(2) = RealRESIZE(par.OSC.Weight_SI(2),{4,27,'s'},'WrpTrc_NoWarn');
par.OSC.Weight_SI(3) = RealRESIZE(par.OSC.Weight_SI(3),{4,27,'s'},'WrpTrc_NoWarn');

% all state variables used by this block must be initialized
sta.OSC.Inc_D = [0,0,0];
sta.OSC.Pos_D = [0,0,0];

sta.OSC.Fint_D(1)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(1),{16,16,'u'},'WrpTrc_NoWarn');
sta.OSC.Fint_D(2)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(2),{16,16,'u'},'WrpTrc_NoWarn');
sta.OSC.Fint_D(3)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(3),{16,16,'u'},'WrpTrc_NoWarn');

sta.OSC.Finalf_D(1)=RealMULT(sta.OSC.Fint_D(1),par.OSC.Multf_DI(1),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Finalf_D(2)=RealMULT(sta.OSC.Fint_D(2),par.OSC.Multf_DI(2),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Finalf_D(3)=RealMULT(sta.OSC.Fint_D(3),par.OSC.Multf_DI(3),{15,17,'u'},'WrpTrc_NoWarn');

sta.OSC.Pos_D(1) = RealRESIZE(sta.OSC.Pos_D(1),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Pos_D(2) = RealRESIZE(sta.OSC.Pos_D(2),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Pos_D(3) = RealRESIZE(sta.OSC.Pos_D(3),{0,23,'s'},'WrpTrc_NoWarn');

sta.OSC.Pkey_D = 0;


end