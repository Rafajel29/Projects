% =========================================================================
% ECE 5746 - Cycle-True MATLAB Model for SynTech V4
% (c) 2019 studer@cornell.edu
% =========================================================================
function SynTech(varargin) 

close all hidden % to close simulation wait bar(s)

addpath RealARITH
addpath Output
addpath GLO
addpath INP
addpath LFO
addpath OSC
addpath FLT
addpath ENV
addpath AMP
addpath NYQ
addpath I2S

%% ------------------------------------------------------------------------

% initialize state field
sta = [];
par = [];

% set default parameters
if nargin==0
    par.INP.tune.name = 'EXA'; % set example tune
    i2s_on = false; % 'true' or 'false' 
elseif nargin==1
    par.INP.tune.name = varargin{1}; % first argument is tune name    
    i2s_on = false; % 'true' or 'false'     
else
    par.INP.tune.name = varargin{1}; % first argument is tune name   
    i2s_on = varargin{2};
end

% initialize all default parameters and state variables
[par,sta] = GLO_init(par,sta);
[par,sta] = INP_init(par,sta);
[par,sta] = LFO_init(par,sta);
[par,sta] = OSC_init(par,sta);
[par,sta] = FLT_init(par,sta);
[par,sta] = ENV_init(par,sta);
[par,sta] = AMP_init(par,sta);
[par,sta] = NYQ_init(par,sta);
[par,sta] = I2S_init(par,sta);

%% ------------------------------------------------------------------------

% set up basic simulation parameters
sim.time = 4; % simulate for 1 second
sim.samples = sim.time*par.GLO.FSInt_DI; % total number of samples
sim.name = ['test_' par.INP.tune.name]; % used as filename

% allocate memory for output waveforms
wav.i = zeros(1,sim.samples);
wav.o = zeros(1,ceil(sim.samples/sta.GLO.OSR_DO));

%% ------------------------------------------------------------------------

% setting up simulation progress bar
tic;
last_time = toc;
f = waitbar(0,'Simulation running...');

% simulate synthesizer for sim.samples cycles
cycle_o = 0;
rng(0);
% simname = 'FLT_IO_rnd1.mat';
% load(simname)
% FLT_DI = RealRESIZE(FLT_DI,{0,23,'s'}, 'SatTrc');
for cycle=1:sim.samples
    
    % update simulation progress bar every 2 seconds
    if last_time+2<toc
        last_time = toc;
        waitbar(cycle/sim.samples,f)
    end
    
    % ---------------------------------------------------------------------
    % Model SynTech functionality
    % ---------------------------------------------------------------------
    
    sta = GLO(par,sta); % GLO model
    sta = INP(par,sta); % INP model
    sta = LFO(par,sta); % LFO model
    sta = OSC(par,sta); % OSC model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    sta.OSC.Out_DO = RealRESIZE(rand(1),{0,23,'s'}, 'SatTrc');  % create some random test  vectors
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    FLT_DI(cycle) = sta.OSC.Out_DO;
    sta = FLT(par,sta); % FLT model
    FLT_DO(cycle) = sta.FLT.Out_DO;
    % FLT_IO_rnd1.mat 12/14/2019 1:04PM, 65th cycle, matlab model has minor difference between sta.FLT.OldSample_D(3) and sta_FLT_OldSample0_D at 93ns
    if cycle == 38 %%%% 
    end
%     sta = ENV(par,sta); % ENV model
%     sta = AMP(par,sta); % AMP model
%     sta = NYQ(par,sta); % NYQ model
%     if i2s_on % only simulate if output required
%         sta = I2S(par,sta); % I2S model
%     end
%     
%     % ---------------------------------------------------------------------
%     
%     % record outputs
%     wav.i(cycle) = sta.AMP.Out_DO; % read from AMP output state
%     if sta.NYQ.Valid_DO==1 % only read sample from NYQ if it is new
%         cycle_o = cycle_o + 1;
%         wav.o(cycle_o) = sta.NYQ.Out_DO; % read from NYQ output state
%     end
    
end

% close simulation wait bar and display total simulation time
close(f)
toc

%% ------------------------------------------------------------------------

% save subsampled audio file
audiowrite(['Output/' sim.name '.wav'],wav.o,par.GLO.FSOut_DI);

% plot output waveform (at internal sampling rate)
figure(1)
t = linspace(0,sim.time,length(wav.i));
plot(t,wav.i)
grid on
xlabel('time [s]');
ylabel('amplitude');
axis([ 0 sim.time -1.1 +1.1])

% plot output waveform (at output sampling rate)
figure(2)
t = linspace(0,sim.time,length(wav.o));
plot(t,wav.o)
grid on
xlabel('time [s]');
ylabel('amplitude');
axis([ 0 sim.time -1.1 +1.1])

%% ------------------------------------------------------------------------

% done and beep!
beep

end