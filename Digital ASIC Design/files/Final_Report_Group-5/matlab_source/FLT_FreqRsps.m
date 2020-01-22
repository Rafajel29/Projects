% =========================================================================
% ECE 5746 - Simple Filter Model (INITIALIZATION)
% (c) 2019 hs994,fjf46@cornell.edu
%
% Author: Haochuan Song, Frans Fourie
% Last edited: 10/23/2019
% Project: SynTech
%
% ---Description----------------------------
% Check the quantization effects to the final 
% frequency response. Generate Bode plots.
%
% =========================================================================
clear
clc
clf

addpath RealARITH

%% FLT input
f0 = 500;   % cut-off frequency
fs = 384000; % sampling frequency
Ts = 1/fs;  % sampling period
Q = 10;
for i = 1:length(Q)
    
    %% Floating points
    % -- FLT intermidiate parameters
    omega0 = 2*pi*f0/fs;
    alpha = (1/(2*Q(i)))*cos(pi/2-omega0);
    
    % -- transfer funtion
    cos_out_float = cos(omega0);
    b0 = 0.5*(1-cos_out_float);
    b1 = 2*b0;
    b2 = b0;
    a0 = 1+alpha;
    a1 = -2*cos_out_float;
    a2 = 1-alpha;
    num = [b0 b1 b2];
    den = [a0 a1 a2];
    
    w = 0:0.0001:pi;
    f_range = w/2/pi*fs;
    H = freqz(num,den,w);
    mag = (abs(H));
    phs = angle(H);
    
    %% Fixed points
    % specify all fixed-point parameters
    %------------------------------------------------------------------------
    FixP_IIR_CAL = {0,31,'s'}; % {I,F,'s'} where 's' is signed
    QType_IIR_CAL = 'SatTrc'; % we saturate and round
    
    FixP_Q_CAL = {3,28,'s'}; % {I,F,'s'} where 's' is signed
    QType_Q_CAL = 'SatTrc'; % we saturate and round
     
    FixP_para_Q1 = {1,30,'s'};
    QType_para_Q1 = 'SatTrc';
    
    FixP_para_Q2 = {2,29,'s'};
    QType_para_Q2 = 'SatTrc';
    
    FixP_para_omega0 = {0,15,'s'};
    QType_para_omega0 = 'SatTrc';
    
    FixP_para_sincos = {0,18,'s'};
    QType_para_sincos = 'SatTrc';
    
    FixP_para_alpha = {0,31,'s'};
    QType_para_alpha = 'SatTrc';
    
    FixP_weight_b0 = {0,19,'s'};
    QType_weight_b0 = 'SatTrc';
    
    FixP_weight_b1 = {1,18,'s'};
    QType_weight_b1 = 'SatTrc';
    
    %%%%%%%%%%%%%%%
    FixP_weight_a0 = {1,18,'s'};
    QType_weight_a0 = 'SatTrc';
    
    FixP_INV_CAL = {0,19,'s'};
    %%%%%%%%%%%%%%%%
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
    
    par.FLT.RFS_norm_D = 1/fs*2^10;
    par.FLT.RQ_D = 1/Q(i);
    constant1 = RealRESIZE(par.FLT.RFS_norm_D,FixP_IIR_CAL,QType_IIR_CAL); %2/internal sampling frequency WITHOUT pi
    omega0_normalized_D_fixed = RealMULT(2*f0/2^10,constant1,FixP_para_omega0, QType_para_omega0); % omega0/pi
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
    
    num_fx = [b0_D_fixed b1_D_fixed b2_D_fixed];
    den_fx = [1/a0_inv_D_fixed -a1_minus_D_fixed -a2_minus_D_fixed];
%     den_fx = [1.0039 -a1_minus_D_fixed -a2_minus_D_fixed];
        
    H_fx = freqz(num_fx,den_fx,w);
    mag_fx = (abs(H_fx));
    phs_fx = angle(H_fx);
     H = tf(num,den,1/fs);  
     Hz = tf(num_fx,den_fx,1/fs);
     

    
    %% Bode plots
%     figure(1)
%     h1 = semilogx(f_range,mag);grid on; hold on;
%     h2 = semilogx(f_range,mag_fx);grid on; hold on;
%     figure(2)
%     h2 = plot(f_range,phs/pi);grid on; hold on;
%     ylabel('\pi rad')

    h = bodeplot(H);
    hold on;
    h = bodeplot(Hz);
    hold on;

    P = bodeoptions();
    P.XLim = [100,3000];
    P.YLim{1} = [-150,50];
    P.YLim{2} = [-200,10];
    P.Grid = 'on';
    P.FreqUnits = 'Hz';
    P.XLabel.FontSize = 20;
    P.YLabel.FontSize = 20;
    setoptions(h,P)
    
%     figure(1)
%     h = bodeplot(H);
%     setoptions(h,P)
%     figure(2)
%     hz = bodeplot(Hz);
%     setoptions(hz,P)

end