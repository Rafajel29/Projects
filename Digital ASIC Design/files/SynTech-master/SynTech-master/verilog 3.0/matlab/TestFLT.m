% ------------------------
% TestAdd.m
% Generates the stimuli and expected-output files for FLT
% Author: Hcoahuan Song (hs994@cornell.edu), Oscar Castaneda (oc66@cornell.edu)
% ------------------------

%Parameters
clear
clc

simname = 'FLT_IO_rnd2.mat';
mode = 'RND';

load('InpPara.mat')
load(simname)
trials = 5;
n_bits = 31;
input_file = ['..\tb\',mode,'_FLT_in.txt'];
output_file = ['..\tb\',mode,'_FLT_out.txt'];
% inter_file = '..\tb\FLT_inter.txt';

%Open files
fin = fopen(input_file,'w');
fout = fopen(output_file,'w');
% finter = fopen(inter_file,'w');

%Apply reset
fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
fprintf(fout,'%s \n','x');
fprintf(fin,'%d %d %d %d %d\n',[0,0,0,0,0]);
fprintf(fout,'%s \n','x');
fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
fprintf(fout,'%s \n','x');

%Feed in parameters
%  Rst_RB, WrEn_S, Addr_D, PAR_In_D, FLT_In_D
fprintf(fin,'%d %d %d %10.0f %d\n',[1,1,0,par.FLT.RQ_D*2^28,0]);  % 1/Q
fprintf(fout,'%d\n',0);
fprintf(fin,'%d %d %d %d %d\n',[1,1,1,par.FLT.f0_D,0]); % f0
fprintf(fout,'%d\n',0);
fprintf(fin,'%d %d %d %10.0f %d\n',[1,1,2,constant1*2^n_bits,0]); % 2/Fs*2^10
fprintf(fout,'%d\n',0);
fprintf(fin,'%d %d %d %10.0f %d\n',[1,1,3,par.FLT.SD_D*2^n_bits,0]); % scaling down factor; also input;
fprintf(fout,'%d\n',0);
fprintf(fin,'%d %d %d %d %d\n',[1,1,4,par.FLT.type_S,0]); % type selection;also input;
fprintf(fout,'%d\n',0);

for i = 1:20
    fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]); % input(2)
    fprintf(fout,'%d\n',0); % output(2)
end

for i = 1:length(FLT_DI)
    fprintf(fin,'%d %d %d %d %7.0f\n',[1,0,0,0,FLT_DI(i)*2^23]); % input(2)
    fprintf(fout,'%d\n',FLT_DO(i)*2^23); % output(2)
end

% fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,FLT_DI(3)*2^23]); % input(3)
% fprintf(fout,'%d\n',FLT_DO(3)*2^23); % output(3)

% % Reset to 0
% fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
% fprintf(fout,'%s \n','x');
% fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
% fprintf(fout,'%s \n','x');
% fprintf(fin,'%d %d %d %d %d\n',[0,0,0,0,0]);
% fprintf(fout,'%s \n','x');
% fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
% fprintf(fout,'%s \n','x');
% fprintf(fin,'%d %d %d %d %d\n',[1,0,0,0,0]);
% fprintf(fout,'%s \n','x');

% Intermidiate results
% fprintf(finter,'%10.0f %10.0f %10.0f %10.0f\n',[constant2_D*2^31, alpha_D_fixed*2^31, a2_minus_D_fixed*2^31,a0_inv_D_fixed*2^31]);


% %Random cases
% for i=1:trials
%   %Generate inputs
%   A = randi(2^n_bits)-1;
%   B = randi(2^n_bits)-1;
%   Cin = randi(2)-1;
%   %Generate expected output
%   FullSum = A+B+Cin;
%   Sum = mod(FullSum+(i==2^2*n_bits),2^n_bits);  
%   Cout = floor((FullSum+(i==2^2*n_bits))/(2^n_bits));
%   %Write to files
%   fprintf(fin,'%d %d %d %d %d\n',[1,1,A,B,Cin]);
%   fprintf(fout,'%d %d\n',[Sum,Cout]); 
% end

%Close files
fclose(fin);
fclose(fout);
% fclose(finter);
