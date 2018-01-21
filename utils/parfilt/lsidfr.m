function [B,A,X,Y,M]=lsidfr(W,X,Y,NB,NA,ITER,Wt);

% LSIDFR [B,A]=lsidfr(W,X,Y,NB,NA,ITER,WEIGHT); estimates a discrete-time
% system which produces an output Y
%	to the input X, given at angular frequencies W, ranging from 0 to pi (one sided specification).
%   The numerator and denominator are given in B and A, and their order
%	is set by NB and NA, respectively.
%
%	The estimation is done in the frequency domain. If ITER=0 (or, not given),
%   we minimize the equation error:
%	|Y*A-B*X|^2
%   If ITER>0, we make an iterative weighting, corresponding to the
%   frequency-domain Steiglitz-McBride algorithm, minimizing the true 
%   error
%   |Y-B/A*X|^2. 
%
%   If X is a scalar, then we simply design a filter for the
%   specification H=Y/X, where the code extends the dimension of X to 
%   match that of Y. (Typically, use X=1 and Y=H as the filter specification.)
%
%   If WEIGHT is given, we minimize
%   WEIGHt*|Y*A-B*X|^2
%   or
%   WEIGHT*|Y-B/A*X|^2.
%
%   For the theory, see
%   L. B. Jackson, “Frequency-domain Steiglitz-McBride method for least-
%   squares filter design, ARMA modeling, and periodogram smoothing,”
%   IEEE Signal Process. Lett., vol. 15, pp. 49–52, 2008.
%
%	C. Balazs Bank, 2011.			

if nargin<6,
   ITER=0;
end;

Weights=0; % is there a weighting vector?
if nargin==7,
    Weights=1;
end;


if size(X)==1, % if X is constant, we extend it
    X=X*ones(size(Y));
end;

X=X(:); %making them column vectors
Y=Y(:);
W=W(:);
L=length(Y);
Z=exp(-j*W); %creating z^-1

PARL=NA+NB+1;

M=zeros(L,PARL); % creating modelling matrix
for k=0:NB,
     M(:,k+1)=X.*Z.^k;
end;
for k=1:NA,
     M(:,k+NB+1)=-Y.*Z.^k;
end;


% in theory, we should construct a large diagonal matrix and multiply 
% WtM=diag(sqrt(Wt));  
% M=WtM*M;       
% Hout=WtM*Hout;
 
if Weights, % actually, we should just scale the rows of M and H - faster and eats less memory
    Wt=Wt(:); % making column vector
    for k=1:PARL,
        M(:,k)=M(:,k).*sqrt(Wt);
    end;
    Y=Y.*sqrt(Wt);
end;

Am=real(M'*M); % least squares minimization for one-sided specification
b=real(M'*Y); 
par=Am\b;      

B=par(1:NB+1)';%making row vectors
A=[1; par(NB+2:PARL)]';

% iterative minimization by the frequency-domain version of the
% Steiglitz-McBride algorithm


for k=1:ITER, % doing N iterations
    AWt=abs(polyval([1 A],Z)).^-2;
    AWt=AWt(:);
    for k=1:PARL,
        MW(:,k)=M(:,k).*sqrt(AWt);
    end;
    YW=Y.*sqrt(AWt);
    
    Am=real(MW'*MW); % least squares minimization for one-sided specification
    b=real(MW'*YW); 
    par=Am\b;      

    B=par(1:NB+1)';%making row vectors
    A=[1; par(NB+2:PARL)]';
end;

    
    

    

