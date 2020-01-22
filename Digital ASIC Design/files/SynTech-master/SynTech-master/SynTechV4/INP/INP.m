% =========================================================================
% ECE 5746 - This block models inputs to the synthesizer
% (c) 2019 studer@cornell.edu
% =========================================================================

function sta = INP(par,sta)

% generate frequencies of notes contained in the vector frequency_list
% index : 1  2   3  4   5  6  7   8  9   10 11  12
% note  : C4 C#4 D4 D#4 E4 F4 F#4 G4 G#4 A4 A#4 B4
% index : 13 14  15 16  17 18 19  20 21  22 23  24
% note  : C5 C#5 D5 D#5 E5 F5 F#5 G5 G#5 A5 A#5 B5
nn = 40:64;
frequency_list = 2.^((nn-49)/12)*440;
% full list of frequencies here: https://en.wikipedia.org/wiki/Piano_key_frequencies

% measure time that elapsed
sta.INP.time = sta.INP.time + 1/par.GLO.FSInt_DI;

% check when to press key and when to release
if sta.INP.time<par.INP.tune.rele(sta.INP.note_index)
    sta.INP.Key_DO = 1; % press key
    sta.INP.Freq_DO = frequency_list(par.INP.tune.note(sta.INP.note_index)); % set frequency
    sta.INP.Vol_DO = par.INP.tune.ampl(sta.INP.note_index); % set amplitude
else
    sta.INP.Key_DO = 0; % release
end

% check which note should be played
if sta.INP.time>par.INP.tune.secs(sta.INP.note_index)
    sta.INP.time = 0; % reset time state
    sta.INP.note_index = sta.INP.note_index + 1; % proceed to next note
    if sta.INP.note_index>length(par.INP.tune.note)
        sta.INP.note_index = length(par.INP.tune.note); % stay at last note
    end
end

end



