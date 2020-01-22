% =========================================================================
% ECE 5746 - Simple Filter Model  
% (c) 2019 hs994,fjf46@cornell.edu
%
% Author: Haochuan Song, Frans Fourie
% Last edited: 10/23/2019
% Project: SynTech
%
% ---Description------------------------------------------------
% A second order IIR filter supports low-pass or direct pass
% ---I/O specifications-----------------------
% sta.FLT.In_DI                     input data
% sta.FLT.Out_DO                output data 
%----parameter specifications-----------------
% par_FLT_RQ_D;				 1/Q: reciprocal of quality factor of low-pass filter stored in parameter memory
% par_FLT_f0_D;				 cut-off frequency, stored in parameter memory
% par_FLT_RFS_norm_D; 		 2/Fs: Normalized reciprocal of Internal Sampling Frequency, used to calculate alpha
% par_FLT_SD_D;				 scaling down factor corresponding to quality factor par.FLT.RQ_D 
% par_FLT_type_S;			 control signal for different filter types; haven't used it so far, stored in parameter memory
%
% =========================================================================

function sta = FLT(par,sta)
% 
% % example of first-order IIR filter 
% % reads directly from OSC output state sta.OSC.Out_DO
% sta.FLT.Out_DO = (1-par.FLT.Alpha_DI)*sta.FLT.Out_DO + par.FLT.Alpha_DI*sta.OSC.Out_DO;

% specify all fixed-point parameters
%------------------------------------------------------------------------
FixP_IIR_CAL = {0,31,'s'}; % {I,F,'s'} where 's' is signed
QType_IIR_CAL = 'SatTrc'; % we saturate and round

FixP_Q_CAL = {3,28,'s'}; % {I,F,'s'} where 's' is signed
QType_Q_CAL = 'SatTrc'; % we saturate and round

FixP_para_omega0 = {0,15,'s'};
QType_para_omega0 = 'SatTrc';

FixP_para_sincos = {0,18,'s'};

FixP_para_alpha = {0,31,'s'};
QType_para_alpha = 'SatTrc';

FixP_weight_b0 = {0,19,'s'};
QType_weight_b0 = 'SatTrc';

FixP_weight_b1 = {1,18,'s'};
QType_weight_b1 = 'SatTrc';

FixP_weight_a0 = {1,18,'s'};
QType_weight_a0 = 'SatTrc';

FixP_INV_CAL = {0,19,'s'};

FixP_weight_a1 = {2,29,'s'};
QType_weight_a1 = 'SatTrc';

FixP_weight_a2 = {0,31,'s'};
QType_weight_a2 = 'SatTrc';

FixP_in = {0,31,'s'}; % {I,F,'s'} where 's' is signed
QType_in = 'SatTrc'; % we saturate and round

FixP_out = {0,23,'s'}; % {I,F,'s'} where 's' is signed
QType_out = 'SatTrc'; % we saturate and round

FixP_inter_y = {1,30,'s'};
QType_inter_y = 'SatTrc';

FixP_inter_x = {0,31,'s'};
QType_inter_x = 'SatTrc';

FixP_add_inter = {1,31,'s'};
QType_add_inter = 'SatTrc';
    
% update FLT state
%-------------------------------------------------------------------------------------------------------------
sta.FLT.In_DI = sta.OSC.Out_DO; % reads directly from OSC output state sta.OSC.Out_DO
par.FLT.SD_D = RealRESIZE(par.FLT.SD_D,FixP_IIR_CAL,QType_IIR_CAL);
sta.FLT.In_SD_tmp_D = par.FLT.SD_D*sta.FLT.In_DI;
sta.FLT.In_SD_tmp_D = RealRESIZE(sta.FLT.In_SD_tmp_D,{1,54,'s'},QType_in);
sta.FLT.OldIn_D(1:2) = sta.FLT.OldIn_D(2:3);            % update the input memory
sta.FLT.OldIn_D(3) = RealRESIZE(sta.FLT.In_SD_tmp_D,FixP_in,QType_in);
sta.FLT.OldSample_D(1:2) = sta.FLT.OldSample_D(2:3);    % update the output memory

