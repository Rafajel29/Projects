% ===================================================================
% ECE 5746 - Simple Nyquist Filter Model
% (c) 2019 ok93@cornell.edu, ut33@cornell.edu, ll556@cornell.edu
% ===================================================================
function sta = NYQ(par,sta)

% ===================================================================
% The input is the sta.AMP.Out_DO which is output from Amp
% The output is sta.NYQ.Out_DO 
% ===================================================================

FixP_out = {0,23,'s'}; % {I,F,'s'} where 's' is signed
QType_out = 'WrpTrc_NoWarn'; % we wrap and truncate

FixP_ff = {0,32,'s'};
QType_ff = 'WrpTrc_NoWarn';

% it is not a valid output unless counter > OSR
sta.NYQ.Valid_DO = 0;

% Resize the input
sta.NYQ.Sample_D = RealRESIZE(sta.AMP.Out_DO, FixP_out,QType_out);

% For each input, we want to multiply x[n] in each of the multipliers by 
% the coefficients that the counter is pointing to at that cycle.
for i=1:length(sta.NYQ.accumulate_D)
    sta.NYQ.accumulate_D(i) = sta.NYQ.accumulate_D(i) ...
        + sta.NYQ.coeff(sta.GLO.OSR_DO * (i - 1) + sta.NYQ.Cnt_D + 1) * ...
        sta.NYQ.Sample_D ;
    % real resize the accumulates
    sta.NYQ.accumulate_D(i) = RealRESIZE(sta.NYQ.accumulate_D(i),...
        {3,29,'s'},QType_out);
end

% Increment count to represent the counter increasing every clk cycle
sta.NYQ.Cnt_D = sta.NYQ.Cnt_D + 1;

% Only output every Kth value where K is the oversampling ratio
if sta.NYQ.Cnt_D >= sta.GLO.OSR_DO
    
    % Reset the counter
    % THIS SHOULD BE UNCOMMENTED IF YOU AREN'T CHECKING PERFORMANCE
    sta.NYQ.Cnt_D = 0;
    
    % Every time the counter overflows, each temp ff should take the value
    % of the previous MAC block and temp ff before it.
    for i=1:length(sta.NYQ.temp_D)
        % for the case of the last ff
        if i == length(sta.NYQ.temp_D)
            sta.NYQ.temp_D(i) = sta.NYQ.accumulate_D(i+1);
            % real resize the temp ff
            sta.NYQ.temp_D(i) = RealRESIZE(sta.NYQ.temp_D(i),...
                {3,29,'s'},QType_out);
        % for literally every other ff
        else 
            % using RealADD with the types defined above for ff
            sta.NYQ.temp_D(i) = RealADD(sta.NYQ.temp_D(i+1),...
                sta.NYQ.accumulate_D(i+1), FixP_ff, QType_ff);
            % real resize the temp ff
            % sta.NYQ.temp_D(i) = RealRESIZE(sta.NYQ.temp_D(i),...
                % {3,29,'s'},QType_out);
        end 
    
    end
    
    % The filtered output is equivalent to the first multiplier value
    % plus the values in the enable ffs    
    sta.NYQ.Out_DO = RealADD(sta.NYQ.accumulate_D(1), sta.NYQ.temp_D(1),...
        FixP_out, QType_out);

    % Clear MAC flip flops
    for i=1:length(sta.NYQ.accumulate_D)
        sta.NYQ.accumulate_D(i) = 0;
    end

    % valid output
    sta.NYQ.Valid_DO = 1;
    
end

% Resize the output
sta.NYQ.Out_DO = RealRESIZE(sta.NYQ.Out_DO, FixP_out, QType_out);
% =========================================================================
% ================         PERFORMANCE CHECKER          =================== 
% =========================================================================

% for every input, add it into the buffer and shift the old one
% sta.NYQ.last_n = [sta.NYQ.Sample_D, sta.NYQ.last_n(1:end-1)];
% if sta.NYQ.Cnt_D >= par.GLO.OSR_DI
%     % sum up the vector from the conv and square and put into the S matrix
%     sta.NYQ.S =  [sta.NYQ.S, ...
%         sum(filter(sta.NYQ.coeff, sta.NYQ.denom, sta.NYQ.last_n)).^2];
%     sta.NYQ.filt_out = [sta.NYQ.filt_out,...
%         sum(filter(sta.NYQ.coeff, sta.NYQ.denom, sta.NYQ.last_n))];
%     % sum up the vector from the conv, subtract with the output we got and then 
%     % square it and put in matrix
%     sta.NYQ.performance_checker = [sta.NYQ.performance_checker, ...
%         (sta.NYQ.Out_DO - sum(filter(sta.NYQ.coeff, sta.NYQ.denom, sta.NYQ.last_n))).^2];
%     sta.NYQ.Cnt_D = 0;
%     disp("conv");
%     disp(sum(filter(sta.NYQ.coeff, sta.NYQ.denom, sta.NYQ.last_n)));
%     disp("output");
%     disp(sta.NYQ.Out_DO);
% end
end
 