
function [Bm,Am,FIR]=parfiltdes(impresp,p,NFIR);

% PARFILTDES - Direct design of second-order parallel filters for a given
% pole set.
%   [Bm,Am,FIRcoeff]=parfiltdes(IMPRESP,P,NFIR); designs the second-order sections
%   [Bm,Am] and the coefficients of the FIR part (FIRcoeff) from the given impulse
%   response IMPRESP and poles P. The number of taps in the parallel FIR filter is set
%   by NFIR. The default is NFIR=1, in this case FIRcoeff is a simple gain.
%
%   The Bm and Am matrices are containing the [b0 b1]' and [1 a0 a1]'
%   coefficients for the different sections in their columns. For example,
%   Bm(:,3) gives the [b0 b1]' parameters of the third second-order
%   section. These can be used by the filter command separatelly (e.g., by
%   y=filter(Bm(:,3),Am(:,3),x), or by the PARFILT command.
%
%   Note that this function does not support pole multiplicity, so P should
%   contain each pole only once.
%
%   More details about the parallel filter can be found in 
%
%   http://www.mit.bme.hu/~bank/parfilt
%
%	Balazs Bank, "Perceptually Motivated Audio Equalization Using Fixed-Pole Parallel
%   Second-Order Filters", IEEE Signal Processing Letters, 2008.
%   http://www.acoustics.hut.fi/go/spl08-parfilt
%
%   Balazs Bank, "Direct Design of Parallel Second-order Filters for
%   Instrument Body Modeling", International Computer Music Conference,
%   Copenhagen, Denmark, Aug. 2007.
%   http://www.acoustics.hut.fi/go/icmc07-parfilt
%
%   C. Balazs Bank, Helsinki University of Technology, 2007.

if nargin==2,
    NFIR=1;
end;

p=p(find(p)); %we don't want to have any poles in the origin - for that we have the parallel FIR part
for k=1:length(p), %making the filter stable by flipping the poles into the unit cirle
   if abs(p(k))>1			
      p(k)=1/conj(p(k));
  end;
end;

p=cplxpair(p); %order it to complex pole pairs + real ones afterwards

%in order to have second-order sections only (i.e., no first order)
pnum=length(p); %number of poles
ppnum=2*floor(pnum/2); %the even part of pnum
ODD=0;
if pnum>ppnum, %if pnum is odd
    ODD=1;
end;

L=length(impresp);
imp=zeros(L,1);
imp(1)=1;

%constructing the modeling signal matrix

for k=1:2:ppnum-1, %second-order sections
    resp=filter(1,poly(p(k:k+1)),imp); %impluse response of the two-pole filter
    M(:,k)=resp;
    M(:,k+1)=[0 ;resp(1:L-1)]; %the response delayed by one sample
end;

if ODD, %if the number of poles is odd, we have a first-order section
    resp=filter(1,poly(p(pnum)),imp);
    M(:,pnum)=resp;
end;
 
for k=1:NFIR, %parallel FIR part
    M(:,pnum+k)=[zeros(k-1,1); imp(1:length(imp)-k+1)]; 
end;

y=impresp(:); %making it column vector

%Looking for min(||y-M*par||) as a function of par:
%least squares solution by equation solving 
A=M'*M;
b=M'*y;
par=A\b;

%constructing the Bm and Am matrices
for k=1:ppnum/2,
    Am(:,k)=poly(p(2*k-1:2*k)).';
    Bm(:,k)=par(2*k-1:2*k);
end;
if ODD, %we extend the first-order section to a second-order one by adding zero coefficients
    Am(:,k+1)=[poly(p(pnum)).'; 0];
    Bm(:,k+1)=[par(pnum); 0];
end;

FIR=0;
%constructing the FIR part
if NFIR>0,
    FIR=par(pnum+1:pnum+NFIR);
end;