% parameter calculation
% ------------------------------------------------------------------------
switch par.FLT.type_S
    case 1 % low pass filter
        constant1 = RealRESIZE(par.FLT.RFS_norm_D,FixP_IIR_CAL,QType_IIR_CAL); %2/internal sampling frequency WITHOUT pi
        omega0_normalized_D_fixed = RealMULT(2*par.FLT.f0_D/2^10,constant1,FixP_para_omega0, QType_para_omega0); % omega0/pi
        par.FLT.RQ_D = RealRESIZE(par.FLT.RQ_D,FixP_Q_CAL,QType_Q_CAL);
        constant2_D = RealMULT(0.5,par.FLT.RQ_D,FixP_Q_CAL,QType_Q_CAL);
        sin_out_D =  RealRESIZE(sin(pi*(omega0_normalized_D_fixed)), FixP_para_sincos,  QType_IIR_CAL);
        alpha_D_fixed = RealMULT(constant2_D,sin_out_D, FixP_para_alpha, QType_para_alpha);
        cos_out_D =  RealRESIZE(cos(pi*(omega0_normalized_D_fixed)), FixP_para_sincos,  QType_IIR_CAL);

        b1_D_fixed = RealSUB(1,cos_out_D , FixP_weight_b1, QType_weight_b1);
        b0_D_fixed = RealMULT(0.5,b1_D_fixed, FixP_weight_b0, QType_weight_b0);
        b2_D_fixed = b0_D_fixed;
        a0_D_fixed = RealADD(1,alpha_D_fixed, FixP_weight_a0, QType_weight_a0);
        a0_inv_D_fixed = RealRESIZE(1/a0_D_fixed, FixP_INV_CAL, QType_IIR_CAL);
        a1_minus_D_fixed = RealMULT(2, cos_out_D, FixP_weight_a1, QType_weight_a1);
        a2_minus_D_fixed = RealSUB(alpha_D_fixed, 1, FixP_weight_a2, QType_weight_a2);

        % feedback loop
        %------------------------------------------------------------------------
        xb0_D = RealMULT(b0_D_fixed, sta.FLT.OldIn_D(3), FixP_inter_x, QType_inter_x);
        xb1_D = RealMULT(b1_D_fixed, sta.FLT.OldIn_D(2), FixP_inter_x, QType_inter_x);
        xb2_D = RealMULT(b2_D_fixed, sta.FLT.OldIn_D(1), FixP_inter_x, QType_inter_x);
        ya1_D = RealMULT(a1_minus_D_fixed, sta.FLT.OldSample_D(2), FixP_inter_y, QType_inter_y);
        ya2_D = RealMULT(a2_minus_D_fixed, sta.FLT.OldSample_D(1), FixP_inter_y, QType_inter_y);
        
        sumx2x1_D = RealADD(xb1_D, xb2_D, FixP_inter_x, QType_inter_x);
        sumx0_D = RealADD(sumx2x1_D, xb0_D, FixP_inter_x, QType_inter_x);
        sumy2y1_D = RealADD(ya2_D, ya1_D, FixP_inter_y, QType_inter_y);
        
        sumx0_RS_D = RealRESIZE(sumx0_D,FixP_add_inter ,QType_add_inter);
        sumy2y1_LS_D = RealRESIZE(sumy2y1_D,FixP_add_inter ,QType_add_inter);
        sumy0_tmp_D = RealADD(sumx0_RS_D, sumy2y1_LS_D, FixP_add_inter, QType_add_inter);
        sumy0_D =  RealRESIZE(sumy0_tmp_D, FixP_inter_y, QType_inter_y);
%         sumy0_D = RealADD(sumx0_D, sumy2y1_D, FixP_inter_y, QType_inter_y);
        sta.FLT.OldSample_D(3) = RealMULT(a0_inv_D_fixed, sumy0_D, FixP_IIR_CAL, QType_IIR_CAL);
        %-----------------------------------------------------------------------------------------------
        
        % current output of 2nd order LPF
        sta.FLT.Out_DO = RealRESIZE(sta.FLT.OldSample_D(3), FixP_out, QType_out);
    case 0
        sta.FLT.Out_DO = sta.FLT.In_DI;
end

end