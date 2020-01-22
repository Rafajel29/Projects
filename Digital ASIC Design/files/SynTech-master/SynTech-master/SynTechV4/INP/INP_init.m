% =========================================================================
% ECE 5746 - This block models inputs to the synthesizer (INITIALIZATION)
% (c) 2019 studer@cornell.edu
% =========================================================================

function [par,sta] = INP_init(par,sta)

% INP states
sta.INP.Key_DO = 0;  % key pressed? (0=no, 1=yes)
sta.INP.Freq_DO = 0; % frequency of pressed key [Hz]
sta.INP.Vol_DO = 0;  % volume of pressed key [0,1] (where 1 is loud!)

% all state variables used by this block must be initialized
sta.INP.time = 0;
sta.INP.note_index = 1;

% define test tunes
switch par.INP.tune.name
    case 'EXA' % Annoying example tune by Studer
        par.INP.tune.note = [ 5 3 1 3 5 5 5 3 3 3 5 8 8 5 3 1 3 5 5 5 3 3 5 3 1 1 ];
        par.INP.tune.ampl = [ 1 0.8 0.8 0.8 0.8 0.8 1 0.9 0.8 0.7 0.8 0.9 1 1 0.9 0.8 0.9 0.9 0.9 1 0.9 0.9 0.9 0.8 0.7 0 ];
        par.INP.tune.rele = [ 1 1 1 1 1 1 3 1 1 2 1 1 3 1 1 1 1 1 1 3 1 1 1 1 2 1 ]/16;
        par.INP.tune.secs = [ 1 1 1 1 1 1 2 1 1 2 1 1 2 1 1 1 1 1 1 2 1 1 1 1 2 1 ]/8;
    case 'ENV' % tune by ENV team
        par.INP.tune.note = [13 13 13 8 10 10 8 17 17 15 15 14 14];
        par.INP.tune.ampl = [ 1 0.8 0.8 0.8 0.8 0.8 0.8 1 1 0.9 0.9 0.8 0];
        par.INP.tune.rele = [ 1 1 1 1 1 1 3 1 1 1 1 3 1]/16;
        par.INP.tune.secs = [ 1 1 1 1 1 1 2 1 1 1 1 2 1]/8;
    case 'FLT' % tune by FLT team
        par.INP.tune.note = [ 1 1 3 1 6 5 1 1 3 1 8 6 1 1 20 10 6 5 3 22 10 6 8 6 ];
        par.INP.tune.ampl = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
        par.INP.tune.rele = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]/16;
        par.INP.tune.secs = [ 0.5 0.5 1 1 1 2 0.5 0.5 1 1 1 2 0.5 0.5 1 1 1 1 1 0.5 0.5 1 1 2 ]/8;
    case 'I2S' % tune by I2S team
        par.INP.tune.note = [ 10 13 12 10 17 15 12 10 13 12 8 11 5 ];
        par.INP.tune.ampl = [ 1 0.8 0.8 0.8 0.8 1 0.8 1 0.8 0.8 0.8 0.9 1 ];
        par.INP.tune.rele = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 ]/16;
        par.INP.tune.secs = [ 2,  1,  1,  3,   1, 4,   4, 2,   1,  1, 3, 1, 4]/8;
    case 'LFO' % tune by LFO team
        par.INP.tune.note = [ 10 10 5 5 7 7 5 5 3 3 2 2 12 12 10 11 10 9 8 7 6 5 4 3 2 1 ]; % New Tune we made up
        par.INP.tune.ampl = [ 1 0.8 0.8 0.8 0.8 0.8 1 0.9 0.8 0.7 0.8 0.9 1 1 0.9 0.8 0.9 0.9 0.9 1 0.9 0.9 0.9 0.8 0.7 0 ];
        par.INP.tune.rele = [ 1 1 1 1 1 1 3 1 1 2 1 1 3 1 1 1 1 1 1 3 1 1 1 1 2 1 ]/16;
        par.INP.tune.secs = [ 1 1 1 1 1 1 2 1 1 2 1 1 2 1 1 1 1 1 1 2 1 1 1 1 2 1 ]/8;
    case 'NYQ' % tune by NYQ team
        par.INP.tune.note = [ 5 3 1 3 5 6 5 5 3 1 3 5 6 3 3 1 3 5 3 5 6 8 5];
        par.INP.tune.ampl = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
        par.INP.tune.rele = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]/16;
        par.INP.tune.secs = [ 1 1 1 1 1 1 4 1 1 1 1 1 1 4 1 2 1 1 2 1 2 1 4]/8;
    case 'OSC' % tune by OSC team
        par.INP.tune.note = [ 1 3 5 8 5 8 13 ];
        par.INP.tune.ampl = [ 1 1 1 1 1 1 1 ];
        par.INP.tune.rele = [ 1 1 1 2 1 2 1 ]/16;
        par.INP.tune.secs = [ 1 1 1 2 1 2 2 ]/8;
    otherwise
        error('Tune not defined')
end

end