function [p]=freqpoles(fr,Fs,Q);

% FREQPOLES - Pole set generation for parallel filter design.
%   [P]=freqpoles(FR,Fs) creates poles from the given frequency vector
%   FR with sampling frequency Fs such that the frequency responses
%   of the second-order basis functions cross approximatelly at their
%   -3 dB point.
%   (See the equations in my 128th AES Convention paper.)
%
%   [P]=freqpoles(FR,Fs,Q) creates poles from the given frequency vector
%   FR with sampling frequency Fs but it uses the quality factors 
%   given in Q vector to set the radius of the poles. (-3dB bandwidth
%   is DeltaF=FR/Q.)
%
%   http://www.mit.bme.hu/~bank/parfilt
%
%   C. Balazs Bank, 2010.

if nargin<2, %default sampling rate
    Fs=44100;      
end;

fr=fr(:); % making a column vector
wp=2*pi*fr/Fs; %discrete pole frequencies

if nargin<3, % we compute the bandwidth from the pole frequencies
    wp=sort(wp); % sorting the frequencies
    pnum=length(wp); 
    dwp=zeros(pnum,1);
    for k=2:pnum-1,
        dwp(k)=(wp(k+1)-wp(k-1))/2;
    end;
    dwp(1)=(wp(2)-wp(1));
    dwp(pnum)=(wp(pnum)-wp(pnum-1));
end;

if nargin==3, % since Q are given, we compute the bandwidth from Q
    Q=Q(:); % making a column vector
    dwp=wp./Q;
end;

p=exp(-dwp/2).*exp(j*wp); % computing poles from center frequency wp and bandwidth dwp

p=[p; conj(p)]; %pole pairs one after the other
p=p(:); %making it a column vector
