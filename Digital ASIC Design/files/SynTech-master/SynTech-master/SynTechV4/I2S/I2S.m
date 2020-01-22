
function [sta] = I2S(par,sta)

% specify all fixed-point parameters
% FixP_in = {0,7,'s'}; % {I,F,'s'} where 's' is signed
% QType_in = 'WrpTrc'; % we wrap and truncate
% 
% % quantize input sample; directly read from NYQ output
% % this will be replaced by the three I2S signals 
% if sta.NYQ.Valid_DO==1
%     sta.I2S.Out_DO = RealRESIZE(sta.NYQ.Out_DO,FixP_in,QType_in);
% end

% start the SCK clock
sta = SCK_block(par,sta); 
if (sta.I2S.Valid_DI == dec2bin(1,32)) % if sta.I2S.Valid_DI == 1
    sta = WS_block(par,sta);
    sta = SDA_block(par,sta);
end


end

function sta = SCK_block(par,sta)   
   
    switch sta.I2S.SCK_S
        case dec2bin(0,1)
            sta.I2S.SCK_DO = dec2bin(0,1);
            if (sta.I2S.SCKcnt_S ==  sta.I2S.SCKt_S) 
            % count until half of SCK period then go to 1
                sta.I2S.SCKcnt_S = dec2bin(0,5); % set sta.I2S.SCKcnt_S back to 0
                sta.I2S.SCK_S  = dec2bin(1,1); % sta.I2S.SCK_S = 1 
                sta.I2S.SCK_DO = dec2bin(1,1);
            end
            sta.I2S.SCKcnt_S = binAddOne(sta.I2S.SCKcnt_S, 5);
            % sta.I2S.SCKcnt_S = sta.I2S.SCKcnt_S + 1; 
        case dec2bin(1,1)
            sta.I2S.SCK_DO = dec2bin(1,1);
            if (sta.I2S.SCKcnt_S ==  sta.I2S.SCKt_S) 
            % count until half of SCK period then go to 0
                sta.I2S.SCKcnt_S = dec2bin(0,5); % set sta.I2S.SCKcnt_S back to 0
                sta.I2S.SCK_S  = dec2bin(0,1); % sta.I2S.SCK_S = 0
                sta.I2S.SCK_DO = dec2bin(0,1);
            end 
            sta.I2S.SCKcnt_S = binAddOne(sta.I2S.SCKcnt_S, 5);
            %sta.I2S.SCKcnt_S = sta.I2S.SCKcnt_S + 1;  
    end
end

            
function sta = WS_block(par,sta) 
        
         switch sta.I2S.WS_S 
             case dec2bin(0,1)
                 
                 %sta.I2S.WScnt_S = sta.I2S.WScnt_S + 1;
                 
                 sta.I2S.WS_DO = dec2bin(0,1);
                 
                 if sta.I2S.WScnt_S == sta.I2S.WSt_S % if sta.I2S.WScnt_S >= sta.I2S.DW_DI 
                 % count until DW_DI * SCK period then go to 1
                     sta.I2S.WScnt_S = dec2bin(0,10);
                     sta.I2S.WS_S = dec2bin(1,1);
                     sta.I2S.WS_DO = dec2bin(1,1);
                 end
                 sta.I2S.WScnt_S = binAddOne(sta.I2S.WScnt_S, 10);
                 
             case dec2bin(1,1)
                 
                 %sta.I2S.WScnt_S = sta.I2S.WScnt_S + 1;
                 
                 sta.I2S.WS_DO = dec2bin(1,1);
                 
                 if sta.I2S.WScnt_S == sta.I2S.WSt_S
                  % count until DW_DI * SCK period then go to 1
                     sta.I2S.WScnt_S = dec2bin(0,10);
                     sta.I2S.WS_S = dec2bin(0,1);
                     sta.I2S.WS_DO = dec2bin(0,1);
                 end
                 sta.I2S.WScnt_S = binAddOne(sta.I2S.WScnt_S, 10);
         end
end

function sta = SDA_block(par,sta)
      switch sta.I2S.SDA_load_S
          case dec2bin(1,1) %First cycle starts here, for the one bit delay  
              if sta.I2S.SDAcnt_S == dec2bin(0,10)
                  sta.I2S.SDA_load_S = dec2bin(0,1);
                  sta.I2S.SDA_DO = dec2bin(str2num(sta.I2S.SDA_DI(bin2dec(sta.I2S.SDA_Bcnt_S))),1);
                  sta.I2S.SDA_DI = (1/2*(sta.NYQ.Out_DO+1))*(2^(sta.I2S.DW_DI-1));
                  sta.I2S.SDA_DI = dec2bin(sta.I2S.SDA_DI, sta.I2S.DW_DI);
                  sta.I2S.SDA_DI
                  sta.I2S.SDA_Bcnt_S = dec2bin(0, 5);
                  sta.I2S.SDA_Bcnt_S = binAddOne(sta.I2S.SDA_Bcnt_S, 5);
              end
              sta.I2S.SDAcnt_S = binAddOne(sta.I2S.SDAcnt_S, 10);
              if sta.I2S.SDAcnt_S == sta.I2S.SDAt_S
                  sta.I2S.SDAcnt_S = dec2bin(0,10);
              end
              
          case dec2bin(0,1)              
              if sta.I2S.SDAcnt_S == dec2bin(0,10)
                  sta.I2S.SDA_DO = dec2bin(str2num(sta.I2S.SDA_DI(bin2dec(sta.I2S.SDA_Bcnt_S))),1);
                  sta.I2S.SDA_Bcnt_S = binAddOne(sta.I2S.SDA_Bcnt_S, 5);
                  if sta.I2S.SDA_Bcnt_S == sta.I2S.SDA_Bt_S
                      sta.I2S.SDA_load_S = dec2bin(1,1);
                  end
                  %sta.I2S.SDAcnt_S = dec2bin(0,10);
              end
              sta.I2S.SDAcnt_S = binAddOne(sta.I2S.SDAcnt_S, 10);              
              if sta.I2S.SDAcnt_S == sta.I2S.SDAt_S
                  sta.I2S.SDAcnt_S = dec2bin(0,10);
              end
      end
              
end

function out = binAddOne(in, DW)
     
      out = bin2dec(in) + 1;
      out = dec2bin(out, DW);
      
end
