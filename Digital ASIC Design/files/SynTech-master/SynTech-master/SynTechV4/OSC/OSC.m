% =========================================================================
% ECE 5746 - Simple Cosine Wave Oscillator Model [SOLUTION]
% (c) 2019 studer@cornell.edu
% =========================================================================

function sta = OSC(par,sta)

if sta.OSC.Pkey_D ~= sta.INP.Key_DO
  if sta.INP.Key_DO == 1
        if par.OSC.Mode_SI(1)==1
            sta.OSC.Pos_D(1) = -1;
        end
        if par.OSC.Mode_SI(2)==1
            sta.OSC.Pos_D(2) = -1;
        end
        if par.OSC.Mode_SI(3)==1
            sta.OSC.Pos_D(3) = -1;
        end
   end
end

sta.OSC.Fint_D(1)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(1),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Fint_D(2)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(2),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Fint_D(3)=RealADD(sta.INP.Freq_DO,par.OSC.Deltaf_DI(3),{15,17,'u'},'WrpTrc_NoWarn');

sta.OSC.Finalf_D(1)=RealMULT(sta.OSC.Fint_D(1),par.OSC.Multf_DI(1),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Finalf_D(2)=RealMULT(sta.OSC.Fint_D(2),par.OSC.Multf_DI(2),{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Finalf_D(3)=RealMULT(sta.OSC.Fint_D(3),par.OSC.Multf_DI(3),{15,17,'u'},'WrpTrc_NoWarn');

sta.OSC.Pkey_D = sta.INP.Key_DO;

sta.OSC.Signal_D(1) = OSC_block(par,sta,1);
sta.OSC.Signal_D(2) = OSC_block(par,sta,2);
sta.OSC.Signal_D(3) = OSC_block(par,sta,3);

sta.OSC.Outw_D(1)=RealMULT(par.OSC.Weight_SI(1),sta.OSC.Signal_D(1),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Outw_D(2)=RealMULT(par.OSC.Weight_SI(2),sta.OSC.Signal_D(2),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Outw_D(3)=RealMULT(par.OSC.Weight_SI(3),sta.OSC.Signal_D(3),{0,23,'s'},'WrpTrc_NoWarn');

sta.OSC.Out_DO = RealADD(RealADD(sta.OSC.Outw_D(1),sta.OSC.Outw_D(2),{0,23,'s'},'WrpTrc_NoWarn'),sta.OSC.Outw_D(3),{0,23,'s'},'SatTrc_NoWarn');

par.OSC.LFOmod_DI = RealRESIZE(par.OSC.LFOmod_DI,{32,0,'u'},'WrpTrc_NoWarn');
sta.LFO.Out_DO =RealRESIZE(sta.LFO.Out_DO,{0,23,'s'},'WrpTrc_NoWarn');

sta.OSC.Intlfo_S(1)=RealMULT(par.OSC.LFOmod_DI,sta.LFO.Out_DO,{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Intlfo_S(2)=RealMULT(par.OSC.LFOmod_DI,sta.LFO.Out_DO,{15,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Intlfo_S(3)=RealMULT(par.OSC.LFOmod_DI,sta.LFO.Out_DO,{15,17,'u'},'WrpTrc_NoWarn');

sta.OSC.Initinc_S(1)=RealADD(sta.OSC.Finalf_D(1),sta.OSC.Intlfo_S(1),{16,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Initinc_S(2)=RealADD(sta.OSC.Finalf_D(2),sta.OSC.Intlfo_S(2),{16,17,'u'},'WrpTrc_NoWarn');
sta.OSC.Initinc_S(3)=RealADD(sta.OSC.Finalf_D(3),sta.OSC.Intlfo_S(3),{16,17,'u'},'WrpTrc_NoWarn');

sta.OSC.Inc_D(1)=RealMULT(sta.OSC.Initinc_S(1),sta.GLO.RFSInt_DO,{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Inc_D(2)=RealMULT(sta.OSC.Initinc_S(2),sta.GLO.RFSInt_DO,{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Inc_D(3)=RealMULT(sta.OSC.Initinc_S(3),sta.GLO.RFSInt_DO,{0,23,'s'},'WrpTrc_NoWarn');

sta.OSC.Pos_D(1) = RealADD(sta.OSC.Pos_D(1),sta.OSC.Inc_D(1),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Pos_D(2) = RealADD(sta.OSC.Pos_D(2),sta.OSC.Inc_D(2),{0,23,'s'},'WrpTrc_NoWarn');
sta.OSC.Pos_D(3) = RealADD(sta.OSC.Pos_D(3),sta.OSC.Inc_D(3),{0,23,'s'},'WrpTrc_NoWarn');

end

function [signal] = OSC_block(par,sta,n)
if par.OSC.Shape_SI(n) == 0
   % compute sawtooth function with quantized output
    signal=sta.OSC.Pos_D(n); 
elseif par.OSC.Shape_SI(n) ==1
    % compute triangle function with quantized output
    signal = 2*RealABS(sta.OSC.Pos_D(n),{0,23,'u'},'WrpTrc_NoWarn')-1;
    if sta.OSC.Pos_D(n)==-1
        signal=RealRESIZE(1,{0,31,'s'},'SatTrc_NoWarn');
    end
elseif par.OSC.Shape_SI(n) == 2
    if sta.OSC.Pos_D(n)>par.OSC.Thld_SI(n) 
        signal = RealRESIZE(1,{0,23,'s'},'SatTrc_NoWarn');
    else
        signal = -1;
    end
end
signal =  RealRESIZE(signal,{0,23,'s'},'SatTrc_NoWarn'); 
end 