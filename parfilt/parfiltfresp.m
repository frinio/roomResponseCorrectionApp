
function H=parfiltfresp(Bm,Am,FIR,F,Fs);

% PARFILTDFRESP - Frequency response of second-order parallel filters
%
%   H=parfiltfresp(Bm,Am,FIR,W); computes the frequency response of the 
%   parallel filter with [Bm,Am] second-order section coefficients
%   and the coefficients of the FIR part (FIRcoeff) at given W frequencies 
%   (in radians from 0 to pi).
%
%   H=parfiltfresp(Bm,Am,FIR,F,Fs); computes the frequency response of the 
%   parallel filter with [Bm,Am] second-order section coefficients
%   and the coefficients of the FIR part (FIRcoeff) at given F ANALOG frequencies
%   given in Hz, and Fs is the sample rate.
%
%   http://www.mit.bme.hu/~bank/parfilt
%
%   C. Balazs Bank, 2010.

if nargin==5, % if they were analog frequencies
     W=2*pi*F/Fs;
else
     W=F;
end;

s=size(Am);
NSEC=s(2);
NFIR=length(FIR);

W=W(:);
Z=exp(-j*W); %creating z^-1
Z2=Z.^2; %creating z^-2


H=zeros(length(W),1);

for k=1:NSEC, %second-order sections
    H = H + (Bm(1,k)+Bm(2,k)*Z)./(Am(1,k)+Am(2,k)*Z+Am(3,k)*Z2);
end;

%adding the fir part

for k=1:NFIR, %parallel FIR part
    H=H+FIR(k)*Z.^(k-1); 
end;


