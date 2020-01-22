% =========================================================================
% ECE 5746 - Simple Amplitude Envelope Model
% (c) 2019 studer@cornell.edu
% =========================================================================

function sta = ENV(par,sta)
FixP_out = {0,31,'s'}; % {I,F,'s'} where 's' is signed
FixP_par = {0,23,'s'};

% Avoid warnings when wrapping and truncating
QType_out = 'WrpTrc_NoWarn';

% Apply naming convention
ENV_key_DI = sta.INP.Key_DO;
ENV_pos_D = sta.ENV.pos;
ENV_inc_D = sta.ENV.inc; 
ENV_prevKey_DP = sta.ENV.prevKey;
ENV_vol_DI = sta.INP.Vol_DO;
%outPrev is out pre vol (the output calculation before multiplying by the
%ENV_vol_DI value
ENV_outPrev_DP = RealRESIZE(0, {0,1,'s'},QType_out);

ENV_a_DI = par.ENV.a; %trial 0 (test.wav): a = 0.02, d = 0.02, r = 0.03
ENV_d_DI = par.ENV.d; %trial 1 (test1.wav): a = 0.01, d = 0.03, r = 0.03
ENV_r_DI = par.ENV.r; %trial 2 (test2.wav): a = 0.01, d = 0.02, r = 0.02
ENV_aY_DI = par.ENV.aY;
ENV_dY_DI = par.ENV.dY;
ENV_rY_DI = par.ENV.rY;

% convert to 32-bit signed fixed point
%in = RealRESIZE(in, FixP_out,QType_out);
ENV_vol_DI = RealRESIZE(ENV_vol_DI,{1,31,'u'},QType_out);
ENV_pos_D = RealRESIZE(ENV_pos_D, FixP_out,QType_out);
ENV_key_DI = RealRESIZE(ENV_key_DI, {1,0,'u'},QType_out);

ENV_dYaY_D = RealRESIZE(ENV_dY_DI - ENV_aY_DI, FixP_par, 'SatTrc_NoWarn');
ENV_rYdY_D = RealRESIZE(ENV_rY_DI - ENV_dY_DI, FixP_par, QType_out);

ENV_aSlope_D = RealRESIZE(ENV_aY_DI*par.ENV.aRec, {8,23,'s'},QType_out);
ENV_adSlope_D = RealRESIZE((ENV_dYaY_D*par.ENV.dRec), {8,23,'s'},QType_out);
ENV_drSlope_D = RealRESIZE(ENV_rYdY_D*par.ENV.rRec, {8,23,'s'},QType_out);

ENV_inc_D = RealRESIZE(par.ENV.glofsi, FixP_out, QType_out);

% increment position within one period of the sine wave
if(~((ENV_key_DI == 0) && (ENV_pos_D > ENV_r_DI)))
        ENV_pos_D = RealRESIZE(ENV_pos_D + ENV_inc_D, FixP_out,QType_out);
end
        
if(ENV_key_DI) % if key is pressed
    if(ENV_prevKey_DP == 0)
        ENV_pos_D = RealRESIZE(0,FixP_out,QType_out);
    else
        if(ENV_pos_D <= ENV_a_DI) % if within a range
            ENV_outPrev_DP = RealRESIZE(ENV_aSlope_D*ENV_pos_D,FixP_out,'SatTrc_NoWarn');
        elseif(ENV_pos_D <= (ENV_d_DI+ENV_a_DI)) % if within d range
            ENV_da_D = RealRESIZE(ENV_d_DI+ENV_a_DI, FixP_par, QType_out);
            ENV_posda_D = RealRESIZE(ENV_pos_D - ENV_da_D, FixP_out, QType_out);
            ENV_adposda_D = RealRESIZE(ENV_posda_D*ENV_adSlope_D, FixP_out, QType_out);
            ENV_outPrev_DP = RealRESIZE(ENV_adposda_D+ENV_dY_DI,FixP_out,QType_out);
        else
            ENV_outPrev_DP = RealRESIZE(ENV_dY_DI, FixP_out, QType_out);       
        end
    end
else % if key is not pressed
    if(ENV_prevKey_DP)
        ENV_pos_D = RealRESIZE(0,FixP_out,QType_out);
    end
    if (ENV_pos_D <= ENV_r_DI)
        ENV_posr_D = RealRESIZE(ENV_pos_D-ENV_r_DI,FixP_out, QType_out);
        ENV_outPrev_DP=RealRESIZE(ENV_drSlope_D*ENV_posr_D,FixP_out,QType_out);
    end
end

ENV_outPrev_DP = RealRESIZE(ENV_outPrev_DP, FixP_out, QType_out);
ENV_prevKey_DP = ENV_key_DI; 
sta.ENV.Out_DO = RealRESIZE(ENV_outPrev_DP*ENV_vol_DI, FixP_out, QType_out); % send out sample value

sta.ENV.pos=ENV_pos_D;
sta.ENV.prevKey = ENV_key_DI;


end