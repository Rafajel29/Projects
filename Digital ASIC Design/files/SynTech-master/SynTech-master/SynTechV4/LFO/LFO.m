% =========================================================================
% ECE 5746 - Simple Low-Frequency Oscillator (LFO)
% (c) 2019 studer@cornell.edu
% =========================================================================

% function sta = LFO(par,sta)
% 
% % compute increment (LFO does not reset at keystroke)
% sta.LFO.Inc_D = par.LFO.Freq_DI/par.GLO.FSInt_DI;
% 
% % increment position within one period of the sine wave
% sta.LFO.Pos_D = sta.LFO.Pos_D + sta.LFO.Inc_D;
% 
% % reset position if period exceeded
% % note that using a power of two for the period would enable us to
% % completely remove the following if statement and the subtraction as we
% % can let the pos state variable "wrap" around. you will learn the details
% % in the class when we discuss signed numbers and wrapping etc. 
% if sta.LFO.Pos_D>1
%     sta.LFO.Pos_D = sta.LFO.Pos_D - 1;
% end
% 
% % compute cosine function and output to a state variable
% % other blocks will be able to read that value (but not write!)
% sta.LFO.Out_DO = cos(2*pi*sta.LFO.Pos_D);
% 
% end

function [sta,out] = LFO(par,sta)
    
% specify all fixed-point parameters
FixP_out = {0,23,'s'}; % {I,F,'s'} where 's' is signed
FixP_par = {0,32,'u'};
QType_out = 'WrpTrc_NoWarn'; % we wrap and truncate

% compute increment (LFO does not reset at keystroke)
sta.LFO.Inc_D = RealRESIZE(par.LFO.Freq_DI*sta.GLO.RFSInt_DO,FixP_par,QType_out);

% increment position
sta.LFO.Pos_D = RealRESIZE(sta.LFO.Pos_D + sta.LFO.Inc_D, FixP_par, QType_out);

% reset position if mode = 1 and on keypress
if par.LFO.Rst_Mode_S == 1 && (sta.LFO.Key_DP ~= sta.INP.Key_DO)
    sta.LFO.Pos_D = 0;
end
sta.LFO.Key_DP = sta.INP.Key_DO;

% compute function, quantized
% other blocks will be able to read that value (but not write!)
if par.LFO.Wave_S == 0 % cos
    Tmp_D = cos(2*pi*sta.LFO.Pos_D);
elseif par.LFO.Wave_S == 1 % saw
    Tmp_D = 2*sta.LFO.Pos_D-1;
elseif par.LFO.Wave_S == 2 % rand
    if sta.LFO.Pos_D < sta.LFO.Inc_D % check for new period
        s = sta.LFO.Prev_Rand_DP;
        t = [5 2];
        seq = LFO_LFSR(s, t);        
        Tmp_D = LFO_mapping(bi2de(seq), 0, 65535, -1, 1, par.LFO.Max_Min_I); % randomize
        sta.LFO.Prev_DP = RealRESIZE(Tmp_D,FixP_out,QType_out);
        sta.LFO.Prev_Rand_DP = seq;
    end
    Tmp_D = sta.LFO.Prev_DP;
end

sta.LFO.Out_DO = RealRESIZE(Tmp_D,FixP_out,QType_out);

end