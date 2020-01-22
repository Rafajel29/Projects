function out = RealDIV(inA,inB,FixP,QType,IDString)
% function out = RealSQRT(inA,inB,FixP,QType)
% Division of two real numbers:
% in: input vector
% FixP: fixedpoint configuration of output vector {WINT,WFRAC,Type}
%       WINT, WFRAC are integer, Type is either 's' or 'u'
% QType: Quantization type ('WrpTrc', 'WrpRnd', 'SatTrc' or 'SatRnd')

if inB == 0
    error('RealDIV division by 0');
end

switch nargin
 case 4 % normal
  out = RealRESIZE(inA./inB,FixP,QType);  
 case 5 % + Log ID
  out = RealRESIZE(inA./inB,FixP,QType,IDString);
 otherwise
  error('Current number of input arguments (=%d) not supported!',nargin)
end
