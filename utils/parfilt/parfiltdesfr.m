
function [Bm,Am,FIR]=parfiltdesfr(W,H,p,NFIR,Wt);

% PARFILTDESFR - Direct design of second-order parallel filters for a given
% pole set in the frequency domain.
%   [Bm,Am,FIRcoeff]=parfiltdesfr(W,H,P,NFIR,Wt); designs the second-order sections
%   [Bm,Am] and the coefficients of the FIR part (FIRcoeff) from the 
%   transfer function H given at W angular frequencies (in radians from 0 to pi)
%   for the given P. The number of taps in the parallel FIR filter is set
%   by NFIR. The default is NFIR=1, in this case FIRcoeff is a simple gain.
%   If Wt weights are given, it means minimizing Wt*|Hparfilt-H|^2.
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
%   This function is based on the paper
%
%   Balázs Bank, "Logarithmic Frequency Scale Parallel Filter Design with Complex
%   and Magnitude-Only Specifications," IEEE Signal Processing Letters,
%   Vol. 18, No. 2, pp. 138-141, Feb. 2011. 
%
%   http://www.mit.bme.hu/~bank/parfilt
%
%   C. Balazs Bank, 2007-2011.

if nargin<3,
     NFIR=1;
end;

Weights=0; % is there a weighting vector?
if nargin>4,
    Weights=1;
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

H=H(:); %making them column vectors
W=W(:);
L=length(H);
Z=exp(-j*W); %creating z^-1
Z2=Z.^2; %creating z^-2

%constructing the modeling signal matrix

clear M;

for k=1:2:ppnum-1, %second-order sections
    A=poly(p(k:k+1)).'; % constructing the denominator from the poles
    resp=1./(A(1)+A(2)*Z+A(3)*Z2);
    M(:,k)=resp;
    M(:,k+1)=Z.*resp; %the response delayed by one sample
end;

if ODD, %if the number of poles is odd, we have a first-order section
    A=poly(p(pnum)).'; % constructing the denominator
    resp=1./(A(1)+A(2)*Z);
    M(:,pnum)=resp;
end;
 
for k=1:NFIR, %parallel FIR part
    M(:,pnum+k)=Z.^(k-1); 
end;


% weighting

% in theory, we should construct a large diagonal matrix and multiply 
% WtM=diag(sqrt(Wt));  
% M=WtM*M;       
% H=WtM*H;
 
if Weights, % actually, we should just scale the rows of M and H - faster and eats less memory
    Wt=Wt(:); % making column vector
    siz=size(M);
    for k=1:siz(2),
        M(:,k)=M(:,k).*sqrt(Wt);
    end;
    H=H.*sqrt(Wt);
end;



%Looking for min(||H-M*par||) as a function of par:

%least squares solution by equation solving 
% MR=[real(M); imag(M)]; % constructing the new real-valued modeling matrix
% HR=[real(H); imag(H)]; % constructing the real-valued output
% A=MR'*MR; 
% b=MR'*HR;
% par=A\b;

A=real(M'*M); % instead, we may do this, because it results in the same results
b=real(M'*H); 
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

