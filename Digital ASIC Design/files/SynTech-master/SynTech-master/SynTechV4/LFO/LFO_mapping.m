function mapped =  LFO_mapping(x, in_min, in_max, out_min, out_max, in_maxmin)

    FixP_out = {0,23,'s'}; % {I,F,'s'} where 's' is signed
    FixP_par = {0,31,'u'};
    QType_out = 'WrpTrc_NoWarn'; % we wrap and truncate
      
    % mapped = RealRESIZE((((x - in_min)*(out_max - out_min))*(in_maxmin) + out_min), FixP_par, QType_out);
    % in_maxmin is 1/(in_max - in_min) and is read from an outside source
    % that does the operation
    
    
    diff1 = RealRESIZE((x- in_min), FixP_par, QType_out);
    diff2 = RealRESIZE((out_max - out_min), FixP_par, QType_out);
    mult1 = RealRESIZE((diff1 * diff2), FixP_par, QType_out);
    mult2 = RealRESIZE((mult1 * in_maxmin), FixP_par, QType_out);
    mapped = RealRESIZE((mult2 + out_min), FixP_par, QType_out);

end